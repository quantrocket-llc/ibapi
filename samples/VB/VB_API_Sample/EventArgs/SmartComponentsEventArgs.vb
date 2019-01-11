' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports System.Collections.Generic

Class SmartComponentsEventArgs

    Property reqId As Integer

    Property theMap As Dictionary(Of Integer, KeyValuePair(Of String, Char))

End Class
