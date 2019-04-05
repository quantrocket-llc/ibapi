/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.SortedMap;
import java.util.TreeMap;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.orders.AutoOpenOrdersRequest;
import com.ib.api.dde.dde2socket.requests.orders.CompletedOrdersRequest;
import com.ib.api.dde.dde2socket.requests.orders.OpenOrdersRequest;
import com.ib.api.dde.dde2socket.requests.orders.OrderStatusRequest;
import com.ib.api.dde.dde2socket.requests.orders.PlaceOrderRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.OpenOrderData;
import com.ib.api.dde.socket2dde.data.OrderData;
import com.ib.api.dde.socket2dde.data.OrderStatusData;
import com.ib.api.dde.socket2dde.notifications.DdeNotificationEvent;
import com.ib.api.dde.utils.OrderUtils;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.ExecutionCondition;
import com.ib.client.MarginCondition;
import com.ib.client.Order;
import com.ib.client.OrderComboLeg;
import com.ib.client.OrderCondition;
import com.ib.client.OrderConditionType;
import com.ib.client.OrderType;
import com.ib.client.PercentChangeCondition;
import com.ib.client.PriceCondition;
import com.ib.client.SoftDollarTier;
import com.ib.client.TimeCondition;
import com.ib.client.VolumeCondition;

/** Class handles orders related requests and messages */
public class OrdersHandler extends BaseHandler {
    // parser
    private OpenOrdersRequestParser m_requestParser = new OpenOrdersRequestParser();

    // open orders
    private OpenOrdersRequest m_openOrdersRequest;
    boolean m_allOrders = false;
    private SortedMap<Integer, OpenOrderData> m_openOrderDataMap = Collections.synchronizedSortedMap(new TreeMap<Integer, OpenOrderData>()); // map orderId->OpenOrderData
    private SortedMap<Integer, OpenOrderData> m_allOpenOrderDataMap = Collections.synchronizedSortedMap(new TreeMap<Integer, OpenOrderData>()); // map permId->OpenOrderData (if orderId == 0)
    private DdeRequestStatus m_openOrdersSubscriptionStatus = DdeRequestStatus.UNKNOWN;

    // completed orders
    private CompletedOrdersRequest m_completedOrdersRequest;
    private List<OrderData> m_completedOrdersList = Collections.synchronizedList(new ArrayList<OrderData>()); // completed orders list
    private DdeRequestStatus m_completedOrdersRequestStatus = DdeRequestStatus.UNKNOWN;
    
    public OrdersHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method requests open orders or all open orders and sets open order subscription status */
    public String handleOpenOrdersRequest(String requestStr, boolean allOrders) {
        m_allOrders = allOrders;
        m_openOrdersRequest = m_requestParser.parseOpenOrdersRequest(requestStr, allOrders);
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.UNKNOWN) {
            if (allOrders) {
                System.out.println("Handling all open orders request");
                clientSocket().reqAllOpenOrders();
            } else {
                System.out.println("Handling open orders request");
                clientSocket().reqOpenOrders();
            }
            m_openOrdersSubscriptionStatus = DdeRequestStatus.REQUESTED;
        }
        return m_openOrdersSubscriptionStatus.toString();
    }

    /** Method handles auto open orders request */
    public byte[] handleAutoOpenOrdersRequest(String requestStr) {
        AutoOpenOrdersRequest request =  m_requestParser.parseAutoOpenOrdersRequest(requestStr);
        System.out.println("Handling auto open orders request: autoBind=" + request.autoBind());
        clientSocket().reqAutoOpenOrders(request.autoBind());
        return null;
    }

    /** Method handles open orders array request */
    public byte[] handleOpenOrdersArrayRequest(String requestStr) {
        System.out.println("Handling open orders array request: id=" + m_openOrdersRequest.requestId() + " type=" + m_openOrdersRequest.ddeRequestType().topic());
        byte[] array = OrderUtils.openOrderDataListToByteArray(syncCopyOpenOrderDataValues(), null, true);
        m_openOrdersSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        if (m_openOrdersRequest != null) {
            notifyDde(false, m_openOrdersRequest.ddeRequestString());
        }
        return array;
    }

    /** Method handles all open orders array request */
    public byte[] handleAllOpenOrdersArrayRequest(String requestStr) {
        System.out.println("Handling all open orders array request: id=" + m_openOrdersRequest.requestId() + " type=" + m_openOrdersRequest.ddeRequestType().topic());
        byte[] array = OrderUtils.openOrderDataListToByteArray(syncCopyOpenOrderDataValues(), syncCopyAllOpenOrderDataValues(), true);
        m_openOrdersSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        if (m_openOrdersRequest != null) {
            notifyDde(true, m_openOrdersRequest.ddeRequestString());
        }
        return array;
    }

    /** Method handles cancel open orders */
    public byte[] handleOpenOrdersCancel(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_OPEN_ORDERS);
        System.out.println("Handling open orders cancel: id=" + request.requestId() + " type=" + request.ddeRequestType().topic());
        m_openOrdersSubscriptionStatus = DdeRequestStatus.UNKNOWN;
        return null;
    }

    /** Method handles order status (status, filled, remaining etc) */
    public String handleOrderStatusRequest(String requestStr) {
        OrderStatusRequest orderStatusRequest = m_requestParser.parseOrderStatusRequest(requestStr);
        System.out.println("Handling order status request: id=" + orderStatusRequest.requestId() + " field=" + orderStatusRequest.field());
        OpenOrderData openOrderData = m_openOrderDataMap.get(orderStatusRequest.requestId());
        if (openOrderData != null) {
            OrderStatusData orderStatus = openOrderData.orderStatus();
            return OrderUtils.getFieldValueFromOrderStatusRequest(orderStatusRequest, orderStatus);
        }
        else {
            return "";
        }
    }

    /** Method sends place order request to TWS */
    public byte[] handlePlaceOrderRequest(String requestStr, byte[] data) {
        PlaceOrderRequest request = m_requestParser.parsePlaceOrderRequest(requestStr, data);
        if (request != null) {
                    
            System.out.println("Placing order: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()) + " order=" + Utils.shortOrderString(request.order()));
            clientSocket().placeOrder(request.requestId(), request.contract(), request.order()); 
            
            OrderStatusData orderStatus = new OrderStatusData(request.requestId(), "Sent", 0, 
                    request.order().totalQuantity(), 0, request.order().permId(), request.order().parentId(), 
                    0, request.order().clientId(), "", 0); 
            OpenOrderData openOrderData = new OpenOrderData(request.requestId(), request.contract(), request.order(), null, orderStatus, false);
    
            m_openOrderDataMap.put(request.requestId(), openOrderData);
        }
        
        return null;
    }

    /** Method sends cancel order request to TWS */
    public byte[] handleCancelOrderRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_ORDER);
        System.out.println("Cancelling order: id=" + request.requestId());
        clientSocket().cancelOrder(request.requestId()); 
        return null;
    }

    /** Method clears order */
    public byte[] handleClearOrderRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.CLEAR_ORDER);
        System.out.println("Clearing order: id=" + request.requestId());
        m_openOrderDataMap.remove(request.requestId());
        return null;
    }

    /** Method sends global cancel to TWS */
    public byte[] handleGlobalCancel(String requestStr) {
        System.out.println("Handling global cancel.");
        clientSocket().reqGlobalCancel(); 
        return null;
    }
    
    /** Method requests completed orders and sets completed orders request status */
    public String handleCompletedOrdersRequest(String requestStr) {
        m_completedOrdersRequest = m_requestParser.parseCompletedOrdersRequest(requestStr);
        if (m_completedOrdersRequestStatus == DdeRequestStatus.UNKNOWN) {
            System.out.println("Handling completed orders request");
            clientSocket().reqCompletedOrders(m_completedOrdersRequest.apiOnly());
            m_completedOrdersRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_completedOrdersRequestStatus.toString();
    }
    
    /** Method handles completed orders array request */
    public byte[] handleCompletedOrdersArrayRequest(String requestStr) {
        System.out.println("Handling completed orders array request: id=" + m_completedOrdersRequest.requestId() + " type=" + m_completedOrdersRequest.ddeRequestType().topic());
        byte[] array = OrderUtils.openOrderDataListToByteArray(syncCopyCompletedOrdersList(), null, true);
        m_completedOrdersRequestStatus = DdeRequestStatus.RECEIVED;
        if (m_completedOrdersRequest != null) {
            notifyDde(false, m_completedOrdersRequest.ddeRequestString());
        }
        return array;
    }
    
    /** Method handles cancel completed orders */
    public byte[] handleCompletedOrdersCancel() {
        m_completedOrdersRequestStatus = DdeRequestStatus.UNKNOWN;
        m_completedOrdersRequest = null;
        m_completedOrdersList.clear();
        
        return null;
    }
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates order status for orderId */
    public void updateOrderStatus(OrderStatusData orderStatus) {
        if (orderStatus.orderId() == 0) {
            OpenOrderData openOrderData = m_allOpenOrderDataMap.get(orderStatus.permId());
            if (openOrderData != null) {
                openOrderData.orderStatus(orderStatus);
                openOrderData.isUpdated(true);
            } else {
                m_allOpenOrderDataMap.put(orderStatus.permId(), new OpenOrderData(orderStatus.orderId(), orderStatus, true));
            }
        } else {
            if (m_allOpenOrderDataMap.containsKey(orderStatus.permId())) {
                m_allOpenOrderDataMap.remove(orderStatus.permId());
            }
            OpenOrderData openOrderData = m_openOrderDataMap.get(orderStatus.orderId());
            if (openOrderData != null) {
                openOrderData.orderStatus(orderStatus);
                openOrderData.isUpdated(true);
            } else {
                m_openOrderDataMap.put(orderStatus.orderId(), new OpenOrderData(orderStatus.orderId(), orderStatus, true));
            }
        }

        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (m_openOrdersRequest != null) {
                notifyDde(m_allOrders, m_openOrdersRequest.ddeRequestString());
            }
        }

        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.STATUS.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.FILLED.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.REMAINING.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.AVG_FILL_PRICE.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.PERM_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.PARENT_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.LAST_FILL_PRICE.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.CLIENT_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.WHY_HELD.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.MKT_CAP_PRICE.topic());
    }

    /** Method saves open order data */
    public void updateOpenOrderData(OpenOrderData newOpenOrderData) {
        if (newOpenOrderData.orderId() == 0) {
            OpenOrderData openOrderData = m_allOpenOrderDataMap.get(newOpenOrderData.order().permId());
            if (openOrderData != null) {
                openOrderData.contract(newOpenOrderData.contract());
                openOrderData.order(newOpenOrderData.order());
                openOrderData.orderState(newOpenOrderData.orderState());
                openOrderData.isUpdated(newOpenOrderData.isUpdated());
            } else {
                m_allOpenOrderDataMap.put(newOpenOrderData.order().permId(), newOpenOrderData);
            }
        } else {
            if (m_allOpenOrderDataMap.containsKey(newOpenOrderData.order().permId())) {
                m_allOpenOrderDataMap.remove(newOpenOrderData.order().permId());
            }
            OpenOrderData openOrderData = m_openOrderDataMap.get(newOpenOrderData.orderId());
            if (openOrderData != null) {
                openOrderData.contract(newOpenOrderData.contract());
                openOrderData.order(newOpenOrderData.order());
                openOrderData.orderState(newOpenOrderData.orderState());
                openOrderData.isUpdated(newOpenOrderData.isUpdated());
            } else {
                m_openOrderDataMap.put(newOpenOrderData.orderId(), newOpenOrderData);
            }
        }
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (m_openOrdersRequest != null) {
                notifyDde(m_allOrders, m_openOrdersRequest.ddeRequestString());
            }
        }
    }

    /** Method updates open orders subscription status after openOrderEnd callback is received */
    public void updateOpenOrderEnd() {
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.REQUESTED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (m_openOrdersRequest != null) {
                notifyDde(m_allOrders, m_openOrdersRequest.ddeRequestString());
            }
        }
    }

    /** Method saves completed order data */
    public void updateCompletedOrderData(OrderData completedOrderData) {
        m_completedOrdersList.add(completedOrderData);
    }

    /** Method updates completed orders request status after completedOrdersEnd callback is received */
    public void updateCompletedOrdersEnd() {
        if (m_completedOrdersRequestStatus == DdeRequestStatus.REQUESTED) {
            m_completedOrdersRequestStatus = DdeRequestStatus.RECEIVED;
            if (m_completedOrdersRequest != null) {
                notifyDde(m_completedOrdersRequest.ddeRequestString());
            }
        }
    }
    
    /** Method updates order status with error for orderId */
    public void updateOrderStatusError(int orderId, String errorMessage) {
        OpenOrderData openOrderData = m_openOrderDataMap.get(orderId);
        if (openOrderData != null) {
            openOrderData.orderStatus().errorMessage(errorMessage);
            notifyDde(orderId, DdeRequestType.ORDER_STATUS.topic(), DdeRequestType.ERROR.topic());
        }
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    /** Method sends notification to DDE */
    private void notifyDde(boolean allOrders, String requestStr) {
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(allOrders ? 
                DdeRequestType.REQ_ALL_OPEN_ORDERS.topic() : DdeRequestType.REQ_OPEN_ORDERS.topic(), requestStr);
        twsService().notifyDde(event);
    }

    private void notifyDde(String requestStr) {
        DdeNotificationEvent event = RequestParser.createDdeNotificationEvent(DdeRequestType.REQ_COMPLETED_ORDERS.topic(), requestStr);
        twsService().notifyDde(event);
    }
    
    private List<OrderData> syncCopyOpenOrderDataValues() {
        synchronized(m_openOrderDataMap) {
            ArrayList<OrderData> updatedOpenOrderDataList = new ArrayList<OrderData>();
            for (OpenOrderData openOrderData: m_openOrderDataMap.values()){
                if (openOrderData.isUpdated()) {
                    updatedOpenOrderDataList.add(openOrderData);
                    openOrderData.isUpdated(false);
                }
            }
            return updatedOpenOrderDataList;
        }
    }

    private List<OrderData> syncCopyAllOpenOrderDataValues() {
        synchronized(m_allOpenOrderDataMap) {
            ArrayList<OrderData> updatedAllOpenOrderDataList = new ArrayList<OrderData>();
            for (OpenOrderData openOrderData: m_allOpenOrderDataMap.values()){
                if (openOrderData.isUpdated()) {
                    updatedAllOpenOrderDataList.add(openOrderData);
                    openOrderData.isUpdated(false);
                }
            }
            return updatedAllOpenOrderDataList;
        }
    }

    private List<OrderData> syncCopyCompletedOrdersList() {
        synchronized(m_completedOrdersList) {
            return new ArrayList<OrderData>(m_completedOrdersList);
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parsing
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests 
     * and TWS responses to DDE notifications */
    private class OpenOrdersRequestParser extends RequestParser {
        private Map<Integer, byte[]> m_dataChunks = Collections.synchronizedMap(new HashMap<Integer, byte[]>());

        /** Method parser DDE request string to OpenOrdersRequest */
        private OpenOrdersRequest parseOpenOrdersRequest(String requestStr, boolean allOrders) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            requestId = parseRequestId(messageTokens[0]);
            return new OpenOrdersRequest(requestId, allOrders, requestStr);
        }

        /** Method parses DDE request string to AutoOpenOrdersRequest */
        private AutoOpenOrdersRequest parseAutoOpenOrdersRequest(String requestStr) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            requestId = parseRequestId(messageTokens[0]);
            boolean autoBind = messageTokens[1].equals("true");
            return new AutoOpenOrdersRequest(requestId, autoBind, requestStr);
        }

        /** Method parses DDE request string to PlaceOrderRequest */
        private PlaceOrderRequest parsePlaceOrderRequest(String requestStr, byte[] data) {
            PlaceOrderRequest request = null;
            int requestId = Integer.MAX_VALUE;
            if (data == null) {
                return null;
            }
            Contract contract = null;
            Order order = null;
            requestId = parseRequestId(requestStr);
            ArrayList<String> table1 = null;
            ArrayList<String> table2 = null;
            if (m_dataChunks.containsKey(requestId)){
                byte[] data1 = m_dataChunks.remove(requestId);
                table1 = Utils.convertArrayToTable(data1);
                table2 = Utils.convertArrayToTable(data);
            } else {
                m_dataChunks.put(requestId,  data);
            }
            if (table1 != null && table2 != null) {
                contract = parseContract(table1, true, true, true, true, false);
                order = null;
                if (contract == null) {
                    contract = parseContract(table2, true, true, true, true, false);
                    order= parseOrder(table2, table1);
                } else {
                    order= parseOrder(table1, table2);
                }
                if (contract == null) {
                    return null;
                }
            }
            if (contract != null && order != null) {
                request = new PlaceOrderRequest(requestId, contract, order, requestStr);
            }
            return request;
        }        
        
        /** Method parses DDE request string to OrderStatusRequest */
        private OrderStatusRequest parseOrderStatusRequest(String requestStr) {
            int requestId = Integer.MAX_VALUE;
            String orderStatusField = "";
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                orderStatusField = requestTokens[1];
            }
            OrderStatusRequest request = new OrderStatusRequest(requestId, orderStatusField, requestStr);
            return request;
        }
        
        /** Method parser DDE request string to CompletedOrdersRequest */
        private CompletedOrdersRequest parseCompletedOrdersRequest(String requestStr) {
            int requestId = -1;
            boolean apiOnly = false;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            if (requestTokens.length > 1) {
                apiOnly = getBooleanFromString(requestTokens[1]);
            }
            return new CompletedOrdersRequest(requestId, apiOnly, requestStr);
        }
        
        /** Method parses order fields */
        private Order parseOrder(ArrayList<String> table1, ArrayList<String> table2) {
            Order order = new Order();
            if (table1.size() < 21) {
                System.out.println("Cannot extract base order fields");
                return null;
            }
            if (table2.size() < 113) {
                System.out.println("Cannot extract extended order attributes");
                return null;
            }
            // base order fields
            if (Utils.isNotNull(table1.get(16))) {
                order.action(table1.get(16));
            }
            if (Utils.isNotNull(table1.get(17))) {
                order.totalQuantity(getDoubleFromString(table1.get(17)));
            }
            if (Utils.isNotNull(table1.get(18))) {
                order.orderType(table1.get(18));
            }
            if (Utils.isNotNull(table1.get(19))) {
                order.lmtPrice(getDoubleFromString(table1.get(19)));
            }
            if (Utils.isNotNull(table1.get(20))) {
                order.auxPrice(getDoubleFromString(table1.get(20)));
            }
            
            // extended order attributes
            if (Utils.isNotNull(table2.get(0))) {
                order.tif(table2.get(0));
            }
            if (Utils.isNotNull(table2.get(1))) {
                order.displaySize(getIntFromString(table2.get(1)));
            }
            if (Utils.isNotNull(table2.get(2))) {
                order.settlingFirm(table2.get(2));
            }
            if (Utils.isNotNull(table2.get(3))) {
                order.clearingAccount(table2.get(3));
            }
            if (Utils.isNotNull(table2.get(4))) {
                order.clearingIntent(table2.get(4));
            }
            if (Utils.isNotNull(table2.get(5))) {
                order.openClose(table2.get(5));
            }
            if (Utils.isNotNull(table2.get(6))) {
                order.origin(getIntFromString(table2.get(6)));
            }
            if (Utils.isNotNull(table2.get(7))) {
                order.shortSaleSlot(getIntFromString(table2.get(7)));
            }
            if (Utils.isNotNull(table2.get(8))) {
                order.designatedLocation(table2.get(8));
            }
            if (Utils.isNotNull(table2.get(9))) {
                order.exemptCode(getIntFromString(table2.get(9)));
            }
            if (Utils.isNotNull(table2.get(10))) {
                order.allOrNone(getBooleanFromString(table2.get(10)));
            }
            if (Utils.isNotNull(table2.get(11))) {
                order.blockOrder(getBooleanFromString(table2.get(11)));
            }
            if (Utils.isNotNull(table2.get(12))) {
                order.hidden(getBooleanFromString(table2.get(12)));
            }
            if (Utils.isNotNull(table2.get(13))) {
                order.outsideRth(getBooleanFromString(table2.get(13)));
            }
            if (Utils.isNotNull(table2.get(14))) {
                order.sweepToFill(getBooleanFromString(table2.get(14)));
            }
            if (Utils.isNotNull(table2.get(15))) {
                order.percentOffset(getDoubleFromString(table2.get(15)));
            }
            if (Utils.isNotNull(table2.get(16))) {
                order.trailingPercent(getDoubleFromString(table2.get(16)));
            }
            if (Utils.isNotNull(table2.get(17))) {
                order.trailStopPrice(getDoubleFromString(table2.get(17)));
            }
            if (Utils.isNotNull(table2.get(18))) {
                order.minQty(getIntFromString(table2.get(18)));
            }
            if (Utils.isNotNull(table2.get(19))) {
                order.goodAfterTime(table2.get(19));
            }
            if (Utils.isNotNull(table2.get(20))) {
                order.goodTillDate(table2.get(20));
            }
            if (Utils.isNotNull(table2.get(21))) {
                order.ocaGroup(table2.get(21));
            }
            if (Utils.isNotNull(table2.get(22))) {
                order.ocaType(getIntFromString(table2.get(22)));
            }
            if (Utils.isNotNull(table2.get(23))) {
                order.orderRef(table2.get(23));
            }
            if (Utils.isNotNull(table2.get(24))) {
                order.rule80A(table2.get(24));
            }
            if (Utils.isNotNull(table2.get(25))) {
                order.triggerMethod(getIntFromString(table2.get(25)));
            }
            if (Utils.isNotNull(table2.get(26))) {
                order.activeStartTime(table2.get(26));
            }
            if (Utils.isNotNull(table2.get(27))) {
                order.activeStopTime(table2.get(27));
            }
            if (Utils.isNotNull(table2.get(28))) {
                order.account(table2.get(28));
            }
            if (Utils.isNotNull(table2.get(29))) {
                order.faGroup(table2.get(29));
            }
            if (Utils.isNotNull(table2.get(30))) {
                order.faMethod(table2.get(30));
            }
            if (Utils.isNotNull(table2.get(31))) {
                order.faPercentage(table2.get(31));
            }
            if (Utils.isNotNull(table2.get(32))) {
                order.faProfile(table2.get(32));
            }
            if (Utils.isNotNull(table2.get(33))) {
                order.volatility(getDoubleFromString(table2.get(33)));
            }
            if (Utils.isNotNull(table2.get(34))) {
                order.volatilityType(getIntFromString(table2.get(34)));
            }
            if (Utils.isNotNull(table2.get(35))) {
                order.continuousUpdate(getIntFromString(table2.get(35)));
            }
            if (Utils.isNotNull(table2.get(36))) {
                order.referencePriceType(getIntFromString(table2.get(36)));
            }
            if (Utils.isNotNull(table2.get(37))) {
                order.deltaNeutralOrderType(table2.get(37));
            }
            if (Utils.isNotNull(table2.get(38))) {
                order.deltaNeutralAuxPrice(getDoubleFromString(table2.get(38)));
            }
            if (Utils.isNotNull(table2.get(39))) {
                order.deltaNeutralConId(getIntFromString(table2.get(39)));
            }
            if (Utils.isNotNull(table2.get(40))) {
                order.deltaNeutralOpenClose(table2.get(40));
            }
            if (Utils.isNotNull(table2.get(41))) {
                order.deltaNeutralShortSale(getBooleanFromString(table2.get(41)));
            }
            if (Utils.isNotNull(table2.get(42))) {
                order.deltaNeutralShortSaleSlot(getIntFromString(table2.get(42)));
            }
            if (Utils.isNotNull(table2.get(43))) {
                order.deltaNeutralDesignatedLocation(table2.get(43));
            }
            if (Utils.isNotNull(table2.get(44))) {
                order.deltaNeutralSettlingFirm(table2.get(44));
            }
            if (Utils.isNotNull(table2.get(45))) {
                order.deltaNeutralClearingAccount(table2.get(45));
            }
            if (Utils.isNotNull(table2.get(46))) {
                order.deltaNeutralClearingIntent(table2.get(46));
            }
            if (Utils.isNotNull(table2.get(47))) {
                order.scaleInitLevelSize(getIntFromString(table2.get(47)));
            }
            if (Utils.isNotNull(table2.get(48))) {
                order.scaleSubsLevelSize(getIntFromString(table2.get(48)));
            }
            if (Utils.isNotNull(table2.get(49))) {
                order.scalePriceIncrement(getDoubleFromString(table2.get(49)));
            }
            if (Utils.isNotNull(table2.get(50))) {
                order.scalePriceAdjustValue(getDoubleFromString(table2.get(50)));
            }
            if (Utils.isNotNull(table2.get(51))) {
                order.scalePriceAdjustInterval(getIntFromString(table2.get(51)));
            }
            if (Utils.isNotNull(table2.get(52))) {
                order.scaleProfitOffset(getDoubleFromString(table2.get(52)));
            }
            if (Utils.isNotNull(table2.get(53))) {
                order.scaleAutoReset(getBooleanFromString(table2.get(53)));
            }
            if (Utils.isNotNull(table2.get(54))) {
                order.scaleInitPosition(getIntFromString(table2.get(54)));
            }
            if (Utils.isNotNull(table2.get(55))) {
                order.scaleInitFillQty(getIntFromString(table2.get(55)));
            }
            if (Utils.isNotNull(table2.get(56))) {
                order.scaleRandomPercent(getBooleanFromString(table2.get(56)));
            }
            if (Utils.isNotNull(table2.get(57))) {
                order.scaleTable(table2.get(57));
            }
            if (Utils.isNotNull(table2.get(58))) {
                order.hedgeType(table2.get(58));
            }
            if (Utils.isNotNull(table2.get(59))) {
                order.hedgeParam(table2.get(59));
            }
            if (Utils.isNotNull(table2.get(60))) {
                order.dontUseAutoPriceForHedge(getBooleanFromString(table2.get(60)));
            }
            if (Utils.isNotNull(table2.get(61))) {
                order.algoStrategy(table2.get(61));
            }
            if (Utils.isNotNull(table2.get(62))) {
                order.algoParams(parseTagValueStr(table2.get(62)));
            }
            if (Utils.isNotNull(table2.get(63))) {
                order.algoId(table2.get(63));
            }
            if (Utils.isNotNull(table2.get(64))) {
                order.smartComboRoutingParams(parseTagValueStr(table2.get(64)));
            }
            if (Utils.isNotNull(table2.get(65))) {
                order.orderComboLegs(parseOrderComboLegStr(table2.get(65)));
            }
            if (Utils.isNotNull(table2.get(66))) {
                order.transmit(getBooleanFromString(table2.get(66)));
            }
            if (Utils.isNotNull(table2.get(67))) {
                order.parentId(getIntFromString(table2.get(67)));
            }
            if (Utils.isNotNull(table2.get(68))) {
                order.overridePercentageConstraints(getBooleanFromString(table2.get(68)));
            }
            if (Utils.isNotNull(table2.get(69))) {
                order.discretionaryAmt(getDoubleFromString(table2.get(69)));
            }
            if (Utils.isNotNull(table2.get(70))) {
                order.eTradeOnly(getBooleanFromString(table2.get(70)));
            }
            if (Utils.isNotNull(table2.get(71))) {
                order.firmQuoteOnly(getBooleanFromString(table2.get(71)));
            }
            if (Utils.isNotNull(table2.get(72))) {
                order.nbboPriceCap(getDoubleFromString(table2.get(72)));
            }
            if (Utils.isNotNull(table2.get(73))) {
                order.optOutSmartRouting(getBooleanFromString(table2.get(73)));
            }
            if (Utils.isNotNull(table2.get(74))) {
                order.auctionStrategy(getIntFromString(table2.get(74)));
            }
            if (Utils.isNotNull(table2.get(75))) {
                order.startingPrice(getDoubleFromString(table2.get(75)));
            }
            if (Utils.isNotNull(table2.get(76))) {
                order.stockRefPrice(getDoubleFromString(table2.get(76)));
            }
            if (Utils.isNotNull(table2.get(77))) {
                order.delta(getDoubleFromString(table2.get(77)));
            }
            if (Utils.isNotNull(table2.get(78))) {
                order.stockRangeLower(getDoubleFromString(table2.get(78)));
            }
            if (Utils.isNotNull(table2.get(79))) {
                order.stockRangeUpper(getDoubleFromString(table2.get(79)));
            }
            if (Utils.isNotNull(table2.get(80))) {
                order.basisPoints(getDoubleFromString(table2.get(80)));
            }
            if (Utils.isNotNull(table2.get(81))) {
                order.basisPointsType(getIntFromString(table2.get(81)));
            }
            if (Utils.isNotNull(table2.get(82))) {
                order.notHeld(getBooleanFromString(table2.get(82)));
            }
            if (Utils.isNotNull(table2.get(83))) {
                order.orderMiscOptions(parseTagValueStr(table2.get(83)));
            }
            if (Utils.isNotNull(table2.get(84))) {
                order.solicited(getBooleanFromString(table2.get(84)));
            }
            if (Utils.isNotNull(table2.get(85))) {
                order.randomizeSize(getBooleanFromString(table2.get(85)));
            }
            if (Utils.isNotNull(table2.get(86))) {
                order.randomizePrice(getBooleanFromString(table2.get(86)));
            }
            if (Utils.isNotNull(table2.get(87))) {
                order.referenceContractId(getIntFromString(table2.get(87)));
            }
            if (Utils.isNotNull(table2.get(88))) {
                order.peggedChangeAmount(getDoubleFromString(table2.get(88)));
            }
            if (Utils.isNotNull(table2.get(89))) {
                order.isPeggedChangeAmountDecrease(getBooleanFromString(table2.get(89)));
            }
            if (Utils.isNotNull(table2.get(90))) {
                order.referenceChangeAmount(getDoubleFromString(table2.get(90)));
            }
            if (Utils.isNotNull(table2.get(91))) {
                order.referenceExchangeId(table2.get(91));
            }
            if (Utils.isNotNull(table2.get(92))) {
                order.adjustedOrderType(OrderType.get(table2.get(92)));
            }
            if (Utils.isNotNull(table2.get(93))) {
                order.triggerPrice(getDoubleFromString(table2.get(93)));
            }
            if (Utils.isNotNull(table2.get(94))) {
                order.adjustedStopPrice(getDoubleFromString(table2.get(94)));
            }
            if (Utils.isNotNull(table2.get(95))) {
                order.adjustedStopLimitPrice(getDoubleFromString(table2.get(95)));
            }
            if (Utils.isNotNull(table2.get(96))) {
                order.adjustedTrailingAmount(getDoubleFromString(table2.get(96)));
            }
            if (Utils.isNotNull(table2.get(97))) {
                order.adjustableTrailingUnit(getIntFromString(table2.get(97)));
            }
            if (Utils.isNotNull(table2.get(98))) {
                order.lmtPriceOffset(getDoubleFromString(table2.get(98)));
            }
            if (Utils.isNotNull(table2.get(99))) {
                order.conditions(parseOrderConditionsStr(table2.get(99)));
            }
            if (Utils.isNotNull(table2.get(100))) {
                order.conditionsIgnoreRth(getBooleanFromString(table2.get(100)));
            }
            if (Utils.isNotNull(table2.get(101))) {
                order.conditionsCancelOrder(getBooleanFromString(table2.get(101)));
            }
            if (Utils.isNotNull(table2.get(102))) {
                order.modelCode(table2.get(102));
            }
            if (Utils.isNotNull(table2.get(103))) {
                order.extOperator(table2.get(103));
            }
            if (Utils.isNotNull(table2.get(104))) {
                order.softDollarTier(parseSoftDollarTierStr(table2.get(104)));
            }
            if (Utils.isNotNull(table2.get(105))) {
                order.cashQty(getDoubleFromString(table2.get(105)));
            }
            if (Utils.isNotNull(table2.get(106))) {
                order.mifid2DecisionMaker(table2.get(106));
            }
            if (Utils.isNotNull(table2.get(107))) {
                order.mifid2DecisionAlgo(table2.get(107));
            }
            if (Utils.isNotNull(table2.get(108))) {
                order.mifid2ExecutionTrader(table2.get(108));
            }
            if (Utils.isNotNull(table2.get(109))) {
                order.mifid2ExecutionAlgo(table2.get(109));
            }
            if (Utils.isNotNull(table2.get(110))) {
                order.isOmsContainer(getBooleanFromString(table2.get(110)));
            }
            if (Utils.isNotNull(table2.get(111))) {
                order.discretionaryUpToLimitPrice(getBooleanFromString(table2.get(111)));
            }
            if (Utils.isNotNull(table2.get(112))) {
                order.usePriceMgmtAlgo(getBooleanFromString(table2.get(112)));
            }
            
            return order;
        }

        /** Method parses order combo leg string in format: "price2;price2;" into List<OrderComboLeg> */
        private List<OrderComboLeg> parseOrderComboLegStr(String orderComboLegStr) {
            List<OrderComboLeg> orderComboLegList = new ArrayList<OrderComboLeg>();
            String[] splittedOrderComboLegStr = orderComboLegStr.split(SEMICOLON_SIGN);
            for (String priceStr : splittedOrderComboLegStr) {
                orderComboLegList.add(new OrderComboLeg(getDoubleFromString(priceStr)));
            }
            return orderComboLegList;
        }

        /** Method parses order conditions string in format: "type1_param11_param12_...;type2_param21_param22_...;" 
         * into List<OrderCondition> */
        private List<OrderCondition> parseOrderConditionsStr(String orderConditionsStr) {
            List<OrderCondition> orderConditionList = new ArrayList<OrderCondition>();
            if (orderConditionsStr == null || orderConditionsStr.isEmpty()) {
                return orderConditionList;
            }
            String[] splittedOrderConditionsStr = orderConditionsStr.split(SEMICOLON_SIGN);
            for (String orderConditionStr : splittedOrderConditionsStr) {
                String[] splittedOrderConditionStr = orderConditionStr.split(PARAM_SEPARATOR);
                if (splittedOrderConditionStr.length >= 1) {
                    OrderConditionType orderConditionType = OrderConditionType.fromString(splittedOrderConditionStr[0].toUpperCase());
                    OrderCondition orderCondition = OrderCondition.create(orderConditionType);
                    if (splittedOrderConditionStr.length >= 2) {
                        orderCondition.conjunctionConnection(getBooleanFromString(splittedOrderConditionStr[1]));
                        switch (orderConditionType) {
                            case Execution:
                                if (splittedOrderConditionStr.length >= 5) {
                                    ((ExecutionCondition)orderCondition).symbol(splittedOrderConditionStr[2]);
                                    ((ExecutionCondition)orderCondition).secType(splittedOrderConditionStr[3]);
                                    ((ExecutionCondition)orderCondition).exchange(splittedOrderConditionStr[4]);
                                }
                                break;
                            case Margin:
                                if (splittedOrderConditionStr.length >= 4) {
                                    ((MarginCondition)orderCondition).isMore(getBooleanFromString(splittedOrderConditionStr[2]));
                                    ((MarginCondition)orderCondition).percent(getIntFromString(splittedOrderConditionStr[3]));
                                }
                                break;
                            case PercentChange:
                                if (splittedOrderConditionStr.length >= 6) {
                                    ((PercentChangeCondition)orderCondition).isMore(getBooleanFromString(splittedOrderConditionStr[2]));
                                    ((PercentChangeCondition)orderCondition).conId(getIntFromString(splittedOrderConditionStr[3]));
                                    ((PercentChangeCondition)orderCondition).exchange(splittedOrderConditionStr[4]);
                                    ((PercentChangeCondition)orderCondition).changePercent(getDoubleFromString(splittedOrderConditionStr[5]));
                                }
                                break;
                            case Price:
                                if (splittedOrderConditionStr.length >= 7) {
                                    ((PriceCondition)orderCondition).isMore(getBooleanFromString(splittedOrderConditionStr[2]));
                                    ((PriceCondition)orderCondition).conId(getIntFromString(splittedOrderConditionStr[3]));
                                    ((PriceCondition)orderCondition).exchange(splittedOrderConditionStr[4]);
                                    ((PriceCondition)orderCondition).price(getDoubleFromString(splittedOrderConditionStr[5]));
                                    ((PriceCondition)orderCondition).triggerMethod(getIntFromString(splittedOrderConditionStr[6]));
                                }
                                break;
                            case Time:
                                if (splittedOrderConditionStr.length >= 4) {
                                    ((TimeCondition)orderCondition).isMore(getBooleanFromString(splittedOrderConditionStr[2]));
                                    ((TimeCondition)orderCondition).time(splittedOrderConditionStr[3]);
                                }
                                break;
                            case Volume:
                                if (splittedOrderConditionStr.length >= 6) {
                                    ((VolumeCondition)orderCondition).isMore(getBooleanFromString(splittedOrderConditionStr[2]));
                                    ((VolumeCondition)orderCondition).conId(getIntFromString(splittedOrderConditionStr[3]));
                                    ((VolumeCondition)orderCondition).exchange(splittedOrderConditionStr[4]);
                                    ((VolumeCondition)orderCondition).volume(getIntFromString(splittedOrderConditionStr[5]));
                                }
                                break;
                        }
                        orderConditionList.add(orderCondition);
                    }
                    
                    
                }
            }
            
            return orderConditionList;
        }
        
        /** Method parses soft dollar tier string in format: "tag1=value1;tag2=valu2;" into List<TagValue> */
        private SoftDollarTier parseSoftDollarTierStr(String softDollarTierStr) {
            SoftDollarTier softDollarTier = new SoftDollarTier(EMPTY_STR, EMPTY_STR, EMPTY_STR);
            String[] splittedSoftDollarTierStr = softDollarTierStr.split(SEMICOLON_SIGN);
            if (splittedSoftDollarTierStr.length >= 3) {
                softDollarTier = new SoftDollarTier(splittedSoftDollarTierStr[0], splittedSoftDollarTierStr[1], splittedSoftDollarTierStr[2]);
            }
            return softDollarTier;
        }
        
    }
    
}
