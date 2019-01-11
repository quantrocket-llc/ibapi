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
     * @class TickAttrib
     * @brief Class describing tick attrib
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComTickAttrib : ComWrapper<TickAttrib>, ITickAttrib
    {
        /**
         * @brief canAutoExecute
         */
        bool CanAutoExecute
        {
            get { return data != null ? data.CanAutoExecute : default(bool); }
            set { if (data != null) data.CanAutoExecute = value; }
        }

        /**
         * @brief pastLimit
         */
        bool PastLimit
        {
            get { return data != null ? data.PastLimit : default(bool); }
            set { if (data != null) data.PastLimit = value; }
        }

        /**
         * @brief preOpen
         */
        bool PreOpen
        {
            get { return data != null ? data.PreOpen : default(bool); }
            set { if (data != null) data.PreOpen = value; }
        }

        public ComTickAttrib()
        {
        }

        public static explicit operator TickAttrib(ComTickAttrib comTickAttrib)
        {
            return comTickAttrib.ConvertTo();
        }

        public static explicit operator ComTickAttrib(TickAttrib tickAttrib)
        {
            return new ComTickAttrib().ConvertFrom(tickAttrib) as ComTickAttrib;
        }

        bool TWSLib.ITickAttrib.canAutoExecute { get { return CanAutoExecute; } set { CanAutoExecute = value; } }
        bool TWSLib.ITickAttrib.pastLimit { get { return PastLimit; } set { PastLimit = value; } }
        bool TWSLib.ITickAttrib.preOpen { get { return PreOpen; } set { PreOpen = value; } }

    }
}
