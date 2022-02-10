﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Class OrderStatusEventArgs

    Property orderId As Integer

    Property status As String

    Property filled As Decimal

    Property remaining As Decimal

    Property avgFillPrice As Double

    Property permId As Integer

    Property parentId As Integer

    Property lastFillPrice As Double

    Property clientId As Integer

    Property whyHeld As String

    Property mktCapPrice As Double

End Class

