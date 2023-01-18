' Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports IBApi

Class HistoricalScheduleEventArgs
    Property reqId As Integer
    Property startDateTime As String
    Property endDateTime As String
    Property timeZone As String
    Property sessions As HistoricalSession()

End Class
