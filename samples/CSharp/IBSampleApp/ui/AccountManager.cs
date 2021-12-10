/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;

using IBSampleApp.messages;
using System.Windows.Forms;
using IBSampleApp.util;
using IBApi;

namespace IBSampleApp.ui
{
    class AccountManager
    {
        private const int ACCOUNT_ID_BASE = 50000000;

        private const int ACCOUNT_SUMMARY_ID = ACCOUNT_ID_BASE + 1;

        private const string ACCOUNT_SUMMARY_TAGS = "AccountType,NetLiquidation,TotalCashValue,SettledCash,AccruedCash,BuyingPower,EquityWithLoanValue,PreviousEquityWithLoanValue,"
             +"GrossPositionValue,ReqTEquity,ReqTMargin,SMA,InitMarginReq,MaintMarginReq,AvailableFunds,ExcessLiquidity,Cushion,FullInitMarginReq,FullMaintMarginReq,FullAvailableFunds,"
             +"FullExcessLiquidity,LookAheadNextChange,LookAheadInitMarginReq ,LookAheadMaintMarginReq,LookAheadAvailableFunds,LookAheadExcessLiquidity,HighestSeverity,DayTradesRemaining,Leverage";

        private List<string> managedAccounts;

        private bool accountSummaryRequestActive;
        private bool accountUpdateRequestActive;
        private string currentAccountSubscribedToTupdate;

        public AccountManager(IBClient ibClient, ComboBox accountSelector, DataGridView accountSummaryGrid, DataGridView accountValueGrid,
            DataGridView accountPortfolioGrid, DataGridView positionsGrid, DataGridView familyCodesGrid)
        {
            IbClient = ibClient;
            AccountSelector = accountSelector;
            AccountSummaryGrid = accountSummaryGrid;
            AccountValueGrid = accountValueGrid;
            AccountPortfolioGrid = accountPortfolioGrid;
            PositionsGrid = positionsGrid;
            FamilyCodesGrid = familyCodesGrid;
        }

        public void HandleAccountSummaryEnd()
        {
            accountSummaryRequestActive = false;
        }

        public void HandleAccountSummary(AccountSummaryMessage summaryMessage)
        {
            for (int i = 0; i < AccountSummaryGrid.Rows.Count; i++)
            {
                if (AccountSummaryGrid[0, i].Value.Equals(summaryMessage.Tag) && AccountSummaryGrid[3, i].Value.Equals(summaryMessage.Account))
                {
                    AccountSummaryGrid[1, i].Value = summaryMessage.Value;
                    AccountSummaryGrid[2, i].Value = summaryMessage.Currency;
                    return;
                }
            }
            AccountSummaryGrid.Rows.Add(1);
            AccountSummaryGrid[0, AccountSummaryGrid.Rows.Count-1].Value = summaryMessage.Tag;
            AccountSummaryGrid[1, AccountSummaryGrid.Rows.Count - 1].Value = summaryMessage.Value;
            AccountSummaryGrid[2, AccountSummaryGrid.Rows.Count - 1].Value = summaryMessage.Currency;
            AccountSummaryGrid[3, AccountSummaryGrid.Rows.Count - 1].Value = summaryMessage.Account;
        }

        public void HandleAccountValue(AccountValueMessage accountValueMessage)
        {
            for (int i = 0; i < AccountValueGrid.Rows.Count; i++)
            {
                if (AccountValueGrid[0, i].Value.Equals(accountValueMessage.Key))
                {
                    AccountValueGrid[1, i].Value = accountValueMessage.Value;
                    AccountValueGrid[2, i].Value = accountValueMessage.Currency;
                    return;
                }
            }
            AccountValueGrid.Rows.Add(1);
            AccountValueGrid[0, AccountValueGrid.Rows.Count - 1].Value = accountValueMessage.Key;
            AccountValueGrid[1, AccountValueGrid.Rows.Count - 1].Value = accountValueMessage.Value;
            AccountValueGrid[2, AccountValueGrid.Rows.Count - 1].Value = accountValueMessage.Currency;
        }

        public void HandlePortfolioValue(UpdatePortfolioMessage updatePortfolioMessage)
        {
            
            for (int i = 0; i < AccountPortfolioGrid.Rows.Count; i++)
            {
                if (AccountPortfolioGrid[0, i].Value.Equals(Utils.ContractToString(updatePortfolioMessage.Contract)))
                {
                    AccountPortfolioGrid[1, i].Value = Util.DecimalMaxString(updatePortfolioMessage.Position);
                    AccountPortfolioGrid[2, i].Value = Util.DoubleMaxString(updatePortfolioMessage.MarketPrice);
                    AccountPortfolioGrid[3, i].Value = Util.DoubleMaxString(updatePortfolioMessage.MarketValue);
                    AccountPortfolioGrid[4, i].Value = Util.DoubleMaxString(updatePortfolioMessage.AverageCost);
                    AccountPortfolioGrid[5, i].Value = Util.DoubleMaxString(updatePortfolioMessage.UnrealizedPNL);
                    AccountPortfolioGrid[6, i].Value = Util.DoubleMaxString(updatePortfolioMessage.RealizedPNL);
                    return;
                }
            }
            
            AccountPortfolioGrid.Rows.Add(1);
            AccountPortfolioGrid[0, AccountPortfolioGrid.Rows.Count - 1].Value = Utils.ContractToString(updatePortfolioMessage.Contract); ;
            AccountPortfolioGrid[1, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DecimalMaxString(updatePortfolioMessage.Position);
            AccountPortfolioGrid[2, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DoubleMaxString(updatePortfolioMessage.MarketPrice);
            AccountPortfolioGrid[3, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DoubleMaxString(updatePortfolioMessage.MarketValue);
            AccountPortfolioGrid[4, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DoubleMaxString(updatePortfolioMessage.AverageCost);
            AccountPortfolioGrid[5, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DoubleMaxString(updatePortfolioMessage.UnrealizedPNL);
            AccountPortfolioGrid[6, AccountPortfolioGrid.Rows.Count - 1].Value = Util.DoubleMaxString(updatePortfolioMessage.RealizedPNL);
        }

        public void HandlePosition(PositionMessage positionMessage)
        {
            for (int i = 0; i < PositionsGrid.Rows.Count; i++)
            {
                if (PositionsGrid[0, i].Value.Equals(Utils.ContractToString(positionMessage.Contract)))
                {
                    PositionsGrid[1, i].Value = positionMessage.Account;
                    PositionsGrid[2, i].Value = Util.DecimalMaxString(positionMessage.Position);
                    PositionsGrid[3, i].Value = Util.DoubleMaxString(positionMessage.AverageCost);
                    return;
                }
            }

            PositionsGrid.Rows.Add(1);
            PositionsGrid[0, PositionsGrid.Rows.Count - 1].Value = Utils.ContractToString(positionMessage.Contract);
            PositionsGrid[1, PositionsGrid.Rows.Count - 1].Value = positionMessage.Account;
            PositionsGrid[2, PositionsGrid.Rows.Count - 1].Value = Util.DecimalMaxString(positionMessage.Position);
            PositionsGrid[3, PositionsGrid.Rows.Count - 1].Value = Util.DoubleMaxString(positionMessage.AverageCost);
        }

        public void HandleFamilyCodes(FamilyCodesMessage familyCodesMessage)
        {
            FamilyCodesGrid.Rows.Clear();
            for (int i = 0; i < familyCodesMessage.FamilyCodes.Length; i++)
            {
                FamilyCodesGrid.Rows.Add(1);
                FamilyCodesGrid[0, FamilyCodesGrid.Rows.Count - 1].Value = familyCodesMessage.FamilyCodes[i].AccountID;
                FamilyCodesGrid[1, FamilyCodesGrid.Rows.Count - 1].Value = familyCodesMessage.FamilyCodes[i].FamilyCodeStr;
            }
        }

        public void RequestAccountSummary()
        {
            if (!accountSummaryRequestActive)
            {
                accountSummaryRequestActive = true;
                AccountSummaryGrid.Rows.Clear();
                IbClient.ClientSocket.reqAccountSummary(ACCOUNT_SUMMARY_ID, "All", ACCOUNT_SUMMARY_TAGS);
            }
            else
            {
                IbClient.ClientSocket.cancelAccountSummary(ACCOUNT_SUMMARY_ID);
            }
        }

        public void SubscribeAccountUpdates()
        {
            if (!accountUpdateRequestActive && AccountSelector.SelectedItem != null)
            {
                currentAccountSubscribedToTupdate = AccountSelector.SelectedItem.ToString();
                accountUpdateRequestActive = true;
                AccountValueGrid.Rows.Clear();
                AccountPortfolioGrid.Rows.Clear();
                IbClient.ClientSocket.reqAccountUpdates(true, currentAccountSubscribedToTupdate);
            }
            else
            {
                IbClient.ClientSocket.reqAccountUpdates(false, currentAccountSubscribedToTupdate);
                currentAccountSubscribedToTupdate = null;
                accountUpdateRequestActive = false;
            }
        }

        public void RequestPositions()
        {
            IbClient.ClientSocket.reqPositions();
        }

        public void RequestFamilyCodes()
        {
            IbClient.ClientSocket.reqFamilyCodes();
        }

        public void ClearFamilyCodes()
        {
            FamilyCodesGrid.Rows.Clear();
        }

        public List<string> ManagedAccounts
        {
            get { return managedAccounts; }
            set 
            { 
                managedAccounts = value; 
                SetManagedAccounts(value);
            }
        }

        public void SetManagedAccounts(List<string> managedAccounts)
        {
            AccountSelector.Items.AddRange(managedAccounts.ToArray());
            AccountSelector.SelectedIndex = 0;
        }

        public ComboBox AccountSelector { get; set; }

        public DataGridView AccountSummaryGrid { get; set; }

        public DataGridView AccountValueGrid { get; set; }

        public DataGridView AccountPortfolioGrid { get; set; }

        public DataGridView PositionsGrid { get; set; }

        public DataGridView FamilyCodesGrid { get; set; }

        public IBClient IbClient { get; set; }
    }
}
