/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.old.handlers;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.SortedMap;
import java.util.StringTokenizer;
import java.util.TreeMap;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.orders.OrderStatusRequest;
import com.ib.api.dde.dde2socket.requests.orders.PlaceOrderRequest;
import com.ib.api.dde.handlers.OrdersHandler;
import com.ib.api.dde.old.requests.parser.OldRequestParser;
import com.ib.api.dde.old.utils.OldUtils;
import com.ib.api.dde.socket2dde.data.OpenOrderData;
import com.ib.api.dde.socket2dde.data.OrderData;
import com.ib.api.dde.socket2dde.data.OrderStatusData;
import com.ib.api.dde.utils.OrderUtils;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.Order;

/** Class handles orders related requests and messages */
public class OldOrdersHandler extends OrdersHandler {

    private static final String PLACE = "place";
    private static final String PLACE2 = "place2";
    private static final String CANCEL = "cancel";

    // parser
    private OldOpenOrdersRequestParser m_requestParser = new OldOpenOrdersRequestParser();

    // open orders
    private String m_openOrdersRequestStr = "";
    private SortedMap<Integer, OpenOrderData> m_openOrderDataMap = Collections.synchronizedSortedMap(new TreeMap<Integer, OpenOrderData>()); // map orderId->OpenOrderData
    private DdeRequestStatus m_openOrdersSubscriptionStatus = DdeRequestStatus.UNKNOWN;

    public OldOrdersHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method requests open orders and sets open order subscription status */
    public String handleOpenOrdersRequest(String requestStr) {
        m_openOrdersRequestStr = requestStr;
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.UNKNOWN) {
            System.out.println("Handling open orders request: " + requestStr);
            m_openOrderDataMap.clear();
            clientSocket().reqOpenOrders();
            m_openOrdersSubscriptionStatus = DdeRequestStatus.REQUESTED;
        }
        return m_openOrdersSubscriptionStatus.toString();
    }

    /** Method handles open orders array request */
    @Override
    public byte[] handleOpenOrdersArrayRequest(String requestStr) {
        System.out.println("Handling open orders array request: " + requestStr);
        byte[] array = OrderUtils.openOrderDataListToByteArray(syncCopyOpenOrderDataValues(), null, false);
        m_openOrdersSubscriptionStatus = DdeRequestStatus.SUBSCRIBED;
        if (Utils.isNotNull(m_openOrdersRequestStr)) {
            notifyDde(DdeRequestType.OPENS.topic(), m_openOrdersRequestStr);
        }
        return array;
    }

    /** Method stops open orders advise loop */
    public void handleOpenOrdersStopAdvise(String requestStr) {
        System.out.println("Handling open orders stop advise: " + requestStr);
        m_openOrdersSubscriptionStatus = DdeRequestStatus.UNKNOWN;
    }    

    /** Method handles place order/cancel order/order status request */
    public String handlePlaceOrderRequest(String requestStr) {
        DdeRequest ddeRequest = m_requestParser.parsePlaceOrderRequest(requestStr);
        String ret = "";
        if (ddeRequest != null) {
            if (ddeRequest instanceof PlaceOrderRequest) {
                // place order
                PlaceOrderRequest request = (PlaceOrderRequest)ddeRequest;  
                System.out.println("Placing order: id=" + request.requestId() + " for contract=" + Utils.shortContractString(request.contract()) + " order=" + Utils.shortOrderString(request.order()));
                clientSocket().placeOrder(request.requestId(), request.contract(), request.order()); 
                
                OrderStatusData orderStatus = new OrderStatusData(request.requestId(), "Sent", 0, 
                        request.order().totalQuantity(), 0, request.order().permId(), request.order().parentId(), 
                        0, request.order().clientId(), "", 0); 
                OpenOrderData openOrderData = new OpenOrderData(request.requestId(), request.contract(), request.order(), null, orderStatus, false);
                m_openOrderDataMap.put(request.requestId(), openOrderData);
            } else if (ddeRequest instanceof OrderStatusRequest) {
                // request order status
                OrderStatusRequest request = (OrderStatusRequest)ddeRequest;
                System.out.println("Handling order status request: id=" + request.requestId() + " field=" + request.field());
                OpenOrderData openOrderData = m_openOrderDataMap.get(request.requestId());
                if (openOrderData != null) {
                    OrderStatusData orderStatus = openOrderData.orderStatus();
                    ret = OrderUtils.getFieldValueFromOrderStatusRequest(request, orderStatus);
                }
            } else {
                // cancel order
                System.out.println("Cancelling order: id=" + ddeRequest.requestId());
                clientSocket().cancelOrder(ddeRequest.requestId()); 
            }
        }
            
        return ret;
    }

    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    /** Method updates order status for orderId */
    @Override
    public void updateOrderStatus(OrderStatusData orderStatus) {
        OpenOrderData openOrderData = m_openOrderDataMap.get(orderStatus.orderId());
        if (openOrderData != null) {
            openOrderData.orderStatus(orderStatus);
            openOrderData.isUpdated(true);
        } else {
            m_openOrderDataMap.put(orderStatus.orderId(), new OpenOrderData(orderStatus.orderId(), orderStatus, true));
        }

        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (Utils.isNotNull(m_openOrdersRequestStr)) {
                notifyDde(DdeRequestType.OPENS.topic(), m_openOrdersRequestStr);
            }
        }

        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.STATUS.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.FILLED.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.REMAINING.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.AVG_FILL_PRICE.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.PERM_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.PARENT_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.LAST_FILL_PRICE.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.CLIENT_ID.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.WHY_HELD.topic());
        notifyDde(orderStatus.orderId(), DdeRequestType.ORD.topic(), DdeRequestType.MKT_CAP_PRICE.topic());
    }

    /** Method saves open order data */
    @Override
    public void updateOpenOrderData(OpenOrderData newOpenOrderData) {
        OpenOrderData openOrderData = m_openOrderDataMap.get(newOpenOrderData.orderId());
        if (openOrderData != null) {
            openOrderData.contract(newOpenOrderData.contract());
            openOrderData.order(newOpenOrderData.order());
            openOrderData.orderState(newOpenOrderData.orderState());
            openOrderData.isUpdated(newOpenOrderData.isUpdated());
        } else {
            m_openOrderDataMap.put(newOpenOrderData.orderId(), newOpenOrderData);
        }
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.SUBSCRIBED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (Utils.isNotNull(m_openOrdersRequestStr)) {
                notifyDde(DdeRequestType.OPENS.topic(), m_openOrdersRequestStr);
            }
        }
    }

    /** Method updates open orders subscription status after openOrderEnd callback is received */
    @Override
    public void updateOpenOrderEnd() {
        if (m_openOrdersSubscriptionStatus == DdeRequestStatus.REQUESTED) {
            m_openOrdersSubscriptionStatus = DdeRequestStatus.RECEIVED;
            if (Utils.isNotNull(m_openOrdersRequestStr)) {
                notifyDde(DdeRequestType.OPENS.topic(), m_openOrdersRequestStr);
            }
        }
    }

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<OrderData> syncCopyOpenOrderDataValues() {
        synchronized(m_openOrderDataMap) {
            ArrayList<OrderData> updatedOpenOrderDataList = new ArrayList<OrderData>();
            for (OpenOrderData openOrderData: m_openOrderDataMap.values()){
                updatedOpenOrderDataList.add(openOrderData);
            }
            return updatedOpenOrderDataList;
        }
    }

    /* *****************************************************************************************************
     *                                          Parsing
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class OldOpenOrdersRequestParser extends OldRequestParser {
        /** Method parses DDE request string to appropriate DDE request */
        private DdeRequest parsePlaceOrderRequest(String requestStr) {

            DdeRequest request = null;
            int requestId = Integer.MAX_VALUE;
            String[] requestTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (requestTokens.length > 0) {
                requestId = parseRequestId(requestTokens[0]);
            }
            String tickTypeStr = "";
            if (requestTokens.length > 1) {
                tickTypeStr = requestTokens[1];
            }
            if (tickTypeStr.equals(PLACE) || tickTypeStr.equals(PLACE2)) {
                String[] contractDetails = requestTokens[2].split(CONTRACT_DETAILS_SEPARATOR);
                String contractStr = "";
                String orderStr = "";
                Contract contract = null;
                Order order = null;
                if (contractDetails.length > 0) {
                    contractStr = contractDetails[0];
                }
                contract = tickTypeStr.equals(PLACE) ? parseContract(contractStr, false, true, false) : parseContract(contractStr, true, true, false);
                if (contractDetails.length > 1) {
                    orderStr = contractDetails[1];
                }
                order = parseOrder(orderStr);
                if (contract != null && order != null) {
                    request = new PlaceOrderRequest(requestId, contract, order, requestStr);
                }
            } else if (tickTypeStr.equals(CANCEL)) {
                request = new DdeRequest(requestId, DdeRequestType.CANCEL_ORDER, requestStr);
               
            } else {
                request = new OrderStatusRequest(requestId, tickTypeStr, requestStr);
            }
            
            return request;
        }        
        
        /** Method parses order fields */
        private Order parseOrder(String orderStr) {
            Order order = new Order();
            StringTokenizer st = new StringTokenizer(orderStr, PARAM_SEPARATOR);
            
            String token = getParameter(st);
            if (Utils.isNotNull(token)){
                order.action(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                order.totalQuantity(Double.parseDouble(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)){
                order.orderType(token);
            }
            if (OldUtils.hasLmtPrice(order.getOrderType())) {
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    order.lmtPrice(getDoubleFromString(token));
                }
            }
            if (OldUtils.hasAuxPrice(order.getOrderType())) {
                token = getParameter(st);
                if (Utils.isNotNull(token)){
                    order.auxPrice(getDoubleFromString(token));
                }
            }
            token = getParameter(st); // empty
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.tif(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.ocaGroup(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.account(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.openClose(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.origin(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.orderRef(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.transmit(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.parentId(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.blockOrder(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.sweepToFill(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.displaySize(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.triggerMethod(getIntFromString(token));
            }
            token = getParameter(st); // ignoreRth (not used)
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.hidden(getBooleanFromString(token));
            }
            token = getParameter(st); // discretionaryAmount
            if (Utils.isNotNull(token)) {
                order.discretionaryAmt(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.goodAfterTime(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.goodTillDate(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.faGroup(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.faMethod(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.faPercentage(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.faProfile(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.shortSaleSlot(getIntFromString(token));
            }
            token = getParameter(st); // empty (not used)
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.designatedLocation(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.ocaType(getIntFromString(token));
            }
            token = getParameter(st); // empty (not used)
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.rule80A(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.settlingFirm(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.allOrNone(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.minQty(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.percentOffset(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.eTradeOnly(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.firmQuoteOnly(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.nbboPriceCap(getDoubleFromString(token));
            }
            token = getParameter(st); // empty (not used)
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.startingPrice(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.stockRefPrice(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.delta(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.stockRangeLower(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.stockRangeUpper(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.volatility(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.volatilityType(getIntFromString(token));
            }
            token = getParameter(st); // referencePriceType
            if (Utils.isNotNull(token)) {
                order.referencePriceType(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.deltaNeutralOrderType(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.continuousUpdate(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.deltaNeutralAuxPrice(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.trailStopPrice(getDoubleFromString(token));
            }
            token = getParameter(st); // empty (not used)
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.scaleInitLevelSize(getIntFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.scalePriceIncrement(getDoubleFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.outsideRth(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.clearingAccount(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.clearingIntent(token);
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.optOutSmartRouting(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.solicited(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.randomizeSize(getBooleanFromString(token));
            }
            token = getParameter(st);
            if (Utils.isNotNull(token)) {
                order.randomizePrice(getBooleanFromString(token));
            }

            return order;
        }
    }
    
}
