/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;
import java.util.List;

import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.orders.OrderStatusRequest;
import com.ib.api.dde.socket2dde.data.OpenOrderData;
import com.ib.api.dde.socket2dde.data.OrderStatusData;

/** Class contains some utility methods related to order requests */
public class OrderUtils {

    /** Method converts openOrderData list to byte array*/
   public static byte[] openOrderDataListToByteArray(List<OpenOrderData> openOrderDataList, List<OpenOrderData> allOpenOrderDataList, boolean isNew) {
        ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();

        int index = 1;
        if (allOpenOrderDataList != null) {
            for (int i = 0; i < allOpenOrderDataList.size(); i++) {
                OpenOrderData msg = allOpenOrderDataList.get(i);
                ArrayList<String> item = createTableItem(msg, isNew, index++);
                list.add(new ArrayList<String>(item));
                item.clear();
            }
        }
        for (int i = 0; i < openOrderDataList.size(); i++) {
            OpenOrderData msg = openOrderDataList.get(i);
            ArrayList<String> item = createTableItem(msg, isNew, index++);
            list.add(new ArrayList<String>(item));
            item.clear();
        }
        byte[] bytes = list.size() > 0 ? Utils.convertTableToByteArray(list) : null;
        return bytes;
    }

    /** Method creates single table row (array of strings) from OpenOrderData */
    private static ArrayList<String> createTableItem(OpenOrderData openOrderData, boolean isNew, int index) {
        ArrayList<String> item = new ArrayList<String>();
        if (openOrderData.contract() != null) {
            item.add(Utils.toString(openOrderData.contract().symbol()));
            item.add(Utils.toString(openOrderData.contract().getSecType()));
            item.add(Utils.toString(openOrderData.contract().lastTradeDateOrContractMonth()));
            item.add(Utils.toString(openOrderData.contract().strike()));
            item.add(Utils.toString(openOrderData.contract().getRight()));
            item.add(Utils.toString(openOrderData.contract().multiplier()));
            item.add(Utils.toString(openOrderData.contract().tradingClass()));
            item.add(Utils.toString(openOrderData.contract().exchange()));
            item.add(Utils.toString(openOrderData.contract().primaryExch()));
            item.add(Utils.toString(openOrderData.contract().currency()));
            if (isNew) {
                item.add(Utils.toString(openOrderData.contract().localSymbol()));
                item.add(Utils.toString(openOrderData.contract().conid()));
                item.add(Utils.comboLegsListToString(openOrderData.contract().comboLegs()));
                item.add(Utils.deltaNeutralContractToString(openOrderData.contract().deltaNeutralContract()));
            } else {
                item.add("");
            }
        } else {
            for (int j = 0; j < (isNew ? 14 : 11); j++) {
                item.add(Utils.toString(""));
            }
        }
        
        if (openOrderData.order() != null) {
            item.add(Utils.toString(openOrderData.order().getAction()));
            item.add(Utils.toString(openOrderData.order().totalQuantity()));
            item.add(Utils.toString(openOrderData.order().getOrderType()));
            item.add(Utils.toString(openOrderData.order().lmtPrice()));
            item.add(Utils.toString(openOrderData.order().auxPrice()));
            if (!isNew) {
                item.add(Utils.toString(index));
            }
            item.add(Utils.toString(openOrderData.order().orderId()));
        } else {
            for (int j = 0; j < (isNew ? 6 : 7); j++) {
                item.add(Utils.toString(""));
            }
        }
         
        if (openOrderData.orderStatus() != null) {
            item.add(Utils.toString(openOrderData.orderStatus().status()));
            item.add(Utils.toString(openOrderData.orderStatus().filled(), "0"));
            item.add(Utils.toString(openOrderData.orderStatus().remaining(), "0"));
            item.add(Utils.toString(openOrderData.orderStatus().avgFillPrice()));
            item.add(Utils.toString(openOrderData.orderStatus().lastFillPrice()));
            if (isNew) {
                item.add(Utils.toString(openOrderData.orderStatus().whyHeld()));
                item.add(Utils.toString(openOrderData.orderStatus().mktCapPrice()));
            }
            item.add(Utils.toString(openOrderData.orderStatus().parentId()));
            if (isNew) {
                item.add(Utils.toString(openOrderData.orderStatus().clientId(), "0"));
                item.add(Utils.toString(openOrderData.orderStatus().permId()));
            }
        } else {
            for (int j = 0; j < (isNew ? 10 : 6); j++) {
                item.add(Utils.toString(""));
            }
        }


        
        
        
        // new
        if (isNew) {
            if (openOrderData.order() != null) {
                item.add(Utils.toString(openOrderData.order().getTif()));
                item.add(Utils.toString(openOrderData.order().displaySize()));
                item.add(Utils.toString(openOrderData.order().settlingFirm()));
                item.add(Utils.toString(openOrderData.order().clearingAccount()));
                item.add(Utils.toString(openOrderData.order().clearingIntent()));
                item.add(Utils.toString(openOrderData.order().openClose()));
                item.add(Utils.toString(openOrderData.order().origin()));
                item.add(Utils.toString(openOrderData.order().shortSaleSlot()));
                item.add(Utils.toString(openOrderData.order().designatedLocation()));
                item.add(Utils.toString(openOrderData.order().exemptCode()));
                item.add(Utils.toString(openOrderData.order().allOrNone()));
                item.add(Utils.toString(openOrderData.order().blockOrder()));
                item.add(Utils.toString(openOrderData.order().hidden()));
                item.add(Utils.toString(openOrderData.order().outsideRth()));
                item.add(Utils.toString(openOrderData.order().sweepToFill()));
                item.add(Utils.toString(openOrderData.order().percentOffset()));
                item.add(Utils.toString(openOrderData.order().trailingPercent()));
                item.add(Utils.toString(openOrderData.order().trailStopPrice()));
                item.add(Utils.toString(openOrderData.order().minQty()));
                item.add(Utils.toString(openOrderData.order().goodAfterTime()));
                item.add(Utils.toString(openOrderData.order().goodTillDate()));
                item.add(Utils.toString(openOrderData.order().ocaGroup()));
                item.add(Utils.toString(openOrderData.order().getOcaType()));
                item.add(Utils.toString(openOrderData.order().orderRef()));
                item.add(Utils.toString(openOrderData.order().getRule80A()));
                item.add(Utils.toString(openOrderData.order().getTriggerMethod()));
                item.add(Utils.toString(openOrderData.order().activeStartTime()));
                item.add(Utils.toString(openOrderData.order().activeStopTime()));
                item.add(Utils.toString(openOrderData.order().account()));
                item.add(Utils.toString(openOrderData.order().faGroup()));
                item.add(Utils.toString(openOrderData.order().getFaMethod()));
                item.add(Utils.toString(openOrderData.order().faPercentage()));
                item.add(Utils.toString(openOrderData.order().faProfile()));
                item.add(Utils.toString(openOrderData.order().volatility()));
                item.add(Utils.toString(openOrderData.order().getVolatilityType()));
                item.add(Utils.toString(openOrderData.order().continuousUpdate()));
                item.add(Utils.toString(openOrderData.order().getReferencePriceType()));
                item.add(Utils.toString(openOrderData.order().getDeltaNeutralOrderType()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralAuxPrice()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralConId()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralOpenClose()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralShortSale()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralShortSaleSlot()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralDesignatedLocation()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralSettlingFirm()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralClearingAccount()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralClearingIntent()));
                item.add(Utils.toString(openOrderData.order().scaleInitLevelSize()));
                item.add(Utils.toString(openOrderData.order().scaleSubsLevelSize()));
                item.add(Utils.toString(openOrderData.order().scalePriceIncrement()));
                item.add(Utils.toString(openOrderData.order().scalePriceAdjustValue()));
                item.add(Utils.toString(openOrderData.order().scalePriceAdjustInterval()));
                item.add(Utils.toString(openOrderData.order().scaleProfitOffset()));
                item.add(Utils.toString(openOrderData.order().scaleAutoReset()));
                item.add(Utils.toString(openOrderData.order().scaleInitPosition()));
                item.add(Utils.toString(openOrderData.order().scaleInitFillQty()));
                item.add(Utils.toString(openOrderData.order().scaleRandomPercent()));
                item.add(Utils.toString(openOrderData.order().getHedgeType()));
                item.add(Utils.toString(openOrderData.order().hedgeParam()));
                item.add(Utils.toString(openOrderData.order().dontUseAutoPriceForHedge()));
                item.add(Utils.toString(openOrderData.order().getAlgoStrategy()));
                item.add(Utils.tagValueListToString(openOrderData.order().algoParams()));
                item.add(Utils.tagValueListToString(openOrderData.order().smartComboRoutingParams()));
                item.add(Utils.orderComboLegsListToString(openOrderData.order().orderComboLegs()));
                item.add(Utils.toString(openOrderData.order().transmit()));
                item.add(Utils.toString(openOrderData.order().parentId()));
                item.add(Utils.toString(openOrderData.order().discretionaryAmt()));
                item.add(Utils.toString(openOrderData.order().eTradeOnly()));
                item.add(Utils.toString(openOrderData.order().firmQuoteOnly()));
                item.add(Utils.toString(openOrderData.order().nbboPriceCap()));
                item.add(Utils.toString(openOrderData.order().optOutSmartRouting()));
                item.add(Utils.toString(openOrderData.order().auctionStrategy()));
                item.add(Utils.toString(openOrderData.order().startingPrice()));
                item.add(Utils.toString(openOrderData.order().stockRefPrice()));
                item.add(Utils.toString(openOrderData.order().delta()));
                item.add(Utils.toString(openOrderData.order().stockRangeLower()));
                item.add(Utils.toString(openOrderData.order().stockRangeUpper()));
                item.add(Utils.toString(openOrderData.order().basisPoints()));
                item.add(Utils.toString(openOrderData.order().basisPointsType()));
                item.add(Utils.toString(openOrderData.order().notHeld()));
                item.add(Utils.toString(openOrderData.order().solicited()));
                item.add(Utils.toString(openOrderData.order().randomizeSize()));
                item.add(Utils.toString(openOrderData.order().randomizePrice()));
                item.add(Utils.toString(openOrderData.order().referenceContractId()));
                item.add(Utils.toString(openOrderData.order().adjustedOrderType() != null ? openOrderData.order().adjustedOrderType().getApiString() : ""));
                item.add(Utils.toString(openOrderData.order().triggerPrice()));
                item.add(Utils.toString(openOrderData.order().adjustedStopPrice()));
                item.add(Utils.toString(openOrderData.order().adjustedStopLimitPrice()));
                item.add(Utils.toString(openOrderData.order().adjustedTrailingAmount()));
                item.add(Utils.toString(openOrderData.order().adjustableTrailingUnit()));
                item.add(Utils.toString(openOrderData.order().lmtPriceOffset()));
                item.add(Utils.conditionsToString(openOrderData.order().conditions()));
                item.add(Utils.toString(openOrderData.order().conditionsIgnoreRth()));
                item.add(Utils.toString(openOrderData.order().conditionsCancelOrder()));
                item.add(Utils.toString(openOrderData.order().modelCode()));
                item.add(Utils.toString(openOrderData.order().softDollarTier()));
                item.add(Utils.toString(openOrderData.order().cashQty()));
                item.add(Utils.toString(openOrderData.order().isOmsContainer()));
            } else {
                for (int j = 0; j < 98; j++) {
                    item.add(Utils.toString(""));
                }
            }
        }
        
        if (!isNew) {
            // old
            if (openOrderData.order() != null) {
                item.add(Utils.toString(openOrderData.order().getTif()));
                item.add(Utils.toString(openOrderData.order().getRule80A()));
                item.add(Utils.toString(openOrderData.order().goodAfterTime()));
                item.add(Utils.toString(openOrderData.order().goodTillDate()));
                item.add(Utils.toString(openOrderData.order().blockOrder()));
                item.add(Utils.toString(openOrderData.order().sweepToFill()));
                item.add(Utils.toString(openOrderData.order().displaySize()));
                item.add(Utils.toString(openOrderData.order().getTriggerMethod()));
                item.add("");
                item.add(Utils.toString(openOrderData.order().hidden()));
                item.add("");
                item.add(Utils.toString(openOrderData.order().allOrNone()));
                item.add(Utils.toString(openOrderData.order().minQty()));
                item.add(Utils.toString(openOrderData.order().orderRef()));
                item.add(Utils.toString(openOrderData.order().percentOffset()));
                item.add(Utils.toString(openOrderData.order().trailStopPrice()));
                item.add(Utils.toString(openOrderData.order().eTradeOnly()));
                item.add(Utils.toString(openOrderData.order().firmQuoteOnly()));
                item.add(Utils.toString(openOrderData.order().nbboPriceCap()));
                item.add(Utils.toString(openOrderData.order().discretionaryAmt()));
                item.add(Utils.toString(openOrderData.order().startingPrice()));
                item.add(Utils.toString(openOrderData.order().stockRefPrice()));
                item.add(Utils.toString(openOrderData.order().delta()));
                item.add(Utils.toString(openOrderData.order().stockRangeLower()));
                item.add(Utils.toString(openOrderData.order().stockRangeUpper()));
                item.add(Utils.toString(openOrderData.order().volatility()));
                item.add(Utils.toString(openOrderData.order().getVolatilityType()));
                item.add(Utils.toString(openOrderData.order().getReferencePriceType()));
                item.add(Utils.toString(openOrderData.order().continuousUpdate()));
                item.add(Utils.toString(openOrderData.order().getDeltaNeutralOrderType()));
                item.add(Utils.toString(openOrderData.order().deltaNeutralAuxPrice()));
                item.add(Utils.toString(openOrderData.order().ocaGroup()));
                item.add(Utils.toString(openOrderData.order().getOcaType()));
                item.add(Utils.toString(openOrderData.order().account()));
                item.add(Utils.toString(openOrderData.order().faGroup()));
                item.add(Utils.toString(openOrderData.order().getFaMethod()));
                item.add(Utils.toString(openOrderData.order().faPercentage()));
                item.add(Utils.toString(openOrderData.order().faProfile()));
                item.add(Utils.toString(openOrderData.order().openClose()));
                item.add(Utils.toString(openOrderData.order().origin()));
                item.add(Utils.toString(openOrderData.order().settlingFirm()));
                item.add(Utils.toString(openOrderData.order().shortSaleSlot()));
                item.add(Utils.toString(openOrderData.order().designatedLocation()));
                item.add(Utils.toString(openOrderData.order().basisPoints()));
                item.add(Utils.toString(openOrderData.order().basisPointsType()));
                item.add(Utils.toString(openOrderData.order().outsideRth()));
                item.add(Utils.toString(openOrderData.order().clearingAccount()));
                item.add(Utils.toString(openOrderData.order().clearingIntent()));
                item.add(Utils.toString(openOrderData.order().optOutSmartRouting()));
                item.add(Utils.toString(openOrderData.order().solicited()));
                item.add(Utils.toString(openOrderData.order().randomizeSize()));
                item.add(Utils.toString(openOrderData.order().randomizePrice()));
            } else {
                for (int j = 0; j < 51; j++) {
                    item.add(Utils.toString(""));
                }
            }
    }
        
        return item;
    }
    
    /** Methods returns orderStatus field value of particular type */
    public static String getFieldValueFromOrderStatusRequest(OrderStatusRequest orderStatusRequest, OrderStatusData orderStatus) {
        String ret = "";
        DdeRequestType requestType = DdeRequestType.getRequestType(orderStatusRequest.field()); 
        switch(requestType) {
            case STATUS:
                ret = orderStatus.status();
                break;
            case FILLED:
                ret = Utils.toString(orderStatus.filled());
                break;
            case REMAINING:
                ret = Utils.toString(orderStatus.remaining());
                break;
            case AVG_FILL_PRICE:
                ret = Utils.toString(orderStatus.avgFillPrice());
                break;
            case LAST_FILL_PRICE:
                ret = Utils.toString(orderStatus.lastFillPrice());
                break;
            case WHY_HELD:
                ret = orderStatus.whyHeld();
                break;
            case MKT_CAP_PRICE:
                ret = Utils.toString(orderStatus.mktCapPrice());
                break;
            case PARENT_ID:
                ret = Utils.toString(orderStatus.parentId());
                break;
            case CLIENT_ID:
                ret = Utils.toString(orderStatus.clientId());
                break;
            case PERM_ID:
                ret = Utils.toString(orderStatus.permId());
                break;
            case ERROR:
                ret = orderStatus.errorMessage();
                break;
            default:
                break;
        }
        return ret;
    }    
}
