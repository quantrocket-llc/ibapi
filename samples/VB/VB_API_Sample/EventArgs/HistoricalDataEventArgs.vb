﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Class HistoricalDataEventArgs

    Property reqId As Integer

    Property [date] As String

    Property open As Double

    Property high As Double

    Property low As Double

    Property close As Double

    Property volume As Decimal

    Property count As Integer

    Property WAP As Decimal

End Class

