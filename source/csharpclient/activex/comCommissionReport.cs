/* Copyright (C) 2013 Interactive Brokers LLC. All rights reserved.  This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace IBApi
{
    /**
     * @class CommissionReport
     * @brief class representing the commissions generated by an execution.
     * @sa Execution
     */
    [ComVisible(true)]
    public class ComCommissionReport : TWSLib.ICommissionReport
    {
        CommissionReport data = new CommissionReport();

        /**
        * @brief the execution's id this commission belongs to.
        */
        public string ExecId
        {
            get { return data.ExecId; }
            set { data.ExecId = value; }
        }

        /**
         * @brief the commissions cost.
         */
        public double Commission
        {
            get { return data.Commission; }
            set { data.Commission = value; }
        }

        /**
        * @brief the reporting currency.
        */
        public string Currency
        {
            get { return data.Currency; }
            set { data.Currency = value; }
        }

        /**
        * @brief the realised profit and loss
        */
        public double RealizedPNL
        {
            get { return data.RealizedPNL; }
            set { data.RealizedPNL = value; }
        }

        /**
         * @brief The income return.
         */
        public double Yield
        {
            get { return data.Yield; }
            set { data.Yield = value; }
        }

        /**
         * @brief date expressed in yyyymmdd format.
         */
        public int YieldRedemptionDate
        {
            get { return data.YieldRedemptionDate; }
            set { data.YieldRedemptionDate = value; }
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
                CommissionReport l_theOther = (CommissionReport)p_other;
                l_bRetVal = ExecId.Equals(l_theOther.ExecId);
            }
            return l_bRetVal;
        }

        string TWSLib.ICommissionReport.execId
        {
            get { return ExecId; }
        }

        double TWSLib.ICommissionReport.commission
        {
            get { return Commission; }
        }

        string TWSLib.ICommissionReport.currency
        {
            get { return Currency; }
        }

        double TWSLib.ICommissionReport.realizedPNL
        {
            get { return RealizedPNL; }
        }

        double TWSLib.ICommissionReport.yield
        {
            get { return Yield; }
        }

        int TWSLib.ICommissionReport.yieldRedemptionDate
        {
            get { return YieldRedemptionDate; }
        }

        public static explicit operator ComCommissionReport(CommissionReport cr)
        {
            return new ComCommissionReport() { data = cr };
        }

        public static explicit operator CommissionReport(ComCommissionReport ccr)
        {
            return ccr.data;
        }
    }
}
