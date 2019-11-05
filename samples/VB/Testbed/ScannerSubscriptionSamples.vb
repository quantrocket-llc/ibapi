' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports IBApi

Namespace Samples

    Public Class ScannerSubscriptionSamples

        Public Shared Function HotUSStkByVolume() As ScannerSubscription

            '! [hotusvolume]
            'Hot US stocks by volume
            Dim scanSub As ScannerSubscription = New ScannerSubscription()
            scanSub.Instrument = "STK"
            scanSub.LocationCode = "STK.US.MAJOR"
            scanSub.ScanCode = "HOT_BY_VOLUME"
            '! [hotusvolume]
            Return scanSub
        End Function

        Public Shared Function TopPercentGainersIbis() As ScannerSubscription

            '! [toppercentgaineribis]
            'Top % gainers at IBIS
            Dim scanSub As ScannerSubscription = New ScannerSubscription()
            scanSub.Instrument = "STOCK.EU"
            scanSub.LocationCode = "STK.EU.IBIS"
            scanSub.ScanCode = "TOP_PERC_GAIN"
            '! [toppercentgaineribis]
            Return scanSub
        End Function

        Public Shared Function MostActiveFutSoffex() As ScannerSubscription

            '! [mostactivefutsoffex]
            'Most active futures at SOFFEX
            Dim scanSub As ScannerSubscription = New ScannerSubscription()
            scanSub.Instrument = "FUT.EU"
            scanSub.LocationCode = "FUT.EU.SOFFEX"
            scanSub.ScanCode = "MOST_ACTIVE"
            '! [mostactivefutsoffex]
            Return scanSub
        End Function

        Public Shared Function HighOptVolumePCRatioUSIndexes() As ScannerSubscription

            '! [highoptvolume]
            'High option volume P/C ratio US indexes
            Dim scanSub As ScannerSubscription = New ScannerSubscription()
            scanSub.Instrument = "IND.US"
            scanSub.LocationCode = "IND.US"
            scanSub.ScanCode = "HIGH_OPT_VOLUME_PUT_CALL_RATIO"
            '! [highoptvolume]
            Return scanSub
        End Function
		
		Public Shared Function ComplexOrdersAndTrades() As ScannerSubscription

            '! [combolatesttrade]
            'Complex orders and trades scan, latest trades
            Dim scanSub As ScannerSubscription = New ScannerSubscription()
            scanSub.Instrument = "NATCOMB"
            scanSub.LocationCode = "NATCOMB.OPT.US"
            scanSub.ScanCode = "COMBO_LATEST_TRADE"
            '! [combolatesttrade]
            Return scanSub
        End Function
    End Class
End Namespace
