/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Windows.Forms;
using IBApi;
using IBSampleApp.messages;

namespace IBSampleApp.ui
{
    class ContractManager
    {
        public const int CONTRACT_ID_BASE = 60000000;
        public const int CONTRACT_DETAILS_ID = CONTRACT_ID_BASE + 1;
        public const int FUNDAMENTALS_ID = CONTRACT_ID_BASE + 2;

        private bool contractRequestActive;
        private bool fundamentalsRequestActive;

        public ContractManager(IBClient ibClient, TextBox fundamentalsOutput, DataGridView contractDetailsGrid, DataGridView bondContractDetailsGrid, ComboBox comboBoxMarketRuleId,
            DataGridView dataGridViewMarketRule, Label labelMarketRuleIdRes)
        {
            IbClient = ibClient;
            Fundamentals = fundamentalsOutput;
            ContractDetailsGrid = contractDetailsGrid;
            BondContractDetailsGrid = bondContractDetailsGrid;
            ComboContractResults = new ComboContractResults();
            ComboBoxMarketRuleId = comboBoxMarketRuleId;
            DataGridViewMarketRule = dataGridViewMarketRule;
            LabelMarketRuleIdRes =  labelMarketRuleIdRes;
        }

        public void UpdateUI(ContractDetailsMessage message)
        {

            if (IsComboLegRequest)
                ComboContractResults.UpdateUI(message);
            else
                HandleContractMessage(message);
        }

        public void HandleContractDataEndMessage(ContractDetailsEndMessage contractDetailsEndMessage)
        {
            if (IsComboLegRequest)
                ComboContractResults.Show();

            contractRequestActive = false;
            IsComboLegRequest = false;
        }

        public void HandleBondContractMessage(BondContractDetailsMessage bondContractDetailsMessage)
        {
            BondContractDetailsGrid.Rows.Add(1);

            BondContractDetailsGrid[0, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Contract.ConId;
            BondContractDetailsGrid[1, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Contract.Symbol;
            BondContractDetailsGrid[2, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Contract.Exchange;
            BondContractDetailsGrid[3, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Contract.Currency;
            BondContractDetailsGrid[4, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Contract.TradingClass;
            BondContractDetailsGrid[5, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.MarketName;
            BondContractDetailsGrid[6, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.MinTick;
            BondContractDetailsGrid[7, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.OrderTypes;
            BondContractDetailsGrid[8, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.ValidExchanges;
            BondContractDetailsGrid[9, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.LongName;
            BondContractDetailsGrid[10, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.MdSizeMultiplier;
            BondContractDetailsGrid[11, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.AggGroup;
            BondContractDetailsGrid[12, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.MarketRuleIds;
            BondContractDetailsGrid[13, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Cusip;
            BondContractDetailsGrid[14, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Ratings;
            BondContractDetailsGrid[15, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.DescAppend;
            BondContractDetailsGrid[16, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.BondType;
            BondContractDetailsGrid[17, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.CouponType;
            BondContractDetailsGrid[18, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Callable;
            BondContractDetailsGrid[19, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Putable;
            BondContractDetailsGrid[20, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Coupon;
            BondContractDetailsGrid[21, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Convertible;
            BondContractDetailsGrid[22, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Maturity;
            BondContractDetailsGrid[23, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.IssueDate;
            BondContractDetailsGrid[24, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.NextOptionDate;
            BondContractDetailsGrid[25, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.NextOptionType;
            BondContractDetailsGrid[26, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.NextOptionPartial;
            BondContractDetailsGrid[27, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.Notes;
            BondContractDetailsGrid[28, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.LastTradeTime;
            BondContractDetailsGrid[29, BondContractDetailsGrid.Rows.Count - 1].Value = bondContractDetailsMessage.ContractDetails.TimeZoneId;

            UpdateMakretRuleIdsComboBox(bondContractDetailsMessage.ContractDetails.MarketRuleIds);
        }


        public void HandleContractMessage(ContractDetailsMessage contractDetailsMessage)
        {
            ContractDetailsGrid.Rows.Add(1);
            ContractDetailsGrid[0, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Symbol;
            ContractDetailsGrid[1, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.LocalSymbol;
            ContractDetailsGrid[2, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.SecType;
            ContractDetailsGrid[3, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Currency;
            ContractDetailsGrid[4, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Exchange;
            ContractDetailsGrid[5, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.PrimaryExch;
            ContractDetailsGrid[6, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.LastTradeDateOrContractMonth;
            ContractDetailsGrid[7, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Multiplier;
            ContractDetailsGrid[8, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Strike;
            ContractDetailsGrid[9, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.Right;
            ContractDetailsGrid[10, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.Contract.ConId;
            ContractDetailsGrid[11, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.MdSizeMultiplier;
            ContractDetailsGrid[12, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.AggGroup;
            ContractDetailsGrid[13, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.UnderSymbol;
            ContractDetailsGrid[14, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.UnderSecType;
            ContractDetailsGrid[15, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.MarketRuleIds;
            ContractDetailsGrid[16, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.RealExpirationDate;
            ContractDetailsGrid[17, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.ContractMonth;
            ContractDetailsGrid[18, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.LastTradeTime;
            ContractDetailsGrid[19, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.TimeZoneId;
            ContractDetailsGrid[20, ContractDetailsGrid.Rows.Count - 1].Value = contractDetailsMessage.ContractDetails.StockType;

            UpdateMakretRuleIdsComboBox(contractDetailsMessage.ContractDetails.MarketRuleIds);
        }

        public void HandleMarketRuleMessage(MarketRuleMessage marketRuleMessage)
        {
            LabelMarketRuleIdRes.Text = "Market Rule Id: " + marketRuleMessage.MarketruleId;

            DataGridViewMarketRule.Rows.Clear();
            for (int i = 0; i < marketRuleMessage.PriceIncrements.Length; i++)
            {
                DataGridViewMarketRule.Rows.Add(1);
                DataGridViewMarketRule[0, DataGridViewMarketRule.Rows.Count - 1].Value = marketRuleMessage.PriceIncrements[i].LowEdge;
                DataGridViewMarketRule[1, DataGridViewMarketRule.Rows.Count - 1].Value = marketRuleMessage.PriceIncrements[i].Increment;
            }
        }

        public void HandleRequestError(int requestId)
        {
            if (requestId == CONTRACT_DETAILS_ID)
            {
                IsComboLegRequest = false;
                contractRequestActive = false;
            }
            else if (requestId == FUNDAMENTALS_ID)
                fundamentalsRequestActive = false;
        }

        public void HandleFundamentalsData(FundamentalsMessage fundamentalsMessage)
        {
            Fundamentals.Text = fundamentalsMessage.Data;
            fundamentalsRequestActive = false;
        }

        public void RequestContractDetails(Contract contract)
        {
            if (!contractRequestActive)
            {
                ContractDetailsGrid.Rows.Clear();
                BondContractDetailsGrid.Rows.Clear();
                IbClient.ClientSocket.reqContractDetails(CONTRACT_DETAILS_ID, contract);
            }
        }

        public void RequestFundamentals(Contract contract, string reportType)
        {
            Fundamentals.Text = "";
            if (!fundamentalsRequestActive)
            {
                fundamentalsRequestActive = true;
                IbClient.ClientSocket.reqFundamentalData(FUNDAMENTALS_ID, contract, reportType, new List<TagValue>());
            }
            else
            {
                fundamentalsRequestActive = false;
                IbClient.ClientSocket.cancelFundamentalData(FUNDAMENTALS_ID);
            }
        }

        public void RequestMarketDataType(int marketDataType)
        {
            IbClient.ClientSocket.reqMarketDataType(marketDataType);
        }

        public void RequestMarketRule(int marketRuleId)
        {
            IbClient.ClientSocket.reqMarketRule(marketRuleId);
        }

        private void UpdateMakretRuleIdsComboBox(string marketRuleIdsStr)
        {
            if (marketRuleIdsStr != null)
            {
                string[] marketRuleIds = marketRuleIdsStr.Split(',');
                foreach (string marketRuleId in marketRuleIds)
                {
                    if (!ComboBoxMarketRuleId.Items.Contains(marketRuleId))
                    {
                        ComboBoxMarketRuleId.Items.Add(marketRuleId);
                    }
                }
            }
        }

        public ComboContractResults ComboContractResults { get; set; }

        public IBClient IbClient { get; set; }

        public TextBox Fundamentals { get; set; }

        public DataGridView ContractDetailsGrid { get; set; }

        public DataGridView BondContractDetailsGrid { get; set; }

        public bool IsComboLegRequest { get; set; }

        public ComboBox ComboBoxMarketRuleId { get; set; }

        public DataGridView DataGridViewMarketRule { get; set; }

        public Label LabelMarketRuleIdRes { get; set; }
    }
}
