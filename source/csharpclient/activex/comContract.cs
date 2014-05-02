/* Copyright (C) 2013 Interactive Brokers LLC. All rights reserved.  This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;

namespace IBApi
{
    /**
     * @class Contract
     * @brief class describing an instrument's definition
     * @sa ContractDetails
     */
    [ComVisible(true)]
    public class ComContract : TWSLib.IContract
    {
        Contract data = new Contract();

        /**
        * @brief The unique contract's identifier
        */
        public int ConId
        {
            get { return data.ConId; }
            set { data.ConId = value; }
        }


        /**
         * @brief The underlying's asset symbol
         */
        public string Symbol
        {
            get { return data.Symbol; }
            set { data.Symbol = value; }
        }

        /**
         * @brief The security's type:
         *      STK - stock
         *      OPT - option
         *      FUT - future
         *      IND - index
         *      FOP - future on an option
         *      CASH - forex pair
         *      BAG - combo
         *      WAR - warrant
         */
        public string SecType
        {
            get { return data.SecType; }
            set { data.SecType = value; }
        }

        /**
        * @brief The contract's expiration date (i.e. Options and Futures)
        */
        public string Expiry
        {
            get { return data.Expiry; }
            set { data.Expiry = value; }
        }

        /**
         * @brief The option's strike price
         */
        public double Strike
        {
            get { return data.Strike; }
            set { data.Strike = value; }
        }

        /**
         * @brief Either Put or Call (i.e. Options)
         */
        public string Right
        {
            get { return data.Right; }
            set { data.Right = value; }
        }

        /**
         * @brief The instrument's multiplier (i.e. options, futures).
         */
        public string Multiplier
        {
            get { return data.Multiplier; }
            set { data.Multiplier = value; }
        }

        /**
         * @brief The destination exchange.
         */
        public string Exchange
        {
            get { return data.Exchange; }
            set { data.Exchange = value; }
        }

        /**
         * @brief The underlying's cuurrency
         */
        public string Currency
        {
            get { return data.Currency; }
            set { data.Currency = value; }
        }

        /**
         * @brief The contract's symbol within its primary exchange
         */
        public string LocalSymbol
        {
            get { return data.LocalSymbol; }
            set { data.LocalSymbol = value; }
        }

        /**
         * @brief The contract's primary exchange.
         */
        public string PrimaryExch
        {
            get { return data.PrimaryExch; }
            set { data.PrimaryExch = value; }
        }

        /**
         * @brief The trading class name for this contract.
         * Available in TWS contract description window as well. For example, GBL Dec '13 future's trading class is "FGBL"
         */
        public string TradingClass
        {
            get { return data.TradingClass; }
            set { data.TradingClass = value; }
        }

        /**
        * @brief If set to true, contract details requests and historical data queries can be performed pertaining to expired contracts.
        * Note: Historical data queries on expired contracts are limited to the last year of the contracts life, and are initially only supported for expired futures contracts.
        */
        public bool IncludeExpired
        {
            get { return data.IncludeExpired; }
            set { data.IncludeExpired = value; }
        }

        /**
         * @brief Security's identifier when querying contract's details or placing orders
         *      SIN - Example: Apple: US0378331005
         *      CUSIP - Example: Apple: 037833100
         *      SEDOL - Consists of 6-AN + check digit. Example: BAE: 0263494
         *      RIC - Consists of exchange-independent RIC Root and a suffix identifying the exchange. Example: AAPL.O for Apple on NASDAQ.
         */
        public string SecIdType
        {
            get { return data.SecIdType; }
            set { data.SecIdType = value; }
        }

        /**
        * @brief Identifier of the security type
        * @sa secIdType
        */
        public string SecId
        {
            get { return data.SecId; }
            set { data.SecId = value; }
        }

         /**
         * @brief Description of the combo legs.
         */
        public string ComboLegsDescription
        {
            get { return data.ComboLegsDescription; }
            set { data.ComboLegsDescription = value; }
        }

        /**
         * @brief The legs of a combined contract definition
         * @sa ComboLeg
         */
        public List<ComboLeg> ComboLegs
        {
            get { return data.ComboLegs; }
            set { data.ComboLegs = value; }
        }

        /**
         * @brief Delta and underlying price for Delta-Neutral combo orders.
         * Underlying (STK or FUT), delta and underlying price goes into this attribute.
         * @sa UnderComp
         */
        public UnderComp UnderComp
        {
            get { return data.UnderComp; }
            set { data.UnderComp = value; }
        }

        int TWSLib.IContract.conId { get { return ConId; } set { ConId = value; } }

        string TWSLib.IContract.symbol { get { return Symbol; } set { Symbol = value; } }

        string TWSLib.IContract.secType { get { return SecType; } set { SecType = value; } }

        string TWSLib.IContract.expiry { get { return Expiry; } set { Expiry = value; } }

        double TWSLib.IContract.strike { get { return Strike; } set { Strike = value; } }

        string TWSLib.IContract.right { get { return Right; } set { Right = value; } }

        string TWSLib.IContract.multiplier { get { return Multiplier; } set { Multiplier = value; } }

        string TWSLib.IContract.exchange { get { return Exchange; } set { Exchange = value; } }

        string TWSLib.IContract.primaryExchange { get { return PrimaryExch; } set { PrimaryExch = value; } }

        string TWSLib.IContract.currency { get { return Currency; } set { Currency = value; } }

        string TWSLib.IContract.localSymbol { get { return LocalSymbol; } set { LocalSymbol = value; } }

        string TWSLib.IContract.tradingClass { get { return TradingClass; } set { TradingClass = value; } }

        bool TWSLib.IContract.includeExpired { get { return IncludeExpired; } set { IncludeExpired = value; } }

        object TWSLib.IContract.comboLegs
        {
            [return: MarshalAs(UnmanagedType.IDispatch)]
            get { return new TWSLib.ComComboLegList(ComboLegs); }

            [param: MarshalAs(UnmanagedType.IDispatch)]
            set { ComboLegs = value is TWSLib.ComComboLegList ? (value as TWSLib.ComComboLegList).Ocl : null; }
        }

        object TWSLib.IContract.underComp 
        { 
            [return: MarshalAs(UnmanagedType.IDispatch)] get { return UnderComp; } 
            [param: MarshalAs(UnmanagedType.IDispatch)] set { UnderComp = (UnderComp)value; } 
        }

        string TWSLib.IContract.comboLegsDescrip { get { return ComboLegsDescription; } }

        string TWSLib.IContract.secIdType { get { return SecIdType; } set { SecIdType = value; } }

        string TWSLib.IContract.secId { get { return SecId; } set { SecId = value; } }

        public static explicit operator ComContract(Contract c)
        {
            return new ComContract() { data = c };
        }

        public static explicit operator Contract(ComContract cc)
        {
            return cc.data;
        }
    }
}
