' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports System.Collections.Generic

Class SecurityDefinitionOptionParameterEventArgs

    Property reqId As Integer

    Property exchange As String

    Property underlyingConId As Integer

    Property tradingClass As String

    Property multiplier As String

    Property expirations As HashSet(Of String)

    Property strikes As HashSet(Of Double)

End Class

