﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Windows.Forms.DataVisualization.Charting;
using IBApi;
using IBSampleApp.messages;
using System.Globalization;
using System.Windows.Forms;

namespace IBSampleApp.ui
{
    class HistoricalDataManager : DataManager
    {
        public const int HISTORICAL_ID_BASE = 30000000;

        protected int barCounter = -1;
        protected DataGridView gridView;

        private List<HistoricalDataMessage> historicalData;

        public HistoricalDataManager(IBClient ibClient, Chart chart, DataGridView gridView) : base(ibClient, chart) 
        {
            Chart historicalChart = (Chart)uiControl;
            historicalChart.Series[0]["PriceUpColor"] = "Green";
            historicalChart.Series[0]["PriceDownColor"] = "Red";
            this.gridView = gridView;
        }

        public void AddRequest(Contract contract, string endDateTime, string durationString, string barSizeSetting, string whatToShow, int useRTH, int dateFormat, bool keepUpToDate)
        {
            Clear();
            ibClient.ClientSocket.reqHistoricalData(currentTicker + HISTORICAL_ID_BASE, contract, endDateTime, durationString, barSizeSetting, whatToShow, useRTH, 1, keepUpToDate, new List<TagValue>());
        }

        public override void Clear()
        {
            barCounter = -1;
            Chart historicalChart = (Chart)uiControl;
            historicalChart.Series[0].Points.Clear();
            gridView.Rows.Clear();
            historicalData = new List<HistoricalDataMessage>();
        }

        public override void NotifyError(int requestId)
        {
        }

        public void UpdateUI(HistoricalDataMessage message)
        {
            historicalData.Add(message);
        }

        public void UpdateUI(HistoricalDataEndMessage message)
        {
            PaintChart();
        }

        private void PaintChart()
        {
            Chart historicalChart = (Chart)uiControl;
            for (int i = 0; i < historicalData.Count; i++)
            {
                // adding date and high
                historicalChart.Series[0].Points.AddXY(historicalData[i].Date, historicalData[i].High);
                // adding low
                historicalChart.Series[0].Points[i].YValues[1] = historicalData[i].Low;
                //adding open
                historicalChart.Series[0].Points[i].YValues[2] = historicalData[i].Open;
                // adding close
                historicalChart.Series[0].Points[i].YValues[3] = historicalData[i].Close;
                PopulateGrid(historicalData[i]);
            }
        }

        protected void PopulateGrid(HistoricalDataMessage bar)
        {            
            gridView.Rows.Add(1);

            gridView[0, gridView.Rows.Count -1].Value = bar.Date;
            gridView[1, gridView.Rows.Count - 1].Value = Util.DoubleMaxString(bar.Open);
            gridView[2, gridView.Rows.Count - 1].Value = Util.DoubleMaxString(bar.High);
            gridView[3, gridView.Rows.Count - 1].Value = Util.DoubleMaxString(bar.Low);
            gridView[4, gridView.Rows.Count - 1].Value = Util.DoubleMaxString(bar.Close);
            gridView[5, gridView.Rows.Count - 1].Value = Util.DecimalMaxString(bar.Volume);
            gridView[6, gridView.Rows.Count - 1].Value = Util.DecimalMaxString(bar.Wap);
        }
    }
}
