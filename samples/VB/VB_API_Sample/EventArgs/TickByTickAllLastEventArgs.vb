' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports IBApi

Class TickByTickAllLastEventArgs

    Property reqId As Integer

    Property tickType As Integer

    Property time As Long

    Property price As Double

    Property size As Integer

    Property tickAttribLast As TickAttribLast

    Property exchange As String

    Property specialConditions As String

End Class
