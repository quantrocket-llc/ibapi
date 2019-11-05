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
     * @class TickAttribLast
     * @brief Class describing tick attrib last
     */
    [ComVisible(true), ClassInterface(ClassInterfaceType.None)]
    public class ComTickAttribLast : ComWrapper<TickAttribLast>, ITickAttribLast
    {
        /**
         * @brief pastLimit
         */
        bool PastLimit
        {
            get { return data != null ? data.PastLimit : default(bool); }
            set { if (data != null) data.PastLimit = value; }
        }

        /**
         * @brief unreported
         */
        bool Unreported
        {
            get { return data != null ? data.Unreported : default(bool); }
            set { if (data != null) data.Unreported = value; }
        }

        public ComTickAttribLast()
        {
        }

        public static explicit operator TickAttribLast(ComTickAttribLast comTickAttribLast)
        {
            return comTickAttribLast.ConvertTo();
        }

        public static explicit operator ComTickAttribLast(TickAttribLast tickAttribLast)
        {
            return new ComTickAttribLast().ConvertFrom(tickAttribLast) as ComTickAttribLast;
        }

        bool TWSLib.ITickAttribLast.pastLimit { get { return PastLimit; } set { PastLimit = value; } }
        bool TWSLib.ITickAttribLast.unreported { get { return Unreported; } set { Unreported = value; } }
    }
}
