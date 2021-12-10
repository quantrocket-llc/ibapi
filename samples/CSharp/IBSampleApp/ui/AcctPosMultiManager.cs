/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using IBSampleApp.messages;
using System.Windows.Forms;
using IBSampleApp.util;
using IBApi;

namespace IBSampleApp.ui
{
    class AcctPosMultiManager
    {
        private const int ACCTPOSMULTI_ID_BASE = 80000000;

        private const int POSITIONS_MULTI_ID = ACCTPOSMULTI_ID_BASE + 1;
        private const int ACCOUNT_UPDATES_MULTI_ID = ACCTPOSMULTI_ID_BASE + 100000;

        public AcctPosMultiManager(IBClient ibClient, DataGridView positionsMultiGrid, DataGridView accountUpdatesMultiGrid)
        {
            IbClient = ibClient;
            PositionsMultiGrid = positionsMultiGrid;
            AccountUpdatesMultiGrid = accountUpdatesMultiGrid;
        }

        public void  HandleAccountUpdateMulti(AccountUpdateMultiMessage accountUpdateMultiMessage)
        {
            for (int i = 0; i < AccountUpdatesMultiGrid.Rows.Count; i++)
            {
                if (AccountUpdatesMultiGrid[2, i].Value.Equals(accountUpdateMultiMessage.Key) && 
                    AccountUpdatesMultiGrid[4, i].Value.Equals(accountUpdateMultiMessage.Currency == null ? "" : accountUpdateMultiMessage.Currency))
                {
                    AccountUpdatesMultiGrid[0, i].Value = accountUpdateMultiMessage.Account;
                    AccountUpdatesMultiGrid[1, i].Value = accountUpdateMultiMessage.ModelCode;
                    AccountUpdatesMultiGrid[3, i].Value = accountUpdateMultiMessage.Value;
                    return;
                }
            }
            AccountUpdatesMultiGrid.Rows.Add(1);
            AccountUpdatesMultiGrid[0, AccountUpdatesMultiGrid.Rows.Count - 1].Value = accountUpdateMultiMessage.Account;
            AccountUpdatesMultiGrid[1, AccountUpdatesMultiGrid.Rows.Count - 1].Value = accountUpdateMultiMessage.ModelCode;
            AccountUpdatesMultiGrid[2, AccountUpdatesMultiGrid.Rows.Count - 1].Value = accountUpdateMultiMessage.Key;
            AccountUpdatesMultiGrid[3, AccountUpdatesMultiGrid.Rows.Count - 1].Value = accountUpdateMultiMessage.Value;
            AccountUpdatesMultiGrid[4, AccountUpdatesMultiGrid.Rows.Count - 1].Value = accountUpdateMultiMessage.Currency == null ? "" : accountUpdateMultiMessage.Currency;
        }

        public void HandleAccountUpdateMultiEnd(AccountUpdateMultiEndMessage accountUpdateMultiEndMessage)
        {
        }

        public void HandlePositionMulti(PositionMultiMessage positionMultiMessage)
        {
            for (int i = 0; i < PositionsMultiGrid.Rows.Count; i++)
            {

                if (PositionsMultiGrid[2, i].Value.Equals(Utils.ContractToString(positionMultiMessage.Contract)) &&
                    PositionsMultiGrid[0, i].Value.Equals(positionMultiMessage.Account) &&
                    PositionsMultiGrid[1, i].Value.Equals(positionMultiMessage.ModelCode == null ? "" : positionMultiMessage.ModelCode)
                    )
                {
                    PositionsMultiGrid[3, i].Value = Util.DecimalMaxString(positionMultiMessage.Position);
                    PositionsMultiGrid[4, i].Value = Util.DoubleMaxString(positionMultiMessage.AverageCost);
                    return;
                }
            }

            PositionsMultiGrid.Rows.Add(1);
            PositionsMultiGrid[0, PositionsMultiGrid.Rows.Count - 1].Value = positionMultiMessage.Account;
            PositionsMultiGrid[1, PositionsMultiGrid.Rows.Count - 1].Value = (positionMultiMessage.ModelCode == null) ? "" : positionMultiMessage.ModelCode;
            PositionsMultiGrid[2, PositionsMultiGrid.Rows.Count - 1].Value = Utils.ContractToString(positionMultiMessage.Contract);
            PositionsMultiGrid[3, PositionsMultiGrid.Rows.Count - 1].Value = Util.DecimalMaxString(positionMultiMessage.Position);
            PositionsMultiGrid[4, PositionsMultiGrid.Rows.Count - 1].Value = Util.DoubleMaxString(positionMultiMessage.AverageCost);
        }

        public void HandlePositionMultiEnd(PositionMultiEndMessage positionMultiEndMessage)
        {
        }

        public void RequestPositionsMulti(string account, string modelCode)
        {
            PositionsMultiGrid.Rows.Clear();
            IbClient.ClientSocket.reqPositionsMulti(POSITIONS_MULTI_ID, account, modelCode);
        }

        public void CancelPositionsMulti()
        {
            IbClient.ClientSocket.cancelPositionsMulti(POSITIONS_MULTI_ID);
        }


        public void RequestAccountUpdatesMulti(string account, string modelCode, bool ledgerAndNLV)
        {
            AccountUpdatesMultiGrid.Rows.Clear();
            IbClient.ClientSocket.reqAccountUpdatesMulti(ACCOUNT_UPDATES_MULTI_ID, account, modelCode, ledgerAndNLV);
        }

        public void CancelAccountUpdatesMulti()
        {
            IbClient.ClientSocket.cancelAccountUpdatesMulti(ACCOUNT_UPDATES_MULTI_ID);
        }

        public void ClearPositionsMulti()
        {
            PositionsMultiGrid.Rows.Clear();
        }

        public void ClearAccountUpdatesMulti()
        {
            AccountUpdatesMultiGrid.Rows.Clear();
        }

        public DataGridView AccountUpdatesMultiGrid { get; set; }

        public DataGridView PositionsMultiGrid { get; set; }

        public IBClient IbClient { get; set; }
    }
}
