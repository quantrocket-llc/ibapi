/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Runtime.InteropServices;
using System.Text;

namespace TWSLib
{
    [ComVisible(true), Guid("E70017ED-FB79-4040-A5BB-8D93FA066C91")]
    public interface IWshEventData
    {
        [DispId(1)]
        int conId { get; set; }
        [DispId(2)]
        string filter { get; set; }
        [DispId(3)]
        bool fillWatshlist { [return: MarshalAs(UnmanagedType.Bool)] get; [param: MarshalAs(UnmanagedType.Bool)] set; }
        [DispId(4)]
        bool fillPortfolio { [return: MarshalAs(UnmanagedType.Bool)] get; [param: MarshalAs(UnmanagedType.Bool)] set; }
        [DispId(5)]
        bool fillCompetitors { [return: MarshalAs(UnmanagedType.Bool)] get; [param: MarshalAs(UnmanagedType.Bool)] set; }
        [DispId(6)]
        string startDate { get; set; }
        [DispId(7)]
        string endDate { get; set; }
        [DispId(8)]
        int totalLimit { get; set; }
    }
}
