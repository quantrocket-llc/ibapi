/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using IBSampleApp.messages;
using IBApi;
using IBSampleApp.ui;
using IBSampleApp.util;
using IBSampleApp.types;
using System.Threading;
using System.IO;
using System.Xml;


namespace IBSampleApp
{
    partial class IBSampleAppDialog : Form
    {
        private MarketDataManager marketDataManager;
        private DeepBookManager deepBookManager;
        private HistoricalDataManager historicalDataManager;
        private RealTimeBarsManager realTimeBarManager;
        private ScannerManager scannerManager;
        private OrderManager orderManager;
        private AccountManager accountManager;
        private ContractManager contractManager;
        private AdvisorManager advisorManager;
        private OptionsManager optionsManager;
        private AcctPosMultiManager acctPosMultiManager;
        private SymbolSamplesManager symbolSamplesManagerData;
        private SymbolSamplesManager symbolSamplesManagerContractInfo;
        private NewsManager newsManager;

        protected IBClient ibClient;

        private const int MAX_LINES_IN_MESSAGE_BOX = 200;
        private const int REDUCED_LINES_IN_MESSAGE_BOX = 100;
        private int numberOfLinesInMessageBox;
        private List<string> linesInMessageBox = new List<string>(MAX_LINES_IN_MESSAGE_BOX);
        private List<string> bboExchangeList = new List<string>();

        private EReaderMonitorSignal signal = new EReaderMonitorSignal();

        private DataTable pnldataTable = new DataTable(),
            pnlSingledataTable = new DataTable(),
            historicalTickTable = new DataTable(),
            historicalTickBidAskTable = new DataTable(),
            historicalTickLastTable = new DataTable(),
            tickByTickLastTable = new DataTable(),
            tickByTickAllLastTable = new DataTable(),
            tickByTickBidAskTable = new DataTable(),
            tickByTickMidPointTable = new DataTable();


        public IBSampleAppDialog()
        {
            InitializeComponent();

            ibClient = new IBClient(signal);
            marketDataManager = new MarketDataManager(ibClient, marketDataGrid_MDT);
            deepBookManager = new DeepBookManager(ibClient, deepBookGrid, mktDepthExchangesGrid_MDT);
            historicalDataManager = new HistoricalDataManager(ibClient, historicalChart, barsGrid);
            realTimeBarManager = new RealTimeBarsManager(ibClient, rtBarsChart, rtBarsGrid);
            scannerManager = new ScannerManager(ibClient, scannerGrid, scannerParamsOutput);
            orderManager = new OrderManager(ibClient, liveOrdersGrid, completedOrdersGrid, tradeLogGrid);
            accountManager = new AccountManager(ibClient, accountSelector, accSummaryGrid, accountValuesGrid, accountPortfolioGrid, positionsGrid, familyCodesGrid);
            contractManager = new ContractManager(ibClient, fundamentalsOutput, contractDetailsGrid, bondContractDetailsGrid, comboBoxMarketRuleId, dataGridViewMarketRule, labelMarketRuleIdRes);
            advisorManager = new AdvisorManager(ibClient, advisorAliasesGrid, advisorGroupsGrid, advisorProfilesGrid);
            optionsManager = new OptionsManager(ibClient, optionChainCallGrid, optionChainPutGrid, optionPositionsGrid, listViewOptionParams);
            acctPosMultiManager = new AcctPosMultiManager(ibClient, positionsMultiGrid, accountUpdatesMultiGrid);
            symbolSamplesManagerData = new SymbolSamplesManager(ibClient, symbolSamplesDataGridData);
            symbolSamplesManagerContractInfo = new SymbolSamplesManager(ibClient, symbolSamplesDataGridContractInfo);
            newsManager = new NewsManager(ibClient, dataGridViewNewsTicks, dataGridViewNewsProviders, textBoxNewsArticle, dataGridViewHistoricalNews);
            pnlMgr = new PnLManager(ibClient);

            pnldataTable.Columns.Add("Daily PnL");
            pnldataTable.Columns.Add("Unrealized PnL");
            pnldataTable.Columns.Add("Realized PnL");

            pnlSingledataTable.Columns.Add("Pos");
            pnlSingledataTable.Columns.Add("Daily PnL");
            pnlSingledataTable.Columns.Add("Unrealized PnL");
            pnlSingledataTable.Columns.Add("Realized PnL");
            pnlSingledataTable.Columns.Add("Value");

            Func<string, DataColumn> toDataColumn = i => new DataColumn
                                                         { ColumnName = i };

            historicalTickTable.Columns.AddRange(new[] { "Time", "Price", "Size" }.Select(toDataColumn).ToArray());
            historicalTickBidAskTable.Columns.AddRange(
                new[] { "Time", "Price bid", "Price ask", "Size bid", "Size ask", "Bid/Ask Tick Attribs" }.Select(toDataColumn).ToArray());
            historicalTickLastTable.Columns.AddRange(
                new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "Last Tick Attribs" }.Select(toDataColumn).ToArray());

            tickByTickLastTable.Columns.AddRange(new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "PastLimit" }.Select(toDataColumn).ToArray());
            tickByTickAllLastTable.Columns.AddRange(new[] { "Time", "Price", "Size", "Exchange", "Special Conditions", "PastLimit", "Unreported" }.Select(toDataColumn).ToArray());
            tickByTickBidAskTable.Columns.AddRange(new[] { "Time", "Bid Price", "Ask Price", "Bid Size", "Ask Size", "BidPastLow", "AskPastHigh" }.Select(toDataColumn).ToArray());
            tickByTickMidPointTable.Columns.AddRange(new[] { "Time", "Mid Point" }.Select(toDataColumn).ToArray());

            mdContractRight.Items.AddRange(ContractRight.GetAll());
            mdContractRight.SelectedIndex = 0;

            conDetRight.Items.AddRange(ContractRight.GetAll());
            conDetRight.SelectedIndex = 0;

            fundamentalsReportType.Items.AddRange(FundamentalsReport.GetAll());
            fundamentalsReportType.SelectedIndex = 0;

            comboBoxMarketDataType_CDT.Items.AddRange(MarketDataType.GetAll());
            comboBoxMarketDataType_CDT.SelectedIndex = 0;

            comboBoxMarketDataType_MDT.Items.AddRange(MarketDataType.GetAll());
            comboBoxMarketDataType_MDT.SelectedIndex = 0;

            groupMethod.DataSource = AllocationGroupMethod.GetAsData();
            groupMethod.ValueMember = "Value";
            groupMethod.DisplayMember = "Name";

            profileType.DataSource = AllocationProfileType.GetAsData();
            profileType.ValueMember = "Value";
            profileType.DisplayMember = "Name";

            hdRequest_EndTime.Text = DateTime.Now.ToString("yyyyMMdd HH:mm:ss");
            bboExchange_comboBox.DataSource = bboExchangeList;

            DateTime execFilterDefault = DateTime.Now.AddHours(-1);
            execFilterTime.Text = execFilterDefault.ToString("yyyyMMdd HH:mm:ss");

            DateTime endDateTime = DateTime.Now.AddDays(-3);
            textBoxHistoricalNewsEndDateTime.Text = endDateTime.ToString("yyyy-MM-dd HH:mm:ss.0");

            DateTime startDateTime = DateTime.Now.AddDays(-4);
            textBoxHistoricalNewsStartDateTime.Text = startDateTime.ToString("yyyy-MM-dd HH:mm:ss.0");

            textBoxNewsArticlePath.Text = Directory.GetCurrentDirectory();

            ibClient.Error += ibClient_Error;
            ibClient.ConnectionClosed += ibClient_ConnectionClosed;
            ibClient.CurrentTime += time => addTextToBox("Current Time: " + time + "\n");
            ibClient.TickPrice += ibClient_Tick;
            ibClient.TickSize += ibClient_Tick;
            ibClient.TickString += (tickerId, tickType, value) => addTextToBox("Tick string. Ticker Id:" + tickerId + ", Type: " + TickType.getField(tickType) + ", Value: " + value + "\n");
            ibClient.TickGeneric += (tickerId, field, value) => addTextToBox("Tick Generic. Ticker Id:" + tickerId + ", Field: " + TickType.getField(field) + ", Value: " + value + "\n");
            ibClient.TickEFP += (tickerId, tickType, basisPoints, formattedBasisPoints, impliedFuture, holdDays, futureLastTradeDate, dividendImpact, dividendsToLastTradeDate) => addTextToBox("TickEFP. " + tickerId + ", Type: " + tickType + ", BasisPoints: " + basisPoints + ", FormattedBasisPoints: " + formattedBasisPoints + ", ImpliedFuture: " + impliedFuture + ", HoldDays: " + holdDays + ", FutureLastTradeDate: " + futureLastTradeDate + ", DividendImpact: " + dividendImpact + ", DividendsToLastTradeDate: " + dividendsToLastTradeDate + "\n");
            ibClient.TickSnapshotEnd += tickerId => addTextToBox("TickSnapshotEnd: " + tickerId + "\n");
            ibClient.NextValidId += UpdateUI;
            ibClient.DeltaNeutralValidation += (reqId, deltaNeutralContract) =>
                addTextToBox("DeltaNeutralValidation. " + reqId + ", ConId: " + deltaNeutralContract.ConId + ", Delta: " + deltaNeutralContract.Delta + ", Price: " + deltaNeutralContract.Price + "\n");

            ibClient.ManagedAccounts += UpdateUI;
            ibClient.TickOptionCommunication += HandleTickMessage;

            ibClient.AccountSummary += accountManager.HandleAccountSummary;
            ibClient.AccountSummaryEnd += UpdateUI;
            ibClient.UpdateAccountValue += accountManager.HandleAccountValue;
            ibClient.UpdatePortfolio += UpdateUI;

            ibClient.UpdateAccountTime += message => accUpdatesLastUpdateValue.Text = message.Timestamp;
            //ibClient.AccountDownloadEnd += (do nothing)
            ibClient.OrderStatus += orderManager.HandleOrderStatus;

            ibClient.OpenOrder += orderManager.handleOpenOrder;
            //ibClient.OpenOrderEnd += (do nothing)
            ibClient.ContractDetails += HandleContractDataMessage;
            ibClient.ContractDetailsEnd += reqId => UpdateUI(new ContractDetailsEndMessage());
            ibClient.ExecDetails += orderManager.HandleExecutionMessage;
            ibClient.ExecDetailsEnd += reqId => addTextToBox("ExecDetailsEnd. " + reqId + "\n");
            ibClient.CommissionReport += commissionReport => orderManager.HandleCommissionMessage(new CommissionMessage(commissionReport));
            ibClient.FundamentalData += UpdateUI;

            ibClient.HistoricalData += historicalDataManager.UpdateUI;
            ibClient.HistoricalDataUpdate += historicalDataManager.UpdateUI;
            ibClient.HistoricalDataEnd += historicalDataManager.UpdateUI;

            ibClient.MarketDataType += UpdateUI;
            ibClient.UpdateMktDepth += deepBookManager.UpdateUI;
            ibClient.UpdateMktDepthL2 += deepBookManager.UpdateUI;
            ibClient.UpdateNewsBulletin += (msgId, msgType, message, origExchange) =>
                addTextToBox("News Bulletins. " + msgId + " - Type: " + msgType + ", Message: " + message + ", Exchange of Origin: " + origExchange + "\n");

            ibClient.Position += accountManager.HandlePosition;
            ibClient.PositionEnd += () => addTextToBox("PositionEnd \n");
            ibClient.RealtimeBar += realTimeBarManager.UpdateUI;
            ibClient.ScannerParameters += xml => scannerManager.UpdateUI(new ScannerParametersMessage(xml));
            ibClient.ScannerParameters += UpdateUi;
            ibClient.ScannerData += scannerManager.UpdateUI;

            ibClient.ScannerDataEnd += reqId => addTextToBox("ScannerDataEnd. " + reqId + "\r\n");
            ibClient.ReceiveFA += advisorManager.UpdateUI;
            ibClient.ReplaceFAEnd += (reqId, text) => addTextToBox("Replace FA End. ReqId: " + reqId + ", Text: " + text + "\r\n");
            ibClient.BondContractDetails += contractManager.HandleBondContractMessage;
            ibClient.VerifyMessageAPI += apiData => addTextToBox("verifyMessageAPI: " + apiData);
            ibClient.VerifyCompleted += (isSuccessful, errorText) => addTextToBox("verifyCompleted. IsSuccessfule: " + isSuccessful + " - Error: " + errorText);
            ibClient.VerifyAndAuthMessageAPI += (apiData, xyzChallenge) => addTextToBox("verifyAndAuthMessageAPI: " + apiData + " " + xyzChallenge);
            ibClient.VerifyAndAuthCompleted += (isSuccessful, errorText) => addTextToBox("verifyAndAuthCompleted. IsSuccessfule: " + isSuccessful + " - Error: " + errorText);
            ibClient.DisplayGroupList += (reqId, groups) => addTextToBox("DisplayGroupList. Request: " + reqId + ", Groups" + groups);
            ibClient.DisplayGroupUpdated += (reqId, contractInfo) => addTextToBox("displayGroupUpdated. Request: " + reqId + ", ContractInfo: " + contractInfo);

            ibClient.PositionMulti += acctPosMultiManager.HandlePositionMulti;
            ibClient.PositionMultiEnd += reqId => acctPosMultiManager.HandlePositionMultiEnd(new PositionMultiEndMessage(reqId));
            ibClient.AccountUpdateMulti += acctPosMultiManager.HandleAccountUpdateMulti;
            ibClient.AccountUpdateMultiEnd += reqId => acctPosMultiManager.HandleAccountUpdateMultiEnd(new AccountUpdateMultiEndMessage(reqId));
            ibClient.SecurityDefinitionOptionParameter += optionsManager.UpdateUI;
            //ibClient.SecurityDefinitionOptionParameterEnd += (do nothing)
            ibClient.SoftDollarTiers += orderManager.HandleSoftDollarTiers;
            ibClient.FamilyCodes += familyCodes => accountManager.HandleFamilyCodes(new FamilyCodesMessage(familyCodes));
            ibClient.SymbolSamples += UpdateUI;
            ibClient.MktDepthExchanges += depthMktDataDescriptions => deepBookManager.HandleMktDepthExchangesMessage(new MktDepthExchangesMessage(depthMktDataDescriptions));
            ibClient.TickNews += newsManager.UpdateUI;
            ibClient.TickReqParams += UpdateUI;
            ibClient.SmartComponents += (reqId, theMap) => theMap.ToList().ForEach(i => dataGridViewSmartComponents.Rows.Add(new object[] { i.Key, i.Value.Key, i.Value.Value }));
            ibClient.NewsProviders += newsProviders => newsManager.HandleNewsProviders(new NewsProvidersMessage(newsProviders));
            ibClient.NewsArticle += newsManager.UpdateUI;
            ibClient.HistoricalNews += newsManager.UpdateUI;
            ibClient.HistoricalNewsEnd += newsManager.UpdateUI;
            ibClient.HeadTimestamp += UpdateUI;
            ibClient.HistogramData += UpdateUI;
            ibClient.RerouteMktDataReq += (reqId, conId, exchange) => addTextToBox("Re-route market data request. ReqId: " + reqId + ", ConId: " + conId + ", Exchange: " + exchange + "\n");
            ibClient.RerouteMktDepthReq += (reqId, conId, exchange) => addTextToBox("Re-route market depth request. ReqId: " + reqId + ", ConId: " + conId + ", Exchange: " + exchange + "\n");
            ibClient.MarketRule += contractManager.HandleMarketRuleMessage;
            ibClient.pnl += msg => pnldataTable.Rows.Add(msg.DailyPnL, msg.UnrealizedPnL, msg.RealizedPnL);
            ibClient.pnlSingle += msg => pnlSingledataTable.Rows.Add(msg.Pos, msg.DailyPnL, msg.UnrealizedPnL, msg.RealizedPnL, msg.Value);
            ibClient.historicalTick += UpdateUI;
            ibClient.historicalTickBidAsk += UpdateUI;
            ibClient.historicalTickLast += UpdateUI;
            ibClient.tickByTickAllLast += UpdateUI;
            ibClient.tickByTickBidAsk += UpdateUI;
            ibClient.tickByTickMidPoint += UpdateUI;
            ibClient.OrderBound += msg => addTextToBox("Order bound. OrderId: " + msg.OrderId + ", ApiClientId: " + msg.ApiClientId + ", ApiOrderId: " + msg.ApiOrderId);
            ibClient.CompletedOrder += orderManager.handleCompletedOrder;
            //ibClient.CompletedOrderEnd += (do nothing)
        }

        private void UpdateUi(string xml)
        {
            XmlDocument doc = new XmlDocument();

            doc.LoadXml(xml);

            var filters = doc.SelectNodes("//AbstractField/code").OfType<XmlNode>().ToList().Select(n => n.InnerText).ToArray();

            comboBoxFilterName.Items.AddRange(filters);
        }

        private void UpdateUI(TickByTickMidPointMessage msg)
        {
            dataGridViewTickByTick.DataSource = tickByTickMidPointTable;
            tickByTickMidPointTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.MidPoint);
        }

        private void UpdateUI(TickByTickBidAskMessage msg)
        {
            dataGridViewTickByTick.DataSource = tickByTickBidAskTable;
            tickByTickBidAskTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.BidPrice, msg.AskPrice, msg.BidSize, msg.AskSize, msg.TickAttribBidAsk.BidPastLow, msg.TickAttribBidAsk.AskPastHigh);
        }

        private void UpdateUI(TickByTickAllLastMessage msg)
        {
            if (msg.TickType == 1)
            {
                dataGridViewTickByTick.DataSource = tickByTickLastTable;
                tickByTickLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast.PastLimit);
            }
            else if (msg.TickType == 2)
            {
                dataGridViewTickByTick.DataSource = tickByTickAllLastTable;
                tickByTickAllLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast.PastLimit, msg.TickAttribLast.Unreported);
            }
        }

        private void UpdateUI(HistoricalTickLastMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickLastTable;

            historicalTickLastTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size, msg.Exchange, msg.SpecialConditions, msg.TickAttribLast);
        }

        private void UpdateUI(HistoricalTickBidAskMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickBidAskTable;

            historicalTickBidAskTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.PriceBid, msg.PriceAsk, msg.SizeBid, msg.SizeAsk, msg.TickAttribBidAsk);
        }

        private void UpdateUI(HistoricalTickMessage msg)
        {
            dataGridViewHistoricalTicks.DataSource = historicalTickTable;

            historicalTickTable.Rows.Add(Util.UnixSecondsToString(msg.Time, "yyyyMMdd-HH:mm:ss zzz"), msg.Price, msg.Size);
        }

        private void UpdateUI(HistogramDataMessage obj)
        {
            if (histogramSubscriptionList.Contains(obj.ReqId))
                obj.Data.ToList().ForEach(i => histogramDataGridView.Rows.Add(new object[] { obj.ReqId, i.Price, i.Size }));
        }

        void ibClient_Tick(TickSizeMessage msg)
        {
            addTextToBox("Tick Size. Ticker Id:" + msg.RequestId + ", Type: " + TickType.getField(msg.Field) + ", Size: " + msg.Size + "\n");

            if (msg.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                if (marketDataManager.IsUIUpdateRequired(msg))
                    marketDataManager.UpdateUI(msg);
            }
            else
            {
                HandleTickMessage(msg);
            }
        }

        void ibClient_Tick(TickPriceMessage msg)
        {
            addTextToBox("Tick Price. Ticker Id:" + msg.RequestId + ", Type: " + TickType.getField(msg.Field) + ", Price: " + msg.Price + ", Pre-Open: " + msg.Attribs.PreOpen + "\n");

            if (msg.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                if (marketDataManager.IsUIUpdateRequired(msg))
                    marketDataManager.UpdateUI(msg);
            }
            else
            {
                HandleTickMessage(msg);
            }
        }

        void ibClient_ConnectionClosed()
        {
            IsConnected = false;
            UpdateUI(new ConnectionStatusMessage(false));
        }

        void ibClient_Error(int id, int errorCode, string str, Exception ex)
        {
            if (ex != null)
            {
                addTextToBox("Error: " + ex);

                return;
            }

            if (id == 0 || errorCode == 0)
            {
                addTextToBox("Error: " + str + "\n");

                return;
            }

            ErrorMessage error = new ErrorMessage(id, errorCode, str);

            HandleErrorMessage(error);
        }


        private void addTextToBox(string text)
        {
            HandleErrorMessage(new ErrorMessage(-1, -1, text));
        }


        public bool IsConnected { get; set; }

        private void UpdateUI(ConnectionStatusMessage statusMessage)
        {
            IsConnected = statusMessage.IsConnected;

            if (statusMessage.IsConnected)
            {
                status_CT.Text = "Connected! Your client Id: " + ibClient.ClientId;
                connectButton.Text = "Disconnect";
            }
            else
            {
                status_CT.Text = "Disconnected...";
                connectButton.Text = "Connect";
            }
        }

        private void UpdateUI(ManagedAccountsMessage message)
        {
            orderManager.ManagedAccounts = message.ManagedAccounts;
            accountManager.ManagedAccounts = message.ManagedAccounts;
            exerciseAccount.Items.AddRange(message.ManagedAccounts.ToArray());
        }

        private void UpdateUI(AccountSummaryEndMessage message)
        {
            accSummaryRequest.Text = "Request";

            accountManager.HandleAccountSummaryEnd();
        }

        private void UpdateUI(UpdatePortfolioMessage message)
        {
            accountManager.HandlePortfolioValue(message);

            if (exerciseAccount.SelectedItem != null)
                optionsManager.HandlePosition(message);
        }

        private void UpdateUI(FundamentalsMessage message)
        {
            fundamentalsQueryButton.Enabled = true;

            contractManager.HandleFundamentalsData(message);
        }

        private void UpdateUI(ContractDetailsEndMessage message)
        {
            searchContractDetails.Enabled = true;

            contractManager.HandleContractDataEndMessage(message);
        }

        private void UpdateUI(MarketDataTypeMessage message)
        {
            if (marketDataManager.isActive())
            {
                marketDataManager.HandleMarketDataTypeMessage(message);
            }
        }

        private void UpdateUI(TickReqParamsMessage message)
        {
            bboExchange_comboBox.BindingContext[bboExchangeList].SuspendBinding();
            bboExchangeList.Add(message.BboExchange);
            bboExchange_comboBox.BindingContext[bboExchangeList].ResumeBinding();

            ReqSmartComponents_Button.Enabled = bboExchange_comboBox.Items.Count > 0;
        }

        private void UpdateUI(SymbolSamplesMessage message)
        {
            if (symbolSamplesManagerData.isActive())
            {
                symbolSamplesManagerData.UpdateUI(message);
            }
            if (symbolSamplesManagerContractInfo.isActive())
            {
                symbolSamplesManagerContractInfo.UpdateUI(message);
            }
        }

        private void HandleTickMessage(MarketDataMessage tickMessage)
        {
            if (!queryOptionChain.Enabled)
            {
                queryOptionChain.Enabled = true;
            }

            optionsManager.UpdateUI(tickMessage);
        }

        private void HandleContractDataMessage(ContractDetailsMessage message)
        {
            if (message.RequestId > ContractManager.CONTRACT_ID_BASE && message.RequestId < OptionsManager.OPTIONS_ID_BASE)
            {
                contractManager.UpdateUI(message);
            }
            else if (message.RequestId >= OptionsManager.OPTIONS_ID_BASE)
            {
                optionsManager.UpdateUI(message);
            }
        }

        private void HandleErrorMessage(ErrorMessage message)
        {
            ShowMessageOnPanel("Request " + message.RequestId + ", Code: " + message.ErrorCode + " - " + message.Message);

            if (message.RequestId > MarketDataManager.TICK_ID_BASE && message.RequestId < DeepBookManager.TICK_ID_BASE)
                marketDataManager.NotifyError(message.RequestId);
            else if (message.RequestId > DeepBookManager.TICK_ID_BASE && message.RequestId < HistoricalDataManager.HISTORICAL_ID_BASE)
            {
                if (message.ErrorCode != 2151)
                {
                    deepBookManager.NotifyError(message.RequestId);
                }
            }
            else if (message.RequestId == ContractManager.CONTRACT_DETAILS_ID)
            {
                contractManager.HandleRequestError(message.RequestId);
                searchContractDetails.Enabled = true;
            }
            else if (message.RequestId == ContractManager.FUNDAMENTALS_ID)
            {
                contractManager.HandleRequestError(message.RequestId);
                fundamentalsQueryButton.Enabled = true;
            }
            else if (message.RequestId == OptionsManager.OPTIONS_ID_BASE)
            {
                optionsManager.Clear();
                queryOptionChain.Enabled = true;
            }
            else if (message.RequestId > OptionsManager.OPTIONS_ID_BASE)
            {
                queryOptionChain.Enabled = true;
            }
            if (message.ErrorCode == 202)
            {
            }
        }

        private void connectButton_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
            {
                int port;
                string host = host_CT.Text;

                if (host == null || host.Equals(""))
                    host = "127.0.0.1";
                try
                {
                    port = int.Parse(port_CT.Text);
                    ibClient.ClientId = int.Parse(clientid_CT.Text);
                    ibClient.ClientSocket.eConnect(host, port, ibClient.ClientId);

                    var reader = new EReader(ibClient.ClientSocket, signal);

                    reader.Start();

                    new Thread(() => { while (ibClient.ClientSocket.IsConnected()) { signal.waitForSignal(); reader.processMsgs(); } }) { IsBackground = true }.Start();
                }
                catch (Exception)
                {
                    HandleErrorMessage(new ErrorMessage(-1, -1, "Please check your connection attributes."));
                }
            }
            else
            {
                IsConnected = false;
                ibClient.ClientSocket.eDisconnect();
            }
        }

        private void marketData_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                string genericTickList = this.genericTickList.Text;
                if (genericTickList == null)
                    genericTickList = "";
                marketDataManager.AddRequest(contract, genericTickList);
                ShowTab(marketData_MDT, topMarketDataTab_MDT);
            }
        }

        private void closeMketDataTab_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            marketDataManager.StopActiveRequests(true);
            marketData_MDT.TabPages.Remove(topMarketDataTab_MDT);
        }

        private void deepBook_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                deepBookManager.AddRequest(contract, int.Parse(deepBookEntries.Text), cbSmartDepth.Checked);
                deepBookTab_MDT.Text = Utils.ContractToString(contract) + " (Book)";
                ShowTab(marketData_MDT, deepBookTab_MDT);
            }
        }

        private void closeDeepBookLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            deepBookManager.StopActiveRequests();
            deepBookTab_MDT.Text = "";
            marketData_MDT.TabPages.Remove(deepBookTab_MDT);
        }

        private void histDataButton_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                string endTime = hdRequest_EndTime.Text.Trim();
                string duration = hdRequest_Duration.Text.Trim() + " " + hdRequest_TimeUnit.Text.Trim();
                string barSize = hdRequest_BarSize.Text.Trim();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                int outsideRTH = contractMDRTH.Checked ? 1 : 0;
                historicalDataManager.AddRequest(contract, endTime, duration, barSize, whatToShow, outsideRTH, 1, cbKeepUpToDate.Checked);
                historicalDataTab.Text = Utils.ContractToString(contract) + " (HD)";
                ShowTab(marketData_MDT, historicalDataTab);
            }
        }

        private void histDataTabClose_MDT_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            marketData_MDT.TabPages.Remove(historicalDataTab);
        }

        private void realTime_Button_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                realTimeBarManager.AddRequest(contract, whatToShow, true);
                rtBarsTab_MDT.Text = Utils.ContractToString(contract) + " (RTB)";
                ShowTab(marketData_MDT, rtBarsTab_MDT);
            }
        }

        private void rtBarsCloseLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            realTimeBarManager.Clear();
            marketData_MDT.TabPages.Remove(rtBarsTab_MDT);
        }

        private void scannerRequest_Button_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                ScannerSubscription subscription = new ScannerSubscription();
                subscription.ScanCode = scanCode.Text;
                subscription.Instrument = scanInstrument.Text;
                subscription.LocationCode = scanLocation.Text;
                subscription.StockTypeFilter = scanStockType.Text;
                subscription.NumberOfRows = int.Parse(scanNumRows.Text);
                scannerManager.AddRequest(subscription, listViewFilterOptions.Items.OfType<ListViewItem>().Select(i => new TagValue(i.Text, i.SubItems[1].Text)).ToList());
                ShowTab(marketData_MDT, scannerTab);
            }
        }

        private void scannerParamsRequest_button_Click(object sender, EventArgs e)
        {
            scannerManager.RequestParameters();
            ShowTab(marketData_MDT, scannerParamsTab);
        }

        private void scannerTab_link_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            scannerManager.Clear();
            marketData_MDT.TabPages.Remove(scannerTab);
        }

        private double stringToDouble(string number)
        {
            if (number != null && !number.Equals(""))
                return double.Parse(number);
            else
                return 0;
        }

        private Contract GetMDContract()
        {
            Contract contract = new Contract();
            contract.SecType = secType_TMD_MDT.Text;
            contract.Symbol = symbol_TMD_MDT.Text;
            contract.Exchange = exchange_TMD_MDT.Text;
            contract.Currency = currency_TMD_MDT.Text;
            contract.LastTradeDateOrContractMonth = lastTradeDateOrContractMonth_TMD_MDT.Text;
            contract.PrimaryExch = primaryExchange.Text;
            contract.IncludeExpired = includeExpired.Checked;

            if (!mdContractRight.Text.Equals("") && !mdContractRight.Text.Equals("None"))
                contract.Right = (string)((IBType)mdContractRight.SelectedItem).Value;

            contract.Strike = stringToDouble(strike_TMD_MDT.Text);
            contract.Multiplier = multiplier_TMD_MDT.Text;
            contract.LocalSymbol = localSymbol_TMD_MDT.Text;

            return contract;
        }

        private void messageBoxClear_link_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            numberOfLinesInMessageBox = 0;
            linesInMessageBox.Clear();
            messageBox.Clear();
        }

        private void ShowTab(TabControl tabControl, TabPage page)
        {
            if (!tabControl.Contains(page))
            {
                tabControl.TabPages.Add(page);
            }
            tabControl.SelectedTab = page;
        }

        private void newOrderLink_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            orderManager.OpenNewOrderDialog();
        }

        private void refreshOrdersButton_Click(object sender, EventArgs e)
        {
            liveOrdersGrid.Rows.Clear();
            ibClient.ClientSocket.reqAllOpenOrders();
        }

        private void refreshExecutionsButton_Click(object sender, EventArgs e)
        {
            tradeLogGrid.Rows.Clear();

            ExecutionFilter execFilter = new ExecutionFilter();
            if (!execFilterClientId.Text.Equals(string.Empty))
                execFilter.ClientId = int.Parse(execFilterClientId.Text);
            execFilter.AcctCode = execFilterAccount.Text;
            execFilter.Time = execFilterTime.Text;
            execFilter.Symbol = execFilterSymbol.Text;
            execFilter.SecType = execFilterSecType.Text;
            execFilter.Exchange = execFilterExchange.Text;
            execFilter.Side = execFilterSide.Text;

            ibClient.ClientSocket.reqExecutions(1, execFilter);
        }

        private void bindOrdersButton_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.reqAutoOpenOrders(true);
        }

        private void liveOrdersGrid_CellCoubleClick(object sender, DataGridViewCellEventArgs e)
        {
            orderManager.EditOrder();
        }

        private void cancelOrdersButton_Click(object sender, EventArgs e)
        {
            orderManager.CancelSelection();
            liveOrdersGrid.Rows.Clear();
            ibClient.ClientSocket.reqAllOpenOrders();
        }

        private void clientOrdersButton_Click(object sender, EventArgs e)
        {
            liveOrdersGrid.Rows.Clear();
            ibClient.ClientSocket.reqOpenOrders();
        }

        private void globalCancelButton_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.reqGlobalCancel();
        }

        private void accSummaryRequest_Click(object sender, EventArgs e)
        {
            accSummaryRequest.Text = "Cancel";
            accountManager.RequestAccountSummary();
        }

        private void accUpdatesSubscribe_Click(object sender, EventArgs e)
        {
            if (accUpdatesSubscribe.Text.Equals("Subscribe") && accountSelector.SelectedItem != null)
            {
                accUpdatesSubscribedAccount.Text = accountSelector.SelectedItem.ToString();
                accUpdatesSubscribe.Text = "Unsubscribe";
            }
            else
            {
                accUpdatesSubscribe.Text = "Subscribe";
            }
            accountManager.SubscribeAccountUpdates();
        }

        private void positionRequest_Click(object sender, EventArgs e)
        {
            accountManager.RequestPositions();
        }

        private void searchContractDetails_Click(object sender, EventArgs e)
        {
            Contract contract = GetConDetContract();
            if (contract.SecType.Equals("BOND"))
            {
                ShowTab(contractInfoTab, bondContractDetailsPage);
            }
            else
            {
                ShowTab(contractInfoTab, contractDetailsPage);
            }
            searchContractDetails.Enabled = false;
            contractManager.RequestContractDetails(contract);
        }

        private Contract GetConDetContract()
        {
            Contract contract = new Contract();
            contract.Symbol = conDetSymbol.Text;
            contract.SecType = conDetSecType.Text;
            contract.Exchange = conDetExchange.Text;
            contract.Currency = conDetCurrency.Text;
            contract.LastTradeDateOrContractMonth = conDetLastTradeDateOrContractMonth.Text;
            contract.Strike = stringToDouble(conDetStrike.Text);
            contract.Multiplier = conDetMultiplier.Text;
            contract.LocalSymbol = conDetLocalSymbol.Text;

            if (!conDetRight.Text.Equals("") && !conDetRight.Text.Equals("None"))
                contract.Right = (string)((IBType)conDetRight.SelectedItem).Value;

            return contract;
        }

        private void fundamentalsQueryButton_Click(object sender, EventArgs e)
        {
            ShowTab(contractInfoTab, fundamentalsPage);
            fundamentalsQueryButton.Enabled = false;
            Contract contract = GetConDetContract();
            contractManager.RequestFundamentals(contract, (string)((IBType)fundamentalsReportType.SelectedItem).Value);
        }

        private void loadAliases_Click(object sender, EventArgs e)
        {
            advisorAliasesGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Aliases);
        }

        private void loadGroups_Click(object sender, EventArgs e)
        {
            advisorGroupsGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Groups);
        }

        private void loadProfiles_Click(object sender, EventArgs e)
        {
            advisorProfilesGrid.Rows.Clear();
            advisorManager.RequestFAData(FinancialAdvisorDataType.Profiles);
        }

        private void saveProfiles_Click(object sender, EventArgs e)
        {
            advisorManager.SaveProfiles();
        }

        private void saveGroups_Click(object sender, EventArgs e)
        {
            advisorManager.SaveGroups();
        }

        private void findComboContract_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            contractManager.IsComboLegRequest = true;
            contractManager.RequestContractDetails(GetComboContract());
        }

        private Contract GetComboContract()
        {
            Contract contract = new Contract();
            contract.Symbol = comboSymbol.Text;
            contract.SecType = comboSecType.Text;
            contract.Exchange = comboExchange.Text;
            contract.Currency = comboCurrency.Text;
            contract.LastTradeDateOrContractMonth = comboLastTradeDate.Text;
            contract.Strike = stringToDouble(comboStrike.Text);
            contract.Multiplier = comboMultiplier.Text;
            contract.LocalSymbol = comboLocalSymbol.Text;

            if (!comboRight.Text.Equals("") && !comboRight.Text.Equals("None"))
                contract.Right = (string)((IBType)comboRight.SelectedItem).Value;

            return contract;
        }

        private void queryOptionChain_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                queryOptionChain.Enabled = false;
                Contract underlying = GetConDetContract();
                underlying.SecType = "OPT";
                optionsManager.AddOptionChainRequest(underlying, optionChainExchange.Text, optionChainUseSnapshot.Checked);
                ShowTab(contractInfoTab, optionChainPage);

            }
        }

        private void exerciseAccount_SelectedIndexChanged(object sender, EventArgs e)
        {
            accountSelector.SelectedItem = exerciseAccount.SelectedItem;
            accountManager.SubscribeAccountUpdates();
        }

        private void ShowMessageOnPanel(string message)
        {
            message = ensureMessageHasNewline(message);

            if (numberOfLinesInMessageBox >= MAX_LINES_IN_MESSAGE_BOX)
            {
                linesInMessageBox.RemoveRange(0, MAX_LINES_IN_MESSAGE_BOX - REDUCED_LINES_IN_MESSAGE_BOX);
                messageBox.Lines = linesInMessageBox.ToArray();
                numberOfLinesInMessageBox = REDUCED_LINES_IN_MESSAGE_BOX;
            }

            linesInMessageBox.Add(message);
            numberOfLinesInMessageBox += 1;
            messageBox.AppendText(message);
        }

        private string ensureMessageHasNewline(string message)
        {
            if (message.Substring(message.Length - 1) != "\n")
            {
                return message + "\n";
            }
            else
            {
                return message;
            }
        }

        private void cancelMarketDataRequests_Click(object sender, EventArgs e)
        {
            marketDataManager.StopActiveRequests(false);
        }

        private void exerciseOption_Click(object sender, EventArgs e)
        {
            int ovrd = overrideOption.Checked == true ? 1 : 0;
            string exchange = optionExchange.Text;
            optionsManager.ExerciseOptions(ovrd, int.Parse(optionExerciseQuan.Text), exchange, 1);
        }

        private void lapseOption_Click(object sender, EventArgs e)
        {
            int ovrd = overrideOption.Checked == true ? 1 : 0;
            string exchange = optionExchange.Text;
            optionsManager.ExerciseOptions(ovrd, int.Parse(optionExerciseQuan.Text), exchange, 2);
        }

        private void optionsTab_Click(object sender, EventArgs e)
        {

        }

        private void buttonRequestPositionsMulti_Click(object sender, EventArgs e)
        {
            string account = textAccount.Text;
            string modelCode = textModelCode.Text;
            acctPosMultiManager.RequestPositionsMulti(account, modelCode);
        }

        private void buttonRequestAccountUpdatesMulti_Click(object sender, EventArgs e)
        {
            string account = textAccount.Text;
            string modelCode = textModelCode.Text;
            bool ledgerAndNLV = cbLedgerAndNLV.Checked;
            acctPosMultiManager.RequestAccountUpdatesMulti(account, modelCode, ledgerAndNLV);
        }

        private void buttonCancelPositionsMulti_Click(object sender, EventArgs e)
        {
            acctPosMultiManager.CancelPositionsMulti();
        }

        private void buttonCancelAccountUpdatesMulti_Click(object sender, EventArgs e)
        {
            acctPosMultiManager.CancelAccountUpdatesMulti();
        }

        private void clearPositionsMulti_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            acctPosMultiManager.ClearPositionsMulti();
        }

        private void clearAccountUpdatesMulti_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            acctPosMultiManager.ClearAccountUpdatesMulti();
        }

        private void queryOptionParams_Click(object sender, EventArgs e)
        {
            string symbol = conDetSymbol.Text;
            string exchange = conDetExchange.Text;
            string secType = conDetSecType.SelectedItem + "";
            int conId = string.IsNullOrWhiteSpace(underlyingConId.Text) ? int.MaxValue : int.Parse(underlyingConId.Text);

            optionsManager.SecurityDefinitionOptionParametersRequest(symbol, exchange, secType, conId);
            ShowTab(contractInfoTab, optionParametersPage);
        }

        private void requestFamilyCodes_Click(object sender, EventArgs e)
        {
            accountManager.RequestFamilyCodes();
        }

        private void clearFamilyCodes_Click(object sender, EventArgs e)
        {
            accountManager.ClearFamilyCodes();
        }

        private void requestMatchingSymbolsContractInfo_Click(object sender, EventArgs e)
        {
            symbolSamplesManagerData.unsetActive();
            symbolSamplesManagerContractInfo.setActive();
            symbolSamplesManagerData.Clear();
            symbolSamplesManagerContractInfo.AddRequest(conDetSymbol.Text);
            ShowTab(contractInfoTab, symbolSamplesTabContractInfo);
        }

        private void requestMatchingSymbolsData_Click(object sender, EventArgs e)
        {
            symbolSamplesManagerContractInfo.unsetActive();
            symbolSamplesManagerData.setActive();
            symbolSamplesManagerContractInfo.Clear();
            symbolSamplesManagerData.AddRequest(symbol_TMD_MDT.Text);
            ShowTab(marketData_MDT, symbolSamplesTabData);
        }

        private void clearSymbolSamplesContractInfo_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            symbolSamplesManagerContractInfo.Clear();
        }

        private void clearSymbolSamplesMarketData_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            symbolSamplesManagerData.Clear();
        }

        private void ReqMktDepthExchanges_Button_Click(object sender, EventArgs e)
        {
            deepBookManager.ReqMktDepthExchanges();
            ShowTab(marketData_MDT, mktDepthExchanges_MDT);
        }

        private void ClearMktDepthExchanges_Button_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            deepBookManager.ClearMktDepthExchanges();
        }

        private void comboBoxMarketDataType_CDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            marketDataManager.unsetActive();
            int marketDataType = (int)((IBType)comboBoxMarketDataType_CDT.SelectedItem).Value;
            marketDataManager.RequestMarketDataType(marketDataType);
            showMarketDataTypeSelectMessage(marketDataType);
        }

        private void comboBoxMarketDataType_MDT_SelectedIndexChanged(object sender, EventArgs e)
        {
            marketDataManager.setActive();
            int marketDataType = (int)((IBType)comboBoxMarketDataType_MDT.SelectedItem).Value;
            marketDataManager.RequestMarketDataType(marketDataType);
            showMarketDataTypeSelectMessage(marketDataType);
        }

        private void showMarketDataTypeSelectMessage(int marketDataType)
        {
            if (IsConnected)
            {
                if (marketDataType == (int)MarketDataType.Real_Time.Value)
                {
                    ShowMessageOnPanel("Frozen, Delayed and Delayed-Frozen market data types are disabled");
                }
                else if (marketDataType == (int)MarketDataType.Frozen.Value)
                {
                    ShowMessageOnPanel("Frozen market data type is enabled");
                }
                else if (marketDataType == (int)MarketDataType.Delayed.Value)
                {
                    ShowMessageOnPanel("Delayed market data type is enabled, Delayed-Frozen market data type is disabled");
                }
                else if (marketDataType == (int)MarketDataType.Delayed_Frozen.Value)
                {
                    ShowMessageOnPanel("Delayed and Delayed-Frozen market data types are enabled");
                }
                else
                {
                    ShowMessageOnPanel("Unknown market data type");
                }
            }
        }

        private void buttonReqNewsTicks_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = new Contract();
                contract.Symbol = textBoxNewsTicksSymbol.Text;
                contract.SecType = comboBoxNewsTicksSecType.Text;
                contract.Currency = textBoxNewsTicksCurrency.Text;
                contract.Exchange = textBoxNewsTicksExchange.Text;
                contract.PrimaryExch = textBoxNewsTicksPrimExchange.Text;

                newsManager.RequestNewsTicks(contract);

                ShowTab(tabControlNewsResults, tabPageTickNewsResults);
            }
        }

        private void linkLabelNewsTicksClear_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearTickNews();
        }

        private void buttonCancelNewsTicks_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                newsManager.CancelTickNews();
            }
        }

        private void dataGridViewNewsTicks_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridView dataGridView = (DataGridView)sender;
            if (e.RowIndex > -1)
            {
                DataGridViewRow dataGridViewRow = dataGridView.Rows[e.RowIndex];
                if (dataGridViewRow.Cells[dataGridViewNewsTicksProviderCode.Index].Value != null && dataGridViewRow.Cells[dataGridViewNewsTicksArticleId.Index].Value != null)
                {
                    textBoxNewsArticleProviderCode.Text = (string)dataGridViewRow.Cells[dataGridViewNewsTicksProviderCode.Index].Value;
                    textBoxNewsArticleArticleId.Text = (string)dataGridViewRow.Cells[dataGridViewNewsTicksArticleId.Index].Value;
                    ShowTab(tabControlNews, tabPageNewsArticle);
                }
            }
        }

        private void ReqSmartComponents_Button_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                ibClient.ClientSocket.reqSmartComponents(new Random(DateTime.Now.Millisecond).Next(), bboExchange_comboBox.SelectedItem + "");
                ShowTab(marketData_MDT, smartComponentsTabPage);
            }
        }

        private void linkLabel1_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            dataGridViewSmartComponents.Rows.Clear();
        }

        private void buttonReqNewsProviders_Click(object sender, EventArgs e)
        {
            ShowTab(tabControlNewsResults, tabPageNewsProvidersResults);
            newsManager.RequestNewsProviders();
        }

        private void linkLabelClearNewsProviders_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearNewsProviders();
        }

        private void buttonRequestNewsArticle_Click(object sender, EventArgs e)
        {
            ShowTab(tabControlNewsResults, tabPageNewsArticleResults);
            newsManager.RequestNewsArticle(textBoxNewsArticleProviderCode.Text, textBoxNewsArticleArticleId.Text, textBoxNewsArticlePath.Text);
        }

        private void linkLabelClearNewsArticle_LinkClicked_1(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearArticleText();
        }


        private void buttonRequestHistoricalNews_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                int conId = string.IsNullOrWhiteSpace(textBoxHistoricalNewsContractId.Text) ? int.MaxValue : int.Parse(textBoxHistoricalNewsContractId.Text);
                string providerCodes = textBoxHistoricalNewsProviderCodes.Text;
                string startDateTime = textBoxHistoricalNewsStartDateTime.Text;
                string endDateTime = textBoxHistoricalNewsEndDateTime.Text;
                int totalResults = string.IsNullOrWhiteSpace(textBoxHistoricalNewsTotalResults.Text) ? 1 : int.Parse(textBoxHistoricalNewsTotalResults.Text);

                newsManager.RequestHistoricalNews(conId, providerCodes, startDateTime, endDateTime, totalResults);

                ShowTab(tabControlNewsResults, tabPageHistoricalNewsResults);
            }
        }

        private void linkLabelClearHistoricalNews_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            newsManager.ClearHistoricalNews();

        }

        private void dataGridViewHistoricalNews_CellClick(object sender, DataGridViewCellEventArgs e)
        {
            DataGridView dataGridView = (DataGridView)sender;
            if (e.RowIndex > -1)
            {
                DataGridViewRow dataGridViewRow = dataGridView.Rows[e.RowIndex];

                if (dataGridViewRow.Cells[dataGridViewTextBoxProviderCode.Index].Value != null && dataGridViewRow.Cells[dataGridViewTextBoxArticleId.Index].Value != null)
                {
                    textBoxNewsArticleProviderCode.Text = (string)dataGridViewRow.Cells[dataGridViewTextBoxProviderCode.Index].Value;
                    textBoxNewsArticleArticleId.Text = (string)dataGridViewRow.Cells[dataGridViewTextBoxArticleId.Index].Value;
                    ShowTab(tabControlNews, tabPageNewsArticle);
                }
            }
        }

        private void headTimestamp_button_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                var reqId = new Random(DateTime.Now.Millisecond).Next();

                ibClient.ClientSocket.reqHeadTimestamp(reqId, contract, whatToShow, 1, 1);
                ShowTab(marketData_MDT, headTimestampTabPage);

                var iRow = headTimestampDataGridView.Rows.Add();

                headTimestampDataGridView[0, iRow].Value = reqId;
                headTimestampDataGridView[2, iRow].Value = contract.ConId;
                headTimestampDataGridView[3, iRow].Value = contract.Symbol;
                headTimestampDataGridView[4, iRow].Value = contract.SecType;
                headTimestampDataGridView[5, iRow].Value = contract.LastTradeDateOrContractMonth;
                headTimestampDataGridView[6, iRow].Value = contract.Strike;
                headTimestampDataGridView[7, iRow].Value = contract.Right;
                headTimestampDataGridView[8, iRow].Value = contract.Multiplier;
                headTimestampDataGridView[9, iRow].Value = contract.Exchange;
                headTimestampDataGridView[10, iRow].Value = contract.PrimaryExch;
                headTimestampDataGridView[11, iRow].Value = contract.Currency;
                headTimestampDataGridView[12, iRow].Value = contract.LocalSymbol;
                headTimestampDataGridView[13, iRow].Value = contract.TradingClass;
                headTimestampDataGridView[14, iRow].Value = contract.IncludeExpired;
                headTimestampDataGridView[15, iRow].Value = whatToShow;
            }
        }

        private void clearHeadTimestampGridViewlinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            headTimestampDataGridView.Rows.Clear();
        }

        private void UpdateUI(HeadTimestampMessage obj)
        {
            var row = headTimestampDataGridView.Rows.OfType<DataGridViewRow>().FirstOrDefault(r => ((int)r.Cells[0].Value) == obj.ReqId);

            if (row != null)
                row.Cells[1].Value = obj.HeadTimestamp;
        }

        private void histogram_button_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                Contract contract = GetMDContract();
                string whatToShow = hdRequest_WhatToShow.Text.Trim();
                string duration = hdRequest_Duration.Text.Trim() + " " + hdRequest_TimeUnit.Text.Trim();
                var reqId = new Random(DateTime.Now.Millisecond).Next();

                histogramSubscriptionList.Add(reqId);
                ibClient.ClientSocket.reqHistogramData(reqId, contract, true, duration);
                ShowTab(marketData_MDT, histogramTabPage);
            }
        }

        private HashSet<int> histogramSubscriptionList = new HashSet<int>();

        private void histogramClearLinkLabel_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            if (histogramDataGridView.Rows.Count == 0)
                return;

            var reqId = (int)histogramDataGridView.Rows[0].Cells[0].Value;

            histogramSubscriptionList.Remove(reqId);
            ibClient.ClientSocket.cancelHistogramData(reqId);
            histogramDataGridView.Rows.Clear();
        }

        private void buttonReqMarketRule_Click(object sender, EventArgs e)
        {
            if (IsConnected)
            {
                int marketRuleId = 0;
                int.TryParse(comboBoxMarketRuleId.Text, out marketRuleId);
                ibClient.ClientSocket.reqMarketRule(marketRuleId);
                ShowTab(contractInfoTab, marketRulePage);
            }
        }

        PnLManager pnlMgr;

        private void btnReqPnL_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            ShowTab(tabControl1, pnlTab);
            pnlMgr.CancelPnLSingle();
            pnldataTable.Clear();

            dataGridViewPnL.DataSource = pnldataTable;

            pnlMgr.ReqPnL(accountSelector.SelectedItem + "", tbModelCode.Text);
        }

        private void btnReqPnLSingle_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            ShowTab(tabControl1, pnlTab);
            pnlMgr.CancelPnL();
            pnlSingledataTable.Clear();

            dataGridViewPnL.DataSource = pnlSingledataTable;

            var conId = 0;

            if (int.TryParse(tbConId.Text, out conId))
            {
                pnlMgr.ReqPnLSingle(accountSelector.SelectedItem + "", tbModelCode.Text, conId);
            }
        }

        private void btnCancelPnL_Click(object sender, EventArgs e)
        {
            pnlMgr.CancelPnL();
        }

        private void btnCancelPnLSingle_Click(object sender, EventArgs e)
        {
            pnlMgr.CancelPnLSingle();
        }

        private void MDT_Selected(object sender, TabControlEventArgs e)
        {
            var page = e.TabPage;

            if (page.Name == historicalTicks_MDT.Name || page.Name == topMktData_MDT.Name)
            {
                page.Controls.Add(groupBox2);
            }
        }

        private void btnRequestHistoricalTicks_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            Contract contract = GetMDContract();
            int reqId = new Random(DateTime.Now.Millisecond).Next(), numOfTicks;

            if (!int.TryParse(tbNumOfTicks.Text, out numOfTicks))
                return;

            clearHistoricalTicksDataSources();
            ShowTab(marketData_MDT, historicalTicksTabPage);
            ibClient.ClientSocket.reqHistoricalTicks(reqId, contract, tbStartDate.Text, tbEndDate.Text, numOfTicks, cbWhatToShow.Text,
                cbRthOnly.Checked ? 1 : 0, cbIgnoreSize.Checked, new List<TagValue>());
        }

        private void clearHistoricalTicksDataSources()
        {
            new[] { historicalTickTable, historicalTickBidAskTable, historicalTickLastTable }.ToList().ForEach(i => i.Clear());
        }

        private void linkLabel2_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            clearHistoricalTicksDataSources();
        }

        private void buttonRequestTickByTick_Click(object sender, EventArgs e)
        {
            if (!IsConnected)
                return;

            Contract contract = GetMDContract();

            ShowTab(marketData_MDT, tabPageTickByTick);

            string tickType = comboBoxTickByTickType.GetItemText(comboBoxTickByTickType.SelectedItem);
            int numberOfTicks;
            if (!int.TryParse(tbNumOfTicks.Text, out numberOfTicks))
                return;

            labelTickByTick.Text = "Tick-By-Tick: " + tickType;
            ibClient.ClientSocket.reqTickByTickData(0, contract, tickType, numberOfTicks, cbIgnoreSize.Checked);
        }

        private void buttonCancelTickByTick_Click(object sender, EventArgs e)
        {
            ibClient.ClientSocket.cancelTickByTickData(0);
        }

        private void linkLabelClearTickByTick_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            ibClient.ClientSocket.cancelTickByTickData(0);
            labelTickByTick.Text = "Tick-By-Tick: ";
            new[] { tickByTickLastTable, tickByTickAllLastTable, tickByTickBidAskTable, tickByTickMidPointTable }.ToList().ForEach(i => i.Clear());
        }

        private void buttonPdfPathDialog_Click(object sender, EventArgs e)
        {
            var fbd = new FolderBrowserDialog
                      { SelectedPath = textBoxNewsArticlePath.Text };

            if (fbd.ShowDialog() != DialogResult.OK)
                return;

            textBoxNewsArticlePath.Text = fbd.SelectedPath;
        }

        private void buttonAttachOrder_Click(object sender, EventArgs e)
        {
            orderManager.AttachOrder();
        }

        private void FilterOptionAdd_button_Click(object sender, EventArgs e)
        {
            listViewFilterOptions.Items.Add(new ListViewItem(new[] { comboBoxFilterName.Text, textBoxFilterValue.Text }));
        }

        private void FilterOptionRemove_button_Click(object sender, EventArgs e)
        {
            listViewFilterOptions.SelectedItems.OfType<ListViewItem>().ToList().ForEach(i => listViewFilterOptions.Items.Remove(i));
        }

        private void completedOrdersButton_Click(object sender, EventArgs e)
        {
            completedOrdersGrid.Rows.Clear();
            ibClient.ClientSocket.reqCompletedOrders(false);
        }
    }
}
