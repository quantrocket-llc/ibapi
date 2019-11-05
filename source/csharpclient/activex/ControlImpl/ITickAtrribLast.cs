/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBApi;
using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true), Guid("14E414F4-ACD2-4BCC-B678-4C49DCE3AF31")]

    public interface ITickAttribLast
    {
        [DispId(1)]
        bool pastLimit { [return: MarshalAs(UnmanagedType.Bool)] get; [param: MarshalAs(UnmanagedType.Bool)] set; }
        [DispId(2)]
        bool unreported { [return: MarshalAs(UnmanagedType.Bool)] get; [param: MarshalAs(UnmanagedType.Bool)] set; }
    }
}
