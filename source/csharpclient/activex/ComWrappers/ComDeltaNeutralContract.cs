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
     * @brief Delta-Neutral Underlying Component.
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComDeltaNeutralContract : ComWrapper<DeltaNeutralContract>, IDeltaNeutralContract
    {
        /**
         * @brief
         */
        public int ConId
        {
            get { return data != null ? data.ConId : default(int); }
            set { if (data != null) data.ConId = value; }
        }

        /**
        * @brief
        */
        public double Delta
        {
            get { return data !=null ? data.Delta : default(double); }
            set { if (data != null) data.Delta = value; }
        }

        /**
        * @brief
        */
        public double Price
        {
            get { return data !=null ? data.Price : default(double); }
            set { if (data != null) data.Price = value; }
        }

        int TWSLib.IDeltaNeutralContract.conId
        {
            get
            {
                return ConId;
            }
            set
            {
                ConId = value;
            }
        }

        double TWSLib.IDeltaNeutralContract.delta
        {
            get
            {
                return Delta;
            }
            set
            {
                Delta = value;
            }
        }

        double TWSLib.IDeltaNeutralContract.price
        {
            get
            {
                return Price;
            }
            set
            {
                Price = value;
            }
        }

        public static explicit operator ComDeltaNeutralContract(DeltaNeutralContract dnc)
        {
            return new ComDeltaNeutralContract().ConvertFrom(dnc) as ComDeltaNeutralContract;
        }

        public static explicit operator DeltaNeutralContract(ComDeltaNeutralContract dnc)
        {
            return dnc.ConvertTo();
        }
    }
}
