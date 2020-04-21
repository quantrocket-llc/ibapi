/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Data;

namespace IBSampleApp.types
{
    class IBType
    {
        public IBType(string name, object value)
        {
            Name = name;
            Value = value;
        }

        public string Name { get; }

        public object Value { get; }

        public override string ToString()
        {
            return Name;
        }
    }

    class TriggerMethod
    {
        public static object[] GetAll()
        {
            return new object[] { Default, DoubleBidAsk, Last, DoubleLast,  BidAsk, LastBidOrAsk, Midpoint};
        }
        public static IBType Default = new IBType("Default", 0);
        public static IBType DoubleBidAsk = new IBType("DoubleBidAsk", 1);
        public static IBType Last = new IBType("Last", 2);
        public static IBType DoubleLast = new IBType("DoubleLast", 3);
        public static IBType BidAsk = new IBType("BidAsk", 4);
        public static IBType LastBidOrAsk = new IBType("LastBidOrAsk", 5);
        public static IBType Midpoint = new IBType("Midpoint", 6);
    }

    class Rule80A
    {
        public static object[] GetAll()
        {
            return new object[] { None, Individual, Agency, AgentOtherMember, IndividualPTIA, AgencyPTIA, AgentOtherMemberPTIA, IndividualPT, AgencyPT, AgentOtherMemberPT };
        }
        public static IBType None = new IBType("None", "");
        public static IBType Individual = new IBType("Individual", "I");
        public static IBType Agency = new IBType("Agency", "A");
        public static IBType AgentOtherMember = new IBType("AgentOtherMember", "W");
        public static IBType IndividualPTIA = new IBType("IndividualPTIA", "J");
        public static IBType AgencyPTIA = new IBType("AgencyPTIA", "U");
        public static IBType AgentOtherMemberPTIA = new IBType("AgentOtherMemberPTIA", "M");
        public static IBType IndividualPT = new IBType("IndividualPT", "K");
        public static IBType AgencyPT = new IBType("AgencyPT", "Y");
        public static IBType AgentOtherMemberPT = new IBType("AgentOtherMemberPT", "N");
    }

    class OCAType
    {
        public static object[] GetAll()
        {
            return new object[] {None, CancelWithBlocking, ReduceWithBlocking, ReduceWithoutBlocking };
        }
        public static IBType None = new IBType("None", 0);
        public static IBType CancelWithBlocking = new IBType("CancelWithBlocking", 1);
        public static IBType ReduceWithBlocking = new IBType("ReduceWithBlocking", 2);
        public static IBType ReduceWithoutBlocking = new IBType("ReduceWithoutBlocking", 3);
    }

    class HedgeType
    {
        public static object[] GetAll()
        {
            return new object[] { None, Delta, Beta, Fx, Pair };
        }
        public static IBType None = new IBType("None", "");
        public static IBType Delta = new IBType("Delta", "D");
        public static IBType Beta = new IBType("Beta", "B");
        public static IBType Fx = new IBType("Fx", "F");
        public static IBType Pair = new IBType("Pair", "P");
    }

    class VolatilityType
    {
        public static object[] GetAll()
        {
            return new object[] { None, Daily, Annual};
        }
        public static IBType None = new IBType("None", 0);
        public static IBType Daily = new IBType("Daily", 1);
        public static IBType Annual = new IBType("Annual", 1);
    }

    class ReferencePriceType
    {
        public static object[] GetAll()
        {
            return new object[] {None, Midpoint, BidOrAsk };
        }
        public static IBType None = new IBType("None", 0);
        public static IBType Midpoint = new IBType("Midpoint", 1);
        public static IBType BidOrAsk = new IBType("BidOrAsk", 2);
    }

    class FaMethod
    {
        public static object[] GetAll()
        {
            return new object[] { None, EqualQuantity, AvailableEquity, NetLiq, PctChange };
        }
        public static IBType None = new IBType("None", "");
        public static IBType EqualQuantity = new IBType("EqualQuantity", "EqualQuantity");
        public static IBType AvailableEquity = new IBType("AvailableEquity", "AvailableEquity");
        public static IBType NetLiq = new IBType("NetLiq", "NetLiq");
        public static IBType PctChange = new IBType("PctChange", "PctChange");
    }

    class ContractRight
    {
        public static object[] GetAll()
        {
            return new object[] { None, Put, Call};
        }

        public static IBType None = new IBType("None", "");
        public static IBType Put = new IBType("Put", "P");
        public static IBType Call = new IBType("Call", "C");
    }

    class FundamentalsReport
    {
        public static object[] GetAll()
        {
            return new object[] { ReportSnapshot, FinancialSummary, FinStatements, RESC};
        }
        public static IBType ReportSnapshot = new IBType("Company overview", "ReportSnapshot");
        public static IBType FinancialSummary = new IBType("Financial summary", "ReportsFinSummary");
        public static IBType FinStatements = new IBType("Financial statements", "ReportsFinStatements");
        public static IBType RESC = new IBType("Analyst estimates", "RESC");
    }

    class FinancialAdvisorDataType
    {
        public static object[] GetAll()
        {
            return new object[] { Groups, Profiles, Aliases };
        }

        public static IBType Groups = new IBType("Groups", 1);
        public static IBType Profiles = new IBType("Profiles", 2);
        public static IBType Aliases = new IBType("Alias", 3);
    }

    class AllocationGroupMethod
    {
        //The DataTable will then properly populate the grid's ComboBox cell
        public static DataTable GetAsData()
        {
            DataTable faDefaultMethods = new DataTable();
            faDefaultMethods.Columns.Add(new DataColumn("Name", typeof(string)));
            faDefaultMethods.Columns.Add(new DataColumn("Value", typeof(string)));
            faDefaultMethods.Rows.Add("Equal quantity", "EqualQuantity");
            faDefaultMethods.Rows.Add("Available equity", "AvailableEquity");
            faDefaultMethods.Rows.Add("Net liquidity", "NetLiq");
            faDefaultMethods.Rows.Add("Percent change", "PctChange");
            return faDefaultMethods;
        }

        public static IBType EqualQuantity = new IBType("Equal quantity", "EqualQuantity");
        public static IBType AvailableEquity = new IBType("Available equity", "AvailableEquity");
        public static IBType NetLiquidity = new IBType("Net liquidity", "NetLiq");
        public static IBType PercentChange = new IBType("Percent change", "PctChange");
    }

    class AllocationProfileType
    {
        public static DataTable GetAsData()
        {
            DataTable allocationProfileTypes = new DataTable();
            allocationProfileTypes.Columns.Add(new DataColumn("Name", typeof(string)));
            allocationProfileTypes.Columns.Add(new DataColumn("Value", typeof(int)));
            allocationProfileTypes.Rows.Add("Percentages", 1);
            allocationProfileTypes.Rows.Add("Financial Ratios", 2);
            allocationProfileTypes.Rows.Add("Shares", 3);
            return allocationProfileTypes;
        }
    }

    class MarketDataType
    {
        public static object[] GetAll()
        {
            return new object[] { Real_Time, Frozen, Delayed, Delayed_Frozen };
        }

        public static IBType get(int marketDataType)
        {
            IBType ret = Real_Time;
            foreach (object ibType in GetAll()){
                if ( (int)((IBType)ibType).Value == marketDataType)
                {
                    ret = (IBType)ibType;
                }
            }
            return ret;
        }

        public static IBType Real_Time = new IBType("Real-Time", 1);
        public static IBType Frozen = new IBType("Frozen", 2);
        public static IBType Delayed = new IBType("Delayed", 3);
        public static IBType Delayed_Frozen = new IBType("Delayed-Frozen", 4);
    }
}
