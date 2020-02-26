﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;

using IBApi;

namespace IBSampleApp.util
{
    class Utils
    {
        public static string UnixMillisecondsToString(long milliseconds, string dateFormat)
        {
            return string.Format("{0:" + dateFormat + "}", DateTime.SpecifyKind(new DateTime(1970, 1, 1), DateTimeKind.Utc).AddMilliseconds(milliseconds));
        }

        public static string ContractToString(Contract contract)
        {
            return contract.Symbol + " " + contract.SecType + " " + contract.Currency + " @ " + contract.Exchange;
        }

        public static bool ContractsAreEqual(Contract contractA, Contract contractB)
        {
            if (contractA.Symbol.Equals(contractB.Symbol) && contractA.SecType.Equals(contractB.SecType) && contractA.Currency.Equals(contractB.Currency))
            {
                if (contractA.LastTradeDateOrContractMonth != null && contractB.LastTradeDateOrContractMonth != null)
                {
                    if (contractA.LastTradeDateOrContractMonth.Equals(contractB.LastTradeDateOrContractMonth))
                    {
                        if (contractA.Multiplier != null && contractB.Multiplier != null)
                        {
                            return contractA.Multiplier.Equals(contractB.Multiplier);
                        }
                        else
                            return true;
                    }
                }
                else
                    return true;
            }

            return false;
        }
    }
}
