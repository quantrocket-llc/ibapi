"""
Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.
"""

import sys
import ibapi

from decimal import Decimal
from ibapi.enum_implem import Enum
from ibapi.object_implem import Object


NO_VALID_ID = -1
MAX_MSG_LEN = 0xFFFFFF # 16Mb - 1byte

UNSET_INTEGER = 2 ** 31 - 1
UNSET_DOUBLE = sys.float_info.max
UNSET_LONG = 2 ** 63 - 1
UNSET_DECIMAL = Decimal(2 ** 127 - 1)

TickerId = int
OrderId  = int
TagValueList = list

FaDataType = int
FaDataTypeEnum = Enum("N/A", "GROUPS", "PROFILES", "ALIASES")

MarketDataType = int
MarketDataTypeEnum = Enum("N/A", "REALTIME", "FROZEN", "DELAYED", "DELAYED_FROZEN")

Liquidities = int
LiquiditiesEnum = Enum("None", "Added", "Remove", "RoudedOut")

SetOfString = set
SetOfFloat = set
ListOfOrder = list
ListOfFamilyCode = list
ListOfContractDescription = list
ListOfDepthExchanges = list
ListOfNewsProviders = list
SmartComponentMap = dict
HistogramDataList = list
ListOfPriceIncrements = list
ListOfHistoricalTick = list
ListOfHistoricalTickBidAsk = list
ListOfHistoricalTickLast = list


class BarData(Object):
    def __init__(self):
        self.date = ""
        self.open = 0.
        self.high = 0.
        self.low = 0.
        self.close = 0.
        self.volume = UNSET_DECIMAL
        self.wap = UNSET_DECIMAL
        self.barCount = 0

    def __str__(self):
        return "Date: %s, Open: %f, High: %f, Low: %f, Close: %f, Volume: %s, WAP: %s, BarCount: %d" % (self.date, self.open, self.high,
            self.low, self.close, ibapi.utils.decimalMaxString(self.volume), ibapi.utils.decimalMaxString(self.wap), self.barCount)


class RealTimeBar(Object):
    def __init__(self, time = 0, endTime = -1, open_ = 0., high = 0., low = 0., close = 0., volume = UNSET_DECIMAL, wap = UNSET_DECIMAL, count = 0):
        self.time = time
        self.endTime = endTime
        self.open_ = open_
        self.high = high
        self.low = low
        self.close = close
        self.volume = volume
        self.wap = wap
        self.count = count

    def __str__(self):
        return "Time: %d, Open: %f, High: %f, Low: %f, Close: %f, Volume: %s, WAP: %s, Count: %d" % (self.time, self.open_, self.high,
            self.low, self.close, ibapi.utils.decimalMaxString(self.volume), ibapi.utils.decimalMaxString(self.wap), self.count)


class HistogramData(Object):
    def __init__(self):
        self.price = 0.
        self.size = UNSET_DECIMAL

    def __str__(self):
        return "Price: %f, Size: %s" % (self.price, ibapi.utils.decimalMaxString(self.size))


class NewsProvider(Object):
    def __init__(self):
        self.code = ""
        self.name = ""

    def __str__(self):
        return "Code: %s, Name: %s" % (self.code, self.name)


class DepthMktDataDescription(Object):
    def __init__(self):
        self.exchange = ""
        self.secType = ""
        self.listingExch = ""
        self.serviceDataType = ""
        self.aggGroup = UNSET_INTEGER

    def __str__(self):
        if (self.aggGroup!= UNSET_INTEGER):
            aggGroup = self.aggGroup
        else:
            aggGroup = ""
        return "Exchange: %s, SecType: %s, ListingExchange: %s, ServiceDataType: %s, AggGroup: %s, " % (self.exchange, self.secType, self.listingExch,self.serviceDataType, aggGroup)


class SmartComponent(Object):
    def __init__(self):
        self.bitNumber = 0
        self.exchange = ""
        self.exchangeLetter = ""

    def __str__(self):
        return "BitNumber: %d, Exchange: %s, ExchangeLetter: %s" % (self.bitNumber, self.exchange, self.exchangeLetter)


class TickAttrib(Object):
    def __init__(self):
        self.canAutoExecute = False
        self.pastLimit = False
        self.preOpen = False

    def __str__(self):
        return "CanAutoExecute: %d, PastLimit: %d, PreOpen: %d" % (self.canAutoExecute, self.pastLimit, self.preOpen)


class TickAttribBidAsk(Object):
    def __init__(self):
        self.bidPastLow = False
        self.askPastHigh = False

    def __str__(self):
        return "BidPastLow: %d, AskPastHigh: %d" % (self.bidPastLow, self.askPastHigh)


class TickAttribLast(Object):
    def __init__(self):
        self.pastLimit = False
        self.unreported = False

    def __str__(self):
        return "PastLimit: %d, Unreported: %d" % (self.pastLimit, self.unreported)


class FamilyCode(Object):
    def __init__(self):
        self.accountID = ""
        self.familyCodeStr = ""

    def __str__(self):
        return "AccountId: %s, FamilyCodeStr: %s" % (self.accountID, self.familyCodeStr)


class PriceIncrement(Object):
    def __init__(self):
        self.lowEdge = 0.
        self.increment = 0.

    def __str__(self):
        return "LowEdge: %f, Increment: %f" % (self.lowEdge, self.increment)


class HistoricalTick(Object):
    def __init__(self):
        self.time = 0
        self.price = 0.
        self.size = UNSET_DECIMAL

    def __str__(self):
        return "Time: %d, Price: %f, Size: %s" % (self.time, self.price, ibapi.utils.decimalMaxString(self.size))


class HistoricalTickBidAsk(Object):
    def __init__(self):
        self.time = 0
        self.tickAttribBidAsk = TickAttribBidAsk()
        self.priceBid = 0.
        self.priceAsk = 0.
        self.sizeBid = UNSET_DECIMAL
        self.sizeAsk = UNSET_DECIMAL

    def __str__(self):
        return "Time: %d, TickAttriBidAsk: %s, PriceBid: %f, PriceAsk: %f, SizeBid: %s, SizeAsk: %s" % (self.time, self.tickAttribBidAsk, self.priceBid, self.priceAsk, ibapi.utils.decimalMaxString(self.sizeBid), ibapi.utils.decimalMaxString(self.sizeAsk))


class HistoricalTickLast(Object):
    def __init__(self):
        self.time = 0
        self.tickAttribLast = TickAttribLast()
        self.price = 0.
        self.size = UNSET_DECIMAL
        self.exchange = ""
        self.specialConditions = ""

    def __str__(self):
        return "Time: %d, TickAttribLast: %s, Price: %f, Size: %s, Exchange: %s, SpecialConditions: %s" % (self.time, self.tickAttribLast, self.price, ibapi.utils.decimalMaxString(self.size), self.exchange, self.specialConditions)


