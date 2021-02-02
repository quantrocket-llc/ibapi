﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Windows.Forms;
using IBApi;
using IBSampleApp.messages;
using IBSampleApp.util;

namespace IBSampleApp.ui
{
    class ScannerManager : DataManager
    {
        private int rowCounter = -1;

        private const int RANK_IDX = 0;
        private const int CONTRACT_IDX = 1;
        private const int DISTANCE_IDX = 2;
        private const int BENCHMARK_IDX = 3;
        private const int PROJECTION_IDX = 4;
        private const int LEGS_IDX = 5;

        private TextBox parametersOutput;

        public ScannerManager(IBClient client, DataGridView dataGrid, TextBox paramsOutput)
            : base(client, dataGrid)
        {
            parametersOutput = paramsOutput;
        }

        public override void NotifyError(int requestId)
        {
        }

        public void UpdateUI(ScannerParametersMessage scanParamsMessage)
        {
            parametersOutput.Text = scanParamsMessage.XmlData;
        }

        public void UpdateUI(ScannerMessage scannMessage)
        {
            DataGridView grid = (DataGridView)uiControl;

            rowCounter++;

            grid.Rows.Add();
            grid[RANK_IDX, rowCounter].Value = scannMessage.Rank;
            grid[CONTRACT_IDX, rowCounter].Value = Utils.ContractToString(scannMessage.ContractDetails.Contract);
            grid[DISTANCE_IDX, rowCounter].Value = scannMessage.Distance;
            grid[BENCHMARK_IDX, rowCounter].Value = scannMessage.Benchmark;
            grid[PROJECTION_IDX, rowCounter].Value = scannMessage.Projection;
            grid[LEGS_IDX, rowCounter].Value = scannMessage.LegsStr;
        }
        

        public override void Clear()
        {
            ibClient.ClientSocket.cancelScannerSubscription(currentTicker);
            DataGridView grid = (DataGridView)uiControl;
            grid.Rows.Clear();
            rowCounter = -1;
        }

        public void AddRequest(ScannerSubscription scannerSubscription, List<TagValue> filterOptions)
        {
            ibClient.ClientSocket.reqScannerSubscription(currentTicker, scannerSubscription, null, filterOptions);
        }

        public void RequestParameters()
        {
            ibClient.ClientSocket.reqScannerParameters();
        }
    }
}
