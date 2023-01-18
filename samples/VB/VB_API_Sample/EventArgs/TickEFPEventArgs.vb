﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Class TickEFPEventArgs

    Property tickerId As Integer

    Property field As Utils.TickType

    Property basisPoints As Double

    Property holdDays As Integer

    Property futureLastTradeDate As String

    Property dividendImpact As Double

    Property dividendsToLastTradeDate As Double

    Property formattedBasisPoints As String

    Property impliedFuture As Double

End Class

