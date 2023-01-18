﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    /**
     * @class Execution
     * @brief Class describing an order's execution.
     * @sa ExecutionFilter, CommissionReport
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComExecution : ComWrapper<Execution>, IExecution
    {
        /**
         * @brief The API client's order Id.
         */
        int OrderId
        {
            get { return data != null ? data.OrderId : default(int); }
            set { if (data != null) data.OrderId = value; }
        }

        /**
         * @brief The API client identifier which placed the order which originated this execution.
         */
        int ClientId
        {
            get { return data != null ? data.ClientId : default(int); }
            set { if (data != null) data.ClientId = value; }
        }

        /**
         * @brief The execution's identifier.
         */
        string ExecId
        {
            get { return data != null ? data.ExecId : default(string); }
            set { if (data != null) data.ExecId = value; }
        }

        /**
         * @brief The execution's server time.
         */
        string Time
        {
            get { return data != null ? data.Time : default(string); }
            set { if (data != null) data.Time = value; }
        }

        /**
         * @brief The account to which the order was allocated.
         */
        string AcctNumber
        {
            get { return data != null ? data.AcctNumber : default(string); }
            set { if (data != null) data.AcctNumber = value; }
        }

        /**
         * @brief The exchange where the execution took place.
         */
        string Exchange
        {
            get { return data != null ? data.Exchange : default(string); }
            set { if (data != null) data.Exchange = value; }
        }

        /**
         * @brief Specifies if the transaction was buy or sale
         * BOT for bought, SLD for sold
         */
        string Side
        {
            get { return data != null ? data.Side : default(string); }
            set { if (data != null) data.Side = value; }
        }

        /**
         * @brief The number of shares filled.
         */
        object Shares
        {
            get { return data != null ? data.Shares : default(object); }
            set { if (data != null) data.Shares = Util.GetDecimal(value); }
        }

        /**
         * @brief The order's execution price excluding commissions.
         */
        double Price
        {
            get { return data != null ? data.Price : default(double); }
            set { if (data != null) data.Price = value; }
        }

        /**
         * @brief The TWS order identifier.
         */
        int PermId
        {
            get { return data != null ? data.PermId : default(int); }
            set { if (data != null) data.PermId = value; }
        }

        /**
         * @brief Identifies the position as one to be liquidated last should the need arise.
         */
        int Liquidation
        {
            get { return data != null ? data.Liquidation : default(int); }
            set { if (data != null) data.Liquidation = value; }
        }

        /**
         * @brief Cumulative quantity. 
         * Used in regular trades, combo trades and legs of the combo.
         */
        object CumQty
        {
            get { return data != null ? data.CumQty : default(object); }
            set { if (data != null) data.CumQty = Util.GetDecimal(value); }
        }

        /**
         * @brief Average price. 
         * Used in regular trades, combo trades and legs of the combo. Includes commissions.
         */
        double AvgPrice
        {
            get { return data != null ? data.AvgPrice : default(double); }
            set { if (data != null) data.AvgPrice = value; }
        }

        /**
         * @brief Allows API client to add a reference to an order.
         */
        string OrderRef
        {
            get { return data != null ? data.OrderRef : default(string); }
            set { if (data != null) data.OrderRef = value; }
        }

        /**
         * @brief The Economic Value Rule name and the respective optional argument.
         * The two values should be separated by a colon. For example, aussieBond:YearsToExpiration=3. When the optional argument is not present, the first value will be followed by a colon.
         */
        string EvRule
        {
            get { return data != null ? data.EvRule : default(string); }
            set { if (data != null) data.EvRule = value; }
        }

        /**
         * @brief Tells you approximately how much the market value of a contract would change if the price were to change by 1.
         * It cannot be used to get market value by multiplying the price by the approximate multiplier.
         */
        double EvMultiplier
        {
            get { return data != null ? data.EvMultiplier : default(double); }
            set { if (data != null) data.EvMultiplier = value; }
        }

        /**
         * @brief model code
         */
        string ModelCode
        {
            get { return data != null ? data.ModelCode : default(string); }
            set { if (data != null) data.ModelCode = value; }
        }

        public string LastLiquidity 
        {
            get { return data != null ? data.LastLiquidity + "" : default(string); }            
        }


        public override bool Equals(Object p_other)
        {
            bool l_bRetVal = false;

            if (p_other == null)
            {
                l_bRetVal = false;
            }
            else if (this == p_other)
            {
                l_bRetVal = true;
            }
            else
            {
                Execution l_theOther = (Execution)p_other;
                l_bRetVal = String.Compare(ExecId, l_theOther.ExecId, true) == 0;
            }
            return l_bRetVal;
        }

        string TWSLib.IExecution.execId
        {
            get { return ExecId; }
        }

        int TWSLib.IExecution.orderId
        {
            get { return OrderId; }
        }

        int TWSLib.IExecution.clientId
        {
            get { return ClientId; }
        }

        int TWSLib.IExecution.permId
        {
            get { return PermId; }
        }

        string TWSLib.IExecution.time
        {
            get { return Time; }
        }

        string TWSLib.IExecution.acctNumber
        {
            get { return AcctNumber; }
        }

        string TWSLib.IExecution.exchange
        {
            get { return Exchange; }
        }

        string TWSLib.IExecution.side
        {
            get { return Side; }
        }

        object TWSLib.IExecution.shares
        {
            get { return Shares; }
        }

        double TWSLib.IExecution.price
        {
            get { return Price; }
        }

        int TWSLib.IExecution.liquidation
        {
            get { return Liquidation; }
        }

        object TWSLib.IExecution.cumQty
        {
            get { return CumQty; }
        }

        double TWSLib.IExecution.avgPrice
        {
            get { return AvgPrice; }
        }

        string TWSLib.IExecution.orderRef
        {
            get { return OrderRef; }
        }

        string TWSLib.IExecution.evRule
        {
            get { return EvRule; }
        }

        double TWSLib.IExecution.evMultiplier
        {
            get { return EvMultiplier; }
        }

        public static explicit operator Execution(ComExecution ce)
        {
            return ce.ConvertTo();
        }

        public static explicit operator ComExecution(Execution e)
        {
            return new ComExecution().ConvertFrom(e) as ComExecution;
        }

        string TWSLib.IExecution.modelCode
        {
            get { return ModelCode; }
        }

        string IExecution.lastLiquidity
        {
            get { return LastLiquidity; }
        }
    }
}
