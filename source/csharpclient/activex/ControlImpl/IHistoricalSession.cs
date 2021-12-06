/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Runtime.InteropServices;

namespace TWSLib
{
    [ComVisible(true), Guid("35011084-D3CC-4C5A-8623-9C938A346EA1")]

    public interface IHistoricalSession
    {
        [DispId(1)]
        string startDateTime { get; }
        [DispId(2)]
        string endDateTime { get; }
        [DispId(3)]
        string refDate { get; }
    }
}
