' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports IBApi

Class TickByTickBidAskEventArgs

    Property reqId As Integer

    Property time As Long

    Property bidPrice As Double

    Property askPrice As Double

    Property bidSize As Integer

    Property askSize As Integer

    Property tickAttribBidAsk As TickAttribBidAsk

End Class
