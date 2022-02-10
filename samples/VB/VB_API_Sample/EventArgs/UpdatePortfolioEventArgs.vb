﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Class UpdatePortfolioEventArgs

    Property contract As IBApi.Contract

    Property position As Decimal

    Property marketPrice As Double

    Property marketValue As Double

    Property averageCost As Double

    Property unrealizedPNL As Double

    Property realizedPNL As Double

    Property accountName As String

End Class

