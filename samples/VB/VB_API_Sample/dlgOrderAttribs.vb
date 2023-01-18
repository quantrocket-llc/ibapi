﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.


Option Explicit On
Public Class dlgOrderAttribs
    Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "
    Public Sub New()
        MyBase.New()
        If m_vb6FormDefInstance Is Nothing Then
            If m_InitializingDefInstance Then
                m_vb6FormDefInstance = Me
            Else
                Try
                    'For the start-up form, the first instance created is the default instance.
                    If System.Reflection.Assembly.GetExecutingAssembly.EntryPoint.DeclaringType Is Me.GetType Then
                        m_vb6FormDefInstance = Me
                    End If
                Catch
                End Try
            End If
        End If
        'This call is required by the Windows Form Designer.
        InitializeComponent()
    End Sub
    'Form overrides dispose to clean up the component list.
    Protected Overloads Overrides Sub Dispose(Disposing As Boolean)
        If Disposing Then
            If Not components Is Nothing Then
                components.Dispose()
            End If
        End If
        MyBase.Dispose(Disposing)
    End Sub
    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer
    Public ToolTip1 As System.Windows.Forms.ToolTip
    Public WithEvents txtRule80A As System.Windows.Forms.TextBox
    Public WithEvents txtSettlingFirm As System.Windows.Forms.TextBox
    Public WithEvents txtMinQty As System.Windows.Forms.TextBox
    Public WithEvents txtPercentOffset As System.Windows.Forms.TextBox
    Public WithEvents txtAuctionStrategy As System.Windows.Forms.TextBox
    Public WithEvents txtStartingPrice As System.Windows.Forms.TextBox
    Public WithEvents txtStockRefPrice As System.Windows.Forms.TextBox
    Public WithEvents txtDelta As System.Windows.Forms.TextBox
    Public WithEvents txtStockRangeLower As System.Windows.Forms.TextBox
    Public WithEvents txtStockRangeUpper As System.Windows.Forms.TextBox
    Public WithEvents txtAllOrNone As System.Windows.Forms.TextBox
    Public WithEvents txtOcaType As System.Windows.Forms.TextBox
    Public WithEvents txtShortSaleSlot As System.Windows.Forms.TextBox
    Public WithEvents txtDesignatedLocation As System.Windows.Forms.TextBox
    Public WithEvents txtDiscretionaryAmt As System.Windows.Forms.TextBox
    Public WithEvents cmdOk As System.Windows.Forms.Button
    Public WithEvents cmdCancel As System.Windows.Forms.Button
    Public WithEvents txtHidden As System.Windows.Forms.TextBox
    Public WithEvents txtOutsideRth As System.Windows.Forms.TextBox
    Public WithEvents txtTriggerMethod As System.Windows.Forms.TextBox
    Public WithEvents txtDisplaySize As System.Windows.Forms.TextBox
    Public WithEvents txtSweepToFill As System.Windows.Forms.TextBox
    Public WithEvents txtBlockOrder As System.Windows.Forms.TextBox
    Public WithEvents txtTransmit As System.Windows.Forms.TextBox
    Public WithEvents txtParentId As System.Windows.Forms.TextBox
    Public WithEvents txtOrderRef As System.Windows.Forms.TextBox
    Public WithEvents txtOrigin As System.Windows.Forms.TextBox
    Public WithEvents txtOpenClose As System.Windows.Forms.TextBox
    Public WithEvents txtAccount As System.Windows.Forms.TextBox
    Public WithEvents txtOCA As System.Windows.Forms.TextBox
    Public WithEvents txtTIF As System.Windows.Forms.TextBox
    Public WithEvents Label35 As System.Windows.Forms.Label
    Public WithEvents Label34 As System.Windows.Forms.Label
    Public WithEvents Label33 As System.Windows.Forms.Label
    Public WithEvents Label32 As System.Windows.Forms.Label
    Public WithEvents Label28 As System.Windows.Forms.Label
    Public WithEvents Label27 As System.Windows.Forms.Label
    Public WithEvents Label26 As System.Windows.Forms.Label
    Public WithEvents Label25 As System.Windows.Forms.Label
    Public WithEvents Label24 As System.Windows.Forms.Label
    Public WithEvents Label23 As System.Windows.Forms.Label
    Public WithEvents Label20 As System.Windows.Forms.Label
    Public WithEvents Label19 As System.Windows.Forms.Label
    Public WithEvents Label17 As System.Windows.Forms.Label
    Public WithEvents Label16 As System.Windows.Forms.Label
    Public WithEvents Label15 As System.Windows.Forms.Label
    Public WithEvents Label14 As System.Windows.Forms.Label
    Public WithEvents Label13 As System.Windows.Forms.Label
    Public WithEvents Label12 As System.Windows.Forms.Label
    Public WithEvents Label11 As System.Windows.Forms.Label
    Public WithEvents Label10 As System.Windows.Forms.Label
    Public WithEvents Label9 As System.Windows.Forms.Label
    Public WithEvents Label8 As System.Windows.Forms.Label
    Public WithEvents Label7 As System.Windows.Forms.Label
    Public WithEvents Label6 As System.Windows.Forms.Label
    Public WithEvents Label5 As System.Windows.Forms.Label
    Public WithEvents Label4 As System.Windows.Forms.Label
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    Public WithEvents txtVolatility As System.Windows.Forms.TextBox
    Public WithEvents txtVolatilityType As System.Windows.Forms.TextBox
    Public WithEvents txtContinuousUpdate As System.Windows.Forms.TextBox
    Public WithEvents txtReferencePriceType As System.Windows.Forms.TextBox
    Public WithEvents Label21 As System.Windows.Forms.Label
    Public WithEvents Label22 As System.Windows.Forms.Label
    Public WithEvents Label36 As System.Windows.Forms.Label
    Public WithEvents Label37 As System.Windows.Forms.Label
    Public WithEvents Label40 As System.Windows.Forms.Label
    Public WithEvents txtDeltaNeutralOrderType As System.Windows.Forms.TextBox
    Public WithEvents txtDeltaNeutralAuxPrice As System.Windows.Forms.TextBox
    Public WithEvents Label38 As System.Windows.Forms.Label
    Public WithEvents txtTrailStopPrice As System.Windows.Forms.TextBox
    Public WithEvents Label39 As System.Windows.Forms.Label
    Public WithEvents txtOverridePercentageConstraints As System.Windows.Forms.TextBox
    Public WithEvents txtScaleInitLevelSize As System.Windows.Forms.TextBox
    Public WithEvents txtScaleSubsLevelSize As System.Windows.Forms.TextBox
    Public WithEvents txtScalePriceIncr As System.Windows.Forms.TextBox
    Public WithEvents Label42 As System.Windows.Forms.Label
    Public WithEvents Label43 As System.Windows.Forms.Label
    Public WithEvents Label44 As System.Windows.Forms.Label
    Public WithEvents txtClearingAccount As System.Windows.Forms.TextBox
    Public WithEvents Label18 As System.Windows.Forms.Label
    Public WithEvents txtClearingIntent As System.Windows.Forms.TextBox
    Public WithEvents Label45 As System.Windows.Forms.Label
    Friend WithEvents txtExemptCode As System.Windows.Forms.TextBox
    Friend WithEvents Label46 As System.Windows.Forms.Label
    Public WithEvents txtHedgeType As System.Windows.Forms.TextBox
    Public WithEvents txtHedgeParam As System.Windows.Forms.TextBox
    Public WithEvents LabelHedgeType As System.Windows.Forms.Label
    Public WithEvents LabelHedgeParam As System.Windows.Forms.Label
    Friend WithEvents checkOptOutSmartRouting As System.Windows.Forms.CheckBox
    Public WithEvents Label47 As System.Windows.Forms.Label
    Public WithEvents Label48 As System.Windows.Forms.Label
    Public WithEvents Label49 As System.Windows.Forms.Label
    Public WithEvents Label50 As System.Windows.Forms.Label
    Public WithEvents txtDeltaNeutralConId As System.Windows.Forms.TextBox
    Public WithEvents txtDeltaNeutralClearingIntent As System.Windows.Forms.TextBox
    Public WithEvents txtDeltaNeutralClearingAccount As System.Windows.Forms.TextBox
    Public WithEvents txtDeltaNeutralSettlingFirm As System.Windows.Forms.TextBox
    Public WithEvents Label51 As System.Windows.Forms.Label
    Public WithEvents Label52 As System.Windows.Forms.Label
    Public WithEvents Label53 As System.Windows.Forms.Label
    Friend WithEvents checkScaleAutoReset As System.Windows.Forms.CheckBox
    Public WithEvents txtScalePriceAdjustValue As System.Windows.Forms.TextBox
    Public WithEvents Label54 As System.Windows.Forms.Label
    Public WithEvents Label55 As System.Windows.Forms.Label
    Friend WithEvents checkScaleRandomPercent As System.Windows.Forms.CheckBox
    Public WithEvents txtScalePriceAdjustInterval As System.Windows.Forms.TextBox
    Public WithEvents txtScaleInitPosition As System.Windows.Forms.TextBox
    Public WithEvents txtScaleInitFillQty As System.Windows.Forms.TextBox
    Public WithEvents txtScaleProfitOffset As System.Windows.Forms.TextBox
    Public WithEvents Label56 As System.Windows.Forms.Label
    Public WithEvents txtTrailingPercent As System.Windows.Forms.TextBox
    Public WithEvents txtDeltaNeutralOpenClose As System.Windows.Forms.TextBox
    Public WithEvents Label57 As System.Windows.Forms.Label
    Friend WithEvents checkDeltaNeutralShortSale As System.Windows.Forms.CheckBox
    Public WithEvents txtDeltaNeutralShortSaleSlot As System.Windows.Forms.TextBox
    Public WithEvents Label58 As System.Windows.Forms.Label
    Public WithEvents txtDeltaNeutralDesignatedLocation As System.Windows.Forms.TextBox
    Public WithEvents Label59 As System.Windows.Forms.Label
    Public WithEvents txtActiveStopTime As System.Windows.Forms.TextBox
    Public WithEvents txtActiveStartTime As System.Windows.Forms.TextBox
    Public WithEvents txtScaleTable As System.Windows.Forms.TextBox
    Public WithEvents Label60 As System.Windows.Forms.Label
    Public WithEvents Label61 As System.Windows.Forms.Label
    Public WithEvents Label62 As System.Windows.Forms.Label
    Friend WithEvents cbSolicited As System.Windows.Forms.CheckBox
    Friend WithEvents cbRandomizeSize As System.Windows.Forms.CheckBox
    Friend WithEvents cbRandomizePrice As System.Windows.Forms.CheckBox
    Public WithEvents txtModelCode As System.Windows.Forms.TextBox
    Public WithEvents Label63 As System.Windows.Forms.Label
    Public WithEvents txtMifid2DecisionMaker As System.Windows.Forms.TextBox
    Public WithEvents Label64 As System.Windows.Forms.Label
    Public WithEvents txtMifid2DecisionAlgo As System.Windows.Forms.TextBox
    Public WithEvents Label65 As System.Windows.Forms.Label
    Public WithEvents txtMifid2ExecutionTrader As System.Windows.Forms.TextBox
    Public WithEvents Label66 As System.Windows.Forms.Label
    Public WithEvents txtMifid2ExecutionAlgo As System.Windows.Forms.TextBox
    Public WithEvents Label67 As System.Windows.Forms.Label
    Friend WithEvents checkDontUseAutoPriceForHedge As System.Windows.Forms.CheckBox
    Friend WithEvents checkOmsContainer As System.Windows.Forms.CheckBox
    Friend WithEvents checkRelativeDiscretionary As System.Windows.Forms.CheckBox
    Public WithEvents Label29 As Label
    Public WithEvents txtDuration As TextBox
    Public WithEvents txtPostToAts As TextBox
    Public WithEvents Label30 As Label
    Friend WithEvents checkNotHeld As CheckBox
    Friend WithEvents checkAutoCancelParent As CheckBox
    Public WithEvents Label31 As Label
    Public WithEvents txtAdvancedErrorOverride As TextBox
    Public WithEvents LabelManualOrderTime As Label
    Public WithEvents txtManualOrderTime As TextBox
    Public WithEvents LabelManualOrderCancelTime As Label
    Public WithEvents txtManualOrderCancelTime As TextBox
    Public WithEvents LabelMinTradeQty As Label
    Public WithEvents txtMinTradeQty As TextBox
    Public WithEvents LabelMinCompeteSize As Label
    Public WithEvents txtMinCompeteSize As TextBox
    Public WithEvents LabelCompeteAgainstBestOffset As Label
    Public WithEvents txtCompeteAgainstBestOffset As TextBox
    Friend WithEvents checkCompeteAgainstBestOffsetUpToMid As CheckBox
    Public WithEvents LabelMidOffsetAtWhole As Label
    Public WithEvents txtMidOffsetAtWhole As TextBox
    Public WithEvents LabelMidOffsetAtHalf As Label
    Public WithEvents txtMidOffsetAtHalf As TextBox
    Public WithEvents Label41 As System.Windows.Forms.Label
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.txtHedgeParam = New System.Windows.Forms.TextBox()
        Me.txtRule80A = New System.Windows.Forms.TextBox()
        Me.txtSettlingFirm = New System.Windows.Forms.TextBox()
        Me.txtMinQty = New System.Windows.Forms.TextBox()
        Me.txtPercentOffset = New System.Windows.Forms.TextBox()
        Me.txtAuctionStrategy = New System.Windows.Forms.TextBox()
        Me.txtStartingPrice = New System.Windows.Forms.TextBox()
        Me.txtStockRefPrice = New System.Windows.Forms.TextBox()
        Me.txtDelta = New System.Windows.Forms.TextBox()
        Me.txtStockRangeLower = New System.Windows.Forms.TextBox()
        Me.txtStockRangeUpper = New System.Windows.Forms.TextBox()
        Me.txtAllOrNone = New System.Windows.Forms.TextBox()
        Me.txtOcaType = New System.Windows.Forms.TextBox()
        Me.txtShortSaleSlot = New System.Windows.Forms.TextBox()
        Me.txtDesignatedLocation = New System.Windows.Forms.TextBox()
        Me.txtDiscretionaryAmt = New System.Windows.Forms.TextBox()
        Me.cmdOk = New System.Windows.Forms.Button()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.txtHidden = New System.Windows.Forms.TextBox()
        Me.txtOutsideRth = New System.Windows.Forms.TextBox()
        Me.txtTriggerMethod = New System.Windows.Forms.TextBox()
        Me.txtDisplaySize = New System.Windows.Forms.TextBox()
        Me.txtSweepToFill = New System.Windows.Forms.TextBox()
        Me.txtBlockOrder = New System.Windows.Forms.TextBox()
        Me.txtTransmit = New System.Windows.Forms.TextBox()
        Me.txtParentId = New System.Windows.Forms.TextBox()
        Me.txtOrderRef = New System.Windows.Forms.TextBox()
        Me.txtOrigin = New System.Windows.Forms.TextBox()
        Me.txtOpenClose = New System.Windows.Forms.TextBox()
        Me.txtAccount = New System.Windows.Forms.TextBox()
        Me.txtOCA = New System.Windows.Forms.TextBox()
        Me.txtTIF = New System.Windows.Forms.TextBox()
        Me.Label35 = New System.Windows.Forms.Label()
        Me.Label34 = New System.Windows.Forms.Label()
        Me.Label33 = New System.Windows.Forms.Label()
        Me.Label32 = New System.Windows.Forms.Label()
        Me.Label28 = New System.Windows.Forms.Label()
        Me.Label27 = New System.Windows.Forms.Label()
        Me.Label26 = New System.Windows.Forms.Label()
        Me.Label25 = New System.Windows.Forms.Label()
        Me.Label24 = New System.Windows.Forms.Label()
        Me.Label23 = New System.Windows.Forms.Label()
        Me.Label20 = New System.Windows.Forms.Label()
        Me.Label19 = New System.Windows.Forms.Label()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.Label15 = New System.Windows.Forms.Label()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.txtVolatility = New System.Windows.Forms.TextBox()
        Me.txtVolatilityType = New System.Windows.Forms.TextBox()
        Me.txtDeltaNeutralOrderType = New System.Windows.Forms.TextBox()
        Me.txtContinuousUpdate = New System.Windows.Forms.TextBox()
        Me.txtReferencePriceType = New System.Windows.Forms.TextBox()
        Me.Label21 = New System.Windows.Forms.Label()
        Me.Label22 = New System.Windows.Forms.Label()
        Me.Label36 = New System.Windows.Forms.Label()
        Me.Label37 = New System.Windows.Forms.Label()
        Me.Label40 = New System.Windows.Forms.Label()
        Me.txtDeltaNeutralAuxPrice = New System.Windows.Forms.TextBox()
        Me.Label38 = New System.Windows.Forms.Label()
        Me.txtTrailStopPrice = New System.Windows.Forms.TextBox()
        Me.Label39 = New System.Windows.Forms.Label()
        Me.txtOverridePercentageConstraints = New System.Windows.Forms.TextBox()
        Me.Label41 = New System.Windows.Forms.Label()
        Me.txtScaleInitLevelSize = New System.Windows.Forms.TextBox()
        Me.txtScaleSubsLevelSize = New System.Windows.Forms.TextBox()
        Me.txtScalePriceIncr = New System.Windows.Forms.TextBox()
        Me.Label42 = New System.Windows.Forms.Label()
        Me.Label43 = New System.Windows.Forms.Label()
        Me.Label44 = New System.Windows.Forms.Label()
        Me.txtClearingAccount = New System.Windows.Forms.TextBox()
        Me.Label18 = New System.Windows.Forms.Label()
        Me.txtClearingIntent = New System.Windows.Forms.TextBox()
        Me.Label45 = New System.Windows.Forms.Label()
        Me.txtExemptCode = New System.Windows.Forms.TextBox()
        Me.Label46 = New System.Windows.Forms.Label()
        Me.txtHedgeType = New System.Windows.Forms.TextBox()
        Me.LabelHedgeType = New System.Windows.Forms.Label()
        Me.LabelHedgeParam = New System.Windows.Forms.Label()
        Me.checkOptOutSmartRouting = New System.Windows.Forms.CheckBox()
        Me.Label47 = New System.Windows.Forms.Label()
        Me.Label48 = New System.Windows.Forms.Label()
        Me.Label49 = New System.Windows.Forms.Label()
        Me.Label50 = New System.Windows.Forms.Label()
        Me.txtDeltaNeutralConId = New System.Windows.Forms.TextBox()
        Me.txtDeltaNeutralClearingIntent = New System.Windows.Forms.TextBox()
        Me.txtDeltaNeutralClearingAccount = New System.Windows.Forms.TextBox()
        Me.txtDeltaNeutralSettlingFirm = New System.Windows.Forms.TextBox()
        Me.Label51 = New System.Windows.Forms.Label()
        Me.Label52 = New System.Windows.Forms.Label()
        Me.Label53 = New System.Windows.Forms.Label()
        Me.checkScaleAutoReset = New System.Windows.Forms.CheckBox()
        Me.txtScalePriceAdjustValue = New System.Windows.Forms.TextBox()
        Me.Label54 = New System.Windows.Forms.Label()
        Me.Label55 = New System.Windows.Forms.Label()
        Me.checkScaleRandomPercent = New System.Windows.Forms.CheckBox()
        Me.txtScalePriceAdjustInterval = New System.Windows.Forms.TextBox()
        Me.txtScaleInitPosition = New System.Windows.Forms.TextBox()
        Me.txtScaleInitFillQty = New System.Windows.Forms.TextBox()
        Me.txtScaleProfitOffset = New System.Windows.Forms.TextBox()
        Me.Label56 = New System.Windows.Forms.Label()
        Me.txtTrailingPercent = New System.Windows.Forms.TextBox()
        Me.txtDeltaNeutralOpenClose = New System.Windows.Forms.TextBox()
        Me.Label57 = New System.Windows.Forms.Label()
        Me.checkDeltaNeutralShortSale = New System.Windows.Forms.CheckBox()
        Me.txtDeltaNeutralShortSaleSlot = New System.Windows.Forms.TextBox()
        Me.Label58 = New System.Windows.Forms.Label()
        Me.txtDeltaNeutralDesignatedLocation = New System.Windows.Forms.TextBox()
        Me.Label59 = New System.Windows.Forms.Label()
        Me.txtActiveStopTime = New System.Windows.Forms.TextBox()
        Me.txtActiveStartTime = New System.Windows.Forms.TextBox()
        Me.txtScaleTable = New System.Windows.Forms.TextBox()
        Me.Label60 = New System.Windows.Forms.Label()
        Me.Label61 = New System.Windows.Forms.Label()
        Me.Label62 = New System.Windows.Forms.Label()
        Me.cbSolicited = New System.Windows.Forms.CheckBox()
        Me.cbRandomizeSize = New System.Windows.Forms.CheckBox()
        Me.cbRandomizePrice = New System.Windows.Forms.CheckBox()
        Me.txtModelCode = New System.Windows.Forms.TextBox()
        Me.Label63 = New System.Windows.Forms.Label()
        Me.txtMifid2DecisionMaker = New System.Windows.Forms.TextBox()
        Me.Label64 = New System.Windows.Forms.Label()
        Me.txtMifid2DecisionAlgo = New System.Windows.Forms.TextBox()
        Me.Label65 = New System.Windows.Forms.Label()
        Me.txtMifid2ExecutionTrader = New System.Windows.Forms.TextBox()
        Me.Label66 = New System.Windows.Forms.Label()
        Me.txtMifid2ExecutionAlgo = New System.Windows.Forms.TextBox()
        Me.Label67 = New System.Windows.Forms.Label()
        Me.checkDontUseAutoPriceForHedge = New System.Windows.Forms.CheckBox()
        Me.checkOmsContainer = New System.Windows.Forms.CheckBox()
        Me.checkRelativeDiscretionary = New System.Windows.Forms.CheckBox()
        Me.Label29 = New System.Windows.Forms.Label()
        Me.txtDuration = New System.Windows.Forms.TextBox()
        Me.txtPostToAts = New System.Windows.Forms.TextBox()
        Me.Label30 = New System.Windows.Forms.Label()
        Me.checkNotHeld = New System.Windows.Forms.CheckBox()
        Me.checkAutoCancelParent = New System.Windows.Forms.CheckBox()
        Me.Label31 = New System.Windows.Forms.Label()
        Me.txtAdvancedErrorOverride = New System.Windows.Forms.TextBox()
        Me.LabelManualOrderTime = New System.Windows.Forms.Label()
        Me.txtManualOrderTime = New System.Windows.Forms.TextBox()
        Me.LabelManualOrderCancelTime = New System.Windows.Forms.Label()
        Me.txtManualOrderCancelTime = New System.Windows.Forms.TextBox()
        Me.LabelMinTradeQty = New System.Windows.Forms.Label()
        Me.txtMinTradeQty = New System.Windows.Forms.TextBox()
        Me.LabelMinCompeteSize = New System.Windows.Forms.Label()
        Me.txtMinCompeteSize = New System.Windows.Forms.TextBox()
        Me.LabelCompeteAgainstBestOffset = New System.Windows.Forms.Label()
        Me.txtCompeteAgainstBestOffset = New System.Windows.Forms.TextBox()
        Me.checkCompeteAgainstBestOffsetUpToMid = New System.Windows.Forms.CheckBox()
        Me.LabelMidOffsetAtWhole = New System.Windows.Forms.Label()
        Me.txtMidOffsetAtWhole = New System.Windows.Forms.TextBox()
        Me.LabelMidOffsetAtHalf = New System.Windows.Forms.Label()
        Me.txtMidOffsetAtHalf = New System.Windows.Forms.TextBox()
        Me.SuspendLayout()
        '
        'txtHedgeParam
        '
        Me.txtHedgeParam.AcceptsReturn = True
        Me.txtHedgeParam.BackColor = System.Drawing.SystemColors.Window
        Me.txtHedgeParam.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtHedgeParam.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtHedgeParam.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtHedgeParam.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtHedgeParam.Location = New System.Drawing.Point(143, 444)
        Me.txtHedgeParam.MaxLength = 0
        Me.txtHedgeParam.Name = "txtHedgeParam"
        Me.txtHedgeParam.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtHedgeParam.Size = New System.Drawing.Size(85, 13)
        Me.txtHedgeParam.TabIndex = 37
        Me.ToolTip1.SetToolTip(Me.txtHedgeParam, "Allowed values are 'beta' for beta hedge and 'ratio' for pair hedge")
        '
        'txtRule80A
        '
        Me.txtRule80A.AcceptsReturn = True
        Me.txtRule80A.BackColor = System.Drawing.SystemColors.Window
        Me.txtRule80A.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtRule80A.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtRule80A.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtRule80A.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtRule80A.Location = New System.Drawing.Point(144, 394)
        Me.txtRule80A.MaxLength = 0
        Me.txtRule80A.Name = "txtRule80A"
        Me.txtRule80A.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtRule80A.Size = New System.Drawing.Size(85, 13)
        Me.txtRule80A.TabIndex = 33
        '
        'txtSettlingFirm
        '
        Me.txtSettlingFirm.AcceptsReturn = True
        Me.txtSettlingFirm.BackColor = System.Drawing.SystemColors.Window
        Me.txtSettlingFirm.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSettlingFirm.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtSettlingFirm.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSettlingFirm.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSettlingFirm.Location = New System.Drawing.Point(144, 106)
        Me.txtSettlingFirm.MaxLength = 0
        Me.txtSettlingFirm.Name = "txtSettlingFirm"
        Me.txtSettlingFirm.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtSettlingFirm.Size = New System.Drawing.Size(85, 13)
        Me.txtSettlingFirm.TabIndex = 9
        '
        'txtMinQty
        '
        Me.txtMinQty.AcceptsReturn = True
        Me.txtMinQty.BackColor = System.Drawing.SystemColors.Window
        Me.txtMinQty.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMinQty.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMinQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMinQty.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMinQty.Location = New System.Drawing.Point(432, 82)
        Me.txtMinQty.MaxLength = 0
        Me.txtMinQty.Name = "txtMinQty"
        Me.txtMinQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMinQty.Size = New System.Drawing.Size(85, 13)
        Me.txtMinQty.TabIndex = 55
        '
        'txtPercentOffset
        '
        Me.txtPercentOffset.AcceptsReturn = True
        Me.txtPercentOffset.BackColor = System.Drawing.SystemColors.Window
        Me.txtPercentOffset.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtPercentOffset.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtPercentOffset.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtPercentOffset.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtPercentOffset.Location = New System.Drawing.Point(432, 106)
        Me.txtPercentOffset.MaxLength = 0
        Me.txtPercentOffset.Name = "txtPercentOffset"
        Me.txtPercentOffset.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtPercentOffset.Size = New System.Drawing.Size(85, 13)
        Me.txtPercentOffset.TabIndex = 57
        '
        'txtAuctionStrategy
        '
        Me.txtAuctionStrategy.AcceptsReturn = True
        Me.txtAuctionStrategy.BackColor = System.Drawing.SystemColors.Window
        Me.txtAuctionStrategy.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAuctionStrategy.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAuctionStrategy.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAuctionStrategy.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAuctionStrategy.Location = New System.Drawing.Point(432, 370)
        Me.txtAuctionStrategy.MaxLength = 0
        Me.txtAuctionStrategy.Name = "txtAuctionStrategy"
        Me.txtAuctionStrategy.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAuctionStrategy.Size = New System.Drawing.Size(85, 13)
        Me.txtAuctionStrategy.TabIndex = 79
        Me.txtAuctionStrategy.Text = "0"
        '
        'txtStartingPrice
        '
        Me.txtStartingPrice.AcceptsReturn = True
        Me.txtStartingPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtStartingPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStartingPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStartingPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStartingPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStartingPrice.Location = New System.Drawing.Point(432, 394)
        Me.txtStartingPrice.MaxLength = 0
        Me.txtStartingPrice.Name = "txtStartingPrice"
        Me.txtStartingPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStartingPrice.Size = New System.Drawing.Size(85, 13)
        Me.txtStartingPrice.TabIndex = 81
        '
        'txtStockRefPrice
        '
        Me.txtStockRefPrice.AcceptsReturn = True
        Me.txtStockRefPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtStockRefPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStockRefPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStockRefPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStockRefPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStockRefPrice.Location = New System.Drawing.Point(432, 418)
        Me.txtStockRefPrice.MaxLength = 0
        Me.txtStockRefPrice.Name = "txtStockRefPrice"
        Me.txtStockRefPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStockRefPrice.Size = New System.Drawing.Size(85, 13)
        Me.txtStockRefPrice.TabIndex = 83
        '
        'txtDelta
        '
        Me.txtDelta.AcceptsReturn = True
        Me.txtDelta.BackColor = System.Drawing.SystemColors.Window
        Me.txtDelta.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDelta.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDelta.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDelta.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDelta.Location = New System.Drawing.Point(432, 442)
        Me.txtDelta.MaxLength = 0
        Me.txtDelta.Name = "txtDelta"
        Me.txtDelta.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDelta.Size = New System.Drawing.Size(85, 13)
        Me.txtDelta.TabIndex = 85
        '
        'txtStockRangeLower
        '
        Me.txtStockRangeLower.AcceptsReturn = True
        Me.txtStockRangeLower.BackColor = System.Drawing.SystemColors.Window
        Me.txtStockRangeLower.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStockRangeLower.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStockRangeLower.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStockRangeLower.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStockRangeLower.Location = New System.Drawing.Point(432, 468)
        Me.txtStockRangeLower.MaxLength = 0
        Me.txtStockRangeLower.Name = "txtStockRangeLower"
        Me.txtStockRangeLower.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStockRangeLower.Size = New System.Drawing.Size(85, 13)
        Me.txtStockRangeLower.TabIndex = 87
        '
        'txtStockRangeUpper
        '
        Me.txtStockRangeUpper.AcceptsReturn = True
        Me.txtStockRangeUpper.BackColor = System.Drawing.SystemColors.Window
        Me.txtStockRangeUpper.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStockRangeUpper.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStockRangeUpper.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStockRangeUpper.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStockRangeUpper.Location = New System.Drawing.Point(432, 494)
        Me.txtStockRangeUpper.MaxLength = 0
        Me.txtStockRangeUpper.Name = "txtStockRangeUpper"
        Me.txtStockRangeUpper.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStockRangeUpper.Size = New System.Drawing.Size(85, 13)
        Me.txtStockRangeUpper.TabIndex = 89
        '
        'txtAllOrNone
        '
        Me.txtAllOrNone.AcceptsReturn = True
        Me.txtAllOrNone.BackColor = System.Drawing.SystemColors.Window
        Me.txtAllOrNone.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAllOrNone.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAllOrNone.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAllOrNone.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAllOrNone.Location = New System.Drawing.Point(432, 58)
        Me.txtAllOrNone.MaxLength = 0
        Me.txtAllOrNone.Name = "txtAllOrNone"
        Me.txtAllOrNone.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAllOrNone.Size = New System.Drawing.Size(85, 13)
        Me.txtAllOrNone.TabIndex = 53
        Me.txtAllOrNone.Text = "0"
        '
        'txtOcaType
        '
        Me.txtOcaType.AcceptsReturn = True
        Me.txtOcaType.BackColor = System.Drawing.SystemColors.Window
        Me.txtOcaType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOcaType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOcaType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOcaType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOcaType.Location = New System.Drawing.Point(144, 58)
        Me.txtOcaType.MaxLength = 0
        Me.txtOcaType.Name = "txtOcaType"
        Me.txtOcaType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOcaType.Size = New System.Drawing.Size(85, 13)
        Me.txtOcaType.TabIndex = 5
        Me.txtOcaType.Text = "0"
        '
        'txtShortSaleSlot
        '
        Me.txtShortSaleSlot.AcceptsReturn = True
        Me.txtShortSaleSlot.BackColor = System.Drawing.SystemColors.Window
        Me.txtShortSaleSlot.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtShortSaleSlot.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtShortSaleSlot.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtShortSaleSlot.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtShortSaleSlot.Location = New System.Drawing.Point(432, 346)
        Me.txtShortSaleSlot.MaxLength = 0
        Me.txtShortSaleSlot.Name = "txtShortSaleSlot"
        Me.txtShortSaleSlot.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtShortSaleSlot.Size = New System.Drawing.Size(85, 13)
        Me.txtShortSaleSlot.TabIndex = 77
        '
        'txtDesignatedLocation
        '
        Me.txtDesignatedLocation.AcceptsReturn = True
        Me.txtDesignatedLocation.BackColor = System.Drawing.SystemColors.Window
        Me.txtDesignatedLocation.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDesignatedLocation.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDesignatedLocation.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDesignatedLocation.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDesignatedLocation.Location = New System.Drawing.Point(144, 346)
        Me.txtDesignatedLocation.MaxLength = 0
        Me.txtDesignatedLocation.Name = "txtDesignatedLocation"
        Me.txtDesignatedLocation.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDesignatedLocation.Size = New System.Drawing.Size(85, 13)
        Me.txtDesignatedLocation.TabIndex = 29
        '
        'txtDiscretionaryAmt
        '
        Me.txtDiscretionaryAmt.AcceptsReturn = True
        Me.txtDiscretionaryAmt.BackColor = System.Drawing.SystemColors.Window
        Me.txtDiscretionaryAmt.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDiscretionaryAmt.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDiscretionaryAmt.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDiscretionaryAmt.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDiscretionaryAmt.Location = New System.Drawing.Point(432, 322)
        Me.txtDiscretionaryAmt.MaxLength = 0
        Me.txtDiscretionaryAmt.Name = "txtDiscretionaryAmt"
        Me.txtDiscretionaryAmt.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDiscretionaryAmt.Size = New System.Drawing.Size(85, 13)
        Me.txtDiscretionaryAmt.TabIndex = 75
        Me.txtDiscretionaryAmt.Text = "0"
        '
        'cmdOk
        '
        Me.cmdOk.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.cmdOk.BackColor = System.Drawing.SystemColors.Control
        Me.cmdOk.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdOk.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdOk.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdOk.Location = New System.Drawing.Point(345, 741)
        Me.cmdOk.Name = "cmdOk"
        Me.cmdOk.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdOk.Size = New System.Drawing.Size(73, 25)
        Me.cmdOk.TabIndex = 146
        Me.cmdOk.Text = "Ok"
        Me.cmdOk.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Left), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.BackColor = System.Drawing.SystemColors.Control
        Me.cmdCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdCancel.Location = New System.Drawing.Point(456, 741)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdCancel.Size = New System.Drawing.Size(73, 25)
        Me.cmdCancel.TabIndex = 147
        Me.cmdCancel.Text = "Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'txtHidden
        '
        Me.txtHidden.AcceptsReturn = True
        Me.txtHidden.BackColor = System.Drawing.SystemColors.Window
        Me.txtHidden.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtHidden.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtHidden.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtHidden.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtHidden.Location = New System.Drawing.Point(432, 298)
        Me.txtHidden.MaxLength = 0
        Me.txtHidden.Name = "txtHidden"
        Me.txtHidden.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtHidden.Size = New System.Drawing.Size(85, 13)
        Me.txtHidden.TabIndex = 73
        Me.txtHidden.Text = "0"
        '
        'txtOutsideRth
        '
        Me.txtOutsideRth.AcceptsReturn = True
        Me.txtOutsideRth.BackColor = System.Drawing.SystemColors.Window
        Me.txtOutsideRth.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOutsideRth.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOutsideRth.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOutsideRth.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOutsideRth.Location = New System.Drawing.Point(432, 274)
        Me.txtOutsideRth.MaxLength = 0
        Me.txtOutsideRth.Name = "txtOutsideRth"
        Me.txtOutsideRth.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOutsideRth.Size = New System.Drawing.Size(85, 13)
        Me.txtOutsideRth.TabIndex = 71
        Me.txtOutsideRth.Text = "0"
        '
        'txtTriggerMethod
        '
        Me.txtTriggerMethod.AcceptsReturn = True
        Me.txtTriggerMethod.BackColor = System.Drawing.SystemColors.Window
        Me.txtTriggerMethod.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTriggerMethod.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTriggerMethod.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTriggerMethod.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTriggerMethod.Location = New System.Drawing.Point(432, 250)
        Me.txtTriggerMethod.MaxLength = 0
        Me.txtTriggerMethod.Name = "txtTriggerMethod"
        Me.txtTriggerMethod.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTriggerMethod.Size = New System.Drawing.Size(85, 13)
        Me.txtTriggerMethod.TabIndex = 69
        Me.txtTriggerMethod.Text = "0"
        '
        'txtDisplaySize
        '
        Me.txtDisplaySize.AcceptsReturn = True
        Me.txtDisplaySize.BackColor = System.Drawing.SystemColors.Window
        Me.txtDisplaySize.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDisplaySize.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDisplaySize.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDisplaySize.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDisplaySize.Location = New System.Drawing.Point(432, 226)
        Me.txtDisplaySize.MaxLength = 0
        Me.txtDisplaySize.Name = "txtDisplaySize"
        Me.txtDisplaySize.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDisplaySize.Size = New System.Drawing.Size(85, 13)
        Me.txtDisplaySize.TabIndex = 67
        Me.txtDisplaySize.Text = "0"
        '
        'txtSweepToFill
        '
        Me.txtSweepToFill.AcceptsReturn = True
        Me.txtSweepToFill.BackColor = System.Drawing.SystemColors.Window
        Me.txtSweepToFill.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSweepToFill.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtSweepToFill.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSweepToFill.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSweepToFill.Location = New System.Drawing.Point(144, 322)
        Me.txtSweepToFill.MaxLength = 0
        Me.txtSweepToFill.Name = "txtSweepToFill"
        Me.txtSweepToFill.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtSweepToFill.Size = New System.Drawing.Size(85, 13)
        Me.txtSweepToFill.TabIndex = 27
        Me.txtSweepToFill.Text = "0"
        '
        'txtBlockOrder
        '
        Me.txtBlockOrder.AcceptsReturn = True
        Me.txtBlockOrder.BackColor = System.Drawing.SystemColors.Window
        Me.txtBlockOrder.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtBlockOrder.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtBlockOrder.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtBlockOrder.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtBlockOrder.Location = New System.Drawing.Point(144, 298)
        Me.txtBlockOrder.MaxLength = 0
        Me.txtBlockOrder.Name = "txtBlockOrder"
        Me.txtBlockOrder.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtBlockOrder.Size = New System.Drawing.Size(85, 13)
        Me.txtBlockOrder.TabIndex = 25
        Me.txtBlockOrder.Text = "0"
        '
        'txtTransmit
        '
        Me.txtTransmit.AcceptsReturn = True
        Me.txtTransmit.BackColor = System.Drawing.SystemColors.Window
        Me.txtTransmit.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTransmit.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTransmit.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTransmit.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTransmit.Location = New System.Drawing.Point(144, 274)
        Me.txtTransmit.MaxLength = 0
        Me.txtTransmit.Name = "txtTransmit"
        Me.txtTransmit.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTransmit.Size = New System.Drawing.Size(85, 13)
        Me.txtTransmit.TabIndex = 23
        Me.txtTransmit.Text = "1"
        '
        'txtParentId
        '
        Me.txtParentId.AcceptsReturn = True
        Me.txtParentId.BackColor = System.Drawing.SystemColors.Window
        Me.txtParentId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtParentId.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtParentId.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtParentId.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtParentId.Location = New System.Drawing.Point(144, 250)
        Me.txtParentId.MaxLength = 0
        Me.txtParentId.Name = "txtParentId"
        Me.txtParentId.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtParentId.Size = New System.Drawing.Size(85, 13)
        Me.txtParentId.TabIndex = 21
        Me.txtParentId.Text = "0"
        '
        'txtOrderRef
        '
        Me.txtOrderRef.AcceptsReturn = True
        Me.txtOrderRef.BackColor = System.Drawing.SystemColors.Window
        Me.txtOrderRef.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOrderRef.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOrderRef.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOrderRef.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOrderRef.Location = New System.Drawing.Point(144, 226)
        Me.txtOrderRef.MaxLength = 0
        Me.txtOrderRef.Name = "txtOrderRef"
        Me.txtOrderRef.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOrderRef.Size = New System.Drawing.Size(85, 13)
        Me.txtOrderRef.TabIndex = 19
        '
        'txtOrigin
        '
        Me.txtOrigin.AcceptsReturn = True
        Me.txtOrigin.BackColor = System.Drawing.SystemColors.Window
        Me.txtOrigin.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOrigin.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOrigin.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOrigin.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOrigin.Location = New System.Drawing.Point(144, 202)
        Me.txtOrigin.MaxLength = 0
        Me.txtOrigin.Name = "txtOrigin"
        Me.txtOrigin.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOrigin.Size = New System.Drawing.Size(85, 13)
        Me.txtOrigin.TabIndex = 17
        Me.txtOrigin.Text = "0"
        '
        'txtOpenClose
        '
        Me.txtOpenClose.AcceptsReturn = True
        Me.txtOpenClose.BackColor = System.Drawing.SystemColors.Window
        Me.txtOpenClose.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOpenClose.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOpenClose.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOpenClose.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOpenClose.Location = New System.Drawing.Point(144, 178)
        Me.txtOpenClose.MaxLength = 0
        Me.txtOpenClose.Name = "txtOpenClose"
        Me.txtOpenClose.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOpenClose.Size = New System.Drawing.Size(85, 13)
        Me.txtOpenClose.TabIndex = 15
        '
        'txtAccount
        '
        Me.txtAccount.AcceptsReturn = True
        Me.txtAccount.BackColor = System.Drawing.SystemColors.Window
        Me.txtAccount.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAccount.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAccount.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAccount.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAccount.Location = New System.Drawing.Point(144, 82)
        Me.txtAccount.MaxLength = 0
        Me.txtAccount.Name = "txtAccount"
        Me.txtAccount.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAccount.Size = New System.Drawing.Size(85, 13)
        Me.txtAccount.TabIndex = 7
        '
        'txtOCA
        '
        Me.txtOCA.AcceptsReturn = True
        Me.txtOCA.BackColor = System.Drawing.SystemColors.Window
        Me.txtOCA.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOCA.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOCA.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOCA.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOCA.Location = New System.Drawing.Point(144, 34)
        Me.txtOCA.MaxLength = 0
        Me.txtOCA.Name = "txtOCA"
        Me.txtOCA.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOCA.Size = New System.Drawing.Size(85, 13)
        Me.txtOCA.TabIndex = 3
        '
        'txtTIF
        '
        Me.txtTIF.AcceptsReturn = True
        Me.txtTIF.BackColor = System.Drawing.SystemColors.Window
        Me.txtTIF.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTIF.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTIF.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTIF.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTIF.Location = New System.Drawing.Point(144, 10)
        Me.txtTIF.MaxLength = 0
        Me.txtTIF.Name = "txtTIF"
        Me.txtTIF.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTIF.Size = New System.Drawing.Size(85, 13)
        Me.txtTIF.TabIndex = 1
        '
        'Label35
        '
        Me.Label35.BackColor = System.Drawing.Color.Gainsboro
        Me.Label35.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label35.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label35.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label35.Location = New System.Drawing.Point(16, 396)
        Me.Label35.Name = "Label35"
        Me.Label35.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label35.Size = New System.Drawing.Size(73, 17)
        Me.Label35.TabIndex = 32
        Me.Label35.Text = "Rule 80 A"
        '
        'Label34
        '
        Me.Label34.BackColor = System.Drawing.Color.Gainsboro
        Me.Label34.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label34.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label34.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label34.Location = New System.Drawing.Point(16, 108)
        Me.Label34.Name = "Label34"
        Me.Label34.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label34.Size = New System.Drawing.Size(73, 17)
        Me.Label34.TabIndex = 8
        Me.Label34.Text = "Settling Firm"
        '
        'Label33
        '
        Me.Label33.BackColor = System.Drawing.Color.Gainsboro
        Me.Label33.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label33.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label33.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label33.Location = New System.Drawing.Point(264, 83)
        Me.Label33.Name = "Label33"
        Me.Label33.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label33.Size = New System.Drawing.Size(121, 17)
        Me.Label33.TabIndex = 54
        Me.Label33.Text = "Minimum Quantity"
        '
        'Label32
        '
        Me.Label32.BackColor = System.Drawing.Color.Gainsboro
        Me.Label32.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label32.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label32.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label32.Location = New System.Drawing.Point(264, 108)
        Me.Label32.Name = "Label32"
        Me.Label32.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label32.Size = New System.Drawing.Size(105, 17)
        Me.Label32.TabIndex = 56
        Me.Label32.Text = "Percent Offset"
        '
        'Label28
        '
        Me.Label28.BackColor = System.Drawing.Color.Gainsboro
        Me.Label28.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label28.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label28.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label28.Location = New System.Drawing.Point(264, 372)
        Me.Label28.Name = "Label28"
        Me.Label28.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label28.Size = New System.Drawing.Size(120, 17)
        Me.Label28.TabIndex = 78
        Me.Label28.Text = "BOX: Auction Strategy"
        '
        'Label27
        '
        Me.Label27.BackColor = System.Drawing.Color.Gainsboro
        Me.Label27.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label27.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label27.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label27.Location = New System.Drawing.Point(264, 397)
        Me.Label27.Name = "Label27"
        Me.Label27.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label27.Size = New System.Drawing.Size(113, 17)
        Me.Label27.TabIndex = 80
        Me.Label27.Text = "BOX: Starting Price"
        '
        'Label26
        '
        Me.Label26.BackColor = System.Drawing.Color.Gainsboro
        Me.Label26.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label26.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label26.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label26.Location = New System.Drawing.Point(264, 420)
        Me.Label26.Name = "Label26"
        Me.Label26.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label26.Size = New System.Drawing.Size(113, 17)
        Me.Label26.TabIndex = 82
        Me.Label26.Text = "BOX: Stock Ref Price"
        '
        'Label25
        '
        Me.Label25.BackColor = System.Drawing.Color.Gainsboro
        Me.Label25.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label25.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label25.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label25.Location = New System.Drawing.Point(264, 445)
        Me.Label25.Name = "Label25"
        Me.Label25.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label25.Size = New System.Drawing.Size(73, 17)
        Me.Label25.TabIndex = 84
        Me.Label25.Text = "BOX: Delta"
        '
        'Label24
        '
        Me.Label24.BackColor = System.Drawing.Color.Gainsboro
        Me.Label24.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label24.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label24.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label24.Location = New System.Drawing.Point(264, 471)
        Me.Label24.Name = "Label24"
        Me.Label24.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label24.Size = New System.Drawing.Size(160, 17)
        Me.Label24.TabIndex = 86
        Me.Label24.Text = "BOX/VOL: Stock Range Lower"
        '
        'Label23
        '
        Me.Label23.BackColor = System.Drawing.Color.Gainsboro
        Me.Label23.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label23.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label23.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label23.Location = New System.Drawing.Point(264, 497)
        Me.Label23.Name = "Label23"
        Me.Label23.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label23.Size = New System.Drawing.Size(160, 17)
        Me.Label23.TabIndex = 88
        Me.Label23.Text = "BOX/VOL: Stock Range Upper"
        '
        'Label20
        '
        Me.Label20.BackColor = System.Drawing.Color.Gainsboro
        Me.Label20.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label20.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label20.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label20.Location = New System.Drawing.Point(264, 59)
        Me.Label20.Name = "Label20"
        Me.Label20.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label20.Size = New System.Drawing.Size(73, 17)
        Me.Label20.TabIndex = 52
        Me.Label20.Text = "All or None"
        '
        'Label19
        '
        Me.Label19.BackColor = System.Drawing.Color.Gainsboro
        Me.Label19.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label19.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label19.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label19.Location = New System.Drawing.Point(16, 59)
        Me.Label19.Name = "Label19"
        Me.Label19.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label19.Size = New System.Drawing.Size(65, 17)
        Me.Label19.TabIndex = 4
        Me.Label19.Text = "OCA type"
        '
        'Label17
        '
        Me.Label17.BackColor = System.Drawing.Color.Gainsboro
        Me.Label17.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label17.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label17.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label17.Location = New System.Drawing.Point(264, 348)
        Me.Label17.Name = "Label17"
        Me.Label17.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label17.Size = New System.Drawing.Size(152, 17)
        Me.Label17.TabIndex = 76
        Me.Label17.Text = "Short Sales Slot"
        '
        'Label16
        '
        Me.Label16.BackColor = System.Drawing.Color.Gainsboro
        Me.Label16.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label16.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label16.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label16.Location = New System.Drawing.Point(16, 348)
        Me.Label16.Name = "Label16"
        Me.Label16.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label16.Size = New System.Drawing.Size(113, 17)
        Me.Label16.TabIndex = 28
        Me.Label16.Text = "Designated Location"
        '
        'Label15
        '
        Me.Label15.BackColor = System.Drawing.Color.Gainsboro
        Me.Label15.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label15.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label15.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label15.Location = New System.Drawing.Point(264, 324)
        Me.Label15.Name = "Label15"
        Me.Label15.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label15.Size = New System.Drawing.Size(152, 17)
        Me.Label15.TabIndex = 74
        Me.Label15.Text = "Discretionary Amt"
        '
        'Label14
        '
        Me.Label14.BackColor = System.Drawing.Color.Gainsboro
        Me.Label14.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label14.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label14.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label14.Location = New System.Drawing.Point(264, 300)
        Me.Label14.Name = "Label14"
        Me.Label14.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label14.Size = New System.Drawing.Size(65, 17)
        Me.Label14.TabIndex = 72
        Me.Label14.Text = "Hidden"
        '
        'Label13
        '
        Me.Label13.BackColor = System.Drawing.Color.Gainsboro
        Me.Label13.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label13.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label13.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label13.Location = New System.Drawing.Point(264, 276)
        Me.Label13.Name = "Label13"
        Me.Label13.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label13.Size = New System.Drawing.Size(81, 17)
        Me.Label13.TabIndex = 70
        Me.Label13.Text = "Outside RTH"
        '
        'Label12
        '
        Me.Label12.BackColor = System.Drawing.Color.Gainsboro
        Me.Label12.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label12.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label12.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label12.Location = New System.Drawing.Point(264, 252)
        Me.Label12.Name = "Label12"
        Me.Label12.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label12.Size = New System.Drawing.Size(88, 17)
        Me.Label12.TabIndex = 68
        Me.Label12.Text = "Trigger Method"
        '
        'Label11
        '
        Me.Label11.BackColor = System.Drawing.Color.Gainsboro
        Me.Label11.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label11.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label11.Location = New System.Drawing.Point(264, 228)
        Me.Label11.Name = "Label11"
        Me.Label11.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label11.Size = New System.Drawing.Size(65, 17)
        Me.Label11.TabIndex = 66
        Me.Label11.Text = "Display Size"
        '
        'Label10
        '
        Me.Label10.BackColor = System.Drawing.Color.Gainsboro
        Me.Label10.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label10.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label10.Location = New System.Drawing.Point(16, 324)
        Me.Label10.Name = "Label10"
        Me.Label10.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label10.Size = New System.Drawing.Size(88, 17)
        Me.Label10.TabIndex = 26
        Me.Label10.Text = "Sweep to Fill"
        '
        'Label9
        '
        Me.Label9.BackColor = System.Drawing.Color.Gainsboro
        Me.Label9.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label9.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label9.Location = New System.Drawing.Point(16, 300)
        Me.Label9.Name = "Label9"
        Me.Label9.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label9.Size = New System.Drawing.Size(65, 17)
        Me.Label9.TabIndex = 24
        Me.Label9.Text = "Block Order"
        '
        'Label8
        '
        Me.Label8.BackColor = System.Drawing.Color.Gainsboro
        Me.Label8.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label8.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label8.Location = New System.Drawing.Point(16, 276)
        Me.Label8.Name = "Label8"
        Me.Label8.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label8.Size = New System.Drawing.Size(65, 17)
        Me.Label8.TabIndex = 22
        Me.Label8.Text = "Transmit"
        '
        'Label7
        '
        Me.Label7.BackColor = System.Drawing.Color.Gainsboro
        Me.Label7.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label7.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label7.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label7.Location = New System.Drawing.Point(16, 252)
        Me.Label7.Name = "Label7"
        Me.Label7.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label7.Size = New System.Drawing.Size(65, 17)
        Me.Label7.TabIndex = 20
        Me.Label7.Text = "Parent Id"
        '
        'Label6
        '
        Me.Label6.BackColor = System.Drawing.Color.Gainsboro
        Me.Label6.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label6.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label6.Location = New System.Drawing.Point(16, 228)
        Me.Label6.Name = "Label6"
        Me.Label6.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label6.Size = New System.Drawing.Size(65, 17)
        Me.Label6.TabIndex = 18
        Me.Label6.Text = "Order Ref"
        '
        'Label5
        '
        Me.Label5.BackColor = System.Drawing.Color.Gainsboro
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(16, 204)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(65, 17)
        Me.Label5.TabIndex = 16
        Me.Label5.Text = "Origin"
        '
        'Label4
        '
        Me.Label4.BackColor = System.Drawing.Color.Gainsboro
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(16, 180)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(65, 17)
        Me.Label4.TabIndex = 14
        Me.Label4.Text = "Open/Close"
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.Color.Gainsboro
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(16, 84)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(65, 17)
        Me.Label3.TabIndex = 6
        Me.Label3.Text = "Account"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.Gainsboro
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(16, 35)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(65, 17)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "OCA group"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.Gainsboro
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(16, 11)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(88, 17)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Time in Force"
        '
        'txtVolatility
        '
        Me.txtVolatility.AcceptsReturn = True
        Me.txtVolatility.BackColor = System.Drawing.SystemColors.Window
        Me.txtVolatility.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtVolatility.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtVolatility.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtVolatility.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtVolatility.Location = New System.Drawing.Point(753, 10)
        Me.txtVolatility.MaxLength = 0
        Me.txtVolatility.Name = "txtVolatility"
        Me.txtVolatility.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtVolatility.Size = New System.Drawing.Size(85, 13)
        Me.txtVolatility.TabIndex = 101
        '
        'txtVolatilityType
        '
        Me.txtVolatilityType.AcceptsReturn = True
        Me.txtVolatilityType.BackColor = System.Drawing.SystemColors.Window
        Me.txtVolatilityType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtVolatilityType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtVolatilityType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtVolatilityType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtVolatilityType.Location = New System.Drawing.Point(753, 34)
        Me.txtVolatilityType.MaxLength = 0
        Me.txtVolatilityType.Name = "txtVolatilityType"
        Me.txtVolatilityType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtVolatilityType.Size = New System.Drawing.Size(85, 13)
        Me.txtVolatilityType.TabIndex = 103
        '
        'txtDeltaNeutralOrderType
        '
        Me.txtDeltaNeutralOrderType.AcceptsReturn = True
        Me.txtDeltaNeutralOrderType.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralOrderType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralOrderType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralOrderType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralOrderType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralOrderType.Location = New System.Drawing.Point(753, 58)
        Me.txtDeltaNeutralOrderType.MaxLength = 0
        Me.txtDeltaNeutralOrderType.Name = "txtDeltaNeutralOrderType"
        Me.txtDeltaNeutralOrderType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralOrderType.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralOrderType.TabIndex = 105
        '
        'txtContinuousUpdate
        '
        Me.txtContinuousUpdate.AcceptsReturn = True
        Me.txtContinuousUpdate.BackColor = System.Drawing.SystemColors.Window
        Me.txtContinuousUpdate.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtContinuousUpdate.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtContinuousUpdate.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtContinuousUpdate.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtContinuousUpdate.Location = New System.Drawing.Point(753, 298)
        Me.txtContinuousUpdate.MaxLength = 0
        Me.txtContinuousUpdate.Name = "txtContinuousUpdate"
        Me.txtContinuousUpdate.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtContinuousUpdate.Size = New System.Drawing.Size(85, 13)
        Me.txtContinuousUpdate.TabIndex = 124
        '
        'txtReferencePriceType
        '
        Me.txtReferencePriceType.AcceptsReturn = True
        Me.txtReferencePriceType.BackColor = System.Drawing.SystemColors.Window
        Me.txtReferencePriceType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtReferencePriceType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtReferencePriceType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtReferencePriceType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtReferencePriceType.Location = New System.Drawing.Point(753, 322)
        Me.txtReferencePriceType.MaxLength = 0
        Me.txtReferencePriceType.Name = "txtReferencePriceType"
        Me.txtReferencePriceType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtReferencePriceType.Size = New System.Drawing.Size(85, 13)
        Me.txtReferencePriceType.TabIndex = 126
        '
        'Label21
        '
        Me.Label21.BackColor = System.Drawing.Color.Gainsboro
        Me.Label21.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label21.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label21.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label21.Location = New System.Drawing.Point(550, 11)
        Me.Label21.Name = "Label21"
        Me.Label21.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label21.Size = New System.Drawing.Size(105, 17)
        Me.Label21.TabIndex = 100
        Me.Label21.Text = "VOL: Volatility"
        '
        'Label22
        '
        Me.Label22.BackColor = System.Drawing.Color.Gainsboro
        Me.Label22.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label22.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label22.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label22.Location = New System.Drawing.Point(550, 35)
        Me.Label22.Name = "Label22"
        Me.Label22.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label22.Size = New System.Drawing.Size(144, 17)
        Me.Label22.TabIndex = 102
        Me.Label22.Text = "VOL: Volatility Type (1 or 2)"
        '
        'Label36
        '
        Me.Label36.BackColor = System.Drawing.Color.Gainsboro
        Me.Label36.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label36.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label36.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label36.Location = New System.Drawing.Point(550, 59)
        Me.Label36.Name = "Label36"
        Me.Label36.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label36.Size = New System.Drawing.Size(152, 17)
        Me.Label36.TabIndex = 104
        Me.Label36.Text = "VOL: Hedge Delta Order Type"
        '
        'Label37
        '
        Me.Label37.BackColor = System.Drawing.Color.Gainsboro
        Me.Label37.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label37.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label37.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label37.Location = New System.Drawing.Point(550, 300)
        Me.Label37.Name = "Label37"
        Me.Label37.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label37.Size = New System.Drawing.Size(128, 17)
        Me.Label37.TabIndex = 123
        Me.Label37.Text = "VOL: Continuous Update"
        '
        'Label40
        '
        Me.Label40.BackColor = System.Drawing.Color.Gainsboro
        Me.Label40.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label40.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label40.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label40.Location = New System.Drawing.Point(550, 324)
        Me.Label40.Name = "Label40"
        Me.Label40.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label40.Size = New System.Drawing.Size(181, 17)
        Me.Label40.TabIndex = 125
        Me.Label40.Text = "VOL: Reference Price Type (1 or 2)"
        '
        'txtDeltaNeutralAuxPrice
        '
        Me.txtDeltaNeutralAuxPrice.AcceptsReturn = True
        Me.txtDeltaNeutralAuxPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralAuxPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralAuxPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralAuxPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralAuxPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralAuxPrice.Location = New System.Drawing.Point(753, 82)
        Me.txtDeltaNeutralAuxPrice.MaxLength = 0
        Me.txtDeltaNeutralAuxPrice.Name = "txtDeltaNeutralAuxPrice"
        Me.txtDeltaNeutralAuxPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralAuxPrice.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralAuxPrice.TabIndex = 107
        '
        'Label38
        '
        Me.Label38.BackColor = System.Drawing.Color.Gainsboro
        Me.Label38.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label38.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label38.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label38.Location = New System.Drawing.Point(550, 84)
        Me.Label38.Name = "Label38"
        Me.Label38.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label38.Size = New System.Drawing.Size(152, 17)
        Me.Label38.TabIndex = 106
        Me.Label38.Text = "VOL: Hedge Delta Aux Price"
        '
        'txtTrailStopPrice
        '
        Me.txtTrailStopPrice.AcceptsReturn = True
        Me.txtTrailStopPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtTrailStopPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTrailStopPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTrailStopPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTrailStopPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTrailStopPrice.Location = New System.Drawing.Point(432, 10)
        Me.txtTrailStopPrice.MaxLength = 0
        Me.txtTrailStopPrice.Name = "txtTrailStopPrice"
        Me.txtTrailStopPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTrailStopPrice.Size = New System.Drawing.Size(85, 13)
        Me.txtTrailStopPrice.TabIndex = 49
        '
        'Label39
        '
        Me.Label39.BackColor = System.Drawing.Color.Gainsboro
        Me.Label39.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label39.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label39.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label39.Location = New System.Drawing.Point(264, 11)
        Me.Label39.Name = "Label39"
        Me.Label39.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label39.Size = New System.Drawing.Size(96, 17)
        Me.Label39.TabIndex = 48
        Me.Label39.Text = "Trail Stop Price"
        '
        'txtOverridePercentageConstraints
        '
        Me.txtOverridePercentageConstraints.AcceptsReturn = True
        Me.txtOverridePercentageConstraints.BackColor = System.Drawing.SystemColors.Window
        Me.txtOverridePercentageConstraints.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOverridePercentageConstraints.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOverridePercentageConstraints.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOverridePercentageConstraints.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOverridePercentageConstraints.Location = New System.Drawing.Point(432, 202)
        Me.txtOverridePercentageConstraints.MaxLength = 0
        Me.txtOverridePercentageConstraints.Name = "txtOverridePercentageConstraints"
        Me.txtOverridePercentageConstraints.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOverridePercentageConstraints.Size = New System.Drawing.Size(85, 13)
        Me.txtOverridePercentageConstraints.TabIndex = 65
        '
        'Label41
        '
        Me.Label41.BackColor = System.Drawing.Color.Gainsboro
        Me.Label41.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label41.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label41.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label41.Location = New System.Drawing.Point(264, 204)
        Me.Label41.Name = "Label41"
        Me.Label41.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label41.Size = New System.Drawing.Size(168, 17)
        Me.Label41.TabIndex = 64
        Me.Label41.Text = "Override Percentage Constraints"
        '
        'txtScaleInitLevelSize
        '
        Me.txtScaleInitLevelSize.AcceptsReturn = True
        Me.txtScaleInitLevelSize.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleInitLevelSize.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleInitLevelSize.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleInitLevelSize.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleInitLevelSize.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleInitLevelSize.Location = New System.Drawing.Point(753, 346)
        Me.txtScaleInitLevelSize.MaxLength = 0
        Me.txtScaleInitLevelSize.Name = "txtScaleInitLevelSize"
        Me.txtScaleInitLevelSize.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleInitLevelSize.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleInitLevelSize.TabIndex = 128
        '
        'txtScaleSubsLevelSize
        '
        Me.txtScaleSubsLevelSize.AcceptsReturn = True
        Me.txtScaleSubsLevelSize.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleSubsLevelSize.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleSubsLevelSize.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleSubsLevelSize.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleSubsLevelSize.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleSubsLevelSize.Location = New System.Drawing.Point(753, 370)
        Me.txtScaleSubsLevelSize.MaxLength = 0
        Me.txtScaleSubsLevelSize.Name = "txtScaleSubsLevelSize"
        Me.txtScaleSubsLevelSize.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleSubsLevelSize.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleSubsLevelSize.TabIndex = 130
        '
        'txtScalePriceIncr
        '
        Me.txtScalePriceIncr.AcceptsReturn = True
        Me.txtScalePriceIncr.BackColor = System.Drawing.SystemColors.Window
        Me.txtScalePriceIncr.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScalePriceIncr.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScalePriceIncr.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScalePriceIncr.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScalePriceIncr.Location = New System.Drawing.Point(753, 394)
        Me.txtScalePriceIncr.MaxLength = 0
        Me.txtScalePriceIncr.Name = "txtScalePriceIncr"
        Me.txtScalePriceIncr.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScalePriceIncr.Size = New System.Drawing.Size(85, 13)
        Me.txtScalePriceIncr.TabIndex = 132
        '
        'Label42
        '
        Me.Label42.BackColor = System.Drawing.Color.Gainsboro
        Me.Label42.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label42.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label42.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label42.Location = New System.Drawing.Point(550, 348)
        Me.Label42.Name = "Label42"
        Me.Label42.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label42.Size = New System.Drawing.Size(128, 17)
        Me.Label42.TabIndex = 127
        Me.Label42.Text = "SCALE: Init Level Size"
        '
        'Label43
        '
        Me.Label43.BackColor = System.Drawing.Color.Gainsboro
        Me.Label43.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label43.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label43.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label43.Location = New System.Drawing.Point(550, 372)
        Me.Label43.Name = "Label43"
        Me.Label43.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label43.Size = New System.Drawing.Size(128, 17)
        Me.Label43.TabIndex = 129
        Me.Label43.Text = "SCALE: Subs Level Size"
        '
        'Label44
        '
        Me.Label44.BackColor = System.Drawing.Color.Gainsboro
        Me.Label44.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label44.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label44.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label44.Location = New System.Drawing.Point(550, 396)
        Me.Label44.Name = "Label44"
        Me.Label44.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label44.Size = New System.Drawing.Size(128, 17)
        Me.Label44.TabIndex = 131
        Me.Label44.Text = "SCALE: Price Increment"
        '
        'txtClearingAccount
        '
        Me.txtClearingAccount.AcceptsReturn = True
        Me.txtClearingAccount.BackColor = System.Drawing.SystemColors.Window
        Me.txtClearingAccount.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtClearingAccount.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtClearingAccount.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtClearingAccount.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtClearingAccount.Location = New System.Drawing.Point(144, 130)
        Me.txtClearingAccount.MaxLength = 0
        Me.txtClearingAccount.Name = "txtClearingAccount"
        Me.txtClearingAccount.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtClearingAccount.Size = New System.Drawing.Size(85, 13)
        Me.txtClearingAccount.TabIndex = 11
        '
        'Label18
        '
        Me.Label18.BackColor = System.Drawing.Color.Gainsboro
        Me.Label18.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label18.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label18.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label18.Location = New System.Drawing.Point(17, 132)
        Me.Label18.Name = "Label18"
        Me.Label18.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label18.Size = New System.Drawing.Size(96, 17)
        Me.Label18.TabIndex = 10
        Me.Label18.Text = "Clearing Account"
        '
        'txtClearingIntent
        '
        Me.txtClearingIntent.AcceptsReturn = True
        Me.txtClearingIntent.BackColor = System.Drawing.SystemColors.Window
        Me.txtClearingIntent.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtClearingIntent.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtClearingIntent.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtClearingIntent.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtClearingIntent.Location = New System.Drawing.Point(144, 154)
        Me.txtClearingIntent.MaxLength = 0
        Me.txtClearingIntent.Name = "txtClearingIntent"
        Me.txtClearingIntent.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtClearingIntent.Size = New System.Drawing.Size(85, 13)
        Me.txtClearingIntent.TabIndex = 13
        '
        'Label45
        '
        Me.Label45.BackColor = System.Drawing.Color.Gainsboro
        Me.Label45.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label45.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label45.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label45.Location = New System.Drawing.Point(17, 156)
        Me.Label45.Name = "Label45"
        Me.Label45.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label45.Size = New System.Drawing.Size(96, 17)
        Me.Label45.TabIndex = 12
        Me.Label45.Text = "Clearing Intent"
        '
        'txtExemptCode
        '
        Me.txtExemptCode.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtExemptCode.Location = New System.Drawing.Point(144, 370)
        Me.txtExemptCode.Name = "txtExemptCode"
        Me.txtExemptCode.Size = New System.Drawing.Size(84, 13)
        Me.txtExemptCode.TabIndex = 31
        Me.txtExemptCode.Text = "-1"
        '
        'Label46
        '
        Me.Label46.AutoSize = True
        Me.Label46.Location = New System.Drawing.Point(16, 373)
        Me.Label46.Name = "Label46"
        Me.Label46.Size = New System.Drawing.Size(70, 14)
        Me.Label46.TabIndex = 30
        Me.Label46.Text = "Exempt Code"
        '
        'txtHedgeType
        '
        Me.txtHedgeType.AcceptsReturn = True
        Me.txtHedgeType.BackColor = System.Drawing.SystemColors.Window
        Me.txtHedgeType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtHedgeType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtHedgeType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtHedgeType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtHedgeType.Location = New System.Drawing.Point(143, 418)
        Me.txtHedgeType.MaxLength = 0
        Me.txtHedgeType.Name = "txtHedgeType"
        Me.txtHedgeType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtHedgeType.Size = New System.Drawing.Size(85, 13)
        Me.txtHedgeType.TabIndex = 35
        '
        'LabelHedgeType
        '
        Me.LabelHedgeType.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelHedgeType.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelHedgeType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelHedgeType.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelHedgeType.Location = New System.Drawing.Point(16, 421)
        Me.LabelHedgeType.Name = "LabelHedgeType"
        Me.LabelHedgeType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelHedgeType.Size = New System.Drawing.Size(73, 17)
        Me.LabelHedgeType.TabIndex = 34
        Me.LabelHedgeType.Text = "Hedge: type"
        '
        'LabelHedgeParam
        '
        Me.LabelHedgeParam.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelHedgeParam.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelHedgeParam.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelHedgeParam.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelHedgeParam.Location = New System.Drawing.Point(16, 447)
        Me.LabelHedgeParam.Name = "LabelHedgeParam"
        Me.LabelHedgeParam.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelHedgeParam.Size = New System.Drawing.Size(85, 17)
        Me.LabelHedgeParam.TabIndex = 36
        Me.LabelHedgeParam.Text = "Hedge: param"
        '
        'checkOptOutSmartRouting
        '
        Me.checkOptOutSmartRouting.AutoSize = True
        Me.checkOptOutSmartRouting.Location = New System.Drawing.Point(16, 471)
        Me.checkOptOutSmartRouting.Name = "checkOptOutSmartRouting"
        Me.checkOptOutSmartRouting.Size = New System.Drawing.Size(166, 18)
        Me.checkOptOutSmartRouting.TabIndex = 38
        Me.checkOptOutSmartRouting.Text = "Opting out of SMART Routing"
        Me.checkOptOutSmartRouting.UseVisualStyleBackColor = True
        '
        'Label47
        '
        Me.Label47.BackColor = System.Drawing.Color.Gainsboro
        Me.Label47.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label47.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label47.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label47.Location = New System.Drawing.Point(550, 108)
        Me.Label47.Name = "Label47"
        Me.Label47.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label47.Size = New System.Drawing.Size(152, 17)
        Me.Label47.TabIndex = 108
        Me.Label47.Text = "VOL: Hedge Delta Con Id"
        '
        'Label48
        '
        Me.Label48.BackColor = System.Drawing.Color.Gainsboro
        Me.Label48.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label48.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label48.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label48.Location = New System.Drawing.Point(550, 132)
        Me.Label48.Name = "Label48"
        Me.Label48.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label48.Size = New System.Drawing.Size(181, 17)
        Me.Label48.TabIndex = 110
        Me.Label48.Text = "VOL: Hedge Delta Settling Firm"
        '
        'Label49
        '
        Me.Label49.BackColor = System.Drawing.Color.Gainsboro
        Me.Label49.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label49.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label49.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label49.Location = New System.Drawing.Point(550, 156)
        Me.Label49.Name = "Label49"
        Me.Label49.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label49.Size = New System.Drawing.Size(188, 17)
        Me.Label49.TabIndex = 112
        Me.Label49.Text = "VOL: Hedge Delta Clearing Account"
        '
        'Label50
        '
        Me.Label50.BackColor = System.Drawing.Color.Gainsboro
        Me.Label50.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label50.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label50.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label50.Location = New System.Drawing.Point(550, 180)
        Me.Label50.Name = "Label50"
        Me.Label50.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label50.Size = New System.Drawing.Size(181, 17)
        Me.Label50.TabIndex = 114
        Me.Label50.Text = "VOL: Hedge Delta Clearing Intent"
        '
        'txtDeltaNeutralConId
        '
        Me.txtDeltaNeutralConId.AcceptsReturn = True
        Me.txtDeltaNeutralConId.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralConId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralConId.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralConId.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralConId.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralConId.Location = New System.Drawing.Point(753, 106)
        Me.txtDeltaNeutralConId.MaxLength = 0
        Me.txtDeltaNeutralConId.Name = "txtDeltaNeutralConId"
        Me.txtDeltaNeutralConId.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralConId.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralConId.TabIndex = 109
        '
        'txtDeltaNeutralClearingIntent
        '
        Me.txtDeltaNeutralClearingIntent.AcceptsReturn = True
        Me.txtDeltaNeutralClearingIntent.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralClearingIntent.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralClearingIntent.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralClearingIntent.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralClearingIntent.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralClearingIntent.Location = New System.Drawing.Point(753, 178)
        Me.txtDeltaNeutralClearingIntent.MaxLength = 0
        Me.txtDeltaNeutralClearingIntent.Name = "txtDeltaNeutralClearingIntent"
        Me.txtDeltaNeutralClearingIntent.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralClearingIntent.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralClearingIntent.TabIndex = 115
        '
        'txtDeltaNeutralClearingAccount
        '
        Me.txtDeltaNeutralClearingAccount.AcceptsReturn = True
        Me.txtDeltaNeutralClearingAccount.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralClearingAccount.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralClearingAccount.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralClearingAccount.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralClearingAccount.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralClearingAccount.Location = New System.Drawing.Point(753, 154)
        Me.txtDeltaNeutralClearingAccount.MaxLength = 0
        Me.txtDeltaNeutralClearingAccount.Name = "txtDeltaNeutralClearingAccount"
        Me.txtDeltaNeutralClearingAccount.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralClearingAccount.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralClearingAccount.TabIndex = 113
        '
        'txtDeltaNeutralSettlingFirm
        '
        Me.txtDeltaNeutralSettlingFirm.AcceptsReturn = True
        Me.txtDeltaNeutralSettlingFirm.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralSettlingFirm.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralSettlingFirm.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralSettlingFirm.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralSettlingFirm.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralSettlingFirm.Location = New System.Drawing.Point(753, 130)
        Me.txtDeltaNeutralSettlingFirm.MaxLength = 0
        Me.txtDeltaNeutralSettlingFirm.Name = "txtDeltaNeutralSettlingFirm"
        Me.txtDeltaNeutralSettlingFirm.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralSettlingFirm.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralSettlingFirm.TabIndex = 111
        '
        'Label51
        '
        Me.Label51.BackColor = System.Drawing.Color.Gainsboro
        Me.Label51.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label51.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label51.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label51.Location = New System.Drawing.Point(550, 420)
        Me.Label51.Name = "Label51"
        Me.Label51.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label51.Size = New System.Drawing.Size(181, 17)
        Me.Label51.TabIndex = 133
        Me.Label51.Text = "SCALE: Price Adjust Value"
        '
        'Label52
        '
        Me.Label52.BackColor = System.Drawing.Color.Gainsboro
        Me.Label52.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label52.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label52.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label52.Location = New System.Drawing.Point(550, 444)
        Me.Label52.Name = "Label52"
        Me.Label52.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label52.Size = New System.Drawing.Size(181, 17)
        Me.Label52.TabIndex = 135
        Me.Label52.Text = "SCALE: Price Adjust Interval"
        '
        'Label53
        '
        Me.Label53.BackColor = System.Drawing.Color.Gainsboro
        Me.Label53.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label53.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label53.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label53.Location = New System.Drawing.Point(550, 469)
        Me.Label53.Name = "Label53"
        Me.Label53.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label53.Size = New System.Drawing.Size(181, 17)
        Me.Label53.TabIndex = 137
        Me.Label53.Text = "SCALE: Profit Offset"
        '
        'checkScaleAutoReset
        '
        Me.checkScaleAutoReset.AutoSize = True
        Me.checkScaleAutoReset.Location = New System.Drawing.Point(550, 490)
        Me.checkScaleAutoReset.Name = "checkScaleAutoReset"
        Me.checkScaleAutoReset.Size = New System.Drawing.Size(119, 18)
        Me.checkScaleAutoReset.TabIndex = 139
        Me.checkScaleAutoReset.Text = "SCALE: Auto Reset"
        Me.checkScaleAutoReset.UseVisualStyleBackColor = True
        '
        'txtScalePriceAdjustValue
        '
        Me.txtScalePriceAdjustValue.AcceptsReturn = True
        Me.txtScalePriceAdjustValue.BackColor = System.Drawing.SystemColors.Window
        Me.txtScalePriceAdjustValue.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScalePriceAdjustValue.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScalePriceAdjustValue.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScalePriceAdjustValue.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScalePriceAdjustValue.Location = New System.Drawing.Point(753, 418)
        Me.txtScalePriceAdjustValue.MaxLength = 0
        Me.txtScalePriceAdjustValue.Name = "txtScalePriceAdjustValue"
        Me.txtScalePriceAdjustValue.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScalePriceAdjustValue.Size = New System.Drawing.Size(85, 13)
        Me.txtScalePriceAdjustValue.TabIndex = 134
        '
        'Label54
        '
        Me.Label54.BackColor = System.Drawing.Color.Gainsboro
        Me.Label54.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label54.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label54.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label54.Location = New System.Drawing.Point(550, 517)
        Me.Label54.Name = "Label54"
        Me.Label54.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label54.Size = New System.Drawing.Size(181, 17)
        Me.Label54.TabIndex = 140
        Me.Label54.Text = "SCALE: Init Position"
        '
        'Label55
        '
        Me.Label55.BackColor = System.Drawing.Color.Gainsboro
        Me.Label55.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label55.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label55.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label55.Location = New System.Drawing.Point(550, 543)
        Me.Label55.Name = "Label55"
        Me.Label55.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label55.Size = New System.Drawing.Size(181, 17)
        Me.Label55.TabIndex = 142
        Me.Label55.Text = "SCALE: Init Fill Qty"
        '
        'checkScaleRandomPercent
        '
        Me.checkScaleRandomPercent.AutoSize = True
        Me.checkScaleRandomPercent.Location = New System.Drawing.Point(550, 567)
        Me.checkScaleRandomPercent.Name = "checkScaleRandomPercent"
        Me.checkScaleRandomPercent.Size = New System.Drawing.Size(145, 18)
        Me.checkScaleRandomPercent.TabIndex = 144
        Me.checkScaleRandomPercent.Text = "SCALE: Random Percent"
        Me.checkScaleRandomPercent.UseVisualStyleBackColor = True
        '
        'txtScalePriceAdjustInterval
        '
        Me.txtScalePriceAdjustInterval.AcceptsReturn = True
        Me.txtScalePriceAdjustInterval.BackColor = System.Drawing.SystemColors.Window
        Me.txtScalePriceAdjustInterval.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScalePriceAdjustInterval.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScalePriceAdjustInterval.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScalePriceAdjustInterval.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScalePriceAdjustInterval.Location = New System.Drawing.Point(753, 442)
        Me.txtScalePriceAdjustInterval.MaxLength = 0
        Me.txtScalePriceAdjustInterval.Name = "txtScalePriceAdjustInterval"
        Me.txtScalePriceAdjustInterval.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScalePriceAdjustInterval.Size = New System.Drawing.Size(85, 13)
        Me.txtScalePriceAdjustInterval.TabIndex = 136
        '
        'txtScaleInitPosition
        '
        Me.txtScaleInitPosition.AcceptsReturn = True
        Me.txtScaleInitPosition.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleInitPosition.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleInitPosition.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleInitPosition.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleInitPosition.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleInitPosition.Location = New System.Drawing.Point(753, 514)
        Me.txtScaleInitPosition.MaxLength = 0
        Me.txtScaleInitPosition.Name = "txtScaleInitPosition"
        Me.txtScaleInitPosition.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleInitPosition.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleInitPosition.TabIndex = 141
        '
        'txtScaleInitFillQty
        '
        Me.txtScaleInitFillQty.AcceptsReturn = True
        Me.txtScaleInitFillQty.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleInitFillQty.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleInitFillQty.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleInitFillQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleInitFillQty.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleInitFillQty.Location = New System.Drawing.Point(753, 540)
        Me.txtScaleInitFillQty.MaxLength = 0
        Me.txtScaleInitFillQty.Name = "txtScaleInitFillQty"
        Me.txtScaleInitFillQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleInitFillQty.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleInitFillQty.TabIndex = 143
        '
        'txtScaleProfitOffset
        '
        Me.txtScaleProfitOffset.AcceptsReturn = True
        Me.txtScaleProfitOffset.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleProfitOffset.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleProfitOffset.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleProfitOffset.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleProfitOffset.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleProfitOffset.Location = New System.Drawing.Point(753, 466)
        Me.txtScaleProfitOffset.MaxLength = 0
        Me.txtScaleProfitOffset.Name = "txtScaleProfitOffset"
        Me.txtScaleProfitOffset.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleProfitOffset.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleProfitOffset.TabIndex = 138
        '
        'Label56
        '
        Me.Label56.BackColor = System.Drawing.Color.Gainsboro
        Me.Label56.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label56.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label56.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label56.Location = New System.Drawing.Point(264, 35)
        Me.Label56.Name = "Label56"
        Me.Label56.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label56.Size = New System.Drawing.Size(136, 17)
        Me.Label56.TabIndex = 50
        Me.Label56.Text = "Trailing Percent"
        '
        'txtTrailingPercent
        '
        Me.txtTrailingPercent.AcceptsReturn = True
        Me.txtTrailingPercent.BackColor = System.Drawing.SystemColors.Window
        Me.txtTrailingPercent.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTrailingPercent.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTrailingPercent.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTrailingPercent.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTrailingPercent.Location = New System.Drawing.Point(432, 34)
        Me.txtTrailingPercent.MaxLength = 0
        Me.txtTrailingPercent.Name = "txtTrailingPercent"
        Me.txtTrailingPercent.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTrailingPercent.Size = New System.Drawing.Size(85, 13)
        Me.txtTrailingPercent.TabIndex = 51
        '
        'txtDeltaNeutralOpenClose
        '
        Me.txtDeltaNeutralOpenClose.AcceptsReturn = True
        Me.txtDeltaNeutralOpenClose.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralOpenClose.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralOpenClose.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralOpenClose.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralOpenClose.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralOpenClose.Location = New System.Drawing.Point(753, 202)
        Me.txtDeltaNeutralOpenClose.MaxLength = 0
        Me.txtDeltaNeutralOpenClose.Name = "txtDeltaNeutralOpenClose"
        Me.txtDeltaNeutralOpenClose.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralOpenClose.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralOpenClose.TabIndex = 117
        '
        'Label57
        '
        Me.Label57.BackColor = System.Drawing.Color.Gainsboro
        Me.Label57.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label57.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label57.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label57.Location = New System.Drawing.Point(550, 204)
        Me.Label57.Name = "Label57"
        Me.Label57.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label57.Size = New System.Drawing.Size(181, 17)
        Me.Label57.TabIndex = 116
        Me.Label57.Text = "VOL: Hedge Delta Open/Close"
        '
        'checkDeltaNeutralShortSale
        '
        Me.checkDeltaNeutralShortSale.AutoSize = True
        Me.checkDeltaNeutralShortSale.Location = New System.Drawing.Point(553, 228)
        Me.checkDeltaNeutralShortSale.Name = "checkDeltaNeutralShortSale"
        Me.checkDeltaNeutralShortSale.Size = New System.Drawing.Size(165, 18)
        Me.checkDeltaNeutralShortSale.TabIndex = 118
        Me.checkDeltaNeutralShortSale.Text = "VOL: Hedge Delta Short Sale"
        Me.checkDeltaNeutralShortSale.UseVisualStyleBackColor = True
        '
        'txtDeltaNeutralShortSaleSlot
        '
        Me.txtDeltaNeutralShortSaleSlot.AcceptsReturn = True
        Me.txtDeltaNeutralShortSaleSlot.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralShortSaleSlot.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralShortSaleSlot.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralShortSaleSlot.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralShortSaleSlot.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralShortSaleSlot.Location = New System.Drawing.Point(753, 250)
        Me.txtDeltaNeutralShortSaleSlot.MaxLength = 0
        Me.txtDeltaNeutralShortSaleSlot.Name = "txtDeltaNeutralShortSaleSlot"
        Me.txtDeltaNeutralShortSaleSlot.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralShortSaleSlot.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralShortSaleSlot.TabIndex = 120
        Me.txtDeltaNeutralShortSaleSlot.Text = "0"
        '
        'Label58
        '
        Me.Label58.BackColor = System.Drawing.Color.Gainsboro
        Me.Label58.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label58.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label58.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label58.Location = New System.Drawing.Point(550, 252)
        Me.Label58.Name = "Label58"
        Me.Label58.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label58.Size = New System.Drawing.Size(181, 17)
        Me.Label58.TabIndex = 119
        Me.Label58.Text = "VOL: Hedge Delta Short Sale Slot"
        '
        'txtDeltaNeutralDesignatedLocation
        '
        Me.txtDeltaNeutralDesignatedLocation.AcceptsReturn = True
        Me.txtDeltaNeutralDesignatedLocation.BackColor = System.Drawing.SystemColors.Window
        Me.txtDeltaNeutralDesignatedLocation.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDeltaNeutralDesignatedLocation.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDeltaNeutralDesignatedLocation.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDeltaNeutralDesignatedLocation.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDeltaNeutralDesignatedLocation.Location = New System.Drawing.Point(753, 274)
        Me.txtDeltaNeutralDesignatedLocation.MaxLength = 0
        Me.txtDeltaNeutralDesignatedLocation.Name = "txtDeltaNeutralDesignatedLocation"
        Me.txtDeltaNeutralDesignatedLocation.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDeltaNeutralDesignatedLocation.Size = New System.Drawing.Size(85, 13)
        Me.txtDeltaNeutralDesignatedLocation.TabIndex = 122
        '
        'Label59
        '
        Me.Label59.BackColor = System.Drawing.Color.Gainsboro
        Me.Label59.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label59.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label59.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label59.Location = New System.Drawing.Point(550, 269)
        Me.Label59.Name = "Label59"
        Me.Label59.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label59.Size = New System.Drawing.Size(181, 31)
        Me.Label59.TabIndex = 121
        Me.Label59.Text = "VOL: Hedge Delta Designated Location"
        '
        'txtActiveStopTime
        '
        Me.txtActiveStopTime.AcceptsReturn = True
        Me.txtActiveStopTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtActiveStopTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtActiveStopTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtActiveStopTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtActiveStopTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtActiveStopTime.Location = New System.Drawing.Point(432, 567)
        Me.txtActiveStopTime.MaxLength = 0
        Me.txtActiveStopTime.Name = "txtActiveStopTime"
        Me.txtActiveStopTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtActiveStopTime.Size = New System.Drawing.Size(85, 13)
        Me.txtActiveStopTime.TabIndex = 95
        '
        'txtActiveStartTime
        '
        Me.txtActiveStartTime.AcceptsReturn = True
        Me.txtActiveStartTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtActiveStartTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtActiveStartTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtActiveStartTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtActiveStartTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtActiveStartTime.Location = New System.Drawing.Point(432, 543)
        Me.txtActiveStartTime.MaxLength = 0
        Me.txtActiveStartTime.Name = "txtActiveStartTime"
        Me.txtActiveStartTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtActiveStartTime.Size = New System.Drawing.Size(85, 13)
        Me.txtActiveStartTime.TabIndex = 93
        '
        'txtScaleTable
        '
        Me.txtScaleTable.AcceptsReturn = True
        Me.txtScaleTable.BackColor = System.Drawing.SystemColors.Window
        Me.txtScaleTable.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtScaleTable.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtScaleTable.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtScaleTable.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtScaleTable.Location = New System.Drawing.Point(432, 519)
        Me.txtScaleTable.MaxLength = 0
        Me.txtScaleTable.Name = "txtScaleTable"
        Me.txtScaleTable.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtScaleTable.Size = New System.Drawing.Size(85, 13)
        Me.txtScaleTable.TabIndex = 91
        '
        'Label60
        '
        Me.Label60.BackColor = System.Drawing.Color.Gainsboro
        Me.Label60.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label60.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label60.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label60.Location = New System.Drawing.Point(264, 570)
        Me.Label60.Name = "Label60"
        Me.Label60.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label60.Size = New System.Drawing.Size(160, 17)
        Me.Label60.TabIndex = 94
        Me.Label60.Text = "Active Stop Time"
        '
        'Label61
        '
        Me.Label61.BackColor = System.Drawing.Color.Gainsboro
        Me.Label61.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label61.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label61.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label61.Location = New System.Drawing.Point(264, 545)
        Me.Label61.Name = "Label61"
        Me.Label61.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label61.Size = New System.Drawing.Size(160, 17)
        Me.Label61.TabIndex = 92
        Me.Label61.Text = "Active Start Time"
        '
        'Label62
        '
        Me.Label62.BackColor = System.Drawing.Color.Gainsboro
        Me.Label62.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label62.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label62.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label62.Location = New System.Drawing.Point(264, 521)
        Me.Label62.Name = "Label62"
        Me.Label62.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label62.Size = New System.Drawing.Size(160, 17)
        Me.Label62.TabIndex = 90
        Me.Label62.Text = "SCALE: Scale Table"
        '
        'cbSolicited
        '
        Me.cbSolicited.AutoSize = True
        Me.cbSolicited.Location = New System.Drawing.Point(16, 497)
        Me.cbSolicited.Name = "cbSolicited"
        Me.cbSolicited.Size = New System.Drawing.Size(66, 18)
        Me.cbSolicited.TabIndex = 39
        Me.cbSolicited.Text = "Solicited"
        Me.cbSolicited.UseVisualStyleBackColor = True
        '
        'cbRandomizeSize
        '
        Me.cbRandomizeSize.AutoSize = True
        Me.cbRandomizeSize.Location = New System.Drawing.Point(16, 521)
        Me.cbRandomizeSize.Name = "cbRandomizeSize"
        Me.cbRandomizeSize.Size = New System.Drawing.Size(103, 18)
        Me.cbRandomizeSize.TabIndex = 40
        Me.cbRandomizeSize.Text = "Randomize Size"
        Me.cbRandomizeSize.UseVisualStyleBackColor = True
        '
        'cbRandomizePrice
        '
        Me.cbRandomizePrice.AutoSize = True
        Me.cbRandomizePrice.Location = New System.Drawing.Point(16, 545)
        Me.cbRandomizePrice.Name = "cbRandomizePrice"
        Me.cbRandomizePrice.Size = New System.Drawing.Size(106, 18)
        Me.cbRandomizePrice.TabIndex = 41
        Me.cbRandomizePrice.Text = "Randomize Price"
        Me.cbRandomizePrice.UseVisualStyleBackColor = True
        '
        'txtModelCode
        '
        Me.txtModelCode.AcceptsReturn = True
        Me.txtModelCode.BackColor = System.Drawing.SystemColors.Window
        Me.txtModelCode.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtModelCode.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtModelCode.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtModelCode.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtModelCode.Location = New System.Drawing.Point(143, 567)
        Me.txtModelCode.MaxLength = 0
        Me.txtModelCode.Name = "txtModelCode"
        Me.txtModelCode.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtModelCode.Size = New System.Drawing.Size(85, 13)
        Me.txtModelCode.TabIndex = 43
        '
        'Label63
        '
        Me.Label63.BackColor = System.Drawing.Color.Gainsboro
        Me.Label63.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label63.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label63.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label63.Location = New System.Drawing.Point(16, 570)
        Me.Label63.Name = "Label63"
        Me.Label63.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label63.Size = New System.Drawing.Size(65, 17)
        Me.Label63.TabIndex = 42
        Me.Label63.Text = "Model Code"
        '
        'txtMifid2DecisionMaker
        '
        Me.txtMifid2DecisionMaker.AcceptsReturn = True
        Me.txtMifid2DecisionMaker.BackColor = System.Drawing.SystemColors.Window
        Me.txtMifid2DecisionMaker.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMifid2DecisionMaker.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMifid2DecisionMaker.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMifid2DecisionMaker.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMifid2DecisionMaker.Location = New System.Drawing.Point(143, 589)
        Me.txtMifid2DecisionMaker.MaxLength = 0
        Me.txtMifid2DecisionMaker.Name = "txtMifid2DecisionMaker"
        Me.txtMifid2DecisionMaker.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMifid2DecisionMaker.Size = New System.Drawing.Size(85, 13)
        Me.txtMifid2DecisionMaker.TabIndex = 45
        '
        'Label64
        '
        Me.Label64.BackColor = System.Drawing.Color.Gainsboro
        Me.Label64.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label64.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label64.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label64.Location = New System.Drawing.Point(17, 589)
        Me.Label64.Name = "Label64"
        Me.Label64.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label64.Size = New System.Drawing.Size(121, 17)
        Me.Label64.TabIndex = 44
        Me.Label64.Text = "MiFID II Decision Maker"
        '
        'txtMifid2DecisionAlgo
        '
        Me.txtMifid2DecisionAlgo.AcceptsReturn = True
        Me.txtMifid2DecisionAlgo.BackColor = System.Drawing.SystemColors.Window
        Me.txtMifid2DecisionAlgo.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMifid2DecisionAlgo.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMifid2DecisionAlgo.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMifid2DecisionAlgo.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMifid2DecisionAlgo.Location = New System.Drawing.Point(432, 589)
        Me.txtMifid2DecisionAlgo.MaxLength = 0
        Me.txtMifid2DecisionAlgo.Name = "txtMifid2DecisionAlgo"
        Me.txtMifid2DecisionAlgo.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMifid2DecisionAlgo.Size = New System.Drawing.Size(85, 13)
        Me.txtMifid2DecisionAlgo.TabIndex = 97
        '
        'Label65
        '
        Me.Label65.BackColor = System.Drawing.Color.Gainsboro
        Me.Label65.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label65.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label65.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label65.Location = New System.Drawing.Point(264, 589)
        Me.Label65.Name = "Label65"
        Me.Label65.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label65.Size = New System.Drawing.Size(160, 17)
        Me.Label65.TabIndex = 96
        Me.Label65.Text = "MiFID II Decision Algo"
        '
        'txtMifid2ExecutionTrader
        '
        Me.txtMifid2ExecutionTrader.AcceptsReturn = True
        Me.txtMifid2ExecutionTrader.BackColor = System.Drawing.SystemColors.Window
        Me.txtMifid2ExecutionTrader.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMifid2ExecutionTrader.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMifid2ExecutionTrader.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMifid2ExecutionTrader.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMifid2ExecutionTrader.Location = New System.Drawing.Point(144, 613)
        Me.txtMifid2ExecutionTrader.MaxLength = 0
        Me.txtMifid2ExecutionTrader.Name = "txtMifid2ExecutionTrader"
        Me.txtMifid2ExecutionTrader.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMifid2ExecutionTrader.Size = New System.Drawing.Size(85, 13)
        Me.txtMifid2ExecutionTrader.TabIndex = 47
        '
        'Label66
        '
        Me.Label66.BackColor = System.Drawing.Color.Gainsboro
        Me.Label66.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label66.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label66.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label66.Location = New System.Drawing.Point(17, 613)
        Me.Label66.Name = "Label66"
        Me.Label66.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label66.Size = New System.Drawing.Size(133, 17)
        Me.Label66.TabIndex = 46
        Me.Label66.Text = "MiFID II Execution Trader"
        '
        'txtMifid2ExecutionAlgo
        '
        Me.txtMifid2ExecutionAlgo.AcceptsReturn = True
        Me.txtMifid2ExecutionAlgo.BackColor = System.Drawing.SystemColors.Window
        Me.txtMifid2ExecutionAlgo.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMifid2ExecutionAlgo.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMifid2ExecutionAlgo.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMifid2ExecutionAlgo.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMifid2ExecutionAlgo.Location = New System.Drawing.Point(432, 613)
        Me.txtMifid2ExecutionAlgo.MaxLength = 0
        Me.txtMifid2ExecutionAlgo.Name = "txtMifid2ExecutionAlgo"
        Me.txtMifid2ExecutionAlgo.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMifid2ExecutionAlgo.Size = New System.Drawing.Size(85, 13)
        Me.txtMifid2ExecutionAlgo.TabIndex = 99
        '
        'Label67
        '
        Me.Label67.BackColor = System.Drawing.Color.Gainsboro
        Me.Label67.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label67.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label67.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label67.Location = New System.Drawing.Point(264, 613)
        Me.Label67.Name = "Label67"
        Me.Label67.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label67.Size = New System.Drawing.Size(160, 17)
        Me.Label67.TabIndex = 98
        Me.Label67.Text = "MiFID II Execution Algo"
        '
        'checkDontUseAutoPriceForHedge
        '
        Me.checkDontUseAutoPriceForHedge.AutoSize = True
        Me.checkDontUseAutoPriceForHedge.Location = New System.Drawing.Point(549, 591)
        Me.checkDontUseAutoPriceForHedge.Name = "checkDontUseAutoPriceForHedge"
        Me.checkDontUseAutoPriceForHedge.Size = New System.Drawing.Size(172, 18)
        Me.checkDontUseAutoPriceForHedge.TabIndex = 145
        Me.checkDontUseAutoPriceForHedge.Text = "Don't use auto price for hedge"
        Me.checkDontUseAutoPriceForHedge.UseVisualStyleBackColor = True
        '
        'checkOmsContainer
        '
        Me.checkOmsContainer.AutoSize = True
        Me.checkOmsContainer.Location = New System.Drawing.Point(549, 615)
        Me.checkOmsContainer.Name = "checkOmsContainer"
        Me.checkOmsContainer.Size = New System.Drawing.Size(98, 18)
        Me.checkOmsContainer.TabIndex = 148
        Me.checkOmsContainer.Text = "OMS Container"
        Me.checkOmsContainer.UseVisualStyleBackColor = True
        '
        'checkRelativeDiscretionary
        '
        Me.checkRelativeDiscretionary.AutoSize = True
        Me.checkRelativeDiscretionary.Location = New System.Drawing.Point(549, 639)
        Me.checkRelativeDiscretionary.Name = "checkRelativeDiscretionary"
        Me.checkRelativeDiscretionary.Size = New System.Drawing.Size(130, 18)
        Me.checkRelativeDiscretionary.TabIndex = 149
        Me.checkRelativeDiscretionary.Text = "Relative discretionary"
        Me.checkRelativeDiscretionary.UseVisualStyleBackColor = True
        '
        'Label29
        '
        Me.Label29.BackColor = System.Drawing.Color.Gainsboro
        Me.Label29.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label29.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label29.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label29.Location = New System.Drawing.Point(264, 132)
        Me.Label29.Name = "Label29"
        Me.Label29.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label29.Size = New System.Drawing.Size(105, 17)
        Me.Label29.TabIndex = 150
        Me.Label29.Text = "Duration"
        '
        'txtDuration
        '
        Me.txtDuration.AcceptsReturn = True
        Me.txtDuration.BackColor = System.Drawing.SystemColors.Window
        Me.txtDuration.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDuration.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDuration.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDuration.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDuration.Location = New System.Drawing.Point(432, 130)
        Me.txtDuration.MaxLength = 0
        Me.txtDuration.Name = "txtDuration"
        Me.txtDuration.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDuration.Size = New System.Drawing.Size(85, 13)
        Me.txtDuration.TabIndex = 151
        '
        'txtPostToAts
        '
        Me.txtPostToAts.AcceptsReturn = True
        Me.txtPostToAts.BackColor = System.Drawing.SystemColors.Window
        Me.txtPostToAts.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtPostToAts.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtPostToAts.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtPostToAts.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtPostToAts.Location = New System.Drawing.Point(432, 154)
        Me.txtPostToAts.MaxLength = 0
        Me.txtPostToAts.Name = "txtPostToAts"
        Me.txtPostToAts.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtPostToAts.Size = New System.Drawing.Size(85, 13)
        Me.txtPostToAts.TabIndex = 153
        '
        'Label30
        '
        Me.Label30.BackColor = System.Drawing.Color.Gainsboro
        Me.Label30.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label30.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label30.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label30.Location = New System.Drawing.Point(264, 156)
        Me.Label30.Name = "Label30"
        Me.Label30.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label30.Size = New System.Drawing.Size(105, 17)
        Me.Label30.TabIndex = 152
        Me.Label30.Text = "Post To Ats"
        '
        'checkNotHeld
        '
        Me.checkNotHeld.AutoSize = True
        Me.checkNotHeld.Location = New System.Drawing.Point(267, 176)
        Me.checkNotHeld.Name = "checkNotHeld"
        Me.checkNotHeld.Size = New System.Drawing.Size(65, 18)
        Me.checkNotHeld.TabIndex = 154
        Me.checkNotHeld.Text = "Not held"
        Me.checkNotHeld.UseVisualStyleBackColor = True
        '
        'checkAutoCancelParent
        '
        Me.checkAutoCancelParent.AutoSize = True
        Me.checkAutoCancelParent.Location = New System.Drawing.Point(15, 639)
        Me.checkAutoCancelParent.Name = "checkAutoCancelParent"
        Me.checkAutoCancelParent.Size = New System.Drawing.Size(119, 18)
        Me.checkAutoCancelParent.TabIndex = 155
        Me.checkAutoCancelParent.Text = "Auto Cancel Parent"
        Me.checkAutoCancelParent.UseVisualStyleBackColor = True
        '
        'Label31
        '
        Me.Label31.BackColor = System.Drawing.Color.Gainsboro
        Me.Label31.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label31.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label31.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label31.Location = New System.Drawing.Point(264, 637)
        Me.Label31.Name = "Label31"
        Me.Label31.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label31.Size = New System.Drawing.Size(160, 17)
        Me.Label31.TabIndex = 156
        Me.Label31.Text = "Advanced Error Override"
        '
        'txtAdvancedErrorOverride
        '
        Me.txtAdvancedErrorOverride.AcceptsReturn = True
        Me.txtAdvancedErrorOverride.BackColor = System.Drawing.SystemColors.Window
        Me.txtAdvancedErrorOverride.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAdvancedErrorOverride.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAdvancedErrorOverride.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAdvancedErrorOverride.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAdvancedErrorOverride.Location = New System.Drawing.Point(432, 637)
        Me.txtAdvancedErrorOverride.MaxLength = 0
        Me.txtAdvancedErrorOverride.Name = "txtAdvancedErrorOverride"
        Me.txtAdvancedErrorOverride.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAdvancedErrorOverride.Size = New System.Drawing.Size(85, 13)
        Me.txtAdvancedErrorOverride.TabIndex = 157
        '
        'LabelManualOrderTime
        '
        Me.LabelManualOrderTime.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelManualOrderTime.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelManualOrderTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelManualOrderTime.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelManualOrderTime.Location = New System.Drawing.Point(13, 660)
        Me.LabelManualOrderTime.Name = "LabelManualOrderTime"
        Me.LabelManualOrderTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelManualOrderTime.Size = New System.Drawing.Size(117, 17)
        Me.LabelManualOrderTime.TabIndex = 158
        Me.LabelManualOrderTime.Text = "Manual Order Time"
        '
        'txtManualOrderTime
        '
        Me.txtManualOrderTime.AcceptsReturn = True
        Me.txtManualOrderTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtManualOrderTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtManualOrderTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtManualOrderTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtManualOrderTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtManualOrderTime.Location = New System.Drawing.Point(143, 660)
        Me.txtManualOrderTime.MaxLength = 0
        Me.txtManualOrderTime.Name = "txtManualOrderTime"
        Me.txtManualOrderTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtManualOrderTime.Size = New System.Drawing.Size(85, 13)
        Me.txtManualOrderTime.TabIndex = 159
        '
        'LabelManualOrderCancelTime
        '
        Me.LabelManualOrderCancelTime.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelManualOrderCancelTime.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelManualOrderCancelTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelManualOrderCancelTime.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelManualOrderCancelTime.Location = New System.Drawing.Point(264, 660)
        Me.LabelManualOrderCancelTime.Name = "LabelManualOrderCancelTime"
        Me.LabelManualOrderCancelTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelManualOrderCancelTime.Size = New System.Drawing.Size(150, 17)
        Me.LabelManualOrderCancelTime.TabIndex = 160
        Me.LabelManualOrderCancelTime.Text = "Manual Order Cancel Time"
        '
        'txtManualOrderCancelTime
        '
        Me.txtManualOrderCancelTime.AcceptsReturn = True
        Me.txtManualOrderCancelTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtManualOrderCancelTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtManualOrderCancelTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtManualOrderCancelTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtManualOrderCancelTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtManualOrderCancelTime.Location = New System.Drawing.Point(432, 660)
        Me.txtManualOrderCancelTime.MaxLength = 0
        Me.txtManualOrderCancelTime.Name = "txtManualOrderCancelTime"
        Me.txtManualOrderCancelTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtManualOrderCancelTime.Size = New System.Drawing.Size(85, 13)
        Me.txtManualOrderCancelTime.TabIndex = 161
        '
        'LabelMinTradeQty
        '
        Me.LabelMinTradeQty.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelMinTradeQty.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelMinTradeQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelMinTradeQty.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelMinTradeQty.Location = New System.Drawing.Point(13, 684)
        Me.LabelMinTradeQty.Name = "LabelMinTradeQty"
        Me.LabelMinTradeQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelMinTradeQty.Size = New System.Drawing.Size(117, 17)
        Me.LabelMinTradeQty.TabIndex = 162
        Me.LabelMinTradeQty.Text = "Min Trade Qty"
        '
        'txtMinTradeQty
        '
        Me.txtMinTradeQty.AcceptsReturn = True
        Me.txtMinTradeQty.BackColor = System.Drawing.SystemColors.Window
        Me.txtMinTradeQty.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMinTradeQty.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMinTradeQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMinTradeQty.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMinTradeQty.Location = New System.Drawing.Point(144, 684)
        Me.txtMinTradeQty.MaxLength = 0
        Me.txtMinTradeQty.Name = "txtMinTradeQty"
        Me.txtMinTradeQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMinTradeQty.Size = New System.Drawing.Size(85, 13)
        Me.txtMinTradeQty.TabIndex = 163
        '
        'LabelMinCompeteSize
        '
        Me.LabelMinCompeteSize.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelMinCompeteSize.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelMinCompeteSize.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelMinCompeteSize.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelMinCompeteSize.Location = New System.Drawing.Point(264, 684)
        Me.LabelMinCompeteSize.Name = "LabelMinCompeteSize"
        Me.LabelMinCompeteSize.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelMinCompeteSize.Size = New System.Drawing.Size(117, 17)
        Me.LabelMinCompeteSize.TabIndex = 164
        Me.LabelMinCompeteSize.Text = "Min Compete Size"
        '
        'txtMinCompeteSize
        '
        Me.txtMinCompeteSize.AcceptsReturn = True
        Me.txtMinCompeteSize.BackColor = System.Drawing.SystemColors.Window
        Me.txtMinCompeteSize.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMinCompeteSize.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMinCompeteSize.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMinCompeteSize.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMinCompeteSize.Location = New System.Drawing.Point(432, 684)
        Me.txtMinCompeteSize.MaxLength = 0
        Me.txtMinCompeteSize.Name = "txtMinCompeteSize"
        Me.txtMinCompeteSize.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMinCompeteSize.Size = New System.Drawing.Size(85, 13)
        Me.txtMinCompeteSize.TabIndex = 165
        '
        'LabelCompeteAgainstBestOffset
        '
        Me.LabelCompeteAgainstBestOffset.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelCompeteAgainstBestOffset.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelCompeteAgainstBestOffset.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelCompeteAgainstBestOffset.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelCompeteAgainstBestOffset.Location = New System.Drawing.Point(547, 684)
        Me.LabelCompeteAgainstBestOffset.Name = "LabelCompeteAgainstBestOffset"
        Me.LabelCompeteAgainstBestOffset.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelCompeteAgainstBestOffset.Size = New System.Drawing.Size(155, 17)
        Me.LabelCompeteAgainstBestOffset.TabIndex = 166
        Me.LabelCompeteAgainstBestOffset.Text = "Compete Against Best Offset"
        '
        'txtCompeteAgainstBestOffset
        '
        Me.txtCompeteAgainstBestOffset.AcceptsReturn = True
        Me.txtCompeteAgainstBestOffset.BackColor = System.Drawing.SystemColors.Window
        Me.txtCompeteAgainstBestOffset.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtCompeteAgainstBestOffset.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtCompeteAgainstBestOffset.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtCompeteAgainstBestOffset.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtCompeteAgainstBestOffset.Location = New System.Drawing.Point(753, 684)
        Me.txtCompeteAgainstBestOffset.MaxLength = 0
        Me.txtCompeteAgainstBestOffset.Name = "txtCompeteAgainstBestOffset"
        Me.txtCompeteAgainstBestOffset.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtCompeteAgainstBestOffset.Size = New System.Drawing.Size(85, 13)
        Me.txtCompeteAgainstBestOffset.TabIndex = 167
        '
        'checkCompeteAgainstBestOffsetUpToMid
        '
        Me.checkCompeteAgainstBestOffsetUpToMid.AutoSize = True
        Me.checkCompeteAgainstBestOffsetUpToMid.Location = New System.Drawing.Point(16, 704)
        Me.checkCompeteAgainstBestOffsetUpToMid.Name = "checkCompeteAgainstBestOffsetUpToMid"
        Me.checkCompeteAgainstBestOffsetUpToMid.Size = New System.Drawing.Size(215, 18)
        Me.checkCompeteAgainstBestOffsetUpToMid.TabIndex = 168
        Me.checkCompeteAgainstBestOffsetUpToMid.Text = "Compete Against Best Offset Up To Mid"
        Me.checkCompeteAgainstBestOffsetUpToMid.UseVisualStyleBackColor = True
        '
        'LabelMidOffsetAtWhole
        '
        Me.LabelMidOffsetAtWhole.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelMidOffsetAtWhole.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelMidOffsetAtWhole.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelMidOffsetAtWhole.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelMidOffsetAtWhole.Location = New System.Drawing.Point(264, 705)
        Me.LabelMidOffsetAtWhole.Name = "LabelMidOffsetAtWhole"
        Me.LabelMidOffsetAtWhole.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelMidOffsetAtWhole.Size = New System.Drawing.Size(117, 17)
        Me.LabelMidOffsetAtWhole.TabIndex = 169
        Me.LabelMidOffsetAtWhole.Text = "Mid Offset At Whole"
        '
        'txtMidOffsetAtWhole
        '
        Me.txtMidOffsetAtWhole.AcceptsReturn = True
        Me.txtMidOffsetAtWhole.BackColor = System.Drawing.SystemColors.Window
        Me.txtMidOffsetAtWhole.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMidOffsetAtWhole.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMidOffsetAtWhole.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMidOffsetAtWhole.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMidOffsetAtWhole.Location = New System.Drawing.Point(432, 705)
        Me.txtMidOffsetAtWhole.MaxLength = 0
        Me.txtMidOffsetAtWhole.Name = "txtMidOffsetAtWhole"
        Me.txtMidOffsetAtWhole.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMidOffsetAtWhole.Size = New System.Drawing.Size(85, 13)
        Me.txtMidOffsetAtWhole.TabIndex = 170
        '
        'LabelMidOffsetAtHalf
        '
        Me.LabelMidOffsetAtHalf.BackColor = System.Drawing.Color.Gainsboro
        Me.LabelMidOffsetAtHalf.Cursor = System.Windows.Forms.Cursors.Default
        Me.LabelMidOffsetAtHalf.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.LabelMidOffsetAtHalf.ForeColor = System.Drawing.SystemColors.ControlText
        Me.LabelMidOffsetAtHalf.Location = New System.Drawing.Point(547, 705)
        Me.LabelMidOffsetAtHalf.Name = "LabelMidOffsetAtHalf"
        Me.LabelMidOffsetAtHalf.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.LabelMidOffsetAtHalf.Size = New System.Drawing.Size(117, 17)
        Me.LabelMidOffsetAtHalf.TabIndex = 171
        Me.LabelMidOffsetAtHalf.Text = "Mid Offset At Half"
        '
        'txtMidOffsetAtHalf
        '
        Me.txtMidOffsetAtHalf.AcceptsReturn = True
        Me.txtMidOffsetAtHalf.BackColor = System.Drawing.SystemColors.Window
        Me.txtMidOffsetAtHalf.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtMidOffsetAtHalf.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtMidOffsetAtHalf.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtMidOffsetAtHalf.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtMidOffsetAtHalf.Location = New System.Drawing.Point(753, 705)
        Me.txtMidOffsetAtHalf.MaxLength = 0
        Me.txtMidOffsetAtHalf.Name = "txtMidOffsetAtHalf"
        Me.txtMidOffsetAtHalf.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtMidOffsetAtHalf.Size = New System.Drawing.Size(85, 13)
        Me.txtMidOffsetAtHalf.TabIndex = 172
        '
        'dlgOrderAttribs
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.Color.Gainsboro
        Me.ClientSize = New System.Drawing.Size(850, 780)
        Me.Controls.Add(Me.txtMidOffsetAtHalf)
        Me.Controls.Add(Me.LabelMidOffsetAtHalf)
        Me.Controls.Add(Me.txtMidOffsetAtWhole)
        Me.Controls.Add(Me.LabelMidOffsetAtWhole)
        Me.Controls.Add(Me.checkCompeteAgainstBestOffsetUpToMid)
        Me.Controls.Add(Me.txtCompeteAgainstBestOffset)
        Me.Controls.Add(Me.LabelCompeteAgainstBestOffset)
        Me.Controls.Add(Me.txtMinCompeteSize)
        Me.Controls.Add(Me.LabelMinCompeteSize)
        Me.Controls.Add(Me.txtMinTradeQty)
        Me.Controls.Add(Me.LabelMinTradeQty)
        Me.Controls.Add(Me.txtManualOrderCancelTime)
        Me.Controls.Add(Me.LabelManualOrderCancelTime)
        Me.Controls.Add(Me.txtManualOrderTime)
        Me.Controls.Add(Me.LabelManualOrderTime)
        Me.Controls.Add(Me.txtAdvancedErrorOverride)
        Me.Controls.Add(Me.Label31)
        Me.Controls.Add(Me.checkAutoCancelParent)
        Me.Controls.Add(Me.checkNotHeld)
        Me.Controls.Add(Me.txtPostToAts)
        Me.Controls.Add(Me.Label30)
        Me.Controls.Add(Me.txtDuration)
        Me.Controls.Add(Me.Label29)
        Me.Controls.Add(Me.checkRelativeDiscretionary)
        Me.Controls.Add(Me.checkOmsContainer)
        Me.Controls.Add(Me.checkDontUseAutoPriceForHedge)
        Me.Controls.Add(Me.txtMifid2ExecutionTrader)
        Me.Controls.Add(Me.Label66)
        Me.Controls.Add(Me.txtMifid2ExecutionAlgo)
        Me.Controls.Add(Me.Label67)
        Me.Controls.Add(Me.txtMifid2DecisionMaker)
        Me.Controls.Add(Me.Label64)
        Me.Controls.Add(Me.txtMifid2DecisionAlgo)
        Me.Controls.Add(Me.Label65)
        Me.Controls.Add(Me.txtModelCode)
        Me.Controls.Add(Me.Label63)
        Me.Controls.Add(Me.cbRandomizePrice)
        Me.Controls.Add(Me.cbRandomizeSize)
        Me.Controls.Add(Me.cbSolicited)
        Me.Controls.Add(Me.txtActiveStopTime)
        Me.Controls.Add(Me.txtActiveStartTime)
        Me.Controls.Add(Me.txtScaleTable)
        Me.Controls.Add(Me.Label60)
        Me.Controls.Add(Me.Label61)
        Me.Controls.Add(Me.Label62)
        Me.Controls.Add(Me.Label59)
        Me.Controls.Add(Me.txtDeltaNeutralDesignatedLocation)
        Me.Controls.Add(Me.Label58)
        Me.Controls.Add(Me.txtDeltaNeutralShortSaleSlot)
        Me.Controls.Add(Me.checkDeltaNeutralShortSale)
        Me.Controls.Add(Me.Label57)
        Me.Controls.Add(Me.txtDeltaNeutralOpenClose)
        Me.Controls.Add(Me.txtTrailingPercent)
        Me.Controls.Add(Me.Label56)
        Me.Controls.Add(Me.txtScaleProfitOffset)
        Me.Controls.Add(Me.txtScaleInitFillQty)
        Me.Controls.Add(Me.txtScaleInitPosition)
        Me.Controls.Add(Me.txtScalePriceAdjustInterval)
        Me.Controls.Add(Me.checkScaleRandomPercent)
        Me.Controls.Add(Me.Label55)
        Me.Controls.Add(Me.Label54)
        Me.Controls.Add(Me.txtScalePriceAdjustValue)
        Me.Controls.Add(Me.checkScaleAutoReset)
        Me.Controls.Add(Me.Label53)
        Me.Controls.Add(Me.Label52)
        Me.Controls.Add(Me.Label51)
        Me.Controls.Add(Me.txtDeltaNeutralSettlingFirm)
        Me.Controls.Add(Me.txtDeltaNeutralClearingAccount)
        Me.Controls.Add(Me.txtDeltaNeutralClearingIntent)
        Me.Controls.Add(Me.txtDeltaNeutralConId)
        Me.Controls.Add(Me.Label50)
        Me.Controls.Add(Me.Label49)
        Me.Controls.Add(Me.Label48)
        Me.Controls.Add(Me.Label47)
        Me.Controls.Add(Me.checkOptOutSmartRouting)
        Me.Controls.Add(Me.LabelHedgeParam)
        Me.Controls.Add(Me.LabelHedgeType)
        Me.Controls.Add(Me.txtHedgeParam)
        Me.Controls.Add(Me.txtHedgeType)
        Me.Controls.Add(Me.Label46)
        Me.Controls.Add(Me.txtExemptCode)
        Me.Controls.Add(Me.Label45)
        Me.Controls.Add(Me.txtClearingIntent)
        Me.Controls.Add(Me.Label18)
        Me.Controls.Add(Me.txtClearingAccount)
        Me.Controls.Add(Me.Label44)
        Me.Controls.Add(Me.Label43)
        Me.Controls.Add(Me.Label42)
        Me.Controls.Add(Me.txtScalePriceIncr)
        Me.Controls.Add(Me.txtScaleSubsLevelSize)
        Me.Controls.Add(Me.txtScaleInitLevelSize)
        Me.Controls.Add(Me.txtOverridePercentageConstraints)
        Me.Controls.Add(Me.Label41)
        Me.Controls.Add(Me.txtTrailStopPrice)
        Me.Controls.Add(Me.Label39)
        Me.Controls.Add(Me.txtDeltaNeutralAuxPrice)
        Me.Controls.Add(Me.Label38)
        Me.Controls.Add(Me.txtVolatility)
        Me.Controls.Add(Me.txtVolatilityType)
        Me.Controls.Add(Me.txtDeltaNeutralOrderType)
        Me.Controls.Add(Me.txtContinuousUpdate)
        Me.Controls.Add(Me.txtReferencePriceType)
        Me.Controls.Add(Me.txtRule80A)
        Me.Controls.Add(Me.txtSettlingFirm)
        Me.Controls.Add(Me.txtMinQty)
        Me.Controls.Add(Me.txtPercentOffset)
        Me.Controls.Add(Me.txtAuctionStrategy)
        Me.Controls.Add(Me.txtStartingPrice)
        Me.Controls.Add(Me.txtStockRefPrice)
        Me.Controls.Add(Me.txtDelta)
        Me.Controls.Add(Me.txtStockRangeLower)
        Me.Controls.Add(Me.txtStockRangeUpper)
        Me.Controls.Add(Me.txtAllOrNone)
        Me.Controls.Add(Me.txtOcaType)
        Me.Controls.Add(Me.txtShortSaleSlot)
        Me.Controls.Add(Me.txtDesignatedLocation)
        Me.Controls.Add(Me.txtDiscretionaryAmt)
        Me.Controls.Add(Me.txtHidden)
        Me.Controls.Add(Me.txtOutsideRth)
        Me.Controls.Add(Me.txtTriggerMethod)
        Me.Controls.Add(Me.txtDisplaySize)
        Me.Controls.Add(Me.txtSweepToFill)
        Me.Controls.Add(Me.txtBlockOrder)
        Me.Controls.Add(Me.txtTransmit)
        Me.Controls.Add(Me.txtParentId)
        Me.Controls.Add(Me.txtOrderRef)
        Me.Controls.Add(Me.txtOrigin)
        Me.Controls.Add(Me.txtOpenClose)
        Me.Controls.Add(Me.txtAccount)
        Me.Controls.Add(Me.txtOCA)
        Me.Controls.Add(Me.txtTIF)
        Me.Controls.Add(Me.Label21)
        Me.Controls.Add(Me.Label22)
        Me.Controls.Add(Me.Label36)
        Me.Controls.Add(Me.Label37)
        Me.Controls.Add(Me.Label40)
        Me.Controls.Add(Me.cmdOk)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.Label35)
        Me.Controls.Add(Me.Label34)
        Me.Controls.Add(Me.Label33)
        Me.Controls.Add(Me.Label32)
        Me.Controls.Add(Me.Label28)
        Me.Controls.Add(Me.Label27)
        Me.Controls.Add(Me.Label26)
        Me.Controls.Add(Me.Label25)
        Me.Controls.Add(Me.Label24)
        Me.Controls.Add(Me.Label23)
        Me.Controls.Add(Me.Label20)
        Me.Controls.Add(Me.Label19)
        Me.Controls.Add(Me.Label17)
        Me.Controls.Add(Me.Label16)
        Me.Controls.Add(Me.Label15)
        Me.Controls.Add(Me.Label14)
        Me.Controls.Add(Me.Label13)
        Me.Controls.Add(Me.Label12)
        Me.Controls.Add(Me.Label11)
        Me.Controls.Add(Me.Label10)
        Me.Controls.Add(Me.Label9)
        Me.Controls.Add(Me.Label8)
        Me.Controls.Add(Me.Label7)
        Me.Controls.Add(Me.Label6)
        Me.Controls.Add(Me.Label5)
        Me.Controls.Add(Me.Label4)
        Me.Controls.Add(Me.Label3)
        Me.Controls.Add(Me.Label2)
        Me.Controls.Add(Me.Label1)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Location = New System.Drawing.Point(1030, 270)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "dlgOrderAttribs"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Extended Order Attributes"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As dlgOrderAttribs
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As dlgOrderAttribs
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New dlgOrderAttribs
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(Value As dlgOrderAttribs)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region
    ' ========================================================
    ' Member variables
    ' ========================================================
    Private m_orderInfo As IBApi.Order
    Private m_manualOrderCancelTime As String
    Private m_mainWnd As MainForm

    Private m_ok As Boolean

    ' ========================================================
    ' Public Methods
    ' ========================================================
    Public Sub init(mainWin As Form, orderInfo As IBApi.Order)

        m_mainWnd = MainForm
        m_orderInfo = orderInfo

        m_ok = False

        txtModelCode.Text = m_orderInfo.ModelCode
        txtTIF.Text = m_orderInfo.Tif
        txtActiveStartTime.Text = m_orderInfo.ActiveStartTime
        txtActiveStopTime.Text = m_orderInfo.ActiveStopTime
        txtOCA.Text = m_orderInfo.OcaGroup
        txtOcaType.Text = m_orderInfo.OcaType
        txtOrderRef.Text = m_orderInfo.OrderRef
        txtTransmit.Text = m_orderInfo.Transmit
        txtParentId.Text = m_orderInfo.ParentId
        txtBlockOrder.Text = m_orderInfo.BlockOrder
        txtSweepToFill.Text = m_orderInfo.SweepToFill
        txtDisplaySize.Text = m_orderInfo.DisplaySize
        txtTriggerMethod.Text = m_orderInfo.TriggerMethod
        txtOutsideRth.Text = m_orderInfo.OutsideRth
        txtHidden.Text = m_orderInfo.Hidden
        txtOverridePercentageConstraints.Text = m_orderInfo.OverridePercentageConstraints
        txtRule80A.Text = m_orderInfo.Rule80A
        txtAllOrNone.Text = m_orderInfo.AllOrNone
        txtMinQty.Text = ivalStr(m_orderInfo.MinQty)
        txtPercentOffset.Text = dvalStr(m_orderInfo.PercentOffset)
        txtTrailStopPrice.Text = dvalStr(m_orderInfo.TrailStopPrice)
        txtTrailingPercent.Text = dvalStr(m_orderInfo.TrailingPercent)

        ' Institutional orders only
        txtOpenClose.Text = m_orderInfo.OpenClose
        txtOrigin.Text = m_orderInfo.Origin
        txtShortSaleSlot.Text = m_orderInfo.ShortSaleSlot
        txtDesignatedLocation.Text = m_orderInfo.DesignatedLocation
        txtExemptCode.Text = m_orderInfo.ExemptCode

        'SMART routing only
        txtDiscretionaryAmt.Text = m_orderInfo.DiscretionaryAmt
        checkOptOutSmartRouting.Checked = m_orderInfo.OptOutSmartRouting

        ' BOX or VOL orders only
        txtAuctionStrategy.Text = m_orderInfo.AuctionStrategy

        'BOX orders only
        txtStartingPrice.Text = dvalStr(m_orderInfo.StartingPrice)
        txtStockRefPrice.Text = dvalStr(m_orderInfo.StockRefPrice)
        txtDelta.Text = dvalStr(m_orderInfo.Delta)

        ' pegged to stock or VOL orders
        txtStockRangeLower.Text = dvalStr(m_orderInfo.StockRangeLower)
        txtStockRangeUpper.Text = dvalStr(m_orderInfo.StockRangeUpper)

        ' VOLATILITY orders only
        txtVolatility.Text = dvalStr(m_orderInfo.Volatility)
        txtVolatilityType.Text = ivalStr(m_orderInfo.VolatilityType)
        txtContinuousUpdate.Text = m_orderInfo.ContinuousUpdate
        txtReferencePriceType.Text = ivalStr(m_orderInfo.ReferencePriceType)
        txtDeltaNeutralOrderType.Text = m_orderInfo.DeltaNeutralOrderType
        txtDeltaNeutralAuxPrice.Text = dvalStr(m_orderInfo.DeltaNeutralAuxPrice)
        txtDeltaNeutralConId.Text = ivalStr(m_orderInfo.DeltaNeutralConId)
        txtDeltaNeutralSettlingFirm.Text = m_orderInfo.DeltaNeutralSettlingFirm
        txtDeltaNeutralClearingAccount.Text = m_orderInfo.DeltaNeutralClearingAccount
        txtDeltaNeutralClearingIntent.Text = m_orderInfo.DeltaNeutralClearingIntent
        txtDeltaNeutralOpenClose.Text = m_orderInfo.DeltaNeutralOpenClose
        checkDeltaNeutralShortSale.Checked = m_orderInfo.DeltaNeutralShortSale
        txtDeltaNeutralShortSaleSlot.Text = ivalStr(m_orderInfo.DeltaNeutralShortSaleSlot)
        txtDeltaNeutralDesignatedLocation.Text = m_orderInfo.DeltaNeutralDesignatedLocation

        ' SCALE orders only
        txtScaleInitLevelSize.Text = ivalStr(m_orderInfo.ScaleInitLevelSize)
        txtScaleSubsLevelSize.Text = ivalStr(m_orderInfo.ScaleSubsLevelSize)
        txtScalePriceIncr.Text = dvalStr(m_orderInfo.ScalePriceIncrement)
        txtScalePriceAdjustValue.Text = dvalStr(m_orderInfo.ScalePriceAdjustValue)
        txtScalePriceAdjustInterval.Text = ivalStr(m_orderInfo.ScalePriceAdjustInterval)
        txtScaleProfitOffset.Text = dvalStr(m_orderInfo.ScaleProfitOffset)
        checkScaleAutoReset.Checked = m_orderInfo.ScaleAutoReset
        txtScaleInitPosition.Text = ivalStr(m_orderInfo.ScaleInitPosition)
        txtScaleInitFillQty.Text = ivalStr(m_orderInfo.ScaleInitFillQty)
        checkScaleRandomPercent.Checked = m_orderInfo.ScaleRandomPercent
        txtScaleTable.Text = m_orderInfo.ScaleTable

        ' HEDGE orders only
        txtHedgeType.Text = m_orderInfo.HedgeType
        txtHedgeParam.Text = m_orderInfo.HedgeParam

        ' Clearing info
        txtAccount.Text = m_orderInfo.Account
        txtSettlingFirm.Text = m_orderInfo.SettlingFirm
        txtClearingAccount.Text = m_orderInfo.ClearingAccount
        txtClearingIntent.Text = m_orderInfo.ClearingIntent

        cbSolicited.Checked = m_orderInfo.Solicited

        txtMifid2DecisionMaker.Text = m_orderInfo.Mifid2DecisionMaker
        txtMifid2DecisionAlgo.Text = m_orderInfo.Mifid2DecisionAlgo
        txtMifid2ExecutionTrader.Text = m_orderInfo.Mifid2ExecutionTrader
        txtMifid2ExecutionAlgo.Text = m_orderInfo.Mifid2ExecutionAlgo

        checkDontUseAutoPriceForHedge.Checked = m_orderInfo.DontUseAutoPriceForHedge
        checkOmsContainer.Checked = m_orderInfo.IsOmsContainer
        checkRelativeDiscretionary.Checked = m_orderInfo.DiscretionaryUpToLimitPrice
        txtDuration.Text = ivalStr(m_orderInfo.Duration)
        txtPostToAts.Text = ivalStr(m_orderInfo.PostToAts)
        checkNotHeld.Checked = m_orderInfo.NotHeld
        checkAutoCancelParent.Checked = m_orderInfo.AutoCancelParent
        txtAdvancedErrorOverride.Text = m_orderInfo.AdvancedErrorOverride
        txtMinTradeQty.Text = ivalStr(m_orderInfo.MinTradeQty)
        txtMinCompeteSize.Text = ivalStr(m_orderInfo.MinCompeteSize)
        If m_orderInfo.CompeteAgainstBestOffset = IBApi.Order.COMPETE_AGAINST_BEST_OFFSET_UP_TO_MID Then
            checkCompeteAgainstBestOffsetUpToMid.Checked = True
        Else
            checkCompeteAgainstBestOffsetUpToMid.Checked = False
            txtCompeteAgainstBestOffset.Text = dvalStr(m_orderInfo.CompeteAgainstBestOffset)
        End If
        txtMidOffsetAtWhole.Text = dvalStr(m_orderInfo.MidOffsetAtWhole)
        txtMidOffsetAtHalf.Text = dvalStr(m_orderInfo.MidOffsetAtHalf)
    End Sub

    ' ========================================================
    ' Get/Set Methods
    ' ========================================================
    Public ReadOnly Property ok() As Boolean
        Get
            ok = m_ok
        End Get
    End Property

    Private Function ivalStr(val As Long) As String
        If val = Int32.MaxValue Then
            Return ""
        Else
            Return val
        End If
    End Function
    Private Function dvalStr(val As Double) As String
        If val = Double.MaxValue Then
            Return ""
        Else
            Return val
        End If
    End Function

    Private Function bval(text As String) As Boolean
        If Len(text) = 0 Then
            Return False
        Else
            Return CBool(text)
        End If
    End Function

    Private Function ival(text As String) As Integer
        If Len(text) = 0 Then
            Return Int32.MaxValue
        Else
            Return CInt(text)
        End If
    End Function

    Private Function dval(text As String) As Double
        If Len(text) = 0 Then
            Return Double.MaxValue
        Else
            Return CDbl(text)
        End If
    End Function

    ' ========================================================
    ' Button Events
    ' ========================================================
    Private Sub cmdOK_Click(sender As Object, e As EventArgs) Handles cmdOk.Click

        m_orderInfo.Tif = txtTIF.Text
        m_orderInfo.ActiveStartTime = txtActiveStartTime.Text
        m_orderInfo.ActiveStopTime = txtActiveStopTime.Text
        m_orderInfo.OcaGroup = txtOCA.Text
        m_orderInfo.OcaType = ival(txtOcaType.Text)
        m_orderInfo.OrderRef = txtOrderRef.Text
        m_orderInfo.Transmit = bval(txtTransmit.Text)
        m_orderInfo.ParentId = ival(txtParentId.Text)
        m_orderInfo.BlockOrder = bval(txtBlockOrder.Text)
        m_orderInfo.SweepToFill = bval(txtSweepToFill.Text)
        m_orderInfo.DisplaySize = ival(txtDisplaySize.Text)
        m_orderInfo.TriggerMethod = txtTriggerMethod.Text
        m_orderInfo.OutsideRth = bval(txtOutsideRth.Text)
        m_orderInfo.Hidden = txtHidden.Text
        m_orderInfo.OverridePercentageConstraints = bval(txtOverridePercentageConstraints.Text)
        m_orderInfo.Rule80A = txtRule80A.Text
        m_orderInfo.AllOrNone = bval(txtAllOrNone.Text)
        m_orderInfo.MinQty = ival(txtMinQty.Text)
        m_orderInfo.PercentOffset = dval(txtPercentOffset.Text)
        m_orderInfo.TrailStopPrice = dval(txtTrailStopPrice.Text)
        m_orderInfo.TrailingPercent = dval(txtTrailingPercent.Text)

        ' Institutional orders only
        m_orderInfo.OpenClose = txtOpenClose.Text
        m_orderInfo.Origin = ival(txtOrigin.Text)
        m_orderInfo.ShortSaleSlot = ival(txtShortSaleSlot.Text)
        m_orderInfo.DesignatedLocation = txtDesignatedLocation.Text
        If Not String.IsNullOrEmpty(txtExemptCode.Text) Then
            m_orderInfo.ExemptCode = ival(txtExemptCode.Text)
        Else
            m_orderInfo.ExemptCode = ival("-1")
        End If

        'SMART routing only
        m_orderInfo.DiscretionaryAmt = dval(txtDiscretionaryAmt.Text)
        m_orderInfo.OptOutSmartRouting = checkOptOutSmartRouting.Checked

        ' BOX or VOL orders only
        m_orderInfo.AuctionStrategy = ival(txtAuctionStrategy.Text)

        'BOX orders only
        m_orderInfo.StartingPrice = dval(txtStartingPrice.Text)
        m_orderInfo.StockRefPrice = dval(txtStockRefPrice.Text)
        m_orderInfo.Delta = dval(txtDelta.Text)

        ' pegged to stock or VOL orders
        m_orderInfo.StockRangeLower = dval(txtStockRangeLower.Text)
        m_orderInfo.StockRangeUpper = dval(txtStockRangeUpper.Text)

        ' VOLATILITY orders only
        m_orderInfo.Volatility = dval(txtVolatility.Text)
        m_orderInfo.VolatilityType = ival(txtVolatilityType.Text)
        m_orderInfo.ContinuousUpdate = bval(txtContinuousUpdate.Text)
        m_orderInfo.ReferencePriceType = ival(txtReferencePriceType.Text)
        m_orderInfo.DeltaNeutralOrderType = txtDeltaNeutralOrderType.Text
        m_orderInfo.DeltaNeutralAuxPrice = dval(txtDeltaNeutralAuxPrice.Text)
        m_orderInfo.DeltaNeutralConId = ival(txtDeltaNeutralConId.Text)
        m_orderInfo.DeltaNeutralSettlingFirm = txtDeltaNeutralSettlingFirm.Text
        m_orderInfo.DeltaNeutralClearingAccount = txtDeltaNeutralClearingAccount.Text
        m_orderInfo.DeltaNeutralClearingIntent = txtDeltaNeutralClearingIntent.Text
        m_orderInfo.DeltaNeutralOpenClose = txtDeltaNeutralOpenClose.Text
        m_orderInfo.DeltaNeutralShortSale = checkDeltaNeutralShortSale.Checked
        m_orderInfo.DeltaNeutralShortSaleSlot = ival(txtDeltaNeutralShortSaleSlot.Text)
        m_orderInfo.DeltaNeutralDesignatedLocation = txtDeltaNeutralDesignatedLocation.Text

        ' SCALE orders only
        m_orderInfo.ScaleInitLevelSize = ival(txtScaleInitLevelSize.Text)
        m_orderInfo.ScaleSubsLevelSize = ival(txtScaleSubsLevelSize.Text)
        m_orderInfo.ScalePriceIncrement = dval(txtScalePriceIncr.Text)
        m_orderInfo.ScalePriceAdjustValue = dval(txtScalePriceAdjustValue.Text)
        m_orderInfo.ScalePriceAdjustInterval = ival(txtScalePriceAdjustInterval.Text)
        m_orderInfo.ScaleProfitOffset = dval(txtScaleProfitOffset.Text)
        m_orderInfo.ScaleAutoReset = checkScaleAutoReset.Checked
        m_orderInfo.ScaleInitPosition = ival(txtScaleInitPosition.Text)
        m_orderInfo.ScaleInitFillQty = ival(txtScaleInitFillQty.Text)
        m_orderInfo.ScaleRandomPercent = checkScaleRandomPercent.Checked
        m_orderInfo.ScaleTable = txtScaleTable.Text

        ' HEDGE orders only
        m_orderInfo.HedgeType = txtHedgeType.Text
        m_orderInfo.HedgeParam = txtHedgeParam.Text

        ' Clearing info
        m_orderInfo.Account = txtAccount.Text
        m_orderInfo.SettlingFirm = txtSettlingFirm.Text
        m_orderInfo.ClearingAccount = txtClearingAccount.Text
        m_orderInfo.ClearingIntent = txtClearingIntent.Text

        m_orderInfo.Solicited = cbSolicited.Checked
        m_orderInfo.RandomizePrice = cbRandomizePrice.Checked
        m_orderInfo.RandomizeSize = cbRandomizeSize.Checked
        m_orderInfo.ModelCode = txtModelCode.Text
        m_orderInfo.Mifid2DecisionMaker = txtMifid2DecisionMaker.Text
        m_orderInfo.Mifid2DecisionAlgo = txtMifid2DecisionAlgo.Text
        m_orderInfo.Mifid2ExecutionTrader = txtMifid2ExecutionTrader.Text
        m_orderInfo.Mifid2ExecutionAlgo = txtMifid2ExecutionAlgo.Text

        m_orderInfo.DontUseAutoPriceForHedge = checkDontUseAutoPriceForHedge.Checked
        m_orderInfo.IsOmsContainer = checkOmsContainer.Checked
        m_orderInfo.DiscretionaryUpToLimitPrice = checkRelativeDiscretionary.Checked
        m_orderInfo.Duration = ival(txtDuration.Text)
        m_orderInfo.PostToAts = ival(txtPostToAts.Text)
        m_orderInfo.NotHeld = checkNotHeld.Checked
        m_orderInfo.AutoCancelParent = checkAutoCancelParent.Checked
        m_orderInfo.AdvancedErrorOverride = txtAdvancedErrorOverride.Text
        m_orderInfo.ManualOrderTime = txtManualOrderTime.Text
        m_manualOrderCancelTime = txtManualOrderCancelTime.Text
        m_orderInfo.MinTradeQty = ival(txtMinTradeQty.Text)
        m_orderInfo.MinCompeteSize = ival(txtMinCompeteSize.Text)
        m_orderInfo.CompeteAgainstBestOffset = If(checkCompeteAgainstBestOffsetUpToMid.Checked, dval(IBApi.Order.COMPETE_AGAINST_BEST_OFFSET_UP_TO_MID), dval(txtCompeteAgainstBestOffset.Text))
        m_orderInfo.MidOffsetAtWhole = dval(txtMidOffsetAtWhole.Text)
        m_orderInfo.MidOffsetAtHalf = dval(txtMidOffsetAtHalf.Text)

        m_ok = True
        Hide()
    End Sub

    Private Sub cmdCancel_Click(sender As Object, e As EventArgs) Handles cmdCancel.Click
        m_ok = False
        Hide()
    End Sub

    Public Function getManualOrderCancelTime() As String
        Return m_manualOrderCancelTime
    End Function

    Private Sub checkCompeteAgainstBestOffsetUpToMid_CheckedChanged(sender As Object, e As EventArgs) Handles checkCompeteAgainstBestOffsetUpToMid.CheckedChanged
        If checkCompeteAgainstBestOffsetUpToMid.Checked Then
            txtCompeteAgainstBestOffset.Enabled = False
        Else
            txtCompeteAgainstBestOffset.Enabled = True
        End If
    End Sub
End Class
