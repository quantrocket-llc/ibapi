/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
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
     * @class OrderState
     * @brief Provides an active order's current state
     * @sa Order
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComOrderState : ComWrapper<OrderState>, IOrderState
    {
        /**
         * @brief The order's current status
         */
        public string Status
        {
            get { return data !=null ? data.Status : default(string); }
            set { if (data != null) data.Status = value; }
        }

        /**
         * @brief The account's current initial margin.
         */
        public string InitMarginBefore
        {
            get { return data !=null ? data.InitMarginBefore : default(string); }
            set { if (data != null) data.InitMarginBefore = value; }
        }

        /**
        * @brief The account's current maintenance margin
        */
        public string MaintMarginBefore
        {
            get { return data !=null ? data.MaintMarginBefore : default(string); }
            set { if (data != null) data.MaintMarginBefore = value; }
        }

        /**
        * @brief The account's current equity with loan
        */
        public string EquityWithLoanBefore
        {
            get { return data !=null ? data.EquityWithLoanBefore : default(string); }
            set { if (data != null) data.EquityWithLoanBefore = value; }
        }

        /**
         * @brief The change of the account's initial margin.
         */
        public string InitMarginChange
        {
            get { return data != null ? data.InitMarginChange : default(string); }
            set { if (data != null) data.InitMarginChange = value; }
        }

        /**
        * @brief The change of the account's maintenance margin
        */
        public string MaintMarginChange
        {
            get { return data != null ? data.MaintMarginChange : default(string); }
            set { if (data != null) data.MaintMarginChange = value; }
        }

        /**
        * @brief The change of the account's equity with loan
        */
        public string EquityWithLoanChange
        {
            get { return data != null ? data.EquityWithLoanChange : default(string); }
            set { if (data != null) data.EquityWithLoanChange = value; }
        }

        /**
         * @brief The order's impact on the account's initial margin.
         */
        public string InitMarginAfter
        {
            get { return data != null ? data.InitMarginAfter : default(string); }
            set { if (data != null) data.InitMarginAfter = value; }
        }

        /**
        * @brief The order's impact on the account's maintenance margin
        */
        public string MaintMarginAfter
        {
            get { return data != null ? data.MaintMarginAfter : default(string); }
            set { if (data != null) data.MaintMarginAfter = value; }
        }

        /**
        * @brief Shows the impact the order would have on the account's equity with loan
        */
        public string EquityWithLoanAfter
        {
            get { return data != null ? data.EquityWithLoanAfter : default(string); }
            set { if (data != null) data.EquityWithLoanAfter = value; }
        }

        /**
          * @brief The order's generated commission.
          */
        public double Commission
        {
            get { return data !=null ? data.Commission : default(double); }
            set { if (data != null) data.Commission = value; }
        }

        /**
        * @brief The execution's minimum commission.
        */
        public double MinCommission
        {
            get { return data !=null ? data.MinCommission : default(double); }
            set { if (data != null) data.MinCommission = value; }
        }

        /**
        * @brief The executions maximum commission.
        */
        public double MaxCommission
        {
            get { return data !=null ? data.MaxCommission : default(double); }
            set { if (data != null) data.MaxCommission = value; }
        }

        /**
         * @brief The generated commission currency
         * @sa CommissionReport
         */
        public string CommissionCurrency
        {
            get { return data !=null ? data.CommissionCurrency : default(string); }
            set { if (data != null) data.CommissionCurrency = value; }
        }

        /**
         * @brief If the order is warranted, a descriptive message will be provided.
         */
        public string WarningText
        {
            get { return data !=null ? data.WarningText : default(string); }
            set { if (data != null) data.WarningText = value; }
        }

        /**
         * @brief Completed time for completed order.
         */
        public string CompletedTime
        {
            get { return data != null ? data.CompletedTime : default(string); }
            set { if (data != null) data.CompletedTime = value; }
        }

        /**
         * @brief Completed status for completed order.
         */
        public string CompletedStatus
        {
            get { return data != null ? data.CompletedStatus : default(string); }
            set { if (data != null) data.CompletedStatus = value; }
        }

        public override bool Equals(Object other)
        {

            if (this == other)
                return true;

            if (other == null)
                return false;

            OrderState state = (OrderState)other;

            if (Commission != state.Commission ||
                MinCommission != state.MinCommission ||
                MaxCommission != state.MaxCommission)
            {
                return false;
            }

            if (Util.StringCompare(Status, state.Status) != 0 ||
                Util.StringCompare(InitMarginBefore, state.InitMarginBefore) != 0 ||
                Util.StringCompare(MaintMarginBefore, state.MaintMarginBefore) != 0 ||
                Util.StringCompare(EquityWithLoanBefore, state.EquityWithLoanBefore) != 0 ||
                Util.StringCompare(InitMarginChange, state.InitMarginChange) != 0 ||
                Util.StringCompare(MaintMarginChange, state.MaintMarginChange) != 0 ||
                Util.StringCompare(EquityWithLoanChange, state.EquityWithLoanChange) != 0 ||
                Util.StringCompare(InitMarginAfter, state.InitMarginAfter) != 0 ||
                Util.StringCompare(MaintMarginAfter, state.MaintMarginAfter) != 0 ||
                Util.StringCompare(EquityWithLoanAfter, state.EquityWithLoanAfter) != 0 ||
                Util.StringCompare(CommissionCurrency, state.CommissionCurrency) != 0 ||
                Util.StringCompare(CompletedTime, state.CompletedTime) != 0 ||
                Util.StringCompare(CompletedStatus, state.CompletedStatus) != 0)
            {
                return false;
            }

            return true;
        }

        string TWSLib.IOrderState.status
        {
            get { return Status; }
        }

        string TWSLib.IOrderState.initMarginBefore
        {
            get { return InitMarginBefore; }
        }

        string TWSLib.IOrderState.maintMarginBefore
        {
            get { return MaintMarginBefore; }
        }

        string TWSLib.IOrderState.equityWithLoanBefore
        {
            get { return EquityWithLoanBefore; }
        }

        string TWSLib.IOrderState.initMarginChange
        {
            get { return InitMarginChange; }
        }

        string TWSLib.IOrderState.maintMarginChange
        {
            get { return MaintMarginChange; }
        }

        string TWSLib.IOrderState.equityWithLoanChange
        {
            get { return EquityWithLoanChange; }
        }

        string TWSLib.IOrderState.initMarginAfter
        {
            get { return InitMarginAfter; }
        }

        string TWSLib.IOrderState.maintMarginAfter
        {
            get { return MaintMarginAfter; }
        }

        string TWSLib.IOrderState.equityWithLoanAfter
        {
            get { return EquityWithLoanAfter; }
        }

        double TWSLib.IOrderState.commission
        {
            get { return Commission; }
        }

        double TWSLib.IOrderState.minCommission
        {
            get { return MinCommission; }
        }

        double TWSLib.IOrderState.maxCommission
        {
            get { return MaxCommission; }
        }

        string TWSLib.IOrderState.commissionCurrency
        {
            get { return CommissionCurrency; }
        }

        string TWSLib.IOrderState.warningText
        {
            get { return WarningText; }
        }

        string TWSLib.IOrderState.completedTime
        {
            get { return CompletedTime; }
        }

        string TWSLib.IOrderState.completedStatus
        {
            get { return CompletedStatus; }
        }

        public static explicit operator OrderState(ComOrderState cos)
        {
            return cos.ConvertTo();
        }

        public static explicit operator ComOrderState(OrderState os)
        {
            return new ComOrderState().ConvertFrom(os) as ComOrderState;
        }
    }
}
