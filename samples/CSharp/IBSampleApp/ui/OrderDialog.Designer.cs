﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using IBSampleApp.types;
using IBSampleApp.ui;
namespace IBSampleApp
{
    partial class OrderDialog
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(OrderDialog));
            this.contractSymbol = new System.Windows.Forms.TextBox();
            this.conditionsTab = new System.Windows.Forms.TabControl();
            this.orderContractTab = new System.Windows.Forms.TabPage();
            this.baseGroup = new System.Windows.Forms.GroupBox();
            this.label24 = new System.Windows.Forms.Label();
            this.usePriceMgmtAlgo = new System.Windows.Forms.CheckBox();
            this.cashQty = new System.Windows.Forms.TextBox();
            this.cashQtyLabel = new System.Windows.Forms.Label();
            this.modelCode = new System.Windows.Forms.TextBox();
            this.modelCodeLabel = new System.Windows.Forms.Label();
            this.timeInForce = new System.Windows.Forms.ComboBox();
            this.auxPrice = new System.Windows.Forms.TextBox();
            this.lmtPrice = new System.Windows.Forms.TextBox();
            this.orderType = new System.Windows.Forms.ComboBox();
            this.displaySize = new System.Windows.Forms.TextBox();
            this.quantity = new System.Windows.Forms.TextBox();
            this.action = new System.Windows.Forms.ComboBox();
            this.timeInForceLabel = new System.Windows.Forms.Label();
            this.auxPriceLabel = new System.Windows.Forms.Label();
            this.account = new System.Windows.Forms.ComboBox();
            this.limitPriceLabel = new System.Windows.Forms.Label();
            this.orderTypeLabel = new System.Windows.Forms.Label();
            this.displaySizeLabel = new System.Windows.Forms.Label();
            this.quantityLabel = new System.Windows.Forms.Label();
            this.actionLabel = new System.Windows.Forms.Label();
            this.accountLabel = new System.Windows.Forms.Label();
            this.contractGroup = new System.Windows.Forms.GroupBox();
            this.orderPrimExchLabel = new System.Windows.Forms.Label();
            this.contractPrimaryExch = new System.Windows.Forms.TextBox();
            this.orderLocalSymbol = new System.Windows.Forms.Label();
            this.orderCurrencyLabel = new System.Windows.Forms.Label();
            this.orderExchangeLabel = new System.Windows.Forms.Label();
            this.orderSymbolLabel = new System.Windows.Forms.Label();
            this.orderMultiplierLabel = new System.Windows.Forms.Label();
            this.orderRightLabel = new System.Windows.Forms.Label();
            this.contractSecType = new System.Windows.Forms.ComboBox();
            this.orderStrikeLabel = new System.Windows.Forms.Label();
            this.contractLastTradeDateOrContractMonth = new System.Windows.Forms.TextBox();
            this.orderLastTradeDateOrContractMonthLabel = new System.Windows.Forms.Label();
            this.contractStrike = new System.Windows.Forms.TextBox();
            this.orderSecTypeLabel = new System.Windows.Forms.Label();
            this.contractRight = new System.Windows.Forms.ComboBox();
            this.contractLocalSymbol = new System.Windows.Forms.TextBox();
            this.contractMultiplier = new System.Windows.Forms.TextBox();
            this.contractCurrency = new System.Windows.Forms.TextBox();
            this.contractExchange = new System.Windows.Forms.TextBox();
            this.extendedOrderTab = new System.Windows.Forms.TabPage();
            this.manualOrderCancelTime = new System.Windows.Forms.TextBox();
            this.labelManualOrderCancelTime = new System.Windows.Forms.Label();
            this.manualOrderTime = new System.Windows.Forms.TextBox();
            this.labelManualOrderTime = new System.Windows.Forms.Label();
            this.advancedErrorOverride = new System.Windows.Forms.TextBox();
            this.label27 = new System.Windows.Forms.Label();
            this.autoCancelParent = new System.Windows.Forms.CheckBox();
            this.postToAts = new System.Windows.Forms.TextBox();
            this.label26 = new System.Windows.Forms.Label();
            this.duration = new System.Windows.Forms.TextBox();
            this.label25 = new System.Windows.Forms.Label();
            this.relativeDiscretionary = new System.Windows.Forms.CheckBox();
            this.omsContainer = new System.Windows.Forms.CheckBox();
            this.dontUseAutoPriceForHedge = new System.Windows.Forms.CheckBox();
            this.label22 = new System.Windows.Forms.Label();
            this.mifid2ExecutionAlgo = new System.Windows.Forms.TextBox();
            this.label23 = new System.Windows.Forms.Label();
            this.mifid2ExecutionTrader = new System.Windows.Forms.TextBox();
            this.label18 = new System.Windows.Forms.Label();
            this.mifid2DecisionAlgo = new System.Windows.Forms.TextBox();
            this.label19 = new System.Windows.Forms.Label();
            this.mifid2DecisionMaker = new System.Windows.Forms.TextBox();
            this.label17 = new System.Windows.Forms.Label();
            this.softDollarTier = new System.Windows.Forms.ComboBox();
            this.trailingPercentLabel = new System.Windows.Forms.Label();
            this.transmit = new System.Windows.Forms.CheckBox();
            this.overrideConstraints = new System.Windows.Forms.CheckBox();
            this.label5 = new System.Windows.Forms.Label();
            this.optOutSmart = new System.Windows.Forms.CheckBox();
            this.trailingPercent = new System.Windows.Forms.TextBox();
            this.discretionaryAmount = new System.Windows.Forms.TextBox();
            this.hidden = new System.Windows.Forms.CheckBox();
            this.outsideRTH = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.allOrNone = new System.Windows.Forms.CheckBox();
            this.label2 = new System.Windows.Forms.Label();
            this.notHeld = new System.Windows.Forms.CheckBox();
            this.block = new System.Windows.Forms.CheckBox();
            this.label1 = new System.Windows.Forms.Label();
            this.sweepToFill = new System.Windows.Forms.CheckBox();
            this.percentOffsetLabel = new System.Windows.Forms.Label();
            this.tiggerMethodLabel = new System.Windows.Forms.Label();
            this.rule80ALabel = new System.Windows.Forms.Label();
            this.goodUntilLabel = new System.Windows.Forms.Label();
            this.goodAfterLabel = new System.Windows.Forms.Label();
            this.ocaGroup = new System.Windows.Forms.TextBox();
            this.hedgeParam = new System.Windows.Forms.TextBox();
            this.ocaType = new System.Windows.Forms.ComboBox();
            this.hedgeType = new System.Windows.Forms.ComboBox();
            this.orderMinQtyLabel = new System.Windows.Forms.Label();
            this.orderRefLabel = new System.Windows.Forms.Label();
            this.trailStopPrice = new System.Windows.Forms.TextBox();
            this.percentOffset = new System.Windows.Forms.TextBox();
            this.triggerMethod = new System.Windows.Forms.ComboBox();
            this.rule80A = new System.Windows.Forms.ComboBox();
            this.goodUntil = new System.Windows.Forms.TextBox();
            this.goodAfter = new System.Windows.Forms.TextBox();
            this.minQty = new System.Windows.Forms.TextBox();
            this.orderReference = new System.Windows.Forms.TextBox();
            this.advisorTab = new System.Windows.Forms.TabPage();
            this.faPercentage = new System.Windows.Forms.TextBox();
            this.faProfile = new System.Windows.Forms.TextBox();
            this.faMethod = new System.Windows.Forms.ComboBox();
            this.faGroup = new System.Windows.Forms.TextBox();
            this.profileLabel = new System.Windows.Forms.Label();
            this.orLabel = new System.Windows.Forms.Label();
            this.percentageLabel = new System.Windows.Forms.Label();
            this.methodLabel = new System.Windows.Forms.Label();
            this.groupLabel = new System.Windows.Forms.Label();
            this.volatilityTab = new System.Windows.Forms.TabPage();
            this.stockRangeLower = new System.Windows.Forms.TextBox();
            this.stockRangeUpper = new System.Windows.Forms.TextBox();
            this.deltaNeutralConId = new System.Windows.Forms.TextBox();
            this.deltaNeutralAuxPrice = new System.Windows.Forms.TextBox();
            this.deltaNeutralOrderType = new System.Windows.Forms.ComboBox();
            this.optionReferencePrice = new System.Windows.Forms.ComboBox();
            this.volatilityType = new System.Windows.Forms.ComboBox();
            this.volatility = new System.Windows.Forms.TextBox();
            this.continuousUpdate = new System.Windows.Forms.CheckBox();
            this.stockRangeLowerLabel = new System.Windows.Forms.Label();
            this.sockRangeUpperLabel = new System.Windows.Forms.Label();
            this.hedgeContractConIdLabel = new System.Windows.Forms.Label();
            this.hedgeOrderAuxPriceLabel = new System.Windows.Forms.Label();
            this.hedgeOrderTypeLabel = new System.Windows.Forms.Label();
            this.optionReferencePriceLabel = new System.Windows.Forms.Label();
            this.volatilityLabel = new System.Windows.Forms.Label();
            this.scaleTab = new System.Windows.Forms.TabPage();
            this.priceAdjustInterval = new System.Windows.Forms.TextBox();
            this.priceAdjustValue = new System.Windows.Forms.TextBox();
            this.initialFillQuantity = new System.Windows.Forms.TextBox();
            this.initialPosition = new System.Windows.Forms.TextBox();
            this.priceIncrement = new System.Windows.Forms.TextBox();
            this.profitOffset = new System.Windows.Forms.TextBox();
            this.subsequentLevelSize = new System.Windows.Forms.TextBox();
            this.initialLevelSize = new System.Windows.Forms.TextBox();
            this.autoReset = new System.Windows.Forms.CheckBox();
            this.randomiseSize = new System.Windows.Forms.CheckBox();
            this.secondsLabel = new System.Windows.Forms.Label();
            this.initialPositionLabel = new System.Windows.Forms.Label();
            this.initialFillQuantityLabel = new System.Windows.Forms.Label();
            this.everyLabel = new System.Windows.Forms.Label();
            this.priceAdjustValueLabel = new System.Windows.Forms.Label();
            this.subsequentLevelSizeLabel = new System.Windows.Forms.Label();
            this.profitOffsetLabel = new System.Windows.Forms.Label();
            this.priceIncrementLabel = new System.Windows.Forms.Label();
            this.initialLevelSizeLabel = new System.Windows.Forms.Label();
            this.algoTab = new System.Windows.Forms.TabPage();
            this.useOddLots = new System.Windows.Forms.TextBox();
            this.noTradeAhead = new System.Windows.Forms.TextBox();
            this.getDone = new System.Windows.Forms.TextBox();
            this.displaySizeAlgo = new System.Windows.Forms.TextBox();
            this.forceCompletion = new System.Windows.Forms.TextBox();
            this.riskAversion = new System.Windows.Forms.TextBox();
            this.noTakeLiq = new System.Windows.Forms.TextBox();
            this.strategyType = new System.Windows.Forms.TextBox();
            this.pctVol = new System.Windows.Forms.TextBox();
            this.maxPctVol = new System.Windows.Forms.TextBox();
            this.allowPastEndTime = new System.Windows.Forms.TextBox();
            this.endTime = new System.Windows.Forms.TextBox();
            this.startTime = new System.Windows.Forms.TextBox();
            this.useOddLotsLabel = new System.Windows.Forms.Label();
            this.noTradeAheadLabel = new System.Windows.Forms.Label();
            this.getDoneLabel = new System.Windows.Forms.Label();
            this.displaySizeAlgoLabel = new System.Windows.Forms.Label();
            this.forceCompletionLabel = new System.Windows.Forms.Label();
            this.riskAversionLabel = new System.Windows.Forms.Label();
            this.noTakeLiqLabel = new System.Windows.Forms.Label();
            this.strategyTypeLabel = new System.Windows.Forms.Label();
            this.pctVolLabel = new System.Windows.Forms.Label();
            this.maxPctVolLabel = new System.Windows.Forms.Label();
            this.allowPastEndTimeLabel = new System.Windows.Forms.Label();
            this.endTimeLabel = new System.Windows.Forms.Label();
            this.startTimeLabel = new System.Windows.Forms.Label();
            this.algoStrategy = new System.Windows.Forms.ComboBox();
            this.algoStrategyLabel = new System.Windows.Forms.Label();
            this.peg2benchTab = new System.Windows.Forms.TabPage();
            this.pgdStockRangeLower = new System.Windows.Forms.TextBox();
            this.pgdStockRangeUpper = new System.Windows.Forms.TextBox();
            this.label20 = new System.Windows.Forms.Label();
            this.label21 = new System.Windows.Forms.Label();
            this.cbPeggedChangeType = new System.Windows.Forms.ComboBox();
            this.tbReferenceChangeAmount = new System.Windows.Forms.TextBox();
            this.tbPeggedChangeAmount = new System.Windows.Forms.TextBox();
            this.tbStartingReferencePrice = new System.Windows.Forms.TextBox();
            this.label10 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.tbStartingPrice = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.adjustStopTab = new System.Windows.Forms.TabPage();
            this.label16 = new System.Windows.Forms.Label();
            this.cbAdjustedTrailingAmntUnit = new System.Windows.Forms.ComboBox();
            this.tbAdjustedTrailingAmnt = new System.Windows.Forms.TextBox();
            this.label15 = new System.Windows.Forms.Label();
            this.tbAdjustedStopLimitPrice = new System.Windows.Forms.TextBox();
            this.label14 = new System.Windows.Forms.Label();
            this.tbAdjustedStopPrice = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            this.tbTriggerPrice = new System.Windows.Forms.TextBox();
            this.label12 = new System.Windows.Forms.Label();
            this.cbAdjustedOrderType = new System.Windows.Forms.ComboBox();
            this.label11 = new System.Windows.Forms.Label();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.ignoreRth = new System.Windows.Forms.CheckBox();
            this.cancelOrder = new System.Windows.Forms.ComboBox();
            this.conditionList = new System.Windows.Forms.DataGridView();
            this.Description = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.Logic = new System.Windows.Forms.DataGridViewComboBoxColumn();
            this.lbAddCondition = new System.Windows.Forms.LinkLabel();
            this.lbRemoveCondition = new System.Windows.Forms.LinkLabel();
            this.PegBestPegMidTab = new System.Windows.Forms.TabPage();
            this.tbMidOffsetAtHalf = new System.Windows.Forms.TextBox();
            this.labelMidOffsetAtHalf = new System.Windows.Forms.Label();
            this.tbMidOffsetAtWhole = new System.Windows.Forms.TextBox();
            this.labelMidOffsetAtWhole = new System.Windows.Forms.Label();
            this.cbCompeteAgainstBestOffsetUpToMid = new System.Windows.Forms.CheckBox();
            this.tbCompeteAgainstBestOffset = new System.Windows.Forms.TextBox();
            this.labelCompeteAgainstBestOffset = new System.Windows.Forms.Label();
            this.tbMinCompeteSize = new System.Windows.Forms.TextBox();
            this.labelMinCompeteSize = new System.Windows.Forms.Label();
            this.tbMinTradeQty = new System.Windows.Forms.TextBox();
            this.labelMinTradeQty = new System.Windows.Forms.Label();
            this.contractSearchControl1 = new IBSampleApp.ui.ContractSearchControl();
            this.sendOrderButton = new System.Windows.Forms.Button();
            this.textBox6 = new System.Windows.Forms.TextBox();
            this.textBox7 = new System.Windows.Forms.TextBox();
            this.textBox8 = new System.Windows.Forms.TextBox();
            this.checkMarginButton = new System.Windows.Forms.Button();
            this.closeOrderDialogButton = new System.Windows.Forms.Button();
            this.cancelOrderButton = new System.Windows.Forms.Button();
            this.solicited = new System.Windows.Forms.CheckBox();
            this.conditionsTab.SuspendLayout();
            this.orderContractTab.SuspendLayout();
            this.baseGroup.SuspendLayout();
            this.contractGroup.SuspendLayout();
            this.extendedOrderTab.SuspendLayout();
            this.advisorTab.SuspendLayout();
            this.volatilityTab.SuspendLayout();
            this.scaleTab.SuspendLayout();
            this.algoTab.SuspendLayout();
            this.peg2benchTab.SuspendLayout();
            this.adjustStopTab.SuspendLayout();
            this.tabPage1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.conditionList)).BeginInit();
            this.PegBestPegMidTab.SuspendLayout();
            this.SuspendLayout();
            // 
            // contractSymbol
            // 
            this.contractSymbol.Location = new System.Drawing.Point(82, 24);
            this.contractSymbol.Name = "contractSymbol";
            this.contractSymbol.Size = new System.Drawing.Size(71, 20);
            this.contractSymbol.TabIndex = 0;
            this.contractSymbol.Text = "EUR";
            // 
            // conditionsTab
            // 
            this.conditionsTab.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.conditionsTab.Controls.Add(this.orderContractTab);
            this.conditionsTab.Controls.Add(this.extendedOrderTab);
            this.conditionsTab.Controls.Add(this.advisorTab);
            this.conditionsTab.Controls.Add(this.volatilityTab);
            this.conditionsTab.Controls.Add(this.scaleTab);
            this.conditionsTab.Controls.Add(this.algoTab);
            this.conditionsTab.Controls.Add(this.peg2benchTab);
            this.conditionsTab.Controls.Add(this.adjustStopTab);
            this.conditionsTab.Controls.Add(this.tabPage1);
            this.conditionsTab.Controls.Add(this.PegBestPegMidTab);
            this.conditionsTab.Location = new System.Drawing.Point(1, 1);
            this.conditionsTab.Name = "conditionsTab";
            this.conditionsTab.SelectedIndex = 0;
            this.conditionsTab.Size = new System.Drawing.Size(748, 390);
            this.conditionsTab.TabIndex = 1;
            // 
            // orderContractTab
            // 
            this.orderContractTab.BackColor = System.Drawing.Color.LightGray;
            this.orderContractTab.Controls.Add(this.baseGroup);
            this.orderContractTab.Controls.Add(this.contractGroup);
            this.orderContractTab.Location = new System.Drawing.Point(4, 22);
            this.orderContractTab.Name = "orderContractTab";
            this.orderContractTab.Padding = new System.Windows.Forms.Padding(3);
            this.orderContractTab.Size = new System.Drawing.Size(740, 364);
            this.orderContractTab.TabIndex = 0;
            this.orderContractTab.Text = "Basic Order";
            // 
            // baseGroup
            // 
            this.baseGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.baseGroup.Controls.Add(this.label24);
            this.baseGroup.Controls.Add(this.usePriceMgmtAlgo);
            this.baseGroup.Controls.Add(this.cashQty);
            this.baseGroup.Controls.Add(this.cashQtyLabel);
            this.baseGroup.Controls.Add(this.modelCode);
            this.baseGroup.Controls.Add(this.modelCodeLabel);
            this.baseGroup.Controls.Add(this.timeInForce);
            this.baseGroup.Controls.Add(this.auxPrice);
            this.baseGroup.Controls.Add(this.lmtPrice);
            this.baseGroup.Controls.Add(this.orderType);
            this.baseGroup.Controls.Add(this.displaySize);
            this.baseGroup.Controls.Add(this.quantity);
            this.baseGroup.Controls.Add(this.action);
            this.baseGroup.Controls.Add(this.timeInForceLabel);
            this.baseGroup.Controls.Add(this.auxPriceLabel);
            this.baseGroup.Controls.Add(this.account);
            this.baseGroup.Controls.Add(this.limitPriceLabel);
            this.baseGroup.Controls.Add(this.orderTypeLabel);
            this.baseGroup.Controls.Add(this.displaySizeLabel);
            this.baseGroup.Controls.Add(this.quantityLabel);
            this.baseGroup.Controls.Add(this.actionLabel);
            this.baseGroup.Controls.Add(this.accountLabel);
            this.baseGroup.Location = new System.Drawing.Point(362, 6);
            this.baseGroup.Name = "baseGroup";
            this.baseGroup.Size = new System.Drawing.Size(357, 325);
            this.baseGroup.TabIndex = 0;
            this.baseGroup.TabStop = false;
            this.baseGroup.Text = "Order Base Attributes";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Location = new System.Drawing.Point(13, 295);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(142, 13);
            this.label24.TabIndex = 25;
            this.label24.Text = "Use Price Management Algo";
            // 
            // usePriceMgmtAlgo
            // 
            this.usePriceMgmtAlgo.AutoSize = true;
            this.usePriceMgmtAlgo.Checked = true;
            this.usePriceMgmtAlgo.CheckState = System.Windows.Forms.CheckState.Indeterminate;
            this.usePriceMgmtAlgo.Location = new System.Drawing.Point(192, 295);
            this.usePriceMgmtAlgo.Name = "usePriceMgmtAlgo";
            this.usePriceMgmtAlgo.Size = new System.Drawing.Size(15, 14);
            this.usePriceMgmtAlgo.TabIndex = 24;
            this.usePriceMgmtAlgo.UseVisualStyleBackColor = true;
            // 
            // cashQty
            // 
            this.cashQty.Location = new System.Drawing.Point(121, 269);
            this.cashQty.Name = "cashQty";
            this.cashQty.Size = new System.Drawing.Size(89, 20);
            this.cashQty.TabIndex = 23;
            // 
            // cashQtyLabel
            // 
            this.cashQtyLabel.AutoSize = true;
            this.cashQtyLabel.Location = new System.Drawing.Point(14, 272);
            this.cashQtyLabel.Name = "cashQtyLabel";
            this.cashQtyLabel.Size = new System.Drawing.Size(50, 13);
            this.cashQtyLabel.TabIndex = 22;
            this.cashQtyLabel.Text = "Cash Qty";
            // 
            // modelCode
            // 
            this.modelCode.Location = new System.Drawing.Point(121, 54);
            this.modelCode.Name = "modelCode";
            this.modelCode.Size = new System.Drawing.Size(89, 20);
            this.modelCode.TabIndex = 3;
            // 
            // modelCodeLabel
            // 
            this.modelCodeLabel.AutoSize = true;
            this.modelCodeLabel.Location = new System.Drawing.Point(13, 61);
            this.modelCodeLabel.Name = "modelCodeLabel";
            this.modelCodeLabel.Size = new System.Drawing.Size(64, 13);
            this.modelCodeLabel.TabIndex = 2;
            this.modelCodeLabel.Text = "Model Code";
            // 
            // timeInForce
            // 
            this.timeInForce.FormattingEnabled = true;
            this.timeInForce.Items.AddRange(new object[] {
            "DAY",
            "GTC",
            "OPG",
            "IOC",
            "GTD",
            "GTT",
            "AUC",
            "FOK",
            "GTX",
            "DTC",
            "Minutes"});
            this.timeInForce.Location = new System.Drawing.Point(121, 242);
            this.timeInForce.Name = "timeInForce";
            this.timeInForce.Size = new System.Drawing.Size(89, 21);
            this.timeInForce.TabIndex = 15;
            this.timeInForce.Text = "DAY";
            // 
            // auxPrice
            // 
            this.auxPrice.Location = new System.Drawing.Point(121, 216);
            this.auxPrice.Name = "auxPrice";
            this.auxPrice.Size = new System.Drawing.Size(89, 20);
            this.auxPrice.TabIndex = 14;
            // 
            // lmtPrice
            // 
            this.lmtPrice.Location = new System.Drawing.Point(121, 190);
            this.lmtPrice.Name = "lmtPrice";
            this.lmtPrice.Size = new System.Drawing.Size(89, 20);
            this.lmtPrice.TabIndex = 13;
            this.lmtPrice.Text = "0.80";
            // 
            // orderType
            // 
            this.orderType.FormattingEnabled = true;
            this.orderType.Items.AddRange(new object[] {
            "MKT",
            "LMT",
            "STP",
            "STP LMT",
            "REL",
            "TRAIL",
            "BOX TOP",
            "FIX PEGGED",
            "LIT",
            "LMT + MKT",
            "LOC",
            "MIT",
            "MKT PRT",
            "MOC",
            "MTL",
            "PASSV REL",
            "PEG BENCH",
            "PEG BEST",
            "PEG MID",
            "PEG MKT",
            "PEG PRIM",
            "PEG STK",
            "REL +LMT",
            "REL + MKT",
            "STP PRT",
            "TRAIL LIMIT",
            "TRAIL LMT + MKT",
            "TRAIL LIT",
            "TRAIL REL + MKT",
            "TRAIL MIT",
            "TRAIL REL + MKT",
            "VOL",
            "VWAP"});
            this.orderType.Location = new System.Drawing.Point(121, 163);
            this.orderType.Name = "orderType";
            this.orderType.Size = new System.Drawing.Size(115, 21);
            this.orderType.TabIndex = 11;
            this.orderType.Text = "LMT";
            // 
            // displaySize
            // 
            this.displaySize.Location = new System.Drawing.Point(121, 137);
            this.displaySize.Name = "displaySize";
            this.displaySize.Size = new System.Drawing.Size(89, 20);
            this.displaySize.TabIndex = 9;
            // 
            // quantity
            // 
            this.quantity.Location = new System.Drawing.Point(121, 111);
            this.quantity.Name = "quantity";
            this.quantity.Size = new System.Drawing.Size(89, 20);
            this.quantity.TabIndex = 7;
            this.quantity.Text = "20000";
            // 
            // action
            // 
            this.action.FormattingEnabled = true;
            this.action.Items.AddRange(new object[] {
            "BUY",
            "SELL",
            "SSHORT"});
            this.action.Location = new System.Drawing.Point(121, 81);
            this.action.Name = "action";
            this.action.Size = new System.Drawing.Size(89, 21);
            this.action.TabIndex = 5;
            this.action.Text = "BUY";
            // 
            // timeInForceLabel
            // 
            this.timeInForceLabel.AutoSize = true;
            this.timeInForceLabel.Location = new System.Drawing.Point(13, 245);
            this.timeInForceLabel.Name = "timeInForceLabel";
            this.timeInForceLabel.Size = new System.Drawing.Size(68, 13);
            this.timeInForceLabel.TabIndex = 8;
            this.timeInForceLabel.Text = "Time-in-force";
            // 
            // auxPriceLabel
            // 
            this.auxPriceLabel.AutoSize = true;
            this.auxPriceLabel.Location = new System.Drawing.Point(13, 219);
            this.auxPriceLabel.Name = "auxPriceLabel";
            this.auxPriceLabel.Size = new System.Drawing.Size(55, 13);
            this.auxPriceLabel.TabIndex = 7;
            this.auxPriceLabel.Text = "Aux. Price";
            // 
            // account
            // 
            this.account.FormattingEnabled = true;
            this.account.Location = new System.Drawing.Point(121, 25);
            this.account.Name = "account";
            this.account.Size = new System.Drawing.Size(89, 21);
            this.account.TabIndex = 1;
            // 
            // limitPriceLabel
            // 
            this.limitPriceLabel.AutoSize = true;
            this.limitPriceLabel.Location = new System.Drawing.Point(13, 191);
            this.limitPriceLabel.Name = "limitPriceLabel";
            this.limitPriceLabel.Size = new System.Drawing.Size(55, 13);
            this.limitPriceLabel.TabIndex = 5;
            this.limitPriceLabel.Text = "Limit Price";
            // 
            // orderTypeLabel
            // 
            this.orderTypeLabel.AutoSize = true;
            this.orderTypeLabel.Location = new System.Drawing.Point(13, 166);
            this.orderTypeLabel.Name = "orderTypeLabel";
            this.orderTypeLabel.Size = new System.Drawing.Size(60, 13);
            this.orderTypeLabel.TabIndex = 10;
            this.orderTypeLabel.Text = "Order Type";
            // 
            // displaySizeLabel
            // 
            this.displaySizeLabel.AutoSize = true;
            this.displaySizeLabel.Location = new System.Drawing.Point(13, 140);
            this.displaySizeLabel.Name = "displaySizeLabel";
            this.displaySizeLabel.Size = new System.Drawing.Size(64, 13);
            this.displaySizeLabel.TabIndex = 8;
            this.displaySizeLabel.Text = "Display Size";
            // 
            // quantityLabel
            // 
            this.quantityLabel.AutoSize = true;
            this.quantityLabel.Location = new System.Drawing.Point(13, 114);
            this.quantityLabel.Name = "quantityLabel";
            this.quantityLabel.Size = new System.Drawing.Size(46, 13);
            this.quantityLabel.TabIndex = 6;
            this.quantityLabel.Text = "Quantity";
            // 
            // actionLabel
            // 
            this.actionLabel.AutoSize = true;
            this.actionLabel.Location = new System.Drawing.Point(13, 90);
            this.actionLabel.Name = "actionLabel";
            this.actionLabel.Size = new System.Drawing.Size(37, 13);
            this.actionLabel.TabIndex = 4;
            this.actionLabel.Text = "Action";
            // 
            // accountLabel
            // 
            this.accountLabel.AutoSize = true;
            this.accountLabel.Location = new System.Drawing.Point(13, 33);
            this.accountLabel.Name = "accountLabel";
            this.accountLabel.Size = new System.Drawing.Size(47, 13);
            this.accountLabel.TabIndex = 0;
            this.accountLabel.Text = "Account";
            // 
            // contractGroup
            // 
            this.contractGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.contractGroup.Controls.Add(this.orderPrimExchLabel);
            this.contractGroup.Controls.Add(this.contractPrimaryExch);
            this.contractGroup.Controls.Add(this.orderLocalSymbol);
            this.contractGroup.Controls.Add(this.orderCurrencyLabel);
            this.contractGroup.Controls.Add(this.orderExchangeLabel);
            this.contractGroup.Controls.Add(this.orderSymbolLabel);
            this.contractGroup.Controls.Add(this.orderMultiplierLabel);
            this.contractGroup.Controls.Add(this.contractSymbol);
            this.contractGroup.Controls.Add(this.orderRightLabel);
            this.contractGroup.Controls.Add(this.contractSecType);
            this.contractGroup.Controls.Add(this.orderStrikeLabel);
            this.contractGroup.Controls.Add(this.contractLastTradeDateOrContractMonth);
            this.contractGroup.Controls.Add(this.orderLastTradeDateOrContractMonthLabel);
            this.contractGroup.Controls.Add(this.contractStrike);
            this.contractGroup.Controls.Add(this.orderSecTypeLabel);
            this.contractGroup.Controls.Add(this.contractRight);
            this.contractGroup.Controls.Add(this.contractLocalSymbol);
            this.contractGroup.Controls.Add(this.contractMultiplier);
            this.contractGroup.Controls.Add(this.contractCurrency);
            this.contractGroup.Controls.Add(this.contractExchange);
            this.contractGroup.Location = new System.Drawing.Point(6, 6);
            this.contractGroup.Name = "contractGroup";
            this.contractGroup.Size = new System.Drawing.Size(465, 302);
            this.contractGroup.TabIndex = 14;
            this.contractGroup.TabStop = false;
            this.contractGroup.Text = "Contract";
            // 
            // orderPrimExchLabel
            // 
            this.orderPrimExchLabel.AutoSize = true;
            this.orderPrimExchLabel.Location = new System.Drawing.Point(5, 163);
            this.orderPrimExchLabel.Name = "orderPrimExchLabel";
            this.orderPrimExchLabel.Size = new System.Drawing.Size(71, 13);
            this.orderPrimExchLabel.TabIndex = 18;
            this.orderPrimExchLabel.Text = "Primary Exch.";
            // 
            // contractPrimaryExch
            // 
            this.contractPrimaryExch.Location = new System.Drawing.Point(82, 160);
            this.contractPrimaryExch.Name = "contractPrimaryExch";
            this.contractPrimaryExch.Size = new System.Drawing.Size(71, 20);
            this.contractPrimaryExch.TabIndex = 17;
            // 
            // orderLocalSymbol
            // 
            this.orderLocalSymbol.AutoSize = true;
            this.orderLocalSymbol.Location = new System.Drawing.Point(7, 133);
            this.orderLocalSymbol.Name = "orderLocalSymbol";
            this.orderLocalSymbol.Size = new System.Drawing.Size(70, 13);
            this.orderLocalSymbol.TabIndex = 16;
            this.orderLocalSymbol.Text = "Local Symbol";
            // 
            // orderCurrencyLabel
            // 
            this.orderCurrencyLabel.AutoSize = true;
            this.orderCurrencyLabel.Location = new System.Drawing.Point(27, 106);
            this.orderCurrencyLabel.Name = "orderCurrencyLabel";
            this.orderCurrencyLabel.Size = new System.Drawing.Size(49, 13);
            this.orderCurrencyLabel.TabIndex = 15;
            this.orderCurrencyLabel.Text = "Currency";
            // 
            // orderExchangeLabel
            // 
            this.orderExchangeLabel.AutoSize = true;
            this.orderExchangeLabel.Location = new System.Drawing.Point(21, 80);
            this.orderExchangeLabel.Name = "orderExchangeLabel";
            this.orderExchangeLabel.Size = new System.Drawing.Size(55, 13);
            this.orderExchangeLabel.TabIndex = 14;
            this.orderExchangeLabel.Text = "Exchange";
            // 
            // orderSymbolLabel
            // 
            this.orderSymbolLabel.AutoSize = true;
            this.orderSymbolLabel.Location = new System.Drawing.Point(35, 27);
            this.orderSymbolLabel.Name = "orderSymbolLabel";
            this.orderSymbolLabel.Size = new System.Drawing.Size(41, 13);
            this.orderSymbolLabel.TabIndex = 0;
            this.orderSymbolLabel.Text = "Symbol";
            // 
            // orderMultiplierLabel
            // 
            this.orderMultiplierLabel.AutoSize = true;
            this.orderMultiplierLabel.Location = new System.Drawing.Point(219, 112);
            this.orderMultiplierLabel.Name = "orderMultiplierLabel";
            this.orderMultiplierLabel.Size = new System.Drawing.Size(48, 13);
            this.orderMultiplierLabel.TabIndex = 13;
            this.orderMultiplierLabel.Text = "Multiplier";
            // 
            // orderRightLabel
            // 
            this.orderRightLabel.AutoSize = true;
            this.orderRightLabel.Location = new System.Drawing.Point(222, 85);
            this.orderRightLabel.Name = "orderRightLabel";
            this.orderRightLabel.Size = new System.Drawing.Size(45, 13);
            this.orderRightLabel.TabIndex = 12;
            this.orderRightLabel.Text = "Put/Call";
            // 
            // contractSecType
            // 
            this.contractSecType.FormattingEnabled = true;
            this.contractSecType.Items.AddRange(new object[] {
            "STK",
            "OPT",
            "FUT",
            "CASH",
            "BOND",
            "CFD",
            "FOP",
            "WAR",
            "IOPT",
            "FWD",
            "BAG",
            "IND",
            "BILL",
            "FUND",
            "FIXED",
            "SLB",
            "NEWS",
            "CMDTY",
            "BSK",
            "ICU",
            "ICS",
            "CRYPTO"});
            this.contractSecType.Location = new System.Drawing.Point(82, 50);
            this.contractSecType.Name = "contractSecType";
            this.contractSecType.Size = new System.Drawing.Size(71, 21);
            this.contractSecType.TabIndex = 1;
            this.contractSecType.Text = "CASH";
            // 
            // orderStrikeLabel
            // 
            this.orderStrikeLabel.AutoSize = true;
            this.orderStrikeLabel.Location = new System.Drawing.Point(233, 57);
            this.orderStrikeLabel.Name = "orderStrikeLabel";
            this.orderStrikeLabel.Size = new System.Drawing.Size(34, 13);
            this.orderStrikeLabel.TabIndex = 11;
            this.orderStrikeLabel.Text = "Strike";
            // 
            // contractLastTradeDateOrContractMonth
            // 
            this.contractLastTradeDateOrContractMonth.Location = new System.Drawing.Point(273, 22);
            this.contractLastTradeDateOrContractMonth.Name = "contractLastTradeDateOrContractMonth";
            this.contractLastTradeDateOrContractMonth.Size = new System.Drawing.Size(71, 20);
            this.contractLastTradeDateOrContractMonth.TabIndex = 2;
            // 
            // orderLastTradeDateOrContractMonthLabel
            // 
            this.orderLastTradeDateOrContractMonthLabel.Location = new System.Drawing.Point(178, 22);
            this.orderLastTradeDateOrContractMonthLabel.Name = "orderLastTradeDateOrContractMonthLabel";
            this.orderLastTradeDateOrContractMonthLabel.Size = new System.Drawing.Size(89, 28);
            this.orderLastTradeDateOrContractMonthLabel.TabIndex = 10;
            this.orderLastTradeDateOrContractMonthLabel.Text = "Last trade date / contract month";
            // 
            // contractStrike
            // 
            this.contractStrike.Location = new System.Drawing.Point(273, 54);
            this.contractStrike.Name = "contractStrike";
            this.contractStrike.Size = new System.Drawing.Size(71, 20);
            this.contractStrike.TabIndex = 3;
            // 
            // orderSecTypeLabel
            // 
            this.orderSecTypeLabel.AutoSize = true;
            this.orderSecTypeLabel.Location = new System.Drawing.Point(26, 55);
            this.orderSecTypeLabel.Name = "orderSecTypeLabel";
            this.orderSecTypeLabel.Size = new System.Drawing.Size(50, 13);
            this.orderSecTypeLabel.TabIndex = 9;
            this.orderSecTypeLabel.Text = "SecType";
            // 
            // contractRight
            // 
            this.contractRight.FormattingEnabled = true;
            this.contractRight.Location = new System.Drawing.Point(273, 82);
            this.contractRight.Name = "contractRight";
            this.contractRight.Size = new System.Drawing.Size(71, 21);
            this.contractRight.TabIndex = 4;
            // 
            // contractLocalSymbol
            // 
            this.contractLocalSymbol.Location = new System.Drawing.Point(82, 130);
            this.contractLocalSymbol.Name = "contractLocalSymbol";
            this.contractLocalSymbol.Size = new System.Drawing.Size(71, 20);
            this.contractLocalSymbol.TabIndex = 8;
            // 
            // contractMultiplier
            // 
            this.contractMultiplier.Location = new System.Drawing.Point(273, 109);
            this.contractMultiplier.Name = "contractMultiplier";
            this.contractMultiplier.Size = new System.Drawing.Size(71, 20);
            this.contractMultiplier.TabIndex = 5;
            // 
            // contractCurrency
            // 
            this.contractCurrency.Location = new System.Drawing.Point(82, 103);
            this.contractCurrency.Name = "contractCurrency";
            this.contractCurrency.Size = new System.Drawing.Size(71, 20);
            this.contractCurrency.TabIndex = 7;
            this.contractCurrency.Text = "USD";
            // 
            // contractExchange
            // 
            this.contractExchange.Location = new System.Drawing.Point(82, 77);
            this.contractExchange.Name = "contractExchange";
            this.contractExchange.Size = new System.Drawing.Size(71, 20);
            this.contractExchange.TabIndex = 6;
            this.contractExchange.Text = "IDEALPRO";
            // 
            // extendedOrderTab
            // 
            this.extendedOrderTab.BackColor = System.Drawing.Color.LightGray;
            this.extendedOrderTab.Controls.Add(this.solicited);
            this.extendedOrderTab.Controls.Add(this.manualOrderCancelTime);
            this.extendedOrderTab.Controls.Add(this.labelManualOrderCancelTime);
            this.extendedOrderTab.Controls.Add(this.manualOrderTime);
            this.extendedOrderTab.Controls.Add(this.labelManualOrderTime);
            this.extendedOrderTab.Controls.Add(this.advancedErrorOverride);
            this.extendedOrderTab.Controls.Add(this.label27);
            this.extendedOrderTab.Controls.Add(this.autoCancelParent);
            this.extendedOrderTab.Controls.Add(this.postToAts);
            this.extendedOrderTab.Controls.Add(this.label26);
            this.extendedOrderTab.Controls.Add(this.duration);
            this.extendedOrderTab.Controls.Add(this.label25);
            this.extendedOrderTab.Controls.Add(this.relativeDiscretionary);
            this.extendedOrderTab.Controls.Add(this.omsContainer);
            this.extendedOrderTab.Controls.Add(this.dontUseAutoPriceForHedge);
            this.extendedOrderTab.Controls.Add(this.label22);
            this.extendedOrderTab.Controls.Add(this.mifid2ExecutionAlgo);
            this.extendedOrderTab.Controls.Add(this.label23);
            this.extendedOrderTab.Controls.Add(this.mifid2ExecutionTrader);
            this.extendedOrderTab.Controls.Add(this.label18);
            this.extendedOrderTab.Controls.Add(this.mifid2DecisionAlgo);
            this.extendedOrderTab.Controls.Add(this.label19);
            this.extendedOrderTab.Controls.Add(this.mifid2DecisionMaker);
            this.extendedOrderTab.Controls.Add(this.label17);
            this.extendedOrderTab.Controls.Add(this.softDollarTier);
            this.extendedOrderTab.Controls.Add(this.trailingPercentLabel);
            this.extendedOrderTab.Controls.Add(this.transmit);
            this.extendedOrderTab.Controls.Add(this.overrideConstraints);
            this.extendedOrderTab.Controls.Add(this.label5);
            this.extendedOrderTab.Controls.Add(this.optOutSmart);
            this.extendedOrderTab.Controls.Add(this.trailingPercent);
            this.extendedOrderTab.Controls.Add(this.discretionaryAmount);
            this.extendedOrderTab.Controls.Add(this.hidden);
            this.extendedOrderTab.Controls.Add(this.outsideRTH);
            this.extendedOrderTab.Controls.Add(this.label3);
            this.extendedOrderTab.Controls.Add(this.allOrNone);
            this.extendedOrderTab.Controls.Add(this.label2);
            this.extendedOrderTab.Controls.Add(this.notHeld);
            this.extendedOrderTab.Controls.Add(this.block);
            this.extendedOrderTab.Controls.Add(this.label1);
            this.extendedOrderTab.Controls.Add(this.sweepToFill);
            this.extendedOrderTab.Controls.Add(this.percentOffsetLabel);
            this.extendedOrderTab.Controls.Add(this.tiggerMethodLabel);
            this.extendedOrderTab.Controls.Add(this.rule80ALabel);
            this.extendedOrderTab.Controls.Add(this.goodUntilLabel);
            this.extendedOrderTab.Controls.Add(this.goodAfterLabel);
            this.extendedOrderTab.Controls.Add(this.ocaGroup);
            this.extendedOrderTab.Controls.Add(this.hedgeParam);
            this.extendedOrderTab.Controls.Add(this.ocaType);
            this.extendedOrderTab.Controls.Add(this.hedgeType);
            this.extendedOrderTab.Controls.Add(this.orderMinQtyLabel);
            this.extendedOrderTab.Controls.Add(this.orderRefLabel);
            this.extendedOrderTab.Controls.Add(this.trailStopPrice);
            this.extendedOrderTab.Controls.Add(this.percentOffset);
            this.extendedOrderTab.Controls.Add(this.triggerMethod);
            this.extendedOrderTab.Controls.Add(this.rule80A);
            this.extendedOrderTab.Controls.Add(this.goodUntil);
            this.extendedOrderTab.Controls.Add(this.goodAfter);
            this.extendedOrderTab.Controls.Add(this.minQty);
            this.extendedOrderTab.Controls.Add(this.orderReference);
            this.extendedOrderTab.Location = new System.Drawing.Point(4, 22);
            this.extendedOrderTab.Name = "extendedOrderTab";
            this.extendedOrderTab.Padding = new System.Windows.Forms.Padding(3);
            this.extendedOrderTab.Size = new System.Drawing.Size(740, 364);
            this.extendedOrderTab.TabIndex = 1;
            this.extendedOrderTab.Text = "Extended Attributes";
            // 
            // manualOrderCancelTime
            // 
            this.manualOrderCancelTime.Location = new System.Drawing.Point(339, 327);
            this.manualOrderCancelTime.Name = "manualOrderCancelTime";
            this.manualOrderCancelTime.Size = new System.Drawing.Size(70, 20);
            this.manualOrderCancelTime.TabIndex = 58;
            // 
            // labelManualOrderCancelTime
            // 
            this.labelManualOrderCancelTime.AutoSize = true;
            this.labelManualOrderCancelTime.Location = new System.Drawing.Point(205, 330);
            this.labelManualOrderCancelTime.Name = "labelManualOrderCancelTime";
            this.labelManualOrderCancelTime.Size = new System.Drawing.Size(114, 13);
            this.labelManualOrderCancelTime.TabIndex = 57;
            this.labelManualOrderCancelTime.Text = "Manual Order Cxl Time";
            // 
            // manualOrderTime
            // 
            this.manualOrderTime.Location = new System.Drawing.Point(125, 327);
            this.manualOrderTime.Name = "manualOrderTime";
            this.manualOrderTime.Size = new System.Drawing.Size(70, 20);
            this.manualOrderTime.TabIndex = 56;
            // 
            // labelManualOrderTime
            // 
            this.labelManualOrderTime.AutoSize = true;
            this.labelManualOrderTime.Location = new System.Drawing.Point(22, 330);
            this.labelManualOrderTime.Name = "labelManualOrderTime";
            this.labelManualOrderTime.Size = new System.Drawing.Size(97, 13);
            this.labelManualOrderTime.TabIndex = 55;
            this.labelManualOrderTime.Text = "Manual Order Time";
            // 
            // advancedErrorOverride
            // 
            this.advancedErrorOverride.Location = new System.Drawing.Point(546, 299);
            this.advancedErrorOverride.Name = "advancedErrorOverride";
            this.advancedErrorOverride.Size = new System.Drawing.Size(70, 20);
            this.advancedErrorOverride.TabIndex = 54;
            // 
            // label27
            // 
            this.label27.AutoSize = true;
            this.label27.Location = new System.Drawing.Point(422, 302);
            this.label27.Name = "label27";
            this.label27.Size = new System.Drawing.Size(124, 13);
            this.label27.TabIndex = 53;
            this.label27.Text = "Advanced Error Override";
            // 
            // autoCancelParent
            // 
            this.autoCancelParent.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.autoCancelParent.AutoSize = true;
            this.autoCancelParent.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.autoCancelParent.Location = new System.Drawing.Point(422, 165);
            this.autoCancelParent.Name = "autoCancelParent";
            this.autoCancelParent.Size = new System.Drawing.Size(118, 17);
            this.autoCancelParent.TabIndex = 52;
            this.autoCancelParent.Text = "Auto Cancel Parent";
            this.autoCancelParent.UseVisualStyleBackColor = true;
            // 
            // postToAts
            // 
            this.postToAts.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.postToAts.Location = new System.Drawing.Point(560, 90);
            this.postToAts.Name = "postToAts";
            this.postToAts.Size = new System.Drawing.Size(55, 20);
            this.postToAts.TabIndex = 51;
            // 
            // label26
            // 
            this.label26.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label26.AutoSize = true;
            this.label26.Location = new System.Drawing.Point(492, 94);
            this.label26.Name = "label26";
            this.label26.Size = new System.Drawing.Size(62, 13);
            this.label26.TabIndex = 50;
            this.label26.Text = "Post To Ats";
            // 
            // duration
            // 
            this.duration.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.duration.Location = new System.Drawing.Point(403, 90);
            this.duration.Name = "duration";
            this.duration.Size = new System.Drawing.Size(70, 20);
            this.duration.TabIndex = 34;
            // 
            // label25
            // 
            this.label25.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label25.AutoSize = true;
            this.label25.Location = new System.Drawing.Point(350, 94);
            this.label25.Name = "label25";
            this.label25.Size = new System.Drawing.Size(47, 13);
            this.label25.TabIndex = 33;
            this.label25.Text = "Duration";
            // 
            // relativeDiscretionary
            // 
            this.relativeDiscretionary.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.relativeDiscretionary.AutoSize = true;
            this.relativeDiscretionary.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.relativeDiscretionary.Location = new System.Drawing.Point(413, 273);
            this.relativeDiscretionary.Name = "relativeDiscretionary";
            this.relativeDiscretionary.Size = new System.Drawing.Size(127, 17);
            this.relativeDiscretionary.TabIndex = 48;
            this.relativeDiscretionary.Text = "Relative discretionary";
            this.relativeDiscretionary.UseVisualStyleBackColor = true;
            // 
            // omsContainer
            // 
            this.omsContainer.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.omsContainer.AutoSize = true;
            this.omsContainer.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.omsContainer.Location = new System.Drawing.Point(442, 254);
            this.omsContainer.Name = "omsContainer";
            this.omsContainer.Size = new System.Drawing.Size(98, 17);
            this.omsContainer.TabIndex = 45;
            this.omsContainer.Text = "OMS Container";
            this.omsContainer.UseVisualStyleBackColor = true;
            // 
            // dontUseAutoPriceForHedge
            // 
            this.dontUseAutoPriceForHedge.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.dontUseAutoPriceForHedge.AutoSize = true;
            this.dontUseAutoPriceForHedge.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.dontUseAutoPriceForHedge.Location = new System.Drawing.Point(371, 231);
            this.dontUseAutoPriceForHedge.Name = "dontUseAutoPriceForHedge";
            this.dontUseAutoPriceForHedge.Size = new System.Drawing.Size(169, 17);
            this.dontUseAutoPriceForHedge.TabIndex = 44;
            this.dontUseAutoPriceForHedge.Text = "Don\'t use auto price for hedge";
            this.dontUseAutoPriceForHedge.UseVisualStyleBackColor = true;
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(205, 302);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(118, 13);
            this.label22.TabIndex = 49;
            this.label22.Text = "MiFID II Execution Algo";
            // 
            // mifid2ExecutionAlgo
            // 
            this.mifid2ExecutionAlgo.Location = new System.Drawing.Point(339, 299);
            this.mifid2ExecutionAlgo.Name = "mifid2ExecutionAlgo";
            this.mifid2ExecutionAlgo.Size = new System.Drawing.Size(70, 20);
            this.mifid2ExecutionAlgo.TabIndex = 0;
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(205, 276);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(128, 13);
            this.label23.TabIndex = 46;
            this.label23.Text = "MiFID II Execution Trader";
            // 
            // mifid2ExecutionTrader
            // 
            this.mifid2ExecutionTrader.Location = new System.Drawing.Point(339, 273);
            this.mifid2ExecutionTrader.Name = "mifid2ExecutionTrader";
            this.mifid2ExecutionTrader.Size = new System.Drawing.Size(70, 20);
            this.mifid2ExecutionTrader.TabIndex = 47;
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(7, 302);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(112, 13);
            this.label18.TabIndex = 23;
            this.label18.Text = "MiFID II Decision Algo";
            // 
            // mifid2DecisionAlgo
            // 
            this.mifid2DecisionAlgo.Location = new System.Drawing.Point(125, 299);
            this.mifid2DecisionAlgo.Name = "mifid2DecisionAlgo";
            this.mifid2DecisionAlgo.Size = new System.Drawing.Size(70, 20);
            this.mifid2DecisionAlgo.TabIndex = 24;
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Location = new System.Drawing.Point(3, 276);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(121, 13);
            this.label19.TabIndex = 21;
            this.label19.Text = "MiFID II Decision Maker";
            // 
            // mifid2DecisionMaker
            // 
            this.mifid2DecisionMaker.Location = new System.Drawing.Point(125, 273);
            this.mifid2DecisionMaker.Name = "mifid2DecisionMaker";
            this.mifid2DecisionMaker.Size = new System.Drawing.Size(70, 20);
            this.mifid2DecisionMaker.TabIndex = 22;
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(48, 249);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(71, 13);
            this.label17.TabIndex = 19;
            this.label17.Text = "Soft dollar tier";
            // 
            // softDollarTier
            // 
            this.softDollarTier.FormattingEnabled = true;
            this.softDollarTier.Location = new System.Drawing.Point(125, 246);
            this.softDollarTier.Name = "softDollarTier";
            this.softDollarTier.Size = new System.Drawing.Size(110, 21);
            this.softDollarTier.TabIndex = 20;
            // 
            // trailingPercentLabel
            // 
            this.trailingPercentLabel.AutoSize = true;
            this.trailingPercentLabel.Location = new System.Drawing.Point(39, 224);
            this.trailingPercentLabel.Name = "trailingPercentLabel";
            this.trailingPercentLabel.Size = new System.Drawing.Size(80, 13);
            this.trailingPercentLabel.TabIndex = 17;
            this.trailingPercentLabel.Text = "Trailing percent";
            // 
            // transmit
            // 
            this.transmit.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.transmit.AutoSize = true;
            this.transmit.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.transmit.Checked = true;
            this.transmit.CheckState = System.Windows.Forms.CheckState.Checked;
            this.transmit.Location = new System.Drawing.Point(549, 118);
            this.transmit.Name = "transmit";
            this.transmit.Size = new System.Drawing.Size(66, 17);
            this.transmit.TabIndex = 37;
            this.transmit.Text = "Transmit";
            this.transmit.UseVisualStyleBackColor = true;
            // 
            // overrideConstraints
            // 
            this.overrideConstraints.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.overrideConstraints.AutoSize = true;
            this.overrideConstraints.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.overrideConstraints.Location = new System.Drawing.Point(420, 141);
            this.overrideConstraints.Name = "overrideConstraints";
            this.overrideConstraints.Size = new System.Drawing.Size(120, 17);
            this.overrideConstraints.TabIndex = 39;
            this.overrideConstraints.Text = "Override constraints";
            this.overrideConstraints.UseVisualStyleBackColor = true;
            // 
            // label5
            // 
            this.label5.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(291, 67);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(106, 13);
            this.label5.TabIndex = 31;
            this.label5.Text = "Discretionary amount";
            // 
            // optOutSmart
            // 
            this.optOutSmart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.optOutSmart.AutoSize = true;
            this.optOutSmart.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.optOutSmart.Location = new System.Drawing.Point(403, 208);
            this.optOutSmart.Name = "optOutSmart";
            this.optOutSmart.Size = new System.Drawing.Size(137, 17);
            this.optOutSmart.TabIndex = 43;
            this.optOutSmart.Text = "Opt out SMART routing";
            this.optOutSmart.UseVisualStyleBackColor = true;
            // 
            // trailingPercent
            // 
            this.trailingPercent.Location = new System.Drawing.Point(125, 220);
            this.trailingPercent.Name = "trailingPercent";
            this.trailingPercent.Size = new System.Drawing.Size(70, 20);
            this.trailingPercent.TabIndex = 18;
            // 
            // discretionaryAmount
            // 
            this.discretionaryAmount.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.discretionaryAmount.Location = new System.Drawing.Point(403, 64);
            this.discretionaryAmount.Name = "discretionaryAmount";
            this.discretionaryAmount.Size = new System.Drawing.Size(70, 20);
            this.discretionaryAmount.TabIndex = 32;
            // 
            // hidden
            // 
            this.hidden.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hidden.AutoSize = true;
            this.hidden.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.hidden.Location = new System.Drawing.Point(337, 185);
            this.hidden.Name = "hidden";
            this.hidden.Size = new System.Drawing.Size(60, 17);
            this.hidden.TabIndex = 41;
            this.hidden.Text = "Hidden";
            this.hidden.UseVisualStyleBackColor = true;
            // 
            // outsideRTH
            // 
            this.outsideRTH.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.outsideRTH.AutoSize = true;
            this.outsideRTH.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.outsideRTH.Location = new System.Drawing.Point(296, 208);
            this.outsideRTH.Name = "outsideRTH";
            this.outsideRTH.Size = new System.Drawing.Size(101, 17);
            this.outsideRTH.TabIndex = 42;
            this.outsideRTH.Text = "Fill outside RTH";
            this.outsideRTH.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(282, 42);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(115, 13);
            this.label3.TabIndex = 28;
            this.label3.Text = "Hedge type and param";
            // 
            // allOrNone
            // 
            this.allOrNone.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.allOrNone.AutoSize = true;
            this.allOrNone.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.allOrNone.Location = new System.Drawing.Point(464, 118);
            this.allOrNone.Name = "allOrNone";
            this.allOrNone.Size = new System.Drawing.Size(76, 17);
            this.allOrNone.TabIndex = 36;
            this.allOrNone.Text = "All or none";
            this.allOrNone.UseVisualStyleBackColor = true;
            // 
            // label2
            // 
            this.label2.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(294, 15);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(103, 13);
            this.label2.TabIndex = 25;
            this.label2.Text = "OCA group and type";
            // 
            // notHeld
            // 
            this.notHeld.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.notHeld.AutoSize = true;
            this.notHeld.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.notHeld.Location = new System.Drawing.Point(331, 118);
            this.notHeld.Name = "notHeld";
            this.notHeld.Size = new System.Drawing.Size(66, 17);
            this.notHeld.TabIndex = 35;
            this.notHeld.Text = "Not held";
            this.notHeld.UseVisualStyleBackColor = true;
            // 
            // block
            // 
            this.block.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.block.AutoSize = true;
            this.block.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.block.Location = new System.Drawing.Point(317, 141);
            this.block.Name = "block";
            this.block.Size = new System.Drawing.Size(80, 17);
            this.block.TabIndex = 38;
            this.block.Text = "Block order";
            this.block.UseVisualStyleBackColor = true;
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(16, 198);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(103, 13);
            this.label1.TabIndex = 15;
            this.label1.Text = "Trail order stop price";
            // 
            // sweepToFill
            // 
            this.sweepToFill.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.sweepToFill.AutoSize = true;
            this.sweepToFill.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.sweepToFill.Location = new System.Drawing.Point(314, 164);
            this.sweepToFill.Name = "sweepToFill";
            this.sweepToFill.Size = new System.Drawing.Size(83, 17);
            this.sweepToFill.TabIndex = 40;
            this.sweepToFill.Text = "Sweep to fill";
            this.sweepToFill.UseVisualStyleBackColor = true;
            // 
            // percentOffsetLabel
            // 
            this.percentOffsetLabel.AutoSize = true;
            this.percentOffsetLabel.Location = new System.Drawing.Point(44, 172);
            this.percentOffsetLabel.Name = "percentOffsetLabel";
            this.percentOffsetLabel.Size = new System.Drawing.Size(75, 13);
            this.percentOffsetLabel.TabIndex = 13;
            this.percentOffsetLabel.Text = "Percent Offset";
            // 
            // tiggerMethodLabel
            // 
            this.tiggerMethodLabel.AutoSize = true;
            this.tiggerMethodLabel.Location = new System.Drawing.Point(40, 146);
            this.tiggerMethodLabel.Name = "tiggerMethodLabel";
            this.tiggerMethodLabel.Size = new System.Drawing.Size(79, 13);
            this.tiggerMethodLabel.TabIndex = 11;
            this.tiggerMethodLabel.Text = "Trigger Method";
            // 
            // rule80ALabel
            // 
            this.rule80ALabel.AutoSize = true;
            this.rule80ALabel.Location = new System.Drawing.Point(68, 120);
            this.rule80ALabel.Name = "rule80ALabel";
            this.rule80ALabel.Size = new System.Drawing.Size(51, 13);
            this.rule80ALabel.TabIndex = 9;
            this.rule80ALabel.Text = "Rule 80A";
            // 
            // goodUntilLabel
            // 
            this.goodUntilLabel.AutoSize = true;
            this.goodUntilLabel.Location = new System.Drawing.Point(64, 94);
            this.goodUntilLabel.Name = "goodUntilLabel";
            this.goodUntilLabel.Size = new System.Drawing.Size(55, 13);
            this.goodUntilLabel.TabIndex = 7;
            this.goodUntilLabel.Text = "Good until";
            // 
            // goodAfterLabel
            // 
            this.goodAfterLabel.AutoSize = true;
            this.goodAfterLabel.Location = new System.Drawing.Point(62, 68);
            this.goodAfterLabel.Name = "goodAfterLabel";
            this.goodAfterLabel.Size = new System.Drawing.Size(57, 13);
            this.goodAfterLabel.TabIndex = 5;
            this.goodAfterLabel.Text = "Good after";
            // 
            // ocaGroup
            // 
            this.ocaGroup.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ocaGroup.Location = new System.Drawing.Point(403, 12);
            this.ocaGroup.Name = "ocaGroup";
            this.ocaGroup.Size = new System.Drawing.Size(70, 20);
            this.ocaGroup.TabIndex = 26;
            // 
            // hedgeParam
            // 
            this.hedgeParam.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hedgeParam.Location = new System.Drawing.Point(479, 39);
            this.hedgeParam.Name = "hedgeParam";
            this.hedgeParam.Size = new System.Drawing.Size(53, 20);
            this.hedgeParam.TabIndex = 30;
            // 
            // ocaType
            // 
            this.ocaType.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.ocaType.FormattingEnabled = true;
            this.ocaType.Location = new System.Drawing.Point(479, 12);
            this.ocaType.Name = "ocaType";
            this.ocaType.Size = new System.Drawing.Size(140, 21);
            this.ocaType.TabIndex = 27;
            // 
            // hedgeType
            // 
            this.hedgeType.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.hedgeType.FormattingEnabled = true;
            this.hedgeType.Location = new System.Drawing.Point(403, 38);
            this.hedgeType.Name = "hedgeType";
            this.hedgeType.Size = new System.Drawing.Size(70, 21);
            this.hedgeType.TabIndex = 29;
            // 
            // orderMinQtyLabel
            // 
            this.orderMinQtyLabel.AutoSize = true;
            this.orderMinQtyLabel.Location = new System.Drawing.Point(70, 43);
            this.orderMinQtyLabel.Name = "orderMinQtyLabel";
            this.orderMinQtyLabel.Size = new System.Drawing.Size(49, 13);
            this.orderMinQtyLabel.TabIndex = 3;
            this.orderMinQtyLabel.Text = "Min. Qty.";
            // 
            // orderRefLabel
            // 
            this.orderRefLabel.AutoSize = true;
            this.orderRefLabel.Location = new System.Drawing.Point(63, 16);
            this.orderRefLabel.Name = "orderRefLabel";
            this.orderRefLabel.Size = new System.Drawing.Size(56, 13);
            this.orderRefLabel.TabIndex = 0;
            this.orderRefLabel.Text = "Order Ref.";
            // 
            // trailStopPrice
            // 
            this.trailStopPrice.Location = new System.Drawing.Point(125, 194);
            this.trailStopPrice.Name = "trailStopPrice";
            this.trailStopPrice.Size = new System.Drawing.Size(70, 20);
            this.trailStopPrice.TabIndex = 16;
            // 
            // percentOffset
            // 
            this.percentOffset.Location = new System.Drawing.Point(125, 169);
            this.percentOffset.Name = "percentOffset";
            this.percentOffset.Size = new System.Drawing.Size(70, 20);
            this.percentOffset.TabIndex = 14;
            // 
            // triggerMethod
            // 
            this.triggerMethod.FormattingEnabled = true;
            this.triggerMethod.Location = new System.Drawing.Point(125, 142);
            this.triggerMethod.Name = "triggerMethod";
            this.triggerMethod.Size = new System.Drawing.Size(110, 21);
            this.triggerMethod.TabIndex = 12;
            // 
            // rule80A
            // 
            this.rule80A.FormattingEnabled = true;
            this.rule80A.Location = new System.Drawing.Point(125, 115);
            this.rule80A.Name = "rule80A";
            this.rule80A.Size = new System.Drawing.Size(110, 21);
            this.rule80A.TabIndex = 10;
            // 
            // goodUntil
            // 
            this.goodUntil.Location = new System.Drawing.Point(125, 91);
            this.goodUntil.Name = "goodUntil";
            this.goodUntil.Size = new System.Drawing.Size(70, 20);
            this.goodUntil.TabIndex = 8;
            // 
            // goodAfter
            // 
            this.goodAfter.Location = new System.Drawing.Point(125, 65);
            this.goodAfter.Name = "goodAfter";
            this.goodAfter.Size = new System.Drawing.Size(70, 20);
            this.goodAfter.TabIndex = 6;
            // 
            // minQty
            // 
            this.minQty.Location = new System.Drawing.Point(125, 39);
            this.minQty.Name = "minQty";
            this.minQty.Size = new System.Drawing.Size(70, 20);
            this.minQty.TabIndex = 4;
            // 
            // orderReference
            // 
            this.orderReference.Location = new System.Drawing.Point(125, 13);
            this.orderReference.Name = "orderReference";
            this.orderReference.Size = new System.Drawing.Size(70, 20);
            this.orderReference.TabIndex = 1;
            // 
            // advisorTab
            // 
            this.advisorTab.BackColor = System.Drawing.Color.LightGray;
            this.advisorTab.Controls.Add(this.faPercentage);
            this.advisorTab.Controls.Add(this.faProfile);
            this.advisorTab.Controls.Add(this.faMethod);
            this.advisorTab.Controls.Add(this.faGroup);
            this.advisorTab.Controls.Add(this.profileLabel);
            this.advisorTab.Controls.Add(this.orLabel);
            this.advisorTab.Controls.Add(this.percentageLabel);
            this.advisorTab.Controls.Add(this.methodLabel);
            this.advisorTab.Controls.Add(this.groupLabel);
            this.advisorTab.Location = new System.Drawing.Point(4, 22);
            this.advisorTab.Name = "advisorTab";
            this.advisorTab.Padding = new System.Windows.Forms.Padding(3);
            this.advisorTab.Size = new System.Drawing.Size(740, 364);
            this.advisorTab.TabIndex = 2;
            this.advisorTab.Text = "Advisor";
            // 
            // faPercentage
            // 
            this.faPercentage.Location = new System.Drawing.Point(76, 65);
            this.faPercentage.Name = "faPercentage";
            this.faPercentage.Size = new System.Drawing.Size(71, 20);
            this.faPercentage.TabIndex = 8;
            // 
            // faProfile
            // 
            this.faProfile.Location = new System.Drawing.Point(76, 117);
            this.faProfile.Name = "faProfile";
            this.faProfile.Size = new System.Drawing.Size(71, 20);
            this.faProfile.TabIndex = 7;
            // 
            // faMethod
            // 
            this.faMethod.FormattingEnabled = true;
            this.faMethod.Location = new System.Drawing.Point(76, 38);
            this.faMethod.Name = "faMethod";
            this.faMethod.Size = new System.Drawing.Size(96, 21);
            this.faMethod.TabIndex = 6;
            // 
            // faGroup
            // 
            this.faGroup.Location = new System.Drawing.Point(76, 12);
            this.faGroup.Name = "faGroup";
            this.faGroup.Size = new System.Drawing.Size(71, 20);
            this.faGroup.TabIndex = 5;
            // 
            // profileLabel
            // 
            this.profileLabel.AutoSize = true;
            this.profileLabel.Location = new System.Drawing.Point(34, 117);
            this.profileLabel.Name = "profileLabel";
            this.profileLabel.Size = new System.Drawing.Size(36, 13);
            this.profileLabel.TabIndex = 4;
            this.profileLabel.Text = "Profile";
            // 
            // orLabel
            // 
            this.orLabel.AutoSize = true;
            this.orLabel.Location = new System.Drawing.Point(42, 94);
            this.orLabel.Name = "orLabel";
            this.orLabel.Size = new System.Drawing.Size(28, 13);
            this.orLabel.TabIndex = 3;
            this.orLabel.Text = "--or--";
            // 
            // percentageLabel
            // 
            this.percentageLabel.AutoSize = true;
            this.percentageLabel.Location = new System.Drawing.Point(8, 68);
            this.percentageLabel.Name = "percentageLabel";
            this.percentageLabel.Size = new System.Drawing.Size(62, 13);
            this.percentageLabel.TabIndex = 2;
            this.percentageLabel.Text = "Percentage";
            // 
            // methodLabel
            // 
            this.methodLabel.AutoSize = true;
            this.methodLabel.Location = new System.Drawing.Point(27, 41);
            this.methodLabel.Name = "methodLabel";
            this.methodLabel.Size = new System.Drawing.Size(43, 13);
            this.methodLabel.TabIndex = 1;
            this.methodLabel.Text = "Method";
            // 
            // groupLabel
            // 
            this.groupLabel.AutoSize = true;
            this.groupLabel.Location = new System.Drawing.Point(34, 15);
            this.groupLabel.Name = "groupLabel";
            this.groupLabel.Size = new System.Drawing.Size(36, 13);
            this.groupLabel.TabIndex = 0;
            this.groupLabel.Text = "Group";
            // 
            // volatilityTab
            // 
            this.volatilityTab.BackColor = System.Drawing.Color.LightGray;
            this.volatilityTab.Controls.Add(this.stockRangeLower);
            this.volatilityTab.Controls.Add(this.stockRangeUpper);
            this.volatilityTab.Controls.Add(this.deltaNeutralConId);
            this.volatilityTab.Controls.Add(this.deltaNeutralAuxPrice);
            this.volatilityTab.Controls.Add(this.deltaNeutralOrderType);
            this.volatilityTab.Controls.Add(this.optionReferencePrice);
            this.volatilityTab.Controls.Add(this.volatilityType);
            this.volatilityTab.Controls.Add(this.volatility);
            this.volatilityTab.Controls.Add(this.continuousUpdate);
            this.volatilityTab.Controls.Add(this.stockRangeLowerLabel);
            this.volatilityTab.Controls.Add(this.sockRangeUpperLabel);
            this.volatilityTab.Controls.Add(this.hedgeContractConIdLabel);
            this.volatilityTab.Controls.Add(this.hedgeOrderAuxPriceLabel);
            this.volatilityTab.Controls.Add(this.hedgeOrderTypeLabel);
            this.volatilityTab.Controls.Add(this.optionReferencePriceLabel);
            this.volatilityTab.Controls.Add(this.volatilityLabel);
            this.volatilityTab.Location = new System.Drawing.Point(4, 22);
            this.volatilityTab.Name = "volatilityTab";
            this.volatilityTab.Padding = new System.Windows.Forms.Padding(3);
            this.volatilityTab.Size = new System.Drawing.Size(740, 364);
            this.volatilityTab.TabIndex = 3;
            this.volatilityTab.Text = "Volatility";
            // 
            // stockRangeLower
            // 
            this.stockRangeLower.Location = new System.Drawing.Point(161, 191);
            this.stockRangeLower.Name = "stockRangeLower";
            this.stockRangeLower.Size = new System.Drawing.Size(71, 20);
            this.stockRangeLower.TabIndex = 16;
            // 
            // stockRangeUpper
            // 
            this.stockRangeUpper.Location = new System.Drawing.Point(161, 165);
            this.stockRangeUpper.Name = "stockRangeUpper";
            this.stockRangeUpper.Size = new System.Drawing.Size(71, 20);
            this.stockRangeUpper.TabIndex = 15;
            // 
            // deltaNeutralConId
            // 
            this.deltaNeutralConId.Location = new System.Drawing.Point(161, 139);
            this.deltaNeutralConId.Name = "deltaNeutralConId";
            this.deltaNeutralConId.Size = new System.Drawing.Size(71, 20);
            this.deltaNeutralConId.TabIndex = 14;
            // 
            // deltaNeutralAuxPrice
            // 
            this.deltaNeutralAuxPrice.Location = new System.Drawing.Point(161, 113);
            this.deltaNeutralAuxPrice.Name = "deltaNeutralAuxPrice";
            this.deltaNeutralAuxPrice.Size = new System.Drawing.Size(71, 20);
            this.deltaNeutralAuxPrice.TabIndex = 13;
            // 
            // deltaNeutralOrderType
            // 
            this.deltaNeutralOrderType.FormattingEnabled = true;
            this.deltaNeutralOrderType.Items.AddRange(new object[] {
            "None",
            "MKT",
            "LMT",
            "STP",
            "STP LMT",
            "REL",
            "TRAIL",
            "BOX TOP",
            "FIX PEGGED",
            "LIT",
            "LMT + MKT",
            "LOC",
            "MIT",
            "MKT PRT",
            "MOC",
            "MTL",
            "PASSV REL",
            "PEG BENCH",
            "PEG BEST",
            "PEG MID",
            "PEG MKT",
            "PEG PRIM",
            "PEG STK",
            "REL +LMT",
            "REL + MKT",
            "STP PRT",
            "TRAIL LIMIT",
            "TRAIL LMT + MKT",
            "TRAIL LIT",
            "TRAIL REL + MKT",
            "TRAIL MIT",
            "TRAIL REL + MKT",
            "VOL",
            "VWAP"});
            this.deltaNeutralOrderType.Location = new System.Drawing.Point(161, 86);
            this.deltaNeutralOrderType.Name = "deltaNeutralOrderType";
            this.deltaNeutralOrderType.Size = new System.Drawing.Size(115, 21);
            this.deltaNeutralOrderType.TabIndex = 12;
            this.deltaNeutralOrderType.Text = "None";
            // 
            // optionReferencePrice
            // 
            this.optionReferencePrice.FormattingEnabled = true;
            this.optionReferencePrice.Location = new System.Drawing.Point(161, 59);
            this.optionReferencePrice.Name = "optionReferencePrice";
            this.optionReferencePrice.Size = new System.Drawing.Size(71, 21);
            this.optionReferencePrice.TabIndex = 11;
            // 
            // volatilityType
            // 
            this.volatilityType.FormattingEnabled = true;
            this.volatilityType.Location = new System.Drawing.Point(238, 10);
            this.volatilityType.Name = "volatilityType";
            this.volatilityType.Size = new System.Drawing.Size(71, 21);
            this.volatilityType.TabIndex = 10;
            // 
            // volatility
            // 
            this.volatility.Location = new System.Drawing.Point(161, 10);
            this.volatility.Name = "volatility";
            this.volatility.Size = new System.Drawing.Size(71, 20);
            this.volatility.TabIndex = 9;
            // 
            // continuousUpdate
            // 
            this.continuousUpdate.AutoSize = true;
            this.continuousUpdate.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.continuousUpdate.Location = new System.Drawing.Point(27, 36);
            this.continuousUpdate.Name = "continuousUpdate";
            this.continuousUpdate.Size = new System.Drawing.Size(148, 17);
            this.continuousUpdate.TabIndex = 8;
            this.continuousUpdate.Text = "Continuously update price";
            this.continuousUpdate.UseVisualStyleBackColor = true;
            // 
            // stockRangeLowerLabel
            // 
            this.stockRangeLowerLabel.AutoSize = true;
            this.stockRangeLowerLabel.Location = new System.Drawing.Point(56, 194);
            this.stockRangeLowerLabel.Name = "stockRangeLowerLabel";
            this.stockRangeLowerLabel.Size = new System.Drawing.Size(99, 13);
            this.stockRangeLowerLabel.TabIndex = 7;
            this.stockRangeLowerLabel.Text = "Stock range - lower";
            // 
            // sockRangeUpperLabel
            // 
            this.sockRangeUpperLabel.AutoSize = true;
            this.sockRangeUpperLabel.Location = new System.Drawing.Point(54, 168);
            this.sockRangeUpperLabel.Name = "sockRangeUpperLabel";
            this.sockRangeUpperLabel.Size = new System.Drawing.Size(101, 13);
            this.sockRangeUpperLabel.TabIndex = 6;
            this.sockRangeUpperLabel.Text = "Stock range - upper";
            // 
            // hedgeContractConIdLabel
            // 
            this.hedgeContractConIdLabel.AutoSize = true;
            this.hedgeContractConIdLabel.Location = new System.Drawing.Point(58, 142);
            this.hedgeContractConIdLabel.Name = "hedgeContractConIdLabel";
            this.hedgeContractConIdLabel.Size = new System.Drawing.Size(97, 13);
            this.hedgeContractConIdLabel.TabIndex = 5;
            this.hedgeContractConIdLabel.Text = "Delta neutral conId";
            // 
            // hedgeOrderAuxPriceLabel
            // 
            this.hedgeOrderAuxPriceLabel.AutoSize = true;
            this.hedgeOrderAuxPriceLabel.Location = new System.Drawing.Point(42, 116);
            this.hedgeOrderAuxPriceLabel.Name = "hedgeOrderAuxPriceLabel";
            this.hedgeOrderAuxPriceLabel.Size = new System.Drawing.Size(113, 13);
            this.hedgeOrderAuxPriceLabel.TabIndex = 4;
            this.hedgeOrderAuxPriceLabel.Text = "Delta neutral aux price";
            // 
            // hedgeOrderTypeLabel
            // 
            this.hedgeOrderTypeLabel.AutoSize = true;
            this.hedgeOrderTypeLabel.Location = new System.Drawing.Point(38, 89);
            this.hedgeOrderTypeLabel.Name = "hedgeOrderTypeLabel";
            this.hedgeOrderTypeLabel.Size = new System.Drawing.Size(117, 13);
            this.hedgeOrderTypeLabel.TabIndex = 3;
            this.hedgeOrderTypeLabel.Text = "Delta neutral order type";
            // 
            // optionReferencePriceLabel
            // 
            this.optionReferencePriceLabel.AutoSize = true;
            this.optionReferencePriceLabel.Location = new System.Drawing.Point(43, 62);
            this.optionReferencePriceLabel.Name = "optionReferencePriceLabel";
            this.optionReferencePriceLabel.Size = new System.Drawing.Size(112, 13);
            this.optionReferencePriceLabel.TabIndex = 2;
            this.optionReferencePriceLabel.Text = "Option reference price";
            // 
            // volatilityLabel
            // 
            this.volatilityLabel.AutoSize = true;
            this.volatilityLabel.Location = new System.Drawing.Point(110, 13);
            this.volatilityLabel.Name = "volatilityLabel";
            this.volatilityLabel.Size = new System.Drawing.Size(45, 13);
            this.volatilityLabel.TabIndex = 0;
            this.volatilityLabel.Text = "Volatility";
            // 
            // scaleTab
            // 
            this.scaleTab.BackColor = System.Drawing.Color.LightGray;
            this.scaleTab.Controls.Add(this.priceAdjustInterval);
            this.scaleTab.Controls.Add(this.priceAdjustValue);
            this.scaleTab.Controls.Add(this.initialFillQuantity);
            this.scaleTab.Controls.Add(this.initialPosition);
            this.scaleTab.Controls.Add(this.priceIncrement);
            this.scaleTab.Controls.Add(this.profitOffset);
            this.scaleTab.Controls.Add(this.subsequentLevelSize);
            this.scaleTab.Controls.Add(this.initialLevelSize);
            this.scaleTab.Controls.Add(this.autoReset);
            this.scaleTab.Controls.Add(this.randomiseSize);
            this.scaleTab.Controls.Add(this.secondsLabel);
            this.scaleTab.Controls.Add(this.initialPositionLabel);
            this.scaleTab.Controls.Add(this.initialFillQuantityLabel);
            this.scaleTab.Controls.Add(this.everyLabel);
            this.scaleTab.Controls.Add(this.priceAdjustValueLabel);
            this.scaleTab.Controls.Add(this.subsequentLevelSizeLabel);
            this.scaleTab.Controls.Add(this.profitOffsetLabel);
            this.scaleTab.Controls.Add(this.priceIncrementLabel);
            this.scaleTab.Controls.Add(this.initialLevelSizeLabel);
            this.scaleTab.Location = new System.Drawing.Point(4, 22);
            this.scaleTab.Name = "scaleTab";
            this.scaleTab.Padding = new System.Windows.Forms.Padding(3);
            this.scaleTab.Size = new System.Drawing.Size(740, 364);
            this.scaleTab.TabIndex = 4;
            this.scaleTab.Text = "Scale";
            // 
            // priceAdjustInterval
            // 
            this.priceAdjustInterval.Location = new System.Drawing.Point(244, 214);
            this.priceAdjustInterval.Name = "priceAdjustInterval";
            this.priceAdjustInterval.Size = new System.Drawing.Size(70, 20);
            this.priceAdjustInterval.TabIndex = 18;
            // 
            // priceAdjustValue
            // 
            this.priceAdjustValue.Location = new System.Drawing.Point(129, 214);
            this.priceAdjustValue.Name = "priceAdjustValue";
            this.priceAdjustValue.Size = new System.Drawing.Size(70, 20);
            this.priceAdjustValue.TabIndex = 17;
            // 
            // initialFillQuantity
            // 
            this.initialFillQuantity.Location = new System.Drawing.Point(129, 188);
            this.initialFillQuantity.Name = "initialFillQuantity";
            this.initialFillQuantity.Size = new System.Drawing.Size(70, 20);
            this.initialFillQuantity.TabIndex = 16;
            // 
            // initialPosition
            // 
            this.initialPosition.Location = new System.Drawing.Point(129, 162);
            this.initialPosition.Name = "initialPosition";
            this.initialPosition.Size = new System.Drawing.Size(70, 20);
            this.initialPosition.TabIndex = 15;
            // 
            // priceIncrement
            // 
            this.priceIncrement.Location = new System.Drawing.Point(129, 87);
            this.priceIncrement.Name = "priceIncrement";
            this.priceIncrement.Size = new System.Drawing.Size(70, 20);
            this.priceIncrement.TabIndex = 14;
            // 
            // profitOffset
            // 
            this.profitOffset.Location = new System.Drawing.Point(129, 113);
            this.profitOffset.Name = "profitOffset";
            this.profitOffset.Size = new System.Drawing.Size(70, 20);
            this.profitOffset.TabIndex = 13;
            // 
            // subsequentLevelSize
            // 
            this.subsequentLevelSize.Location = new System.Drawing.Point(129, 38);
            this.subsequentLevelSize.Name = "subsequentLevelSize";
            this.subsequentLevelSize.Size = new System.Drawing.Size(70, 20);
            this.subsequentLevelSize.TabIndex = 12;
            // 
            // initialLevelSize
            // 
            this.initialLevelSize.Location = new System.Drawing.Point(129, 12);
            this.initialLevelSize.Name = "initialLevelSize";
            this.initialLevelSize.Size = new System.Drawing.Size(70, 20);
            this.initialLevelSize.TabIndex = 11;
            // 
            // autoReset
            // 
            this.autoReset.AutoSize = true;
            this.autoReset.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.autoReset.Location = new System.Drawing.Point(68, 139);
            this.autoReset.Name = "autoReset";
            this.autoReset.Size = new System.Drawing.Size(74, 17);
            this.autoReset.TabIndex = 10;
            this.autoReset.Text = "Auto-reset";
            this.autoReset.UseVisualStyleBackColor = true;
            // 
            // randomiseSize
            // 
            this.randomiseSize.AutoSize = true;
            this.randomiseSize.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.randomiseSize.Location = new System.Drawing.Point(42, 64);
            this.randomiseSize.Name = "randomiseSize";
            this.randomiseSize.Size = new System.Drawing.Size(100, 17);
            this.randomiseSize.TabIndex = 9;
            this.randomiseSize.Text = "Randomise size";
            this.randomiseSize.UseVisualStyleBackColor = true;
            // 
            // secondsLabel
            // 
            this.secondsLabel.AutoSize = true;
            this.secondsLabel.Location = new System.Drawing.Point(320, 217);
            this.secondsLabel.Name = "secondsLabel";
            this.secondsLabel.Size = new System.Drawing.Size(47, 13);
            this.secondsLabel.TabIndex = 8;
            this.secondsLabel.Text = "seconds";
            // 
            // initialPositionLabel
            // 
            this.initialPositionLabel.AutoSize = true;
            this.initialPositionLabel.Location = new System.Drawing.Point(53, 165);
            this.initialPositionLabel.Name = "initialPositionLabel";
            this.initialPositionLabel.Size = new System.Drawing.Size(70, 13);
            this.initialPositionLabel.TabIndex = 7;
            this.initialPositionLabel.Text = "Initial position";
            // 
            // initialFillQuantityLabel
            // 
            this.initialFillQuantityLabel.AutoSize = true;
            this.initialFillQuantityLabel.Location = new System.Drawing.Point(40, 191);
            this.initialFillQuantityLabel.Name = "initialFillQuantityLabel";
            this.initialFillQuantityLabel.Size = new System.Drawing.Size(83, 13);
            this.initialFillQuantityLabel.TabIndex = 6;
            this.initialFillQuantityLabel.Text = "Initial fill quantity";
            // 
            // everyLabel
            // 
            this.everyLabel.AutoSize = true;
            this.everyLabel.Location = new System.Drawing.Point(205, 217);
            this.everyLabel.Name = "everyLabel";
            this.everyLabel.Size = new System.Drawing.Size(33, 13);
            this.everyLabel.TabIndex = 5;
            this.everyLabel.Text = "every";
            // 
            // priceAdjustValueLabel
            // 
            this.priceAdjustValueLabel.AutoSize = true;
            this.priceAdjustValueLabel.Location = new System.Drawing.Point(32, 217);
            this.priceAdjustValueLabel.Name = "priceAdjustValueLabel";
            this.priceAdjustValueLabel.Size = new System.Drawing.Size(91, 13);
            this.priceAdjustValueLabel.TabIndex = 4;
            this.priceAdjustValueLabel.Text = "Price adjust value";
            // 
            // subsequentLevelSizeLabel
            // 
            this.subsequentLevelSizeLabel.AutoSize = true;
            this.subsequentLevelSizeLabel.Location = new System.Drawing.Point(13, 41);
            this.subsequentLevelSizeLabel.Name = "subsequentLevelSizeLabel";
            this.subsequentLevelSizeLabel.Size = new System.Drawing.Size(110, 13);
            this.subsequentLevelSizeLabel.TabIndex = 3;
            this.subsequentLevelSizeLabel.Text = "Subsequent level size";
            // 
            // profitOffsetLabel
            // 
            this.profitOffsetLabel.AutoSize = true;
            this.profitOffsetLabel.Location = new System.Drawing.Point(61, 116);
            this.profitOffsetLabel.Name = "profitOffsetLabel";
            this.profitOffsetLabel.Size = new System.Drawing.Size(62, 13);
            this.profitOffsetLabel.TabIndex = 2;
            this.profitOffsetLabel.Text = "Profit Offset";
            // 
            // priceIncrementLabel
            // 
            this.priceIncrementLabel.AutoSize = true;
            this.priceIncrementLabel.Location = new System.Drawing.Point(43, 90);
            this.priceIncrementLabel.Name = "priceIncrementLabel";
            this.priceIncrementLabel.Size = new System.Drawing.Size(80, 13);
            this.priceIncrementLabel.TabIndex = 1;
            this.priceIncrementLabel.Text = "Price increment";
            // 
            // initialLevelSizeLabel
            // 
            this.initialLevelSizeLabel.AutoSize = true;
            this.initialLevelSizeLabel.Location = new System.Drawing.Point(46, 19);
            this.initialLevelSizeLabel.Name = "initialLevelSizeLabel";
            this.initialLevelSizeLabel.Size = new System.Drawing.Size(77, 13);
            this.initialLevelSizeLabel.TabIndex = 0;
            this.initialLevelSizeLabel.Text = "Initial level size";
            // 
            // algoTab
            // 
            this.algoTab.BackColor = System.Drawing.Color.LightGray;
            this.algoTab.Controls.Add(this.useOddLots);
            this.algoTab.Controls.Add(this.noTradeAhead);
            this.algoTab.Controls.Add(this.getDone);
            this.algoTab.Controls.Add(this.displaySizeAlgo);
            this.algoTab.Controls.Add(this.forceCompletion);
            this.algoTab.Controls.Add(this.riskAversion);
            this.algoTab.Controls.Add(this.noTakeLiq);
            this.algoTab.Controls.Add(this.strategyType);
            this.algoTab.Controls.Add(this.pctVol);
            this.algoTab.Controls.Add(this.maxPctVol);
            this.algoTab.Controls.Add(this.allowPastEndTime);
            this.algoTab.Controls.Add(this.endTime);
            this.algoTab.Controls.Add(this.startTime);
            this.algoTab.Controls.Add(this.useOddLotsLabel);
            this.algoTab.Controls.Add(this.noTradeAheadLabel);
            this.algoTab.Controls.Add(this.getDoneLabel);
            this.algoTab.Controls.Add(this.displaySizeAlgoLabel);
            this.algoTab.Controls.Add(this.forceCompletionLabel);
            this.algoTab.Controls.Add(this.riskAversionLabel);
            this.algoTab.Controls.Add(this.noTakeLiqLabel);
            this.algoTab.Controls.Add(this.strategyTypeLabel);
            this.algoTab.Controls.Add(this.pctVolLabel);
            this.algoTab.Controls.Add(this.maxPctVolLabel);
            this.algoTab.Controls.Add(this.allowPastEndTimeLabel);
            this.algoTab.Controls.Add(this.endTimeLabel);
            this.algoTab.Controls.Add(this.startTimeLabel);
            this.algoTab.Controls.Add(this.algoStrategy);
            this.algoTab.Controls.Add(this.algoStrategyLabel);
            this.algoTab.Location = new System.Drawing.Point(4, 22);
            this.algoTab.Name = "algoTab";
            this.algoTab.Padding = new System.Windows.Forms.Padding(3);
            this.algoTab.Size = new System.Drawing.Size(740, 364);
            this.algoTab.TabIndex = 5;
            this.algoTab.Text = "IB Algo";
            // 
            // useOddLots
            // 
            this.useOddLots.Enabled = false;
            this.useOddLots.Location = new System.Drawing.Point(322, 175);
            this.useOddLots.Name = "useOddLots";
            this.useOddLots.Size = new System.Drawing.Size(70, 20);
            this.useOddLots.TabIndex = 27;
            // 
            // noTradeAhead
            // 
            this.noTradeAhead.Enabled = false;
            this.noTradeAhead.Location = new System.Drawing.Point(322, 149);
            this.noTradeAhead.Name = "noTradeAhead";
            this.noTradeAhead.Size = new System.Drawing.Size(70, 20);
            this.noTradeAhead.TabIndex = 26;
            // 
            // getDone
            // 
            this.getDone.Enabled = false;
            this.getDone.Location = new System.Drawing.Point(322, 123);
            this.getDone.Name = "getDone";
            this.getDone.Size = new System.Drawing.Size(70, 20);
            this.getDone.TabIndex = 25;
            // 
            // displaySizeAlgo
            // 
            this.displaySizeAlgo.Enabled = false;
            this.displaySizeAlgo.Location = new System.Drawing.Point(322, 97);
            this.displaySizeAlgo.Name = "displaySizeAlgo";
            this.displaySizeAlgo.Size = new System.Drawing.Size(70, 20);
            this.displaySizeAlgo.TabIndex = 24;
            // 
            // forceCompletion
            // 
            this.forceCompletion.Enabled = false;
            this.forceCompletion.Location = new System.Drawing.Point(322, 71);
            this.forceCompletion.Name = "forceCompletion";
            this.forceCompletion.Size = new System.Drawing.Size(70, 20);
            this.forceCompletion.TabIndex = 23;
            // 
            // riskAversion
            // 
            this.riskAversion.Enabled = false;
            this.riskAversion.Location = new System.Drawing.Point(322, 45);
            this.riskAversion.Name = "riskAversion";
            this.riskAversion.Size = new System.Drawing.Size(70, 20);
            this.riskAversion.TabIndex = 22;
            // 
            // noTakeLiq
            // 
            this.noTakeLiq.Enabled = false;
            this.noTakeLiq.Location = new System.Drawing.Point(322, 19);
            this.noTakeLiq.Name = "noTakeLiq";
            this.noTakeLiq.Size = new System.Drawing.Size(70, 20);
            this.noTakeLiq.TabIndex = 21;
            // 
            // strategyType
            // 
            this.strategyType.Enabled = false;
            this.strategyType.Location = new System.Drawing.Point(125, 175);
            this.strategyType.Name = "strategyType";
            this.strategyType.Size = new System.Drawing.Size(70, 20);
            this.strategyType.TabIndex = 20;
            // 
            // pctVol
            // 
            this.pctVol.Enabled = false;
            this.pctVol.Location = new System.Drawing.Point(125, 149);
            this.pctVol.Name = "pctVol";
            this.pctVol.Size = new System.Drawing.Size(70, 20);
            this.pctVol.TabIndex = 19;
            // 
            // maxPctVol
            // 
            this.maxPctVol.Enabled = false;
            this.maxPctVol.Location = new System.Drawing.Point(125, 123);
            this.maxPctVol.Name = "maxPctVol";
            this.maxPctVol.Size = new System.Drawing.Size(70, 20);
            this.maxPctVol.TabIndex = 18;
            // 
            // allowPastEndTime
            // 
            this.allowPastEndTime.Enabled = false;
            this.allowPastEndTime.Location = new System.Drawing.Point(125, 97);
            this.allowPastEndTime.Name = "allowPastEndTime";
            this.allowPastEndTime.Size = new System.Drawing.Size(70, 20);
            this.allowPastEndTime.TabIndex = 17;
            // 
            // endTime
            // 
            this.endTime.Enabled = false;
            this.endTime.Location = new System.Drawing.Point(125, 71);
            this.endTime.Name = "endTime";
            this.endTime.Size = new System.Drawing.Size(70, 20);
            this.endTime.TabIndex = 16;
            // 
            // startTime
            // 
            this.startTime.Enabled = false;
            this.startTime.Location = new System.Drawing.Point(125, 45);
            this.startTime.Name = "startTime";
            this.startTime.Size = new System.Drawing.Size(70, 20);
            this.startTime.TabIndex = 15;
            // 
            // useOddLotsLabel
            // 
            this.useOddLotsLabel.AutoSize = true;
            this.useOddLotsLabel.Location = new System.Drawing.Point(250, 175);
            this.useOddLotsLabel.Name = "useOddLotsLabel";
            this.useOddLotsLabel.Size = new System.Drawing.Size(66, 13);
            this.useOddLotsLabel.TabIndex = 14;
            this.useOddLotsLabel.Text = "Use odd lots";
            // 
            // noTradeAheadLabel
            // 
            this.noTradeAheadLabel.AutoSize = true;
            this.noTradeAheadLabel.Location = new System.Drawing.Point(235, 149);
            this.noTradeAheadLabel.Name = "noTradeAheadLabel";
            this.noTradeAheadLabel.Size = new System.Drawing.Size(81, 13);
            this.noTradeAheadLabel.TabIndex = 13;
            this.noTradeAheadLabel.Text = "No trade ahead";
            // 
            // getDoneLabel
            // 
            this.getDoneLabel.AutoSize = true;
            this.getDoneLabel.Location = new System.Drawing.Point(265, 123);
            this.getDoneLabel.Name = "getDoneLabel";
            this.getDoneLabel.Size = new System.Drawing.Size(51, 13);
            this.getDoneLabel.TabIndex = 12;
            this.getDoneLabel.Text = "Get done";
            // 
            // displaySizeAlgoLabel
            // 
            this.displaySizeAlgoLabel.AutoSize = true;
            this.displaySizeAlgoLabel.Location = new System.Drawing.Point(254, 97);
            this.displaySizeAlgoLabel.Name = "displaySizeAlgoLabel";
            this.displaySizeAlgoLabel.Size = new System.Drawing.Size(62, 13);
            this.displaySizeAlgoLabel.TabIndex = 11;
            this.displaySizeAlgoLabel.Text = "Display size";
            // 
            // forceCompletionLabel
            // 
            this.forceCompletionLabel.AutoSize = true;
            this.forceCompletionLabel.Location = new System.Drawing.Point(228, 71);
            this.forceCompletionLabel.Name = "forceCompletionLabel";
            this.forceCompletionLabel.Size = new System.Drawing.Size(88, 13);
            this.forceCompletionLabel.TabIndex = 10;
            this.forceCompletionLabel.Text = "Force completion";
            // 
            // riskAversionLabel
            // 
            this.riskAversionLabel.AutoSize = true;
            this.riskAversionLabel.Location = new System.Drawing.Point(245, 45);
            this.riskAversionLabel.Name = "riskAversionLabel";
            this.riskAversionLabel.Size = new System.Drawing.Size(71, 13);
            this.riskAversionLabel.TabIndex = 9;
            this.riskAversionLabel.Text = "Risk aversion";
            // 
            // noTakeLiqLabel
            // 
            this.noTakeLiqLabel.AutoSize = true;
            this.noTakeLiqLabel.Location = new System.Drawing.Point(255, 18);
            this.noTakeLiqLabel.Name = "noTakeLiqLabel";
            this.noTakeLiqLabel.Size = new System.Drawing.Size(61, 13);
            this.noTakeLiqLabel.TabIndex = 8;
            this.noTakeLiqLabel.Text = "No take liq.";
            // 
            // strategyTypeLabel
            // 
            this.strategyTypeLabel.AutoSize = true;
            this.strategyTypeLabel.Location = new System.Drawing.Point(36, 175);
            this.strategyTypeLabel.Name = "strategyTypeLabel";
            this.strategyTypeLabel.Size = new System.Drawing.Size(69, 13);
            this.strategyTypeLabel.TabIndex = 7;
            this.strategyTypeLabel.Text = "Strategy type";
            // 
            // pctVolLabel
            // 
            this.pctVolLabel.AutoSize = true;
            this.pctVolLabel.Location = new System.Drawing.Point(59, 149);
            this.pctVolLabel.Name = "pctVolLabel";
            this.pctVolLabel.Size = new System.Drawing.Size(46, 13);
            this.pctVolLabel.TabIndex = 6;
            this.pctVolLabel.Text = "Pct. vol.";
            // 
            // maxPctVolLabel
            // 
            this.maxPctVolLabel.AutoSize = true;
            this.maxPctVolLabel.Location = new System.Drawing.Point(35, 123);
            this.maxPctVolLabel.Name = "maxPctVolLabel";
            this.maxPctVolLabel.Size = new System.Drawing.Size(70, 13);
            this.maxPctVolLabel.TabIndex = 5;
            this.maxPctVolLabel.Text = "Max Pct. Vol.";
            // 
            // allowPastEndTimeLabel
            // 
            this.allowPastEndTimeLabel.AutoSize = true;
            this.allowPastEndTimeLabel.Location = new System.Drawing.Point(7, 97);
            this.allowPastEndTimeLabel.Name = "allowPastEndTimeLabel";
            this.allowPastEndTimeLabel.Size = new System.Drawing.Size(98, 13);
            this.allowPastEndTimeLabel.TabIndex = 4;
            this.allowPastEndTimeLabel.Text = "Allow past end time";
            // 
            // endTimeLabel
            // 
            this.endTimeLabel.AutoSize = true;
            this.endTimeLabel.Location = new System.Drawing.Point(57, 71);
            this.endTimeLabel.Name = "endTimeLabel";
            this.endTimeLabel.Size = new System.Drawing.Size(48, 13);
            this.endTimeLabel.TabIndex = 3;
            this.endTimeLabel.Text = "End time";
            // 
            // startTimeLabel
            // 
            this.startTimeLabel.AutoSize = true;
            this.startTimeLabel.Location = new System.Drawing.Point(54, 45);
            this.startTimeLabel.Name = "startTimeLabel";
            this.startTimeLabel.Size = new System.Drawing.Size(51, 13);
            this.startTimeLabel.TabIndex = 2;
            this.startTimeLabel.Text = "Start time";
            // 
            // algoStrategy
            // 
            this.algoStrategy.FormattingEnabled = true;
            this.algoStrategy.Items.AddRange(new object[] {
            "None",
            "Vwap",
            "Twap",
            "ArrivalPx",
            "DarkIce",
            "PctVol"});
            this.algoStrategy.Location = new System.Drawing.Point(125, 18);
            this.algoStrategy.Name = "algoStrategy";
            this.algoStrategy.Size = new System.Drawing.Size(70, 21);
            this.algoStrategy.TabIndex = 1;
            this.algoStrategy.Text = "None";
            this.algoStrategy.SelectedIndexChanged += new System.EventHandler(this.AlgoStrategy_SelectedIndexChanged);
            // 
            // algoStrategyLabel
            // 
            this.algoStrategyLabel.AutoSize = true;
            this.algoStrategyLabel.Location = new System.Drawing.Point(37, 18);
            this.algoStrategyLabel.Name = "algoStrategyLabel";
            this.algoStrategyLabel.Size = new System.Drawing.Size(68, 13);
            this.algoStrategyLabel.TabIndex = 0;
            this.algoStrategyLabel.Text = "Algo strategy";
            // 
            // peg2benchTab
            // 
            this.peg2benchTab.BackColor = System.Drawing.Color.LightGray;
            this.peg2benchTab.Controls.Add(this.pgdStockRangeLower);
            this.peg2benchTab.Controls.Add(this.pgdStockRangeUpper);
            this.peg2benchTab.Controls.Add(this.label20);
            this.peg2benchTab.Controls.Add(this.label21);
            this.peg2benchTab.Controls.Add(this.cbPeggedChangeType);
            this.peg2benchTab.Controls.Add(this.tbReferenceChangeAmount);
            this.peg2benchTab.Controls.Add(this.tbPeggedChangeAmount);
            this.peg2benchTab.Controls.Add(this.tbStartingReferencePrice);
            this.peg2benchTab.Controls.Add(this.label10);
            this.peg2benchTab.Controls.Add(this.label9);
            this.peg2benchTab.Controls.Add(this.label8);
            this.peg2benchTab.Controls.Add(this.label7);
            this.peg2benchTab.Controls.Add(this.label6);
            this.peg2benchTab.Controls.Add(this.tbStartingPrice);
            this.peg2benchTab.Controls.Add(this.label4);
            this.peg2benchTab.Location = new System.Drawing.Point(4, 22);
            this.peg2benchTab.Name = "peg2benchTab";
            this.peg2benchTab.Size = new System.Drawing.Size(740, 364);
            this.peg2benchTab.TabIndex = 6;
            this.peg2benchTab.Text = "Pegged to Benchmark";
            // 
            // pgdStockRangeLower
            // 
            this.pgdStockRangeLower.Location = new System.Drawing.Point(149, 185);
            this.pgdStockRangeLower.Name = "pgdStockRangeLower";
            this.pgdStockRangeLower.Size = new System.Drawing.Size(206, 20);
            this.pgdStockRangeLower.TabIndex = 20;
            // 
            // pgdStockRangeUpper
            // 
            this.pgdStockRangeUpper.Location = new System.Drawing.Point(149, 159);
            this.pgdStockRangeUpper.Name = "pgdStockRangeUpper";
            this.pgdStockRangeUpper.Size = new System.Drawing.Size(206, 20);
            this.pgdStockRangeUpper.TabIndex = 19;
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(7, 188);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(99, 13);
            this.label20.TabIndex = 18;
            this.label20.Text = "Stock range - lower";
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(7, 162);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(101, 13);
            this.label21.TabIndex = 17;
            this.label21.Text = "Stock range - upper";
            // 
            // cbPeggedChangeType
            // 
            this.cbPeggedChangeType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbPeggedChangeType.FormattingEnabled = true;
            this.cbPeggedChangeType.Items.AddRange(new object[] {
            "Increase",
            "Decrease"});
            this.cbPeggedChangeType.Location = new System.Drawing.Point(149, 107);
            this.cbPeggedChangeType.Name = "cbPeggedChangeType";
            this.cbPeggedChangeType.Size = new System.Drawing.Size(208, 21);
            this.cbPeggedChangeType.TabIndex = 10;
            // 
            // tbReferenceChangeAmount
            // 
            this.tbReferenceChangeAmount.Location = new System.Drawing.Point(149, 133);
            this.tbReferenceChangeAmount.Name = "tbReferenceChangeAmount";
            this.tbReferenceChangeAmount.Size = new System.Drawing.Size(208, 20);
            this.tbReferenceChangeAmount.TabIndex = 9;
            // 
            // tbPeggedChangeAmount
            // 
            this.tbPeggedChangeAmount.Location = new System.Drawing.Point(149, 81);
            this.tbPeggedChangeAmount.Name = "tbPeggedChangeAmount";
            this.tbPeggedChangeAmount.Size = new System.Drawing.Size(208, 20);
            this.tbPeggedChangeAmount.TabIndex = 8;
            // 
            // tbStartingReferencePrice
            // 
            this.tbStartingReferencePrice.Location = new System.Drawing.Point(149, 55);
            this.tbStartingReferencePrice.Name = "tbStartingReferencePrice";
            this.tbStartingReferencePrice.Size = new System.Drawing.Size(208, 20);
            this.tbStartingReferencePrice.TabIndex = 7;
            // 
            // label10
            // 
            this.label10.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(7, 136);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(134, 13);
            this.label10.TabIndex = 6;
            this.label10.Text = "Reference change amount";
            // 
            // label9
            // 
            this.label9.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(7, 110);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(106, 13);
            this.label9.TabIndex = 5;
            this.label9.Text = "Pegged change type";
            // 
            // label8
            // 
            this.label8.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(7, 84);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(121, 13);
            this.label8.TabIndex = 4;
            this.label8.Text = "Pegged change amount";
            // 
            // label7
            // 
            this.label7.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(7, 58);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(117, 13);
            this.label7.TabIndex = 3;
            this.label7.Text = "Starting reference price";
            // 
            // label6
            // 
            this.label6.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(7, 32);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(99, 13);
            this.label6.TabIndex = 2;
            this.label6.Text = "Reference contract";
            // 
            // tbStartingPrice
            // 
            this.tbStartingPrice.Location = new System.Drawing.Point(149, 3);
            this.tbStartingPrice.Name = "tbStartingPrice";
            this.tbStartingPrice.Size = new System.Drawing.Size(208, 20);
            this.tbStartingPrice.TabIndex = 1;
            // 
            // label4
            // 
            this.label4.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(7, 6);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(69, 13);
            this.label4.TabIndex = 0;
            this.label4.Text = "Starting price";
            // 
            // adjustStopTab
            // 
            this.adjustStopTab.BackColor = System.Drawing.Color.LightGray;
            this.adjustStopTab.Controls.Add(this.label16);
            this.adjustStopTab.Controls.Add(this.cbAdjustedTrailingAmntUnit);
            this.adjustStopTab.Controls.Add(this.tbAdjustedTrailingAmnt);
            this.adjustStopTab.Controls.Add(this.label15);
            this.adjustStopTab.Controls.Add(this.tbAdjustedStopLimitPrice);
            this.adjustStopTab.Controls.Add(this.label14);
            this.adjustStopTab.Controls.Add(this.tbAdjustedStopPrice);
            this.adjustStopTab.Controls.Add(this.label13);
            this.adjustStopTab.Controls.Add(this.tbTriggerPrice);
            this.adjustStopTab.Controls.Add(this.label12);
            this.adjustStopTab.Controls.Add(this.cbAdjustedOrderType);
            this.adjustStopTab.Controls.Add(this.label11);
            this.adjustStopTab.Location = new System.Drawing.Point(4, 22);
            this.adjustStopTab.Name = "adjustStopTab";
            this.adjustStopTab.Size = new System.Drawing.Size(740, 364);
            this.adjustStopTab.TabIndex = 7;
            this.adjustStopTab.Text = "Adjustable stops";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(14, 137);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(139, 13);
            this.label16.TabIndex = 11;
            this.label16.Text = "Adjusted trailing amount unit";
            // 
            // cbAdjustedTrailingAmntUnit
            // 
            this.cbAdjustedTrailingAmntUnit.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbAdjustedTrailingAmntUnit.FormattingEnabled = true;
            this.cbAdjustedTrailingAmntUnit.Items.AddRange(new object[] {
            "amonunt",
            "%"});
            this.cbAdjustedTrailingAmntUnit.Location = new System.Drawing.Point(163, 134);
            this.cbAdjustedTrailingAmntUnit.Name = "cbAdjustedTrailingAmntUnit";
            this.cbAdjustedTrailingAmntUnit.Size = new System.Drawing.Size(121, 21);
            this.cbAdjustedTrailingAmntUnit.TabIndex = 7;
            // 
            // tbAdjustedTrailingAmnt
            // 
            this.tbAdjustedTrailingAmnt.Location = new System.Drawing.Point(163, 108);
            this.tbAdjustedTrailingAmnt.Name = "tbAdjustedTrailingAmnt";
            this.tbAdjustedTrailingAmnt.Size = new System.Drawing.Size(121, 20);
            this.tbAdjustedTrailingAmnt.TabIndex = 6;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(14, 111);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(119, 13);
            this.label15.TabIndex = 8;
            this.label15.Text = "Adjusted trailing amount";
            // 
            // tbAdjustedStopLimitPrice
            // 
            this.tbAdjustedStopLimitPrice.Location = new System.Drawing.Point(163, 82);
            this.tbAdjustedStopLimitPrice.Name = "tbAdjustedStopLimitPrice";
            this.tbAdjustedStopLimitPrice.Size = new System.Drawing.Size(121, 20);
            this.tbAdjustedStopLimitPrice.TabIndex = 5;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(14, 85);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(115, 13);
            this.label14.TabIndex = 6;
            this.label14.Text = "Adusted stop limit price";
            // 
            // tbAdjustedStopPrice
            // 
            this.tbAdjustedStopPrice.Location = new System.Drawing.Point(163, 56);
            this.tbAdjustedStopPrice.Name = "tbAdjustedStopPrice";
            this.tbAdjustedStopPrice.Size = new System.Drawing.Size(121, 20);
            this.tbAdjustedStopPrice.TabIndex = 4;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(14, 59);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(97, 13);
            this.label13.TabIndex = 4;
            this.label13.Text = "Adjusted stop price";
            // 
            // tbTriggerPrice
            // 
            this.tbTriggerPrice.Location = new System.Drawing.Point(163, 30);
            this.tbTriggerPrice.Name = "tbTriggerPrice";
            this.tbTriggerPrice.Size = new System.Drawing.Size(121, 20);
            this.tbTriggerPrice.TabIndex = 3;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(14, 6);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(98, 13);
            this.label12.TabIndex = 2;
            this.label12.Text = "Adjust to order type";
            // 
            // cbAdjustedOrderType
            // 
            this.cbAdjustedOrderType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cbAdjustedOrderType.FormattingEnabled = true;
            this.cbAdjustedOrderType.Items.AddRange(new object[] {
            "",
            "STP",
            "STP LMT",
            "TRAIL",
            "TRAIL LIMIT"});
            this.cbAdjustedOrderType.Location = new System.Drawing.Point(163, 3);
            this.cbAdjustedOrderType.Name = "cbAdjustedOrderType";
            this.cbAdjustedOrderType.Size = new System.Drawing.Size(121, 21);
            this.cbAdjustedOrderType.TabIndex = 2;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(14, 33);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(66, 13);
            this.label11.TabIndex = 0;
            this.label11.Text = "Trigger price";
            // 
            // tabPage1
            // 
            this.tabPage1.BackColor = System.Drawing.Color.LightGray;
            this.tabPage1.Controls.Add(this.ignoreRth);
            this.tabPage1.Controls.Add(this.cancelOrder);
            this.tabPage1.Controls.Add(this.conditionList);
            this.tabPage1.Controls.Add(this.lbAddCondition);
            this.tabPage1.Controls.Add(this.lbRemoveCondition);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Size = new System.Drawing.Size(740, 364);
            this.tabPage1.TabIndex = 8;
            this.tabPage1.Text = "Conditions";
            // 
            // ignoreRth
            // 
            this.ignoreRth.AutoSize = true;
            this.ignoreRth.Location = new System.Drawing.Point(134, 293);
            this.ignoreRth.Name = "ignoreRth";
            this.ignoreRth.Size = new System.Drawing.Size(402, 17);
            this.ignoreRth.TabIndex = 13;
            this.ignoreRth.Text = "Allow condition to be satisfied and activate order outside of regular trading hou" +
    "rs";
            this.ignoreRth.UseVisualStyleBackColor = true;
            // 
            // cancelOrder
            // 
            this.cancelOrder.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.cancelOrder.FormattingEnabled = true;
            this.cancelOrder.Items.AddRange(new object[] {
            "Submit order",
            "Cancel order"});
            this.cancelOrder.Location = new System.Drawing.Point(7, 289);
            this.cancelOrder.Name = "cancelOrder";
            this.cancelOrder.Size = new System.Drawing.Size(121, 21);
            this.cancelOrder.TabIndex = 4;
            // 
            // conditionList
            // 
            this.conditionList.AllowUserToAddRows = false;
            this.conditionList.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.DisplayedCells;
            this.conditionList.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.conditionList.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.Description,
            this.Logic});
            this.conditionList.Dock = System.Windows.Forms.DockStyle.Top;
            this.conditionList.Location = new System.Drawing.Point(0, 0);
            this.conditionList.Name = "conditionList";
            this.conditionList.Size = new System.Drawing.Size(740, 283);
            this.conditionList.TabIndex = 3;
            this.conditionList.CellDoubleClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.conditionList_CellDoubleClick);
            // 
            // Description
            // 
            this.Description.HeaderText = "Description";
            this.Description.Name = "Description";
            this.Description.ReadOnly = true;
            this.Description.Width = 85;
            // 
            // Logic
            // 
            this.Logic.HeaderText = "Logic";
            this.Logic.Items.AddRange(new object[] {
            "and",
            "or"});
            this.Logic.Name = "Logic";
            this.Logic.Width = 39;
            // 
            // lbAddCondition
            // 
            this.lbAddCondition.AutoSize = true;
            this.lbAddCondition.Location = new System.Drawing.Point(542, 294);
            this.lbAddCondition.Name = "lbAddCondition";
            this.lbAddCondition.Size = new System.Drawing.Size(25, 13);
            this.lbAddCondition.TabIndex = 1;
            this.lbAddCondition.TabStop = true;
            this.lbAddCondition.Text = "add";
            this.lbAddCondition.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbAddCondition_LinkClicked);
            // 
            // lbRemoveCondition
            // 
            this.lbRemoveCondition.AutoSize = true;
            this.lbRemoveCondition.Location = new System.Drawing.Point(573, 294);
            this.lbRemoveCondition.Name = "lbRemoveCondition";
            this.lbRemoveCondition.Size = new System.Drawing.Size(42, 13);
            this.lbRemoveCondition.TabIndex = 2;
            this.lbRemoveCondition.TabStop = true;
            this.lbRemoveCondition.Text = "remove";
            this.lbRemoveCondition.LinkClicked += new System.Windows.Forms.LinkLabelLinkClickedEventHandler(this.lbRemoveCondition_LinkClicked);
            // 
            // PegBestPegMidTab
            // 
            this.PegBestPegMidTab.BackColor = System.Drawing.Color.LightGray;
            this.PegBestPegMidTab.Controls.Add(this.tbMidOffsetAtHalf);
            this.PegBestPegMidTab.Controls.Add(this.labelMidOffsetAtHalf);
            this.PegBestPegMidTab.Controls.Add(this.tbMidOffsetAtWhole);
            this.PegBestPegMidTab.Controls.Add(this.labelMidOffsetAtWhole);
            this.PegBestPegMidTab.Controls.Add(this.cbCompeteAgainstBestOffsetUpToMid);
            this.PegBestPegMidTab.Controls.Add(this.tbCompeteAgainstBestOffset);
            this.PegBestPegMidTab.Controls.Add(this.labelCompeteAgainstBestOffset);
            this.PegBestPegMidTab.Controls.Add(this.tbMinCompeteSize);
            this.PegBestPegMidTab.Controls.Add(this.labelMinCompeteSize);
            this.PegBestPegMidTab.Controls.Add(this.tbMinTradeQty);
            this.PegBestPegMidTab.Controls.Add(this.labelMinTradeQty);
            this.PegBestPegMidTab.Location = new System.Drawing.Point(4, 22);
            this.PegBestPegMidTab.Name = "PegBestPegMidTab";
            this.PegBestPegMidTab.Size = new System.Drawing.Size(740, 364);
            this.PegBestPegMidTab.TabIndex = 9;
            this.PegBestPegMidTab.Text = "PegBest / PegMid";
            // 
            // tbMidOffsetAtHalf
            // 
            this.tbMidOffsetAtHalf.Location = new System.Drawing.Point(149, 148);
            this.tbMidOffsetAtHalf.Name = "tbMidOffsetAtHalf";
            this.tbMidOffsetAtHalf.Size = new System.Drawing.Size(208, 20);
            this.tbMidOffsetAtHalf.TabIndex = 14;
            // 
            // labelMidOffsetAtHalf
            // 
            this.labelMidOffsetAtHalf.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.labelMidOffsetAtHalf.AutoSize = true;
            this.labelMidOffsetAtHalf.Location = new System.Drawing.Point(7, 151);
            this.labelMidOffsetAtHalf.Name = "labelMidOffsetAtHalf";
            this.labelMidOffsetAtHalf.Size = new System.Drawing.Size(90, 13);
            this.labelMidOffsetAtHalf.TabIndex = 13;
            this.labelMidOffsetAtHalf.Text = "Mid Offset At Half";
            // 
            // tbMidOffsetAtWhole
            // 
            this.tbMidOffsetAtWhole.Location = new System.Drawing.Point(149, 122);
            this.tbMidOffsetAtWhole.Name = "tbMidOffsetAtWhole";
            this.tbMidOffsetAtWhole.Size = new System.Drawing.Size(208, 20);
            this.tbMidOffsetAtWhole.TabIndex = 12;
            // 
            // labelMidOffsetAtWhole
            // 
            this.labelMidOffsetAtWhole.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.labelMidOffsetAtWhole.AutoSize = true;
            this.labelMidOffsetAtWhole.Location = new System.Drawing.Point(7, 125);
            this.labelMidOffsetAtWhole.Name = "labelMidOffsetAtWhole";
            this.labelMidOffsetAtWhole.Size = new System.Drawing.Size(102, 13);
            this.labelMidOffsetAtWhole.TabIndex = 11;
            this.labelMidOffsetAtWhole.Text = "Mid Offset At Whole";
            // 
            // cbCompeteAgainstBestOffsetUpToMid
            // 
            this.cbCompeteAgainstBestOffsetUpToMid.AutoSize = true;
            this.cbCompeteAgainstBestOffsetUpToMid.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.cbCompeteAgainstBestOffsetUpToMid.Location = new System.Drawing.Point(10, 99);
            this.cbCompeteAgainstBestOffsetUpToMid.Name = "cbCompeteAgainstBestOffsetUpToMid";
            this.cbCompeteAgainstBestOffsetUpToMid.Size = new System.Drawing.Size(214, 17);
            this.cbCompeteAgainstBestOffsetUpToMid.TabIndex = 10;
            this.cbCompeteAgainstBestOffsetUpToMid.Text = "Compete Against Best Offset Up To Mid";
            this.cbCompeteAgainstBestOffsetUpToMid.UseVisualStyleBackColor = true;
            this.cbCompeteAgainstBestOffsetUpToMid.CheckedChanged += new System.EventHandler(this.cbCompeteAgainstBestOffsetUpToMid_CheckedChanged);
            // 
            // tbCompeteAgainstBestOffset
            // 
            this.tbCompeteAgainstBestOffset.Location = new System.Drawing.Point(149, 68);
            this.tbCompeteAgainstBestOffset.Name = "tbCompeteAgainstBestOffset";
            this.tbCompeteAgainstBestOffset.Size = new System.Drawing.Size(208, 20);
            this.tbCompeteAgainstBestOffset.TabIndex = 7;
            // 
            // labelCompeteAgainstBestOffset
            // 
            this.labelCompeteAgainstBestOffset.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.labelCompeteAgainstBestOffset.AutoSize = true;
            this.labelCompeteAgainstBestOffset.Location = new System.Drawing.Point(7, 71);
            this.labelCompeteAgainstBestOffset.Name = "labelCompeteAgainstBestOffset";
            this.labelCompeteAgainstBestOffset.Size = new System.Drawing.Size(142, 13);
            this.labelCompeteAgainstBestOffset.TabIndex = 6;
            this.labelCompeteAgainstBestOffset.Text = "Compete Against Best Offset";
            // 
            // tbMinCompeteSize
            // 
            this.tbMinCompeteSize.Location = new System.Drawing.Point(149, 42);
            this.tbMinCompeteSize.Name = "tbMinCompeteSize";
            this.tbMinCompeteSize.Size = new System.Drawing.Size(208, 20);
            this.tbMinCompeteSize.TabIndex = 5;
            // 
            // labelMinCompeteSize
            // 
            this.labelMinCompeteSize.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.labelMinCompeteSize.AutoSize = true;
            this.labelMinCompeteSize.Location = new System.Drawing.Point(7, 45);
            this.labelMinCompeteSize.Name = "labelMinCompeteSize";
            this.labelMinCompeteSize.Size = new System.Drawing.Size(92, 13);
            this.labelMinCompeteSize.TabIndex = 4;
            this.labelMinCompeteSize.Text = "Min Compete Size";
            // 
            // tbMinTradeQty
            // 
            this.tbMinTradeQty.Location = new System.Drawing.Point(149, 16);
            this.tbMinTradeQty.Name = "tbMinTradeQty";
            this.tbMinTradeQty.Size = new System.Drawing.Size(208, 20);
            this.tbMinTradeQty.TabIndex = 3;
            // 
            // labelMinTradeQty
            // 
            this.labelMinTradeQty.AccessibleRole = System.Windows.Forms.AccessibleRole.Grip;
            this.labelMinTradeQty.AutoSize = true;
            this.labelMinTradeQty.Location = new System.Drawing.Point(7, 19);
            this.labelMinTradeQty.Name = "labelMinTradeQty";
            this.labelMinTradeQty.Size = new System.Drawing.Size(74, 13);
            this.labelMinTradeQty.TabIndex = 2;
            this.labelMinTradeQty.Text = "Min Trade Qty";
            // 
            // contractSearchControl1
            // 
            this.contractSearchControl1.Contract = null;
            this.contractSearchControl1.IBClient = null;
            this.contractSearchControl1.Location = new System.Drawing.Point(149, 32);
            this.contractSearchControl1.Name = "contractSearchControl1";
            this.contractSearchControl1.Size = new System.Drawing.Size(206, 13);
            this.contractSearchControl1.TabIndex = 0;
            // 
            // sendOrderButton
            // 
            this.sendOrderButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.sendOrderButton.Location = new System.Drawing.Point(132, 425);
            this.sendOrderButton.Name = "sendOrderButton";
            this.sendOrderButton.Size = new System.Drawing.Size(83, 23);
            this.sendOrderButton.TabIndex = 0;
            this.sendOrderButton.Text = "Place/Modify";
            this.sendOrderButton.UseVisualStyleBackColor = true;
            this.sendOrderButton.Click += new System.EventHandler(this.sendOrderButton_Click);
            // 
            // textBox6
            // 
            this.textBox6.Location = new System.Drawing.Point(383, 188);
            this.textBox6.Name = "textBox6";
            this.textBox6.Size = new System.Drawing.Size(70, 20);
            this.textBox6.TabIndex = 0;
            this.textBox6.Text = "WARNING!!!";
            // 
            // textBox7
            // 
            this.textBox7.Location = new System.Drawing.Point(383, 214);
            this.textBox7.Name = "textBox7";
            this.textBox7.Size = new System.Drawing.Size(70, 20);
            this.textBox7.TabIndex = 1;
            this.textBox7.Text = "WARNING!!!";
            // 
            // textBox8
            // 
            this.textBox8.Location = new System.Drawing.Point(383, 240);
            this.textBox8.Name = "textBox8";
            this.textBox8.Size = new System.Drawing.Size(70, 20);
            this.textBox8.TabIndex = 2;
            this.textBox8.Text = "WARNING!!!";
            // 
            // checkMarginButton
            // 
            this.checkMarginButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.checkMarginButton.Location = new System.Drawing.Point(306, 425);
            this.checkMarginButton.Name = "checkMarginButton";
            this.checkMarginButton.Size = new System.Drawing.Size(87, 23);
            this.checkMarginButton.TabIndex = 1;
            this.checkMarginButton.Text = "Check Margin";
            this.checkMarginButton.UseVisualStyleBackColor = true;
            this.checkMarginButton.Click += new System.EventHandler(this.checkMarginButton_Click);
            // 
            // closeOrderDialogButton
            // 
            this.closeOrderDialogButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.closeOrderDialogButton.Location = new System.Drawing.Point(674, 425);
            this.closeOrderDialogButton.Name = "closeOrderDialogButton";
            this.closeOrderDialogButton.Size = new System.Drawing.Size(75, 23);
            this.closeOrderDialogButton.TabIndex = 2;
            this.closeOrderDialogButton.Text = "Close";
            this.closeOrderDialogButton.UseVisualStyleBackColor = true;
            this.closeOrderDialogButton.Click += new System.EventHandler(this.closeOrderDialogButton_Click);
            // 
            // cancelOrderButton
            // 
            this.cancelOrderButton.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.cancelOrderButton.Location = new System.Drawing.Point(221, 425);
            this.cancelOrderButton.Name = "cancelOrderButton";
            this.cancelOrderButton.Size = new System.Drawing.Size(83, 23);
            this.cancelOrderButton.TabIndex = 3;
            this.cancelOrderButton.Text = "Cancel";
            this.cancelOrderButton.UseVisualStyleBackColor = true;
            this.cancelOrderButton.Click += new System.EventHandler(this.cancelOrderButton_Click);
            // 
            // solicited
            // 
            this.solicited.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.solicited.AutoSize = true;
            this.solicited.CheckAlign = System.Drawing.ContentAlignment.MiddleRight;
            this.solicited.Location = new System.Drawing.Point(474, 185);
            this.solicited.Name = "solicited";
            this.solicited.Size = new System.Drawing.Size(66, 17);
            this.solicited.TabIndex = 59;
            this.solicited.Text = "Solicited";
            this.solicited.UseVisualStyleBackColor = true;
            // 
            // OrderDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(761, 453);
            this.ControlBox = false;
            this.Controls.Add(this.cancelOrderButton);
            this.Controls.Add(this.closeOrderDialogButton);
            this.Controls.Add(this.checkMarginButton);
            this.Controls.Add(this.sendOrderButton);
            this.Controls.Add(this.conditionsTab);
            this.Controls.Add(this.textBox6);
            this.Controls.Add(this.textBox8);
            this.Controls.Add(this.textBox7);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "OrderDialog";
            this.Text = "Order";
            this.conditionsTab.ResumeLayout(false);
            this.orderContractTab.ResumeLayout(false);
            this.baseGroup.ResumeLayout(false);
            this.baseGroup.PerformLayout();
            this.contractGroup.ResumeLayout(false);
            this.contractGroup.PerformLayout();
            this.extendedOrderTab.ResumeLayout(false);
            this.extendedOrderTab.PerformLayout();
            this.advisorTab.ResumeLayout(false);
            this.advisorTab.PerformLayout();
            this.volatilityTab.ResumeLayout(false);
            this.volatilityTab.PerformLayout();
            this.scaleTab.ResumeLayout(false);
            this.scaleTab.PerformLayout();
            this.algoTab.ResumeLayout(false);
            this.algoTab.PerformLayout();
            this.peg2benchTab.ResumeLayout(false);
            this.peg2benchTab.PerformLayout();
            this.adjustStopTab.ResumeLayout(false);
            this.adjustStopTab.PerformLayout();
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.conditionList)).EndInit();
            this.PegBestPegMidTab.ResumeLayout(false);
            this.PegBestPegMidTab.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        
        private System.Windows.Forms.TabControl conditionsTab;
        private System.Windows.Forms.TabPage orderContractTab;
        private System.Windows.Forms.TabPage extendedOrderTab;
        private System.Windows.Forms.Button sendOrderButton;

        private System.Windows.Forms.ComboBox contractSecType;
        private System.Windows.Forms.TextBox contractLastTradeDateOrContractMonth;
        private System.Windows.Forms.TextBox contractStrike;
        private System.Windows.Forms.ComboBox contractRight;
        private System.Windows.Forms.TextBox contractMultiplier;
        private System.Windows.Forms.TextBox contractExchange;
        private System.Windows.Forms.TextBox contractCurrency;
        private System.Windows.Forms.TextBox contractLocalSymbol;        
        private System.Windows.Forms.GroupBox contractGroup;
        private System.Windows.Forms.GroupBox baseGroup;
        private System.Windows.Forms.TextBox contractSymbol;
        private System.Windows.Forms.TextBox orderReference;        
        private System.Windows.Forms.CheckBox overrideConstraints;
        private System.Windows.Forms.CheckBox allOrNone;
        private System.Windows.Forms.CheckBox outsideRTH;
        private System.Windows.Forms.CheckBox hidden;
        private System.Windows.Forms.CheckBox sweepToFill;
        private System.Windows.Forms.CheckBox block;
        private System.Windows.Forms.CheckBox notHeld;
        private System.Windows.Forms.TextBox hedgeParam;
        private System.Windows.Forms.TextBox trailStopPrice;
        private System.Windows.Forms.TextBox percentOffset;
        private System.Windows.Forms.ComboBox hedgeType;
        private System.Windows.Forms.ComboBox triggerMethod;
        private System.Windows.Forms.ComboBox rule80A;
        private System.Windows.Forms.ComboBox ocaType;
        private System.Windows.Forms.TextBox goodUntil;
        private System.Windows.Forms.TextBox ocaGroup;
        private System.Windows.Forms.TextBox goodAfter;
        private System.Windows.Forms.TextBox minQty;
        private System.Windows.Forms.TextBox textBox6;
        private System.Windows.Forms.TextBox textBox7;
        private System.Windows.Forms.TextBox textBox8;
        private System.Windows.Forms.CheckBox transmit;
        private System.Windows.Forms.CheckBox optOutSmart;
        private System.Windows.Forms.TextBox discretionaryAmount;
        private System.Windows.Forms.TextBox trailingPercent;

        private System.Windows.Forms.Label orderSymbolLabel;
        private System.Windows.Forms.Label orderSecTypeLabel;
        private System.Windows.Forms.Label orderLastTradeDateOrContractMonthLabel;
        private System.Windows.Forms.Label orderStrikeLabel;
        private System.Windows.Forms.Label orderRightLabel;
        private System.Windows.Forms.Label orderMultiplierLabel;
        private System.Windows.Forms.Label orderExchangeLabel;
        private System.Windows.Forms.Label orderCurrencyLabel;
        private System.Windows.Forms.Label orderLocalSymbol;
        private System.Windows.Forms.Label tiggerMethodLabel;
        private System.Windows.Forms.Label rule80ALabel;
        private System.Windows.Forms.Label goodUntilLabel;
        private System.Windows.Forms.Label goodAfterLabel;
        private System.Windows.Forms.Label orderMinQtyLabel;
        private System.Windows.Forms.Label orderRefLabel;
        private System.Windows.Forms.Label percentOffsetLabel;        
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label trailingPercentLabel;
        private System.Windows.Forms.Label accountLabel;
        private System.Windows.Forms.Label limitPriceLabel;
        private System.Windows.Forms.Label orderTypeLabel;
        private System.Windows.Forms.Label displaySizeLabel;
        private System.Windows.Forms.Label quantityLabel;
        private System.Windows.Forms.Label actionLabel;
        private System.Windows.Forms.Label auxPriceLabel;
        private System.Windows.Forms.ComboBox account;
        private System.Windows.Forms.Label timeInForceLabel;
        private System.Windows.Forms.ComboBox orderType;
        private System.Windows.Forms.TextBox displaySize;
        private System.Windows.Forms.TextBox quantity;
        private System.Windows.Forms.ComboBox action;
        private System.Windows.Forms.ComboBox timeInForce;
        private System.Windows.Forms.TextBox auxPrice;
        private System.Windows.Forms.TextBox lmtPrice;
        private System.Windows.Forms.TabPage advisorTab;
        private System.Windows.Forms.Label groupLabel;
        private System.Windows.Forms.Label profileLabel;
        private System.Windows.Forms.Label orLabel;
        private System.Windows.Forms.Label percentageLabel;
        private System.Windows.Forms.Label methodLabel;
        private System.Windows.Forms.TextBox faGroup;
        private System.Windows.Forms.ComboBox faMethod;
        private System.Windows.Forms.TextBox faProfile;
        private System.Windows.Forms.TextBox faPercentage;
        private System.Windows.Forms.TabPage volatilityTab;
        private System.Windows.Forms.TabPage scaleTab;
        private System.Windows.Forms.TabPage algoTab;
        private System.Windows.Forms.Label stockRangeLowerLabel;
        private System.Windows.Forms.Label sockRangeUpperLabel;
        private System.Windows.Forms.Label hedgeContractConIdLabel;
        private System.Windows.Forms.Label hedgeOrderAuxPriceLabel;
        private System.Windows.Forms.Label hedgeOrderTypeLabel;
        private System.Windows.Forms.Label optionReferencePriceLabel;
        private System.Windows.Forms.Label volatilityLabel;
        private System.Windows.Forms.CheckBox continuousUpdate;
        private System.Windows.Forms.TextBox stockRangeLower;
        private System.Windows.Forms.TextBox stockRangeUpper;
        private System.Windows.Forms.TextBox deltaNeutralConId;
        private System.Windows.Forms.TextBox deltaNeutralAuxPrice;
        private System.Windows.Forms.ComboBox deltaNeutralOrderType;
        private System.Windows.Forms.ComboBox optionReferencePrice;
        private System.Windows.Forms.ComboBox volatilityType;
        private System.Windows.Forms.TextBox volatility;
        private System.Windows.Forms.Label secondsLabel;
        private System.Windows.Forms.Label initialPositionLabel;
        private System.Windows.Forms.Label initialFillQuantityLabel;
        private System.Windows.Forms.Label everyLabel;
        private System.Windows.Forms.Label priceAdjustValueLabel;
        private System.Windows.Forms.Label subsequentLevelSizeLabel;
        private System.Windows.Forms.Label profitOffsetLabel;
        private System.Windows.Forms.Label priceIncrementLabel;
        private System.Windows.Forms.Label initialLevelSizeLabel;
        private System.Windows.Forms.CheckBox autoReset;
        private System.Windows.Forms.CheckBox randomiseSize;
        private System.Windows.Forms.TextBox initialLevelSize;
        private System.Windows.Forms.TextBox priceAdjustInterval;
        private System.Windows.Forms.TextBox priceAdjustValue;
        private System.Windows.Forms.TextBox initialFillQuantity;
        private System.Windows.Forms.TextBox initialPosition;
        private System.Windows.Forms.TextBox priceIncrement;
        private System.Windows.Forms.TextBox profitOffset;
        private System.Windows.Forms.TextBox subsequentLevelSize;
        private System.Windows.Forms.Label algoStrategyLabel;
        private System.Windows.Forms.ComboBox algoStrategy;
        private System.Windows.Forms.Label useOddLotsLabel;
        private System.Windows.Forms.Label noTradeAheadLabel;
        private System.Windows.Forms.Label getDoneLabel;
        private System.Windows.Forms.Label displaySizeAlgoLabel;
        private System.Windows.Forms.Label forceCompletionLabel;
        private System.Windows.Forms.Label riskAversionLabel;
        private System.Windows.Forms.Label noTakeLiqLabel;
        private System.Windows.Forms.Label strategyTypeLabel;
        private System.Windows.Forms.Label pctVolLabel;
        private System.Windows.Forms.Label maxPctVolLabel;
        private System.Windows.Forms.Label allowPastEndTimeLabel;
        private System.Windows.Forms.Label endTimeLabel;
        private System.Windows.Forms.Label startTimeLabel;
        private System.Windows.Forms.TextBox useOddLots;
        private System.Windows.Forms.TextBox noTradeAhead;
        private System.Windows.Forms.TextBox getDone;
        private System.Windows.Forms.TextBox displaySizeAlgo;
        private System.Windows.Forms.TextBox forceCompletion;
        private System.Windows.Forms.TextBox riskAversion;
        private System.Windows.Forms.TextBox noTakeLiq;
        private System.Windows.Forms.TextBox strategyType;
        private System.Windows.Forms.TextBox pctVol;
        private System.Windows.Forms.TextBox maxPctVol;
        private System.Windows.Forms.TextBox allowPastEndTime;
        private System.Windows.Forms.TextBox endTime;
        private System.Windows.Forms.TextBox startTime;
        private System.Windows.Forms.Button checkMarginButton;
        private System.Windows.Forms.Button closeOrderDialogButton;
        private System.Windows.Forms.Label orderPrimExchLabel;
        private System.Windows.Forms.TextBox contractPrimaryExch;
        private System.Windows.Forms.TabPage peg2benchTab;
        private System.Windows.Forms.TextBox tbReferenceChangeAmount;
        private System.Windows.Forms.TextBox tbPeggedChangeAmount;
        private System.Windows.Forms.TextBox tbStartingReferencePrice;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.TextBox tbStartingPrice;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.ComboBox cbPeggedChangeType;
        private System.Windows.Forms.TabPage adjustStopTab;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.ComboBox cbAdjustedTrailingAmntUnit;
        private System.Windows.Forms.TextBox tbAdjustedTrailingAmnt;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox tbAdjustedStopLimitPrice;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.TextBox tbAdjustedStopPrice;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.TextBox tbTriggerPrice;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.ComboBox cbAdjustedOrderType;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.LinkLabel lbAddCondition;
        private System.Windows.Forms.LinkLabel lbRemoveCondition;
        private ui.ContractSearchControl contractSearchControl1;
        private System.Windows.Forms.DataGridView conditionList;
        private System.Windows.Forms.DataGridViewTextBoxColumn Description;
        private System.Windows.Forms.DataGridViewComboBoxColumn Logic;
        private System.Windows.Forms.ComboBox cancelOrder;
        private System.Windows.Forms.CheckBox ignoreRth;
        private System.Windows.Forms.TextBox pgdStockRangeLower;
        private System.Windows.Forms.TextBox pgdStockRangeUpper;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox modelCode;
        private System.Windows.Forms.Label modelCodeLabel;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.ComboBox softDollarTier;
        private System.Windows.Forms.TextBox cashQty;
        private System.Windows.Forms.Label cashQtyLabel;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.TextBox mifid2DecisionAlgo;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.TextBox mifid2DecisionMaker;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.TextBox mifid2ExecutionAlgo;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.TextBox mifid2ExecutionTrader;
        private System.Windows.Forms.CheckBox dontUseAutoPriceForHedge;
        private System.Windows.Forms.CheckBox omsContainer;
        private System.Windows.Forms.CheckBox relativeDiscretionary;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.CheckBox usePriceMgmtAlgo;
        private System.Windows.Forms.TextBox duration;
        private System.Windows.Forms.Label label25;
        private System.Windows.Forms.TextBox postToAts;
        private System.Windows.Forms.Label label26;
        private System.Windows.Forms.CheckBox autoCancelParent;
        private System.Windows.Forms.TextBox advancedErrorOverride;
        private System.Windows.Forms.Label label27;
        private System.Windows.Forms.TextBox manualOrderCancelTime;
        private System.Windows.Forms.Label labelManualOrderCancelTime;
        private System.Windows.Forms.TextBox manualOrderTime;
        private System.Windows.Forms.Label labelManualOrderTime;
        private System.Windows.Forms.Button cancelOrderButton;
        private System.Windows.Forms.TabPage PegBestPegMidTab;
        private System.Windows.Forms.TextBox tbMinTradeQty;
        private System.Windows.Forms.Label labelMinTradeQty;
        private System.Windows.Forms.TextBox tbMinCompeteSize;
        private System.Windows.Forms.Label labelMinCompeteSize;
        private System.Windows.Forms.TextBox tbCompeteAgainstBestOffset;
        private System.Windows.Forms.Label labelCompeteAgainstBestOffset;
        private System.Windows.Forms.TextBox tbMidOffsetAtHalf;
        private System.Windows.Forms.Label labelMidOffsetAtHalf;
        private System.Windows.Forms.TextBox tbMidOffsetAtWhole;
        private System.Windows.Forms.Label labelMidOffsetAtWhole;
        private System.Windows.Forms.CheckBox cbCompeteAgainstBestOffsetUpToMid;
        private System.Windows.Forms.CheckBox solicited;
    }
}