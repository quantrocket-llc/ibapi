﻿' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.


Option Explicit On

Imports System.Collections.Generic

Friend Class dlgOrder
    Inherits System.Windows.Forms.Form
#Region "Windows Form Designer generated code "

    Dim m_keepUpToDate As Boolean

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
        Form_Initialize_Renamed()
    End Sub

    Public ReadOnly Property keepUpToDate As Boolean
        Get
            Return m_keepUpToDate
        End Get
    End Property

    Property histStartDateTime As String

    Property numberOfTicks As Integer

    Property ignoreSize As Boolean

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
    Public WithEvents txtFormatDate As System.Windows.Forms.TextBox
    Public WithEvents txtUseRTH As System.Windows.Forms.TextBox
    Public WithEvents txtWhatToShow As System.Windows.Forms.TextBox
    Public WithEvents Frame1 As System.Windows.Forms.GroupBox
    Public WithEvents cmdCancel As System.Windows.Forms.Button
    Public WithEvents cmdOk As System.Windows.Forms.Button
    Public WithEvents TextMultiplier As System.Windows.Forms.TextBox
    Public WithEvents TxtPrimaryExchange As System.Windows.Forms.TextBox
    Public WithEvents txtRight As System.Windows.Forms.TextBox
    Public WithEvents txtLocalSymbol As System.Windows.Forms.TextBox
    Public WithEvents txtCurrency As System.Windows.Forms.TextBox
    Public WithEvents txtExchange As System.Windows.Forms.TextBox
    Public WithEvents txtStrike As System.Windows.Forms.TextBox
    Public WithEvents txtLastTradeDateOrContractMonth As System.Windows.Forms.TextBox
    Public WithEvents txtSecType As System.Windows.Forms.TextBox
    Public WithEvents txtSymbol As System.Windows.Forms.TextBox
    Public WithEvents frameTickerDesc As System.Windows.Forms.GroupBox
    Public WithEvents txtReqId As System.Windows.Forms.TextBox
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    Public WithEvents GroupBox1 As System.Windows.Forms.GroupBox
    Public WithEvents txtDuration As System.Windows.Forms.TextBox
    Public WithEvents txtBarSizeSetting As System.Windows.Forms.TextBox
    Public WithEvents txtEndDateTime As System.Windows.Forms.TextBox
    Public WithEvents GroupBox2 As System.Windows.Forms.GroupBox
    Public WithEvents txtExerciseAction As System.Windows.Forms.TextBox
    Public WithEvents txtExerciseQuantity As System.Windows.Forms.TextBox
    Public WithEvents txtExerciseOverride As System.Windows.Forms.TextBox
    Public WithEvents GroupBox3 As System.Windows.Forms.GroupBox
    Public WithEvents GroupBox4 As System.Windows.Forms.GroupBox
    Public WithEvents txtGenericTickTags As System.Windows.Forms.TextBox
    Public WithEvents txtNumRows As System.Windows.Forms.TextBox
    Public WithEvents Label24 As System.Windows.Forms.Label
    Public WithEvents Label23 As System.Windows.Forms.Label
    Public WithEvents Label21 As System.Windows.Forms.Label
    Public WithEvents Label20 As System.Windows.Forms.Label
    Public WithEvents Label19 As System.Windows.Forms.Label
    Public WithEvents Label25 As System.Windows.Forms.Label
    Public WithEvents Label39 As System.Windows.Forms.Label
    Public WithEvents Label4 As System.Windows.Forms.Label
    Public WithEvents Label5 As System.Windows.Forms.Label
    Public WithEvents Label2 As System.Windows.Forms.Label
    Public WithEvents Label37 As System.Windows.Forms.Label
    Public WithEvents Label53 As System.Windows.Forms.Label
    Public WithEvents Label54 As System.Windows.Forms.Label
    Public WithEvents Label55 As System.Windows.Forms.Label
    Public WithEvents Label56 As System.Windows.Forms.Label
    Public WithEvents Label57 As System.Windows.Forms.Label
    Public WithEvents Label58 As System.Windows.Forms.Label
    Public WithEvents Label22 As System.Windows.Forms.Label
    Public WithEvents Label36 As System.Windows.Forms.Label
    Public WithEvents Label35 As System.Windows.Forms.Label
    Public WithEvents Label30 As System.Windows.Forms.Label
    Public WithEvents Label38 As System.Windows.Forms.Label
    Public WithEvents Label1 As System.Windows.Forms.Label
    Friend WithEvents chkSnapshotMktData As System.Windows.Forms.CheckBox
    Public WithEvents Label3 As System.Windows.Forms.Label
    Public WithEvents txtConId As System.Windows.Forms.TextBox
    Public WithEvents Label27 As System.Windows.Forms.Label
    Public WithEvents cmdSetShareAllocation As System.Windows.Forms.Button
    Public WithEvents Label10 As System.Windows.Forms.Label
    Public WithEvents Label11 As System.Windows.Forms.Label
    Public WithEvents Label13 As System.Windows.Forms.Label
    Public WithEvents Label14 As System.Windows.Forms.Label
    Public WithEvents Label15 As System.Windows.Forms.Label
    Public WithEvents Label16 As System.Windows.Forms.Label
    Public WithEvents txtAction As System.Windows.Forms.TextBox
    Public WithEvents txtQuantity As System.Windows.Forms.TextBox
    Public WithEvents txtOrderType As System.Windows.Forms.TextBox
    Public WithEvents txtLmtPrice As System.Windows.Forms.TextBox
    Public WithEvents txtAuxPrice As System.Windows.Forms.TextBox
    Public WithEvents cmdAddCmboLegs As System.Windows.Forms.Button
    Public WithEvents tGTD As System.Windows.Forms.TextBox
    Public WithEvents tGAT As System.Windows.Forms.TextBox
    Public WithEvents cmdDeltaNeutralContract As System.Windows.Forms.Button
    Public WithEvents cmdAlgoParams As System.Windows.Forms.Button
    Public WithEvents frameOrderDesc As System.Windows.Forms.GroupBox
    Friend WithEvents txtSecId As System.Windows.Forms.TextBox
    Friend WithEvents txtSecIdType As System.Windows.Forms.TextBox
    Friend WithEvents Label7 As System.Windows.Forms.Label
    Friend WithEvents Label6 As System.Windows.Forms.Label
    Public WithEvents labelMarketDataType As System.Windows.Forms.Label
    Public WithEvents frameMarketDataType As System.Windows.Forms.GroupBox
    Friend WithEvents cmbMarketDataType As System.Windows.Forms.ComboBox
    Public WithEvents cmdSmartComboRoutingParams As System.Windows.Forms.Button
    Public WithEvents txtTradingClass As System.Windows.Forms.TextBox
    Public WithEvents Label8 As System.Windows.Forms.Label
    Friend WithEvents cmdOptions As System.Windows.Forms.Button
    Friend WithEvents cmdPegBench As System.Windows.Forms.Button
    Friend WithEvents cmdAdjustStop As System.Windows.Forms.Button
    Friend WithEvents cmdConditions As System.Windows.Forms.Button
    Public WithEvents txtCashQty As System.Windows.Forms.TextBox
    Public WithEvents labelCashQty As System.Windows.Forms.Label
    Friend WithEvents chkRegulatorySnapshotMktData As System.Windows.Forms.CheckBox
    Friend WithEvents chkKeepUpToDate As System.Windows.Forms.CheckBox
    Friend WithEvents chkIgnoreSize As System.Windows.Forms.CheckBox
    Public WithEvents txtNumOfTicks As System.Windows.Forms.TextBox
    Public WithEvents Label12 As System.Windows.Forms.Label
    Public WithEvents txtStartDateTime As System.Windows.Forms.TextBox
    Public WithEvents Label9 As System.Windows.Forms.Label
    Friend WithEvents comboBoxTickByTickType As System.Windows.Forms.ComboBox
    Public WithEvents labelTickByTickType As System.Windows.Forms.Label
    Friend WithEvents chkSmartDepth As System.Windows.Forms.CheckBox
    Friend WithEvents chkUsePriceMgmtAlgo As System.Windows.Forms.CheckBox
    Friend WithEvents txtIssuerId As TextBox
    Friend WithEvents Label17 As Label
    Public WithEvents txtIncludeExpired As System.Windows.Forms.TextBox
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.comboBoxTickByTickType = New System.Windows.Forms.ComboBox()
        Me.labelTickByTickType = New System.Windows.Forms.Label()
        Me.txtNumOfTicks = New System.Windows.Forms.TextBox()
        Me.Label12 = New System.Windows.Forms.Label()
        Me.txtStartDateTime = New System.Windows.Forms.TextBox()
        Me.Label9 = New System.Windows.Forms.Label()
        Me.chkIgnoreSize = New System.Windows.Forms.CheckBox()
        Me.chkKeepUpToDate = New System.Windows.Forms.CheckBox()
        Me.txtEndDateTime = New System.Windows.Forms.TextBox()
        Me.Label24 = New System.Windows.Forms.Label()
        Me.txtBarSizeSetting = New System.Windows.Forms.TextBox()
        Me.Label23 = New System.Windows.Forms.Label()
        Me.txtFormatDate = New System.Windows.Forms.TextBox()
        Me.txtUseRTH = New System.Windows.Forms.TextBox()
        Me.txtWhatToShow = New System.Windows.Forms.TextBox()
        Me.txtDuration = New System.Windows.Forms.TextBox()
        Me.Label21 = New System.Windows.Forms.Label()
        Me.Label20 = New System.Windows.Forms.Label()
        Me.Label19 = New System.Windows.Forms.Label()
        Me.Label25 = New System.Windows.Forms.Label()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.cmdOk = New System.Windows.Forms.Button()
        Me.frameTickerDesc = New System.Windows.Forms.GroupBox()
        Me.txtTradingClass = New System.Windows.Forms.TextBox()
        Me.Label8 = New System.Windows.Forms.Label()
        Me.txtSecId = New System.Windows.Forms.TextBox()
        Me.txtSecIdType = New System.Windows.Forms.TextBox()
        Me.Label7 = New System.Windows.Forms.Label()
        Me.Label6 = New System.Windows.Forms.Label()
        Me.Label3 = New System.Windows.Forms.Label()
        Me.txtConId = New System.Windows.Forms.TextBox()
        Me.txtIncludeExpired = New System.Windows.Forms.TextBox()
        Me.Label39 = New System.Windows.Forms.Label()
        Me.Label4 = New System.Windows.Forms.Label()
        Me.TextMultiplier = New System.Windows.Forms.TextBox()
        Me.TxtPrimaryExchange = New System.Windows.Forms.TextBox()
        Me.txtRight = New System.Windows.Forms.TextBox()
        Me.txtLocalSymbol = New System.Windows.Forms.TextBox()
        Me.txtCurrency = New System.Windows.Forms.TextBox()
        Me.txtExchange = New System.Windows.Forms.TextBox()
        Me.txtStrike = New System.Windows.Forms.TextBox()
        Me.txtLastTradeDateOrContractMonth = New System.Windows.Forms.TextBox()
        Me.txtSecType = New System.Windows.Forms.TextBox()
        Me.txtSymbol = New System.Windows.Forms.TextBox()
        Me.Label5 = New System.Windows.Forms.Label()
        Me.Label2 = New System.Windows.Forms.Label()
        Me.Label37 = New System.Windows.Forms.Label()
        Me.Label53 = New System.Windows.Forms.Label()
        Me.Label54 = New System.Windows.Forms.Label()
        Me.Label55 = New System.Windows.Forms.Label()
        Me.Label56 = New System.Windows.Forms.Label()
        Me.Label57 = New System.Windows.Forms.Label()
        Me.Label58 = New System.Windows.Forms.Label()
        Me.txtReqId = New System.Windows.Forms.TextBox()
        Me.GroupBox1 = New System.Windows.Forms.GroupBox()
        Me.chkRegulatorySnapshotMktData = New System.Windows.Forms.CheckBox()
        Me.chkSnapshotMktData = New System.Windows.Forms.CheckBox()
        Me.txtGenericTickTags = New System.Windows.Forms.TextBox()
        Me.Label22 = New System.Windows.Forms.Label()
        Me.GroupBox2 = New System.Windows.Forms.GroupBox()
        Me.txtExerciseOverride = New System.Windows.Forms.TextBox()
        Me.Label36 = New System.Windows.Forms.Label()
        Me.txtExerciseQuantity = New System.Windows.Forms.TextBox()
        Me.Label35 = New System.Windows.Forms.Label()
        Me.txtExerciseAction = New System.Windows.Forms.TextBox()
        Me.Label30 = New System.Windows.Forms.Label()
        Me.GroupBox3 = New System.Windows.Forms.GroupBox()
        Me.Label38 = New System.Windows.Forms.Label()
        Me.GroupBox4 = New System.Windows.Forms.GroupBox()
        Me.chkSmartDepth = New System.Windows.Forms.CheckBox()
        Me.txtNumRows = New System.Windows.Forms.TextBox()
        Me.Label1 = New System.Windows.Forms.Label()
        Me.Label27 = New System.Windows.Forms.Label()
        Me.cmdSetShareAllocation = New System.Windows.Forms.Button()
        Me.Label10 = New System.Windows.Forms.Label()
        Me.Label11 = New System.Windows.Forms.Label()
        Me.Label13 = New System.Windows.Forms.Label()
        Me.Label14 = New System.Windows.Forms.Label()
        Me.Label15 = New System.Windows.Forms.Label()
        Me.Label16 = New System.Windows.Forms.Label()
        Me.txtAction = New System.Windows.Forms.TextBox()
        Me.txtQuantity = New System.Windows.Forms.TextBox()
        Me.txtOrderType = New System.Windows.Forms.TextBox()
        Me.txtLmtPrice = New System.Windows.Forms.TextBox()
        Me.txtAuxPrice = New System.Windows.Forms.TextBox()
        Me.cmdAddCmboLegs = New System.Windows.Forms.Button()
        Me.tGTD = New System.Windows.Forms.TextBox()
        Me.tGAT = New System.Windows.Forms.TextBox()
        Me.cmdDeltaNeutralContract = New System.Windows.Forms.Button()
        Me.cmdAlgoParams = New System.Windows.Forms.Button()
        Me.frameOrderDesc = New System.Windows.Forms.GroupBox()
        Me.chkUsePriceMgmtAlgo = New System.Windows.Forms.CheckBox()
        Me.txtCashQty = New System.Windows.Forms.TextBox()
        Me.labelCashQty = New System.Windows.Forms.Label()
        Me.cmdPegBench = New System.Windows.Forms.Button()
        Me.cmdAdjustStop = New System.Windows.Forms.Button()
        Me.cmdConditions = New System.Windows.Forms.Button()
        Me.cmdOptions = New System.Windows.Forms.Button()
        Me.cmdSmartComboRoutingParams = New System.Windows.Forms.Button()
        Me.labelMarketDataType = New System.Windows.Forms.Label()
        Me.frameMarketDataType = New System.Windows.Forms.GroupBox()
        Me.cmbMarketDataType = New System.Windows.Forms.ComboBox()
        Me.Label17 = New System.Windows.Forms.Label()
        Me.txtIssuerId = New System.Windows.Forms.TextBox()
        Me.Frame1.SuspendLayout()
        Me.frameTickerDesc.SuspendLayout()
        Me.GroupBox1.SuspendLayout()
        Me.GroupBox2.SuspendLayout()
        Me.GroupBox3.SuspendLayout()
        Me.GroupBox4.SuspendLayout()
        Me.frameOrderDesc.SuspendLayout()
        Me.frameMarketDataType.SuspendLayout()
        Me.SuspendLayout()
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.Color.Gainsboro
        Me.Frame1.Controls.Add(Me.comboBoxTickByTickType)
        Me.Frame1.Controls.Add(Me.labelTickByTickType)
        Me.Frame1.Controls.Add(Me.txtNumOfTicks)
        Me.Frame1.Controls.Add(Me.Label12)
        Me.Frame1.Controls.Add(Me.txtStartDateTime)
        Me.Frame1.Controls.Add(Me.Label9)
        Me.Frame1.Controls.Add(Me.chkIgnoreSize)
        Me.Frame1.Controls.Add(Me.chkKeepUpToDate)
        Me.Frame1.Controls.Add(Me.txtEndDateTime)
        Me.Frame1.Controls.Add(Me.Label24)
        Me.Frame1.Controls.Add(Me.txtBarSizeSetting)
        Me.Frame1.Controls.Add(Me.Label23)
        Me.Frame1.Controls.Add(Me.txtFormatDate)
        Me.Frame1.Controls.Add(Me.txtUseRTH)
        Me.Frame1.Controls.Add(Me.txtWhatToShow)
        Me.Frame1.Controls.Add(Me.txtDuration)
        Me.Frame1.Controls.Add(Me.Label21)
        Me.Frame1.Controls.Add(Me.Label20)
        Me.Frame1.Controls.Add(Me.Label19)
        Me.Frame1.Controls.Add(Me.Label25)
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.Highlight
        Me.Frame1.Location = New System.Drawing.Point(234, 485)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(232, 261)
        Me.Frame1.TabIndex = 7
        Me.Frame1.TabStop = False
        Me.Frame1.Text = "Historical Data"
        '
        'comboBoxTickByTickType
        '
        Me.comboBoxTickByTickType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.comboBoxTickByTickType.FormattingEnabled = True
        Me.comboBoxTickByTickType.Items.AddRange(New Object() {"Last", "AllLast", "BidAsk", "MidPoint"})
        Me.comboBoxTickByTickType.Location = New System.Drawing.Point(104, 233)
        Me.comboBoxTickByTickType.Name = "comboBoxTickByTickType"
        Me.comboBoxTickByTickType.Size = New System.Drawing.Size(104, 22)
        Me.comboBoxTickByTickType.TabIndex = 19
        '
        'labelTickByTickType
        '
        Me.labelTickByTickType.BackColor = System.Drawing.Color.Gainsboro
        Me.labelTickByTickType.Cursor = System.Windows.Forms.Cursors.Default
        Me.labelTickByTickType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.labelTickByTickType.ForeColor = System.Drawing.SystemColors.ControlText
        Me.labelTickByTickType.Location = New System.Drawing.Point(11, 233)
        Me.labelTickByTickType.Name = "labelTickByTickType"
        Me.labelTickByTickType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.labelTickByTickType.Size = New System.Drawing.Size(96, 17)
        Me.labelTickByTickType.TabIndex = 18
        Me.labelTickByTickType.Text = "Tick-by-tick type"
        '
        'txtNumOfTicks
        '
        Me.txtNumOfTicks.AcceptsReturn = True
        Me.txtNumOfTicks.BackColor = System.Drawing.SystemColors.Window
        Me.txtNumOfTicks.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtNumOfTicks.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtNumOfTicks.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNumOfTicks.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtNumOfTicks.Location = New System.Drawing.Point(104, 57)
        Me.txtNumOfTicks.MaxLength = 0
        Me.txtNumOfTicks.Name = "txtNumOfTicks"
        Me.txtNumOfTicks.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtNumOfTicks.Size = New System.Drawing.Size(120, 13)
        Me.txtNumOfTicks.TabIndex = 5
        Me.txtNumOfTicks.Text = "1"
        Me.txtNumOfTicks.TextAlign = System.Windows.Forms.HorizontalAlignment.Right
        '
        'Label12
        '
        Me.Label12.BackColor = System.Drawing.Color.Gainsboro
        Me.Label12.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label12.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label12.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label12.Location = New System.Drawing.Point(11, 57)
        Me.Label12.Name = "Label12"
        Me.Label12.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label12.Size = New System.Drawing.Size(89, 17)
        Me.Label12.TabIndex = 4
        Me.Label12.Text = "Number of ticks"
        '
        'txtStartDateTime
        '
        Me.txtStartDateTime.AcceptsReturn = True
        Me.txtStartDateTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtStartDateTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStartDateTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStartDateTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStartDateTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStartDateTime.Location = New System.Drawing.Point(104, 19)
        Me.txtStartDateTime.MaxLength = 0
        Me.txtStartDateTime.Name = "txtStartDateTime"
        Me.txtStartDateTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStartDateTime.Size = New System.Drawing.Size(120, 13)
        Me.txtStartDateTime.TabIndex = 1
        Me.txtStartDateTime.Text = "YYYYMMDD hh:mm:ss [TMZ]"
        '
        'Label9
        '
        Me.Label9.BackColor = System.Drawing.Color.Gainsboro
        Me.Label9.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label9.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label9.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label9.Location = New System.Drawing.Point(11, 19)
        Me.Label9.Name = "Label9"
        Me.Label9.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label9.Size = New System.Drawing.Size(87, 19)
        Me.Label9.TabIndex = 0
        Me.Label9.Text = "Start Date/Time"
        '
        'chkIgnoreSize
        '
        Me.chkIgnoreSize.AutoSize = True
        Me.chkIgnoreSize.Location = New System.Drawing.Point(145, 209)
        Me.chkIgnoreSize.Name = "chkIgnoreSize"
        Me.chkIgnoreSize.Size = New System.Drawing.Size(79, 18)
        Me.chkIgnoreSize.TabIndex = 17
        Me.chkIgnoreSize.Text = "Ignore size"
        Me.chkIgnoreSize.UseVisualStyleBackColor = True
        '
        'chkKeepUpToDate
        '
        Me.chkKeepUpToDate.AutoSize = True
        Me.chkKeepUpToDate.Location = New System.Drawing.Point(16, 209)
        Me.chkKeepUpToDate.Name = "chkKeepUpToDate"
        Me.chkKeepUpToDate.Size = New System.Drawing.Size(102, 18)
        Me.chkKeepUpToDate.TabIndex = 16
        Me.chkKeepUpToDate.Text = "Keep up to date"
        Me.chkKeepUpToDate.UseVisualStyleBackColor = True
        '
        'txtEndDateTime
        '
        Me.txtEndDateTime.AcceptsReturn = True
        Me.txtEndDateTime.BackColor = System.Drawing.SystemColors.Window
        Me.txtEndDateTime.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtEndDateTime.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtEndDateTime.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtEndDateTime.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtEndDateTime.Location = New System.Drawing.Point(104, 38)
        Me.txtEndDateTime.MaxLength = 0
        Me.txtEndDateTime.Name = "txtEndDateTime"
        Me.txtEndDateTime.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtEndDateTime.Size = New System.Drawing.Size(120, 13)
        Me.txtEndDateTime.TabIndex = 3
        Me.txtEndDateTime.Text = "YYYYMMDD hh:mm:ss [TMZ]"
        '
        'Label24
        '
        Me.Label24.BackColor = System.Drawing.Color.Gainsboro
        Me.Label24.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label24.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label24.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label24.Location = New System.Drawing.Point(11, 38)
        Me.Label24.Name = "Label24"
        Me.Label24.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label24.Size = New System.Drawing.Size(80, 17)
        Me.Label24.TabIndex = 2
        Me.Label24.Text = "End Date/Time"
        '
        'txtBarSizeSetting
        '
        Me.txtBarSizeSetting.AcceptsReturn = True
        Me.txtBarSizeSetting.BackColor = System.Drawing.SystemColors.Window
        Me.txtBarSizeSetting.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtBarSizeSetting.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtBarSizeSetting.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtBarSizeSetting.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtBarSizeSetting.Location = New System.Drawing.Point(104, 103)
        Me.txtBarSizeSetting.MaxLength = 0
        Me.txtBarSizeSetting.Name = "txtBarSizeSetting"
        Me.txtBarSizeSetting.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtBarSizeSetting.Size = New System.Drawing.Size(120, 13)
        Me.txtBarSizeSetting.TabIndex = 9
        Me.txtBarSizeSetting.Text = "1 day"
        '
        'Label23
        '
        Me.Label23.BackColor = System.Drawing.Color.Gainsboro
        Me.Label23.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label23.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label23.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label23.Location = New System.Drawing.Point(11, 103)
        Me.Label23.Name = "Label23"
        Me.Label23.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label23.Size = New System.Drawing.Size(80, 17)
        Me.Label23.TabIndex = 8
        Me.Label23.Text = "Bar Size"
        '
        'txtFormatDate
        '
        Me.txtFormatDate.AcceptsReturn = True
        Me.txtFormatDate.BackColor = System.Drawing.SystemColors.Window
        Me.txtFormatDate.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtFormatDate.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtFormatDate.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtFormatDate.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtFormatDate.Location = New System.Drawing.Point(104, 178)
        Me.txtFormatDate.MaxLength = 0
        Me.txtFormatDate.Name = "txtFormatDate"
        Me.txtFormatDate.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtFormatDate.Size = New System.Drawing.Size(120, 13)
        Me.txtFormatDate.TabIndex = 15
        Me.txtFormatDate.Text = "1"
        '
        'txtUseRTH
        '
        Me.txtUseRTH.AcceptsReturn = True
        Me.txtUseRTH.BackColor = System.Drawing.SystemColors.Window
        Me.txtUseRTH.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtUseRTH.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtUseRTH.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtUseRTH.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtUseRTH.Location = New System.Drawing.Point(104, 141)
        Me.txtUseRTH.MaxLength = 0
        Me.txtUseRTH.Name = "txtUseRTH"
        Me.txtUseRTH.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtUseRTH.Size = New System.Drawing.Size(120, 13)
        Me.txtUseRTH.TabIndex = 13
        Me.txtUseRTH.Text = "1"
        '
        'txtWhatToShow
        '
        Me.txtWhatToShow.AcceptsReturn = True
        Me.txtWhatToShow.BackColor = System.Drawing.SystemColors.Window
        Me.txtWhatToShow.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtWhatToShow.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtWhatToShow.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtWhatToShow.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtWhatToShow.Location = New System.Drawing.Point(104, 122)
        Me.txtWhatToShow.MaxLength = 0
        Me.txtWhatToShow.Name = "txtWhatToShow"
        Me.txtWhatToShow.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtWhatToShow.Size = New System.Drawing.Size(120, 13)
        Me.txtWhatToShow.TabIndex = 11
        Me.txtWhatToShow.Text = "TRADES"
        '
        'txtDuration
        '
        Me.txtDuration.AcceptsReturn = True
        Me.txtDuration.BackColor = System.Drawing.SystemColors.Window
        Me.txtDuration.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtDuration.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtDuration.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtDuration.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtDuration.Location = New System.Drawing.Point(104, 84)
        Me.txtDuration.MaxLength = 0
        Me.txtDuration.Name = "txtDuration"
        Me.txtDuration.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtDuration.Size = New System.Drawing.Size(120, 13)
        Me.txtDuration.TabIndex = 7
        Me.txtDuration.Text = "1 M"
        '
        'Label21
        '
        Me.Label21.BackColor = System.Drawing.Color.Gainsboro
        Me.Label21.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label21.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label21.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label21.Location = New System.Drawing.Point(12, 178)
        Me.Label21.Name = "Label21"
        Me.Label21.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label21.Size = New System.Drawing.Size(80, 33)
        Me.Label21.TabIndex = 14
        Me.Label21.Text = "Date Format Style (1 or 2)"
        '
        'Label20
        '
        Me.Label20.BackColor = System.Drawing.Color.Gainsboro
        Me.Label20.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label20.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label20.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label20.Location = New System.Drawing.Point(12, 141)
        Me.Label20.Name = "Label20"
        Me.Label20.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label20.Size = New System.Drawing.Size(86, 37)
        Me.Label20.TabIndex = 12
        Me.Label20.Text = "Regular Trading Hours (1 or 0)"
        '
        'Label19
        '
        Me.Label19.BackColor = System.Drawing.Color.Gainsboro
        Me.Label19.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label19.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label19.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label19.Location = New System.Drawing.Point(11, 122)
        Me.Label19.Name = "Label19"
        Me.Label19.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label19.Size = New System.Drawing.Size(80, 17)
        Me.Label19.TabIndex = 10
        Me.Label19.Text = "What To Show"
        '
        'Label25
        '
        Me.Label25.BackColor = System.Drawing.Color.Gainsboro
        Me.Label25.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label25.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label25.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label25.Location = New System.Drawing.Point(11, 84)
        Me.Label25.Name = "Label25"
        Me.Label25.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label25.Size = New System.Drawing.Size(80, 17)
        Me.Label25.TabIndex = 6
        Me.Label25.Text = "Duration"
        '
        'cmdCancel
        '
        Me.cmdCancel.BackColor = System.Drawing.SystemColors.Control
        Me.cmdCancel.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdCancel.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdCancel.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdCancel.Location = New System.Drawing.Point(232, 814)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdCancel.Size = New System.Drawing.Size(73, 25)
        Me.cmdCancel.TabIndex = 9
        Me.cmdCancel.Text = "Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'cmdOk
        '
        Me.cmdOk.BackColor = System.Drawing.SystemColors.Control
        Me.cmdOk.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdOk.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdOk.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdOk.Location = New System.Drawing.Point(151, 814)
        Me.cmdOk.Name = "cmdOk"
        Me.cmdOk.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdOk.Size = New System.Drawing.Size(73, 25)
        Me.cmdOk.TabIndex = 8
        Me.cmdOk.Text = "Ok"
        Me.cmdOk.UseVisualStyleBackColor = True
        '
        'frameTickerDesc
        '
        Me.frameTickerDesc.BackColor = System.Drawing.Color.Gainsboro
        Me.frameTickerDesc.Controls.Add(Me.txtIssuerId)
        Me.frameTickerDesc.Controls.Add(Me.Label17)
        Me.frameTickerDesc.Controls.Add(Me.txtTradingClass)
        Me.frameTickerDesc.Controls.Add(Me.Label8)
        Me.frameTickerDesc.Controls.Add(Me.txtSecId)
        Me.frameTickerDesc.Controls.Add(Me.txtSecIdType)
        Me.frameTickerDesc.Controls.Add(Me.Label7)
        Me.frameTickerDesc.Controls.Add(Me.Label6)
        Me.frameTickerDesc.Controls.Add(Me.Label3)
        Me.frameTickerDesc.Controls.Add(Me.txtConId)
        Me.frameTickerDesc.Controls.Add(Me.txtIncludeExpired)
        Me.frameTickerDesc.Controls.Add(Me.Label39)
        Me.frameTickerDesc.Controls.Add(Me.Label4)
        Me.frameTickerDesc.Controls.Add(Me.TextMultiplier)
        Me.frameTickerDesc.Controls.Add(Me.TxtPrimaryExchange)
        Me.frameTickerDesc.Controls.Add(Me.txtRight)
        Me.frameTickerDesc.Controls.Add(Me.txtLocalSymbol)
        Me.frameTickerDesc.Controls.Add(Me.txtCurrency)
        Me.frameTickerDesc.Controls.Add(Me.txtExchange)
        Me.frameTickerDesc.Controls.Add(Me.txtStrike)
        Me.frameTickerDesc.Controls.Add(Me.txtLastTradeDateOrContractMonth)
        Me.frameTickerDesc.Controls.Add(Me.txtSecType)
        Me.frameTickerDesc.Controls.Add(Me.txtSymbol)
        Me.frameTickerDesc.Controls.Add(Me.Label5)
        Me.frameTickerDesc.Controls.Add(Me.Label2)
        Me.frameTickerDesc.Controls.Add(Me.Label37)
        Me.frameTickerDesc.Controls.Add(Me.Label53)
        Me.frameTickerDesc.Controls.Add(Me.Label54)
        Me.frameTickerDesc.Controls.Add(Me.Label55)
        Me.frameTickerDesc.Controls.Add(Me.Label56)
        Me.frameTickerDesc.Controls.Add(Me.Label57)
        Me.frameTickerDesc.Controls.Add(Me.Label58)
        Me.frameTickerDesc.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.frameTickerDesc.ForeColor = System.Drawing.SystemColors.Highlight
        Me.frameTickerDesc.Location = New System.Drawing.Point(8, 48)
        Me.frameTickerDesc.Name = "frameTickerDesc"
        Me.frameTickerDesc.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.frameTickerDesc.Size = New System.Drawing.Size(216, 461)
        Me.frameTickerDesc.TabIndex = 1
        Me.frameTickerDesc.TabStop = False
        Me.frameTickerDesc.Text = "Ticker Description"
        '
        'txtTradingClass
        '
        Me.txtTradingClass.AcceptsReturn = True
        Me.txtTradingClass.BackColor = System.Drawing.SystemColors.Window
        Me.txtTradingClass.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtTradingClass.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtTradingClass.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtTradingClass.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtTradingClass.Location = New System.Drawing.Point(120, 325)
        Me.txtTradingClass.MaxLength = 0
        Me.txtTradingClass.Name = "txtTradingClass"
        Me.txtTradingClass.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtTradingClass.Size = New System.Drawing.Size(88, 13)
        Me.txtTradingClass.TabIndex = 23
        '
        'Label8
        '
        Me.Label8.BackColor = System.Drawing.Color.Gainsboro
        Me.Label8.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label8.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label8.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label8.Location = New System.Drawing.Point(8, 325)
        Me.Label8.Name = "Label8"
        Me.Label8.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label8.Size = New System.Drawing.Size(73, 17)
        Me.Label8.TabIndex = 22
        Me.Label8.Text = "Trading Class"
        '
        'txtSecId
        '
        Me.txtSecId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSecId.Location = New System.Drawing.Point(120, 409)
        Me.txtSecId.Name = "txtSecId"
        Me.txtSecId.Size = New System.Drawing.Size(85, 13)
        Me.txtSecId.TabIndex = 29
        '
        'txtSecIdType
        '
        Me.txtSecIdType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSecIdType.Location = New System.Drawing.Point(120, 382)
        Me.txtSecIdType.Name = "txtSecIdType"
        Me.txtSecIdType.Size = New System.Drawing.Size(86, 13)
        Me.txtSecIdType.TabIndex = 27
        '
        'Label7
        '
        Me.Label7.AutoSize = True
        Me.Label7.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label7.Location = New System.Drawing.Point(8, 410)
        Me.Label7.Name = "Label7"
        Me.Label7.Size = New System.Drawing.Size(37, 14)
        Me.Label7.TabIndex = 28
        Me.Label7.Text = "Sec Id"
        '
        'Label6
        '
        Me.Label6.AutoSize = True
        Me.Label6.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label6.Location = New System.Drawing.Point(8, 383)
        Me.Label6.Name = "Label6"
        Me.Label6.Size = New System.Drawing.Size(63, 14)
        Me.Label6.TabIndex = 26
        Me.Label6.Text = "Sec Id Type"
        '
        'Label3
        '
        Me.Label3.BackColor = System.Drawing.Color.Gainsboro
        Me.Label3.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label3.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label3.Location = New System.Drawing.Point(8, 15)
        Me.Label3.Name = "Label3"
        Me.Label3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label3.Size = New System.Drawing.Size(73, 17)
        Me.Label3.TabIndex = 0
        Me.Label3.Text = "Contract Id"
        '
        'txtConId
        '
        Me.txtConId.AcceptsReturn = True
        Me.txtConId.BackColor = System.Drawing.SystemColors.Window
        Me.txtConId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtConId.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtConId.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtConId.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtConId.Location = New System.Drawing.Point(120, 19)
        Me.txtConId.MaxLength = 0
        Me.txtConId.Name = "txtConId"
        Me.txtConId.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtConId.Size = New System.Drawing.Size(88, 13)
        Me.txtConId.TabIndex = 1
        Me.txtConId.Text = "0"
        '
        'txtIncludeExpired
        '
        Me.txtIncludeExpired.AcceptsReturn = True
        Me.txtIncludeExpired.BackColor = System.Drawing.SystemColors.Window
        Me.txtIncludeExpired.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtIncludeExpired.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtIncludeExpired.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtIncludeExpired.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtIncludeExpired.Location = New System.Drawing.Point(120, 354)
        Me.txtIncludeExpired.MaxLength = 0
        Me.txtIncludeExpired.Name = "txtIncludeExpired"
        Me.txtIncludeExpired.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtIncludeExpired.Size = New System.Drawing.Size(88, 13)
        Me.txtIncludeExpired.TabIndex = 25
        Me.txtIncludeExpired.Text = "0"
        '
        'Label39
        '
        Me.Label39.BackColor = System.Drawing.Color.Gainsboro
        Me.Label39.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label39.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label39.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label39.Location = New System.Drawing.Point(8, 353)
        Me.Label39.Name = "Label39"
        Me.Label39.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label39.Size = New System.Drawing.Size(88, 17)
        Me.Label39.TabIndex = 24
        Me.Label39.Text = "Include Expired"
        '
        'Label4
        '
        Me.Label4.BackColor = System.Drawing.Color.Gainsboro
        Me.Label4.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label4.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label4.Location = New System.Drawing.Point(8, 93)
        Me.Label4.Name = "Label4"
        Me.Label4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label4.Size = New System.Drawing.Size(96, 32)
        Me.Label4.TabIndex = 6
        Me.Label4.Text = "Last trade date or contract month"
        '
        'TextMultiplier
        '
        Me.TextMultiplier.AcceptsReturn = True
        Me.TextMultiplier.BackColor = System.Drawing.SystemColors.Window
        Me.TextMultiplier.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.TextMultiplier.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.TextMultiplier.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TextMultiplier.ForeColor = System.Drawing.SystemColors.WindowText
        Me.TextMultiplier.Location = New System.Drawing.Point(120, 185)
        Me.TextMultiplier.MaxLength = 0
        Me.TextMultiplier.Name = "TextMultiplier"
        Me.TextMultiplier.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.TextMultiplier.Size = New System.Drawing.Size(88, 13)
        Me.TextMultiplier.TabIndex = 13
        '
        'TxtPrimaryExchange
        '
        Me.TxtPrimaryExchange.AcceptsReturn = True
        Me.TxtPrimaryExchange.BackColor = System.Drawing.SystemColors.Window
        Me.TxtPrimaryExchange.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.TxtPrimaryExchange.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.TxtPrimaryExchange.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.TxtPrimaryExchange.ForeColor = System.Drawing.SystemColors.WindowText
        Me.TxtPrimaryExchange.Location = New System.Drawing.Point(120, 241)
        Me.TxtPrimaryExchange.MaxLength = 0
        Me.TxtPrimaryExchange.Name = "TxtPrimaryExchange"
        Me.TxtPrimaryExchange.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.TxtPrimaryExchange.Size = New System.Drawing.Size(88, 13)
        Me.TxtPrimaryExchange.TabIndex = 17
        Me.TxtPrimaryExchange.Text = "ARCA"
        '
        'txtRight
        '
        Me.txtRight.AcceptsReturn = True
        Me.txtRight.BackColor = System.Drawing.SystemColors.Window
        Me.txtRight.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtRight.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtRight.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtRight.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtRight.Location = New System.Drawing.Point(120, 158)
        Me.txtRight.MaxLength = 0
        Me.txtRight.Name = "txtRight"
        Me.txtRight.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtRight.Size = New System.Drawing.Size(88, 13)
        Me.txtRight.TabIndex = 11
        '
        'txtLocalSymbol
        '
        Me.txtLocalSymbol.AcceptsReturn = True
        Me.txtLocalSymbol.BackColor = System.Drawing.SystemColors.Window
        Me.txtLocalSymbol.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtLocalSymbol.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtLocalSymbol.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtLocalSymbol.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtLocalSymbol.Location = New System.Drawing.Point(120, 296)
        Me.txtLocalSymbol.MaxLength = 0
        Me.txtLocalSymbol.Name = "txtLocalSymbol"
        Me.txtLocalSymbol.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtLocalSymbol.Size = New System.Drawing.Size(88, 13)
        Me.txtLocalSymbol.TabIndex = 21
        '
        'txtCurrency
        '
        Me.txtCurrency.AcceptsReturn = True
        Me.txtCurrency.BackColor = System.Drawing.SystemColors.Window
        Me.txtCurrency.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtCurrency.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtCurrency.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtCurrency.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtCurrency.Location = New System.Drawing.Point(120, 268)
        Me.txtCurrency.MaxLength = 0
        Me.txtCurrency.Name = "txtCurrency"
        Me.txtCurrency.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtCurrency.Size = New System.Drawing.Size(88, 13)
        Me.txtCurrency.TabIndex = 19
        Me.txtCurrency.Text = "USD"
        '
        'txtExchange
        '
        Me.txtExchange.AcceptsReturn = True
        Me.txtExchange.BackColor = System.Drawing.SystemColors.Window
        Me.txtExchange.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtExchange.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtExchange.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtExchange.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtExchange.Location = New System.Drawing.Point(120, 213)
        Me.txtExchange.MaxLength = 0
        Me.txtExchange.Name = "txtExchange"
        Me.txtExchange.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtExchange.Size = New System.Drawing.Size(88, 13)
        Me.txtExchange.TabIndex = 15
        Me.txtExchange.Text = "SMART"
        '
        'txtStrike
        '
        Me.txtStrike.AcceptsReturn = True
        Me.txtStrike.BackColor = System.Drawing.SystemColors.Window
        Me.txtStrike.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtStrike.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtStrike.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtStrike.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtStrike.Location = New System.Drawing.Point(120, 130)
        Me.txtStrike.MaxLength = 0
        Me.txtStrike.Name = "txtStrike"
        Me.txtStrike.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtStrike.Size = New System.Drawing.Size(88, 13)
        Me.txtStrike.TabIndex = 9
        Me.txtStrike.Text = "0"
        '
        'txtLastTradeDateOrContractMonth
        '
        Me.txtLastTradeDateOrContractMonth.AcceptsReturn = True
        Me.txtLastTradeDateOrContractMonth.BackColor = System.Drawing.SystemColors.Window
        Me.txtLastTradeDateOrContractMonth.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtLastTradeDateOrContractMonth.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtLastTradeDateOrContractMonth.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtLastTradeDateOrContractMonth.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtLastTradeDateOrContractMonth.Location = New System.Drawing.Point(120, 101)
        Me.txtLastTradeDateOrContractMonth.MaxLength = 0
        Me.txtLastTradeDateOrContractMonth.Name = "txtLastTradeDateOrContractMonth"
        Me.txtLastTradeDateOrContractMonth.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtLastTradeDateOrContractMonth.Size = New System.Drawing.Size(88, 13)
        Me.txtLastTradeDateOrContractMonth.TabIndex = 7
        '
        'txtSecType
        '
        Me.txtSecType.AcceptsReturn = True
        Me.txtSecType.BackColor = System.Drawing.SystemColors.Window
        Me.txtSecType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSecType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtSecType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSecType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSecType.Location = New System.Drawing.Point(120, 74)
        Me.txtSecType.MaxLength = 0
        Me.txtSecType.Name = "txtSecType"
        Me.txtSecType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtSecType.Size = New System.Drawing.Size(88, 13)
        Me.txtSecType.TabIndex = 5
        Me.txtSecType.Text = "STK"
        '
        'txtSymbol
        '
        Me.txtSymbol.AcceptsReturn = True
        Me.txtSymbol.BackColor = System.Drawing.SystemColors.Window
        Me.txtSymbol.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtSymbol.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtSymbol.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtSymbol.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtSymbol.Location = New System.Drawing.Point(120, 46)
        Me.txtSymbol.MaxLength = 0
        Me.txtSymbol.Name = "txtSymbol"
        Me.txtSymbol.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtSymbol.Size = New System.Drawing.Size(88, 13)
        Me.txtSymbol.TabIndex = 3
        Me.txtSymbol.Text = "SPY"
        '
        'Label5
        '
        Me.Label5.BackColor = System.Drawing.Color.Gainsboro
        Me.Label5.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label5.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label5.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label5.Location = New System.Drawing.Point(8, 130)
        Me.Label5.Name = "Label5"
        Me.Label5.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label5.Size = New System.Drawing.Size(73, 17)
        Me.Label5.TabIndex = 8
        Me.Label5.Text = "Strike"
        '
        'Label2
        '
        Me.Label2.BackColor = System.Drawing.Color.Gainsboro
        Me.Label2.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label2.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label2.Location = New System.Drawing.Point(8, 42)
        Me.Label2.Name = "Label2"
        Me.Label2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label2.Size = New System.Drawing.Size(73, 17)
        Me.Label2.TabIndex = 2
        Me.Label2.Text = "Symbol"
        '
        'Label37
        '
        Me.Label37.BackColor = System.Drawing.Color.Gainsboro
        Me.Label37.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label37.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label37.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label37.Location = New System.Drawing.Point(8, 70)
        Me.Label37.Name = "Label37"
        Me.Label37.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label37.Size = New System.Drawing.Size(73, 17)
        Me.Label37.TabIndex = 4
        Me.Label37.Text = "Type"
        '
        'Label53
        '
        Me.Label53.BackColor = System.Drawing.Color.Gainsboro
        Me.Label53.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label53.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label53.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label53.Location = New System.Drawing.Point(8, 185)
        Me.Label53.Name = "Label53"
        Me.Label53.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label53.Size = New System.Drawing.Size(73, 17)
        Me.Label53.TabIndex = 12
        Me.Label53.Text = "Multiplier"
        '
        'Label54
        '
        Me.Label54.BackColor = System.Drawing.Color.Gainsboro
        Me.Label54.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label54.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label54.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label54.Location = New System.Drawing.Point(8, 240)
        Me.Label54.Name = "Label54"
        Me.Label54.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label54.Size = New System.Drawing.Size(97, 17)
        Me.Label54.TabIndex = 16
        Me.Label54.Text = "Primary Exchange"
        '
        'Label55
        '
        Me.Label55.BackColor = System.Drawing.Color.Gainsboro
        Me.Label55.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label55.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label55.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label55.Location = New System.Drawing.Point(8, 156)
        Me.Label55.Name = "Label55"
        Me.Label55.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label55.Size = New System.Drawing.Size(73, 17)
        Me.Label55.TabIndex = 10
        Me.Label55.Text = "Right"
        '
        'Label56
        '
        Me.Label56.BackColor = System.Drawing.Color.Gainsboro
        Me.Label56.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label56.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label56.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label56.Location = New System.Drawing.Point(8, 296)
        Me.Label56.Name = "Label56"
        Me.Label56.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label56.Size = New System.Drawing.Size(73, 17)
        Me.Label56.TabIndex = 20
        Me.Label56.Text = "Local Symbol"
        '
        'Label57
        '
        Me.Label57.BackColor = System.Drawing.Color.Gainsboro
        Me.Label57.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label57.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label57.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label57.Location = New System.Drawing.Point(8, 268)
        Me.Label57.Name = "Label57"
        Me.Label57.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label57.Size = New System.Drawing.Size(73, 17)
        Me.Label57.TabIndex = 18
        Me.Label57.Text = "Currency"
        '
        'Label58
        '
        Me.Label58.BackColor = System.Drawing.Color.Gainsboro
        Me.Label58.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label58.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label58.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label58.Location = New System.Drawing.Point(8, 213)
        Me.Label58.Name = "Label58"
        Me.Label58.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label58.Size = New System.Drawing.Size(73, 17)
        Me.Label58.TabIndex = 14
        Me.Label58.Text = "Exchange"
        '
        'txtReqId
        '
        Me.txtReqId.AcceptsReturn = True
        Me.txtReqId.BackColor = System.Drawing.SystemColors.Window
        Me.txtReqId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtReqId.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtReqId.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtReqId.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtReqId.Location = New System.Drawing.Point(80, 16)
        Me.txtReqId.MaxLength = 0
        Me.txtReqId.Name = "txtReqId"
        Me.txtReqId.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtReqId.Size = New System.Drawing.Size(105, 13)
        Me.txtReqId.TabIndex = 1
        Me.txtReqId.Text = "0"
        '
        'GroupBox1
        '
        Me.GroupBox1.BackColor = System.Drawing.Color.Gainsboro
        Me.GroupBox1.Controls.Add(Me.chkRegulatorySnapshotMktData)
        Me.GroupBox1.Controls.Add(Me.chkSnapshotMktData)
        Me.GroupBox1.Controls.Add(Me.txtGenericTickTags)
        Me.GroupBox1.Controls.Add(Me.Label22)
        Me.GroupBox1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox1.ForeColor = System.Drawing.SystemColors.Highlight
        Me.GroupBox1.Location = New System.Drawing.Point(8, 612)
        Me.GroupBox1.Name = "GroupBox1"
        Me.GroupBox1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.GroupBox1.Size = New System.Drawing.Size(216, 64)
        Me.GroupBox1.TabIndex = 3
        Me.GroupBox1.TabStop = False
        Me.GroupBox1.Text = "Market Data"
        '
        'chkRegulatorySnapshotMktData
        '
        Me.chkRegulatorySnapshotMktData.AutoSize = True
        Me.chkRegulatorySnapshotMktData.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkRegulatorySnapshotMktData.Location = New System.Drawing.Point(89, 41)
        Me.chkRegulatorySnapshotMktData.Name = "chkRegulatorySnapshotMktData"
        Me.chkRegulatorySnapshotMktData.Size = New System.Drawing.Size(127, 18)
        Me.chkRegulatorySnapshotMktData.TabIndex = 3
        Me.chkRegulatorySnapshotMktData.Text = "Regulatory Snapshot"
        Me.chkRegulatorySnapshotMktData.UseVisualStyleBackColor = True
        '
        'chkSnapshotMktData
        '
        Me.chkSnapshotMktData.AutoSize = True
        Me.chkSnapshotMktData.ForeColor = System.Drawing.SystemColors.ControlText
        Me.chkSnapshotMktData.Location = New System.Drawing.Point(11, 41)
        Me.chkSnapshotMktData.Name = "chkSnapshotMktData"
        Me.chkSnapshotMktData.Size = New System.Drawing.Size(72, 18)
        Me.chkSnapshotMktData.TabIndex = 2
        Me.chkSnapshotMktData.Text = "Snapshot"
        Me.chkSnapshotMktData.UseVisualStyleBackColor = True
        '
        'txtGenericTickTags
        '
        Me.txtGenericTickTags.AcceptsReturn = True
        Me.txtGenericTickTags.BackColor = System.Drawing.SystemColors.Window
        Me.txtGenericTickTags.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtGenericTickTags.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtGenericTickTags.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtGenericTickTags.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtGenericTickTags.Location = New System.Drawing.Point(120, 19)
        Me.txtGenericTickTags.MaxLength = 0
        Me.txtGenericTickTags.Name = "txtGenericTickTags"
        Me.txtGenericTickTags.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtGenericTickTags.Size = New System.Drawing.Size(88, 13)
        Me.txtGenericTickTags.TabIndex = 1
        Me.txtGenericTickTags.Text = "100,101,104,106,165,221,232,236,258,293,294,295,318,411,460,619"
        '
        'Label22
        '
        Me.Label22.BackColor = System.Drawing.Color.Gainsboro
        Me.Label22.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label22.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label22.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label22.Location = New System.Drawing.Point(8, 20)
        Me.Label22.Name = "Label22"
        Me.Label22.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label22.Size = New System.Drawing.Size(96, 17)
        Me.Label22.TabIndex = 0
        Me.Label22.Text = "Generic Tick Tags"
        '
        'GroupBox2
        '
        Me.GroupBox2.BackColor = System.Drawing.Color.Gainsboro
        Me.GroupBox2.Controls.Add(Me.txtExerciseOverride)
        Me.GroupBox2.Controls.Add(Me.Label36)
        Me.GroupBox2.Controls.Add(Me.txtExerciseQuantity)
        Me.GroupBox2.Controls.Add(Me.Label35)
        Me.GroupBox2.Controls.Add(Me.txtExerciseAction)
        Me.GroupBox2.Controls.Add(Me.Label30)
        Me.GroupBox2.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox2.ForeColor = System.Drawing.SystemColors.Highlight
        Me.GroupBox2.Location = New System.Drawing.Point(8, 682)
        Me.GroupBox2.Name = "GroupBox2"
        Me.GroupBox2.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.GroupBox2.Size = New System.Drawing.Size(216, 100)
        Me.GroupBox2.TabIndex = 4
        Me.GroupBox2.TabStop = False
        Me.GroupBox2.Text = "Options Exercise"
        '
        'txtExerciseOverride
        '
        Me.txtExerciseOverride.AcceptsReturn = True
        Me.txtExerciseOverride.BackColor = System.Drawing.SystemColors.Window
        Me.txtExerciseOverride.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtExerciseOverride.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtExerciseOverride.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtExerciseOverride.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtExerciseOverride.Location = New System.Drawing.Point(120, 71)
        Me.txtExerciseOverride.MaxLength = 0
        Me.txtExerciseOverride.Name = "txtExerciseOverride"
        Me.txtExerciseOverride.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtExerciseOverride.Size = New System.Drawing.Size(88, 13)
        Me.txtExerciseOverride.TabIndex = 5
        Me.txtExerciseOverride.Text = "0"
        '
        'Label36
        '
        Me.Label36.BackColor = System.Drawing.Color.Gainsboro
        Me.Label36.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label36.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label36.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label36.Location = New System.Drawing.Point(8, 71)
        Me.Label36.Name = "Label36"
        Me.Label36.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label36.Size = New System.Drawing.Size(88, 17)
        Me.Label36.TabIndex = 4
        Me.Label36.Text = "Override (0 or 1)"
        '
        'txtExerciseQuantity
        '
        Me.txtExerciseQuantity.AcceptsReturn = True
        Me.txtExerciseQuantity.BackColor = System.Drawing.SystemColors.Window
        Me.txtExerciseQuantity.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtExerciseQuantity.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtExerciseQuantity.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtExerciseQuantity.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtExerciseQuantity.Location = New System.Drawing.Point(120, 45)
        Me.txtExerciseQuantity.MaxLength = 0
        Me.txtExerciseQuantity.Name = "txtExerciseQuantity"
        Me.txtExerciseQuantity.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtExerciseQuantity.Size = New System.Drawing.Size(88, 13)
        Me.txtExerciseQuantity.TabIndex = 3
        Me.txtExerciseQuantity.Text = "1"
        '
        'Label35
        '
        Me.Label35.BackColor = System.Drawing.Color.Gainsboro
        Me.Label35.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label35.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label35.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label35.Location = New System.Drawing.Point(8, 45)
        Me.Label35.Name = "Label35"
        Me.Label35.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label35.Size = New System.Drawing.Size(108, 17)
        Me.Label35.TabIndex = 2
        Me.Label35.Text = "Number of Contracts"
        '
        'txtExerciseAction
        '
        Me.txtExerciseAction.AcceptsReturn = True
        Me.txtExerciseAction.BackColor = System.Drawing.SystemColors.Window
        Me.txtExerciseAction.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtExerciseAction.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtExerciseAction.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtExerciseAction.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtExerciseAction.Location = New System.Drawing.Point(120, 19)
        Me.txtExerciseAction.MaxLength = 0
        Me.txtExerciseAction.Name = "txtExerciseAction"
        Me.txtExerciseAction.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtExerciseAction.Size = New System.Drawing.Size(88, 13)
        Me.txtExerciseAction.TabIndex = 1
        Me.txtExerciseAction.Text = "1"
        '
        'Label30
        '
        Me.Label30.BackColor = System.Drawing.Color.Gainsboro
        Me.Label30.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label30.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label30.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label30.Location = New System.Drawing.Point(8, 17)
        Me.Label30.Name = "Label30"
        Me.Label30.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label30.Size = New System.Drawing.Size(88, 17)
        Me.Label30.TabIndex = 0
        Me.Label30.Text = "Action (1 or 2)"
        '
        'GroupBox3
        '
        Me.GroupBox3.BackColor = System.Drawing.Color.Gainsboro
        Me.GroupBox3.Controls.Add(Me.Label38)
        Me.GroupBox3.Controls.Add(Me.txtReqId)
        Me.GroupBox3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox3.ForeColor = System.Drawing.SystemColors.Highlight
        Me.GroupBox3.Location = New System.Drawing.Point(8, 0)
        Me.GroupBox3.Name = "GroupBox3"
        Me.GroupBox3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.GroupBox3.Size = New System.Drawing.Size(456, 41)
        Me.GroupBox3.TabIndex = 0
        Me.GroupBox3.TabStop = False
        '
        'Label38
        '
        Me.Label38.BackColor = System.Drawing.Color.Gainsboro
        Me.Label38.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label38.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label38.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label38.Location = New System.Drawing.Point(16, 16)
        Me.Label38.Name = "Label38"
        Me.Label38.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label38.Size = New System.Drawing.Size(57, 17)
        Me.Label38.TabIndex = 0
        Me.Label38.Text = "Ticker ID"
        '
        'GroupBox4
        '
        Me.GroupBox4.BackColor = System.Drawing.Color.Gainsboro
        Me.GroupBox4.Controls.Add(Me.chkSmartDepth)
        Me.GroupBox4.Controls.Add(Me.txtNumRows)
        Me.GroupBox4.Controls.Add(Me.Label1)
        Me.GroupBox4.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.GroupBox4.ForeColor = System.Drawing.SystemColors.Highlight
        Me.GroupBox4.Location = New System.Drawing.Point(8, 515)
        Me.GroupBox4.Name = "GroupBox4"
        Me.GroupBox4.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.GroupBox4.Size = New System.Drawing.Size(216, 86)
        Me.GroupBox4.TabIndex = 2
        Me.GroupBox4.TabStop = False
        Me.GroupBox4.Text = "Market Depth"
        '
        'chkSmartDepth
        '
        Me.chkSmartDepth.AutoSize = True
        Me.chkSmartDepth.Checked = True
        Me.chkSmartDepth.CheckState = System.Windows.Forms.CheckState.Checked
        Me.chkSmartDepth.Location = New System.Drawing.Point(11, 54)
        Me.chkSmartDepth.Name = "chkSmartDepth"
        Me.chkSmartDepth.Size = New System.Drawing.Size(93, 18)
        Me.chkSmartDepth.TabIndex = 17
        Me.chkSmartDepth.Text = "SMART Depth"
        Me.chkSmartDepth.UseVisualStyleBackColor = True
        '
        'txtNumRows
        '
        Me.txtNumRows.AcceptsReturn = True
        Me.txtNumRows.BackColor = System.Drawing.SystemColors.Window
        Me.txtNumRows.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtNumRows.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtNumRows.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtNumRows.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtNumRows.Location = New System.Drawing.Point(120, 19)
        Me.txtNumRows.MaxLength = 0
        Me.txtNumRows.Name = "txtNumRows"
        Me.txtNumRows.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtNumRows.Size = New System.Drawing.Size(88, 13)
        Me.txtNumRows.TabIndex = 1
        Me.txtNumRows.Text = "20"
        '
        'Label1
        '
        Me.Label1.BackColor = System.Drawing.Color.Gainsboro
        Me.Label1.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label1.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label1.Location = New System.Drawing.Point(8, 16)
        Me.Label1.Name = "Label1"
        Me.Label1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label1.Size = New System.Drawing.Size(96, 30)
        Me.Label1.TabIndex = 0
        Me.Label1.Text = "Max Market Depth Rows"
        '
        'Label27
        '
        Me.Label27.BackColor = System.Drawing.Color.Gainsboro
        Me.Label27.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label27.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label27.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label27.Location = New System.Drawing.Point(13, 82)
        Me.Label27.Name = "Label27"
        Me.Label27.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label27.Size = New System.Drawing.Size(89, 17)
        Me.Label27.TabIndex = 4
        Me.Label27.Text = "Order Type"
        '
        'cmdSetShareAllocation
        '
        Me.cmdSetShareAllocation.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSetShareAllocation.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSetShareAllocation.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSetShareAllocation.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSetShareAllocation.Location = New System.Drawing.Point(17, 262)
        Me.cmdSetShareAllocation.Name = "cmdSetShareAllocation"
        Me.cmdSetShareAllocation.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSetShareAllocation.Size = New System.Drawing.Size(99, 25)
        Me.cmdSetShareAllocation.TabIndex = 16
        Me.cmdSetShareAllocation.Text = "FA Alloc"
        Me.cmdSetShareAllocation.UseVisualStyleBackColor = True
        '
        'Label10
        '
        Me.Label10.BackColor = System.Drawing.Color.Gainsboro
        Me.Label10.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label10.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label10.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label10.Location = New System.Drawing.Point(13, 19)
        Me.Label10.Name = "Label10"
        Me.Label10.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label10.Size = New System.Drawing.Size(89, 17)
        Me.Label10.TabIndex = 0
        Me.Label10.Text = "Action"
        '
        'Label11
        '
        Me.Label11.BackColor = System.Drawing.Color.Gainsboro
        Me.Label11.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label11.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label11.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label11.Location = New System.Drawing.Point(14, 47)
        Me.Label11.Name = "Label11"
        Me.Label11.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label11.Size = New System.Drawing.Size(89, 17)
        Me.Label11.TabIndex = 2
        Me.Label11.Text = "Quantity"
        '
        'Label13
        '
        Me.Label13.BackColor = System.Drawing.Color.Gainsboro
        Me.Label13.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label13.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label13.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label13.Location = New System.Drawing.Point(13, 103)
        Me.Label13.Name = "Label13"
        Me.Label13.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label13.Size = New System.Drawing.Size(89, 30)
        Me.Label13.TabIndex = 6
        Me.Label13.Text = "Lmt/Opt Price / Volatility"
        '
        'Label14
        '
        Me.Label14.BackColor = System.Drawing.Color.Gainsboro
        Me.Label14.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label14.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label14.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label14.Location = New System.Drawing.Point(13, 134)
        Me.Label14.Name = "Label14"
        Me.Label14.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label14.Size = New System.Drawing.Size(89, 17)
        Me.Label14.TabIndex = 8
        Me.Label14.Text = "Aux/Under Price"
        '
        'Label15
        '
        Me.Label15.BackColor = System.Drawing.Color.Gainsboro
        Me.Label15.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label15.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label15.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label15.Location = New System.Drawing.Point(14, 191)
        Me.Label15.Name = "Label15"
        Me.Label15.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label15.Size = New System.Drawing.Size(89, 17)
        Me.Label15.TabIndex = 12
        Me.Label15.Text = "Good Till Date"
        '
        'Label16
        '
        Me.Label16.BackColor = System.Drawing.Color.Gainsboro
        Me.Label16.Cursor = System.Windows.Forms.Cursors.Default
        Me.Label16.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Label16.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label16.Location = New System.Drawing.Point(14, 163)
        Me.Label16.Name = "Label16"
        Me.Label16.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Label16.Size = New System.Drawing.Size(89, 17)
        Me.Label16.TabIndex = 10
        Me.Label16.Text = "Good After Time"
        '
        'txtAction
        '
        Me.txtAction.AcceptsReturn = True
        Me.txtAction.BackColor = System.Drawing.SystemColors.Window
        Me.txtAction.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAction.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAction.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAction.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAction.Location = New System.Drawing.Point(114, 19)
        Me.txtAction.MaxLength = 0
        Me.txtAction.Name = "txtAction"
        Me.txtAction.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAction.Size = New System.Drawing.Size(112, 13)
        Me.txtAction.TabIndex = 1
        Me.txtAction.Text = "BUY"
        '
        'txtQuantity
        '
        Me.txtQuantity.AcceptsReturn = True
        Me.txtQuantity.BackColor = System.Drawing.SystemColors.Window
        Me.txtQuantity.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtQuantity.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtQuantity.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtQuantity.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtQuantity.Location = New System.Drawing.Point(112, 47)
        Me.txtQuantity.MaxLength = 0
        Me.txtQuantity.Name = "txtQuantity"
        Me.txtQuantity.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtQuantity.Size = New System.Drawing.Size(112, 13)
        Me.txtQuantity.TabIndex = 3
        Me.txtQuantity.Text = "10"
        '
        'txtOrderType
        '
        Me.txtOrderType.AcceptsReturn = True
        Me.txtOrderType.BackColor = System.Drawing.SystemColors.Window
        Me.txtOrderType.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtOrderType.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtOrderType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtOrderType.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtOrderType.Location = New System.Drawing.Point(112, 79)
        Me.txtOrderType.MaxLength = 0
        Me.txtOrderType.Name = "txtOrderType"
        Me.txtOrderType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtOrderType.Size = New System.Drawing.Size(112, 13)
        Me.txtOrderType.TabIndex = 5
        Me.txtOrderType.Text = "LMT"
        '
        'txtLmtPrice
        '
        Me.txtLmtPrice.AcceptsReturn = True
        Me.txtLmtPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtLmtPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtLmtPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtLmtPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtLmtPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtLmtPrice.Location = New System.Drawing.Point(112, 104)
        Me.txtLmtPrice.MaxLength = 0
        Me.txtLmtPrice.Name = "txtLmtPrice"
        Me.txtLmtPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtLmtPrice.Size = New System.Drawing.Size(112, 13)
        Me.txtLmtPrice.TabIndex = 7
        Me.txtLmtPrice.Text = "40"
        '
        'txtAuxPrice
        '
        Me.txtAuxPrice.AcceptsReturn = True
        Me.txtAuxPrice.BackColor = System.Drawing.SystemColors.Window
        Me.txtAuxPrice.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtAuxPrice.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtAuxPrice.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtAuxPrice.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtAuxPrice.Location = New System.Drawing.Point(114, 134)
        Me.txtAuxPrice.MaxLength = 0
        Me.txtAuxPrice.Name = "txtAuxPrice"
        Me.txtAuxPrice.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtAuxPrice.Size = New System.Drawing.Size(112, 13)
        Me.txtAuxPrice.TabIndex = 9
        Me.txtAuxPrice.Text = "0"
        '
        'cmdAddCmboLegs
        '
        Me.cmdAddCmboLegs.BackColor = System.Drawing.SystemColors.Control
        Me.cmdAddCmboLegs.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdAddCmboLegs.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdAddCmboLegs.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdAddCmboLegs.Location = New System.Drawing.Point(122, 262)
        Me.cmdAddCmboLegs.Name = "cmdAddCmboLegs"
        Me.cmdAddCmboLegs.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdAddCmboLegs.Size = New System.Drawing.Size(99, 25)
        Me.cmdAddCmboLegs.TabIndex = 17
        Me.cmdAddCmboLegs.Text = "Combo Legs"
        Me.cmdAddCmboLegs.UseVisualStyleBackColor = True
        '
        'tGTD
        '
        Me.tGTD.AcceptsReturn = True
        Me.tGTD.BackColor = System.Drawing.SystemColors.Window
        Me.tGTD.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.tGTD.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.tGTD.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tGTD.ForeColor = System.Drawing.SystemColors.WindowText
        Me.tGTD.Location = New System.Drawing.Point(112, 192)
        Me.tGTD.MaxLength = 0
        Me.tGTD.Name = "tGTD"
        Me.tGTD.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.tGTD.Size = New System.Drawing.Size(112, 13)
        Me.tGTD.TabIndex = 13
        '
        'tGAT
        '
        Me.tGAT.AcceptsReturn = True
        Me.tGAT.BackColor = System.Drawing.SystemColors.Window
        Me.tGAT.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.tGAT.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.tGAT.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.tGAT.ForeColor = System.Drawing.SystemColors.WindowText
        Me.tGAT.Location = New System.Drawing.Point(112, 163)
        Me.tGAT.MaxLength = 0
        Me.tGAT.Name = "tGAT"
        Me.tGAT.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.tGAT.Size = New System.Drawing.Size(112, 13)
        Me.tGAT.TabIndex = 11
        '
        'cmdDeltaNeutralContract
        '
        Me.cmdDeltaNeutralContract.BackColor = System.Drawing.SystemColors.Control
        Me.cmdDeltaNeutralContract.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdDeltaNeutralContract.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdDeltaNeutralContract.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdDeltaNeutralContract.Location = New System.Drawing.Point(17, 298)
        Me.cmdDeltaNeutralContract.Name = "cmdDeltaNeutralContract"
        Me.cmdDeltaNeutralContract.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdDeltaNeutralContract.Size = New System.Drawing.Size(99, 25)
        Me.cmdDeltaNeutralContract.TabIndex = 18
        Me.cmdDeltaNeutralContract.Text = "Delta Neutral"
        Me.cmdDeltaNeutralContract.UseVisualStyleBackColor = True
        '
        'cmdAlgoParams
        '
        Me.cmdAlgoParams.BackColor = System.Drawing.SystemColors.Control
        Me.cmdAlgoParams.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdAlgoParams.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdAlgoParams.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdAlgoParams.Location = New System.Drawing.Point(122, 298)
        Me.cmdAlgoParams.Name = "cmdAlgoParams"
        Me.cmdAlgoParams.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdAlgoParams.Size = New System.Drawing.Size(99, 25)
        Me.cmdAlgoParams.TabIndex = 19
        Me.cmdAlgoParams.Text = "Algo Params"
        Me.cmdAlgoParams.UseVisualStyleBackColor = True
        '
        'frameOrderDesc
        '
        Me.frameOrderDesc.BackColor = System.Drawing.Color.Gainsboro
        Me.frameOrderDesc.Controls.Add(Me.chkUsePriceMgmtAlgo)
        Me.frameOrderDesc.Controls.Add(Me.txtCashQty)
        Me.frameOrderDesc.Controls.Add(Me.labelCashQty)
        Me.frameOrderDesc.Controls.Add(Me.cmdPegBench)
        Me.frameOrderDesc.Controls.Add(Me.cmdAdjustStop)
        Me.frameOrderDesc.Controls.Add(Me.cmdConditions)
        Me.frameOrderDesc.Controls.Add(Me.cmdOptions)
        Me.frameOrderDesc.Controls.Add(Me.cmdSmartComboRoutingParams)
        Me.frameOrderDesc.Controls.Add(Me.cmdAlgoParams)
        Me.frameOrderDesc.Controls.Add(Me.cmdDeltaNeutralContract)
        Me.frameOrderDesc.Controls.Add(Me.tGAT)
        Me.frameOrderDesc.Controls.Add(Me.tGTD)
        Me.frameOrderDesc.Controls.Add(Me.cmdAddCmboLegs)
        Me.frameOrderDesc.Controls.Add(Me.txtAuxPrice)
        Me.frameOrderDesc.Controls.Add(Me.txtLmtPrice)
        Me.frameOrderDesc.Controls.Add(Me.txtOrderType)
        Me.frameOrderDesc.Controls.Add(Me.txtQuantity)
        Me.frameOrderDesc.Controls.Add(Me.txtAction)
        Me.frameOrderDesc.Controls.Add(Me.Label16)
        Me.frameOrderDesc.Controls.Add(Me.Label15)
        Me.frameOrderDesc.Controls.Add(Me.Label14)
        Me.frameOrderDesc.Controls.Add(Me.Label13)
        Me.frameOrderDesc.Controls.Add(Me.Label11)
        Me.frameOrderDesc.Controls.Add(Me.Label10)
        Me.frameOrderDesc.Controls.Add(Me.cmdSetShareAllocation)
        Me.frameOrderDesc.Controls.Add(Me.Label27)
        Me.frameOrderDesc.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.frameOrderDesc.ForeColor = System.Drawing.SystemColors.Highlight
        Me.frameOrderDesc.Location = New System.Drawing.Point(232, 48)
        Me.frameOrderDesc.Name = "frameOrderDesc"
        Me.frameOrderDesc.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.frameOrderDesc.Size = New System.Drawing.Size(232, 431)
        Me.frameOrderDesc.TabIndex = 6
        Me.frameOrderDesc.TabStop = False
        Me.frameOrderDesc.Text = "Order Description"
        '
        'chkUsePriceMgmtAlgo
        '
        Me.chkUsePriceMgmtAlgo.AutoSize = True
        Me.chkUsePriceMgmtAlgo.Checked = True
        Me.chkUsePriceMgmtAlgo.CheckState = System.Windows.Forms.CheckState.Indeterminate
        Me.chkUsePriceMgmtAlgo.Location = New System.Drawing.Point(17, 238)
        Me.chkUsePriceMgmtAlgo.Name = "chkUsePriceMgmtAlgo"
        Me.chkUsePriceMgmtAlgo.Size = New System.Drawing.Size(160, 18)
        Me.chkUsePriceMgmtAlgo.TabIndex = 10
        Me.chkUsePriceMgmtAlgo.Text = "Use Price Management Algo"
        Me.chkUsePriceMgmtAlgo.UseVisualStyleBackColor = True
        '
        'txtCashQty
        '
        Me.txtCashQty.AcceptsReturn = True
        Me.txtCashQty.BackColor = System.Drawing.SystemColors.Window
        Me.txtCashQty.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtCashQty.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.txtCashQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.txtCashQty.ForeColor = System.Drawing.SystemColors.WindowText
        Me.txtCashQty.Location = New System.Drawing.Point(112, 220)
        Me.txtCashQty.MaxLength = 0
        Me.txtCashQty.Name = "txtCashQty"
        Me.txtCashQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.txtCashQty.Size = New System.Drawing.Size(112, 13)
        Me.txtCashQty.TabIndex = 15
        '
        'labelCashQty
        '
        Me.labelCashQty.BackColor = System.Drawing.Color.Gainsboro
        Me.labelCashQty.Cursor = System.Windows.Forms.Cursors.Default
        Me.labelCashQty.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.labelCashQty.ForeColor = System.Drawing.SystemColors.ControlText
        Me.labelCashQty.Location = New System.Drawing.Point(14, 220)
        Me.labelCashQty.Name = "labelCashQty"
        Me.labelCashQty.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.labelCashQty.Size = New System.Drawing.Size(89, 17)
        Me.labelCashQty.TabIndex = 14
        Me.labelCashQty.Text = "Cash Qty"
        '
        'cmdPegBench
        '
        Me.cmdPegBench.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdPegBench.Location = New System.Drawing.Point(63, 396)
        Me.cmdPegBench.Name = "cmdPegBench"
        Me.cmdPegBench.Size = New System.Drawing.Size(125, 25)
        Me.cmdPegBench.TabIndex = 24
        Me.cmdPegBench.Text = "Pegged to benchmark"
        Me.cmdPegBench.UseVisualStyleBackColor = True
        '
        'cmdAdjustStop
        '
        Me.cmdAdjustStop.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdAdjustStop.Location = New System.Drawing.Point(122, 365)
        Me.cmdAdjustStop.Name = "cmdAdjustStop"
        Me.cmdAdjustStop.Size = New System.Drawing.Size(99, 25)
        Me.cmdAdjustStop.TabIndex = 23
        Me.cmdAdjustStop.Text = "Adjustable stops"
        Me.cmdAdjustStop.UseVisualStyleBackColor = True
        '
        'cmdConditions
        '
        Me.cmdConditions.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdConditions.Location = New System.Drawing.Point(17, 365)
        Me.cmdConditions.Name = "cmdConditions"
        Me.cmdConditions.Size = New System.Drawing.Size(99, 25)
        Me.cmdConditions.TabIndex = 22
        Me.cmdConditions.Text = "Conditions"
        Me.cmdConditions.UseVisualStyleBackColor = True
        '
        'cmdOptions
        '
        Me.cmdOptions.Enabled = False
        Me.cmdOptions.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdOptions.Location = New System.Drawing.Point(122, 335)
        Me.cmdOptions.Name = "cmdOptions"
        Me.cmdOptions.Size = New System.Drawing.Size(99, 25)
        Me.cmdOptions.TabIndex = 21
        Me.cmdOptions.Text = "Options"
        Me.cmdOptions.UseVisualStyleBackColor = True
        '
        'cmdSmartComboRoutingParams
        '
        Me.cmdSmartComboRoutingParams.BackColor = System.Drawing.SystemColors.Control
        Me.cmdSmartComboRoutingParams.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdSmartComboRoutingParams.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdSmartComboRoutingParams.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdSmartComboRoutingParams.Location = New System.Drawing.Point(17, 335)
        Me.cmdSmartComboRoutingParams.Name = "cmdSmartComboRoutingParams"
        Me.cmdSmartComboRoutingParams.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdSmartComboRoutingParams.Size = New System.Drawing.Size(99, 25)
        Me.cmdSmartComboRoutingParams.TabIndex = 20
        Me.cmdSmartComboRoutingParams.Text = "Cmb Rou Params"
        Me.cmdSmartComboRoutingParams.UseVisualStyleBackColor = True
        '
        'labelMarketDataType
        '
        Me.labelMarketDataType.BackColor = System.Drawing.Color.Gainsboro
        Me.labelMarketDataType.Cursor = System.Windows.Forms.Cursors.Default
        Me.labelMarketDataType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.labelMarketDataType.ForeColor = System.Drawing.SystemColors.ControlText
        Me.labelMarketDataType.Location = New System.Drawing.Point(11, 21)
        Me.labelMarketDataType.Name = "labelMarketDataType"
        Me.labelMarketDataType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.labelMarketDataType.Size = New System.Drawing.Size(93, 17)
        Me.labelMarketDataType.TabIndex = 0
        Me.labelMarketDataType.Text = "Market Data Type"
        '
        'frameMarketDataType
        '
        Me.frameMarketDataType.BackColor = System.Drawing.Color.Gainsboro
        Me.frameMarketDataType.Controls.Add(Me.cmbMarketDataType)
        Me.frameMarketDataType.Controls.Add(Me.labelMarketDataType)
        Me.frameMarketDataType.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.frameMarketDataType.ForeColor = System.Drawing.SystemColors.Highlight
        Me.frameMarketDataType.Location = New System.Drawing.Point(234, 752)
        Me.frameMarketDataType.Name = "frameMarketDataType"
        Me.frameMarketDataType.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.frameMarketDataType.Size = New System.Drawing.Size(232, 53)
        Me.frameMarketDataType.TabIndex = 5
        Me.frameMarketDataType.TabStop = False
        Me.frameMarketDataType.Text = "Market Data Type"
        '
        'cmbMarketDataType
        '
        Me.cmbMarketDataType.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList
        Me.cmbMarketDataType.FormattingEnabled = True
        Me.cmbMarketDataType.Location = New System.Drawing.Point(104, 21)
        Me.cmbMarketDataType.Name = "cmbMarketDataType"
        Me.cmbMarketDataType.Size = New System.Drawing.Size(115, 22)
        Me.cmbMarketDataType.TabIndex = 1
        '
        'Label17
        '
        Me.Label17.AutoSize = True
        Me.Label17.ForeColor = System.Drawing.SystemColors.ControlText
        Me.Label17.Location = New System.Drawing.Point(8, 437)
        Me.Label17.Name = "Label17"
        Me.Label17.Size = New System.Drawing.Size(48, 14)
        Me.Label17.TabIndex = 30
        Me.Label17.Text = "Issuer Id"
        '
        'txtIssuerId
        '
        Me.txtIssuerId.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.txtIssuerId.Location = New System.Drawing.Point(120, 437)
        Me.txtIssuerId.Name = "txtIssuerId"
        Me.txtIssuerId.Size = New System.Drawing.Size(85, 13)
        Me.txtIssuerId.TabIndex = 31
        '
        'dlgOrder
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.Color.Gainsboro
        Me.ClientSize = New System.Drawing.Size(474, 841)
        Me.Controls.Add(Me.frameMarketDataType)
        Me.Controls.Add(Me.GroupBox4)
        Me.Controls.Add(Me.GroupBox2)
        Me.Controls.Add(Me.GroupBox1)
        Me.Controls.Add(Me.Frame1)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.cmdOk)
        Me.Controls.Add(Me.frameOrderDesc)
        Me.Controls.Add(Me.frameTickerDesc)
        Me.Controls.Add(Me.GroupBox3)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Location = New System.Drawing.Point(-66, 115)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "dlgOrder"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen
        Me.Text = "Request Market Data"
        Me.Frame1.ResumeLayout(False)
        Me.Frame1.PerformLayout()
        Me.frameTickerDesc.ResumeLayout(False)
        Me.frameTickerDesc.PerformLayout()
        Me.GroupBox1.ResumeLayout(False)
        Me.GroupBox1.PerformLayout()
        Me.GroupBox2.ResumeLayout(False)
        Me.GroupBox2.PerformLayout()
        Me.GroupBox3.ResumeLayout(False)
        Me.GroupBox3.PerformLayout()
        Me.GroupBox4.ResumeLayout(False)
        Me.GroupBox4.PerformLayout()
        Me.frameOrderDesc.ResumeLayout(False)
        Me.frameOrderDesc.PerformLayout()
        Me.frameMarketDataType.ResumeLayout(False)
        Me.ResumeLayout(False)

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As dlgOrder
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As dlgOrder
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New dlgOrder()
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(value As dlgOrder)
            m_vb6FormDefInstance = value
        End Set
    End Property
#End Region
    ' Enums
    Friend Enum DialogType
        RequestMarketData = 1
        CancelMarketData
        RequestMarketDepth
        CancelMarketDepth
        PlaceOrder
        CancelOrder
        RequestContractDetails
        RequestHistoricalData
        ExerciseOptions
        CancelHistoricalData
        RequestRealtimeBars
        CancelRealtimeBars
        CalculateImpliedVolatility
        CalculateOptionPrice
        CancelCalculateImpliedVolatility
        CancelCalculateOptionPrice
        RequestMarketDataType
        RequestFundamentalData
        CancelFundamentalData
        RequestMatchingSymbols
        RequestHistoricalTicks
        RequestTickByTick
        CancelTickByTick

    End Enum

    Friend Enum MarketDataTypes
        Realtime = 1
        Frozen = 2
        Delayed = 3
        DelayedFrozen = 4
    End Enum


    ' ========================================================
    ' Member variables
    ' ========================================================
    Private m_mainWnd As MainForm
    Private m_arrDlgTitles As New Collection

    Private m_orderId As Integer

    Private m_contractInfo As IBApi.Contract
    Private m_orderInfo As IBApi.Order
    Private m_deltaNeutralContract As IBApi.DeltaNeutralContract

    Private m_faMethod, m_faGroup, m_faPercentage As Object
    Private m_faProfile As String

    Private m_genericTickTags As String
    Private m_snapshotMktData As Boolean
    Private m_regulatorySnapshotMktData As Boolean

    Private m_numRows As Integer
    Private m_isSmartDepth As Boolean

    Private m_exerciseAction As Integer
    Private m_exerciseQuantity As Integer
    Private m_exerciseOverride As Integer

    Private m_barSizeSetting As String
    Private m_duration As String
    Private m_endDateTime As String
    Private m_useRTH As Integer
    Private m_whatToShow As String
    Private m_formatDate As Integer

    Private m_marketDataType As Integer
    Private m_optionsDlgTitle As String
    Private m_options As List(Of IBApi.TagValue)
    Private m_tickByTickType As String

    ' ========================================================
    ' Get/Set Methods
    ' ========================================================
    Public ReadOnly Property options() As List(Of IBApi.TagValue)
        Get
            options = m_options
        End Get
    End Property

    Public Property histBarSizeSetting() As String
        Get
            histBarSizeSetting = m_barSizeSetting
        End Get
        Set(Value As String)
            m_barSizeSetting = Value
            txtBarSizeSetting.Text = m_barSizeSetting
        End Set
    End Property
    Public Property genericTickTags() As String
        Get
            genericTickTags = m_genericTickTags
        End Get
        Set(Value As String)
            m_genericTickTags = Value
            txtGenericTickTags.Text = m_genericTickTags
        End Set
    End Property
    Public Property histEndDateTime() As String
        Get
            histEndDateTime = m_endDateTime
        End Get
        Set(Value As String)
            m_endDateTime = Value
            txtEndDateTime.Text = m_endDateTime
        End Set
    End Property
    Public Property histDuration() As String
        Get
            histDuration = m_duration
        End Get
        Set(Value As String)
            m_duration = Value
            txtDuration.Text = m_duration
        End Set
    End Property
    Public Property formatDate() As Integer
        Get
            formatDate = m_formatDate
        End Get
        Set(Value As Integer)
            m_formatDate = Value
            txtFormatDate.Text = m_formatDate
        End Set
    End Property
    Public Property whatToShow() As String
        Get
            whatToShow = m_whatToShow
        End Get
        Set(Value As String)
            m_whatToShow = Value
            txtWhatToShow.Text = m_whatToShow
        End Set
    End Property
    Public Property useRTH() As Integer
        Get
            useRTH = m_useRTH
        End Get
        Set(Value As Integer)
            m_useRTH = Value
            txtUseRTH.Text = CStr(m_useRTH)
        End Set
    End Property
    Public Property orderId() As Integer
        Get
            orderId = m_orderId
        End Get
        Set(Value As Integer)
            m_orderId = Value
            txtReqId.Text = CStr(m_orderId)
        End Set
    End Property
    Public Property exerciseAction() As Integer
        Get
            exerciseAction = m_exerciseAction
        End Get
        Set(Value As Integer)
            m_exerciseAction = Value
            txtExerciseAction.Text = CStr(m_exerciseAction)
        End Set
    End Property
    Public Property exerciseQuantity() As Integer
        Get
            exerciseQuantity = m_exerciseQuantity
        End Get
        Set(Value As Integer)
            m_exerciseQuantity = Value
            txtExerciseQuantity.Text = CStr(m_exerciseQuantity)
        End Set
    End Property
    Public Property exerciseOverride() As Integer
        Get
            exerciseOverride = m_exerciseOverride
        End Get
        Set(Value As Integer)
            m_exerciseOverride = Value
            txtExerciseOverride.Text = CStr(m_exerciseOverride)
        End Set
    End Property
    Public Property numRows() As Integer
        Get
            numRows = m_numRows
        End Get
        Set(Value As Integer)
            m_numRows = Value
            txtNumRows.Text = CStr(m_numRows)
        End Set
    End Property
    Public ReadOnly Property isSmartDepth() As Boolean
        Get
            isSmartDepth = m_isSmartDepth
        End Get
    End Property

    Public ReadOnly Property snapshotMktData() As Boolean
        Get
            snapshotMktData = m_snapshotMktData
        End Get
    End Property

    Public ReadOnly Property regulatorySnapshotMktData() As Boolean
        Get
            regulatorySnapshotMktData = m_regulatorySnapshotMktData
        End Get
    End Property

    Public ReadOnly Property marketDataType() As Integer
        Get
            marketDataType = m_marketDataType
        End Get
    End Property

    Public ReadOnly Property tickByTickType() As String
        Get
            tickByTickType = m_tickByTickType
        End Get
    End Property

    Public ReadOnly Property ok() As Boolean
        Get
            ok = DialogResult = Windows.Forms.DialogResult.OK
        End Get
    End Property

    ' ========================================================
    ' Button Events
    ' ========================================================
    Private Sub cmdAddCmboLegs_Click(sender As Object, e As EventArgs) Handles cmdAddCmboLegs.Click

        Dim dlgComboLegs As New dlgComboOrderLegs

        dlgComboLegs.Init(m_contractInfo.ComboLegs, m_orderInfo.OrderComboLegs)
        dlgComboLegs.ShowDialog()

        If dlgComboLegs.ok Then

            m_contractInfo.ComboLegs = dlgComboLegs.comboLegs
            m_orderInfo.OrderComboLegs = dlgComboLegs.orderComboLegs

        End If

    End Sub

    Private Sub cmdAlgoParams_Click(sender As Object, e As System.EventArgs) Handles cmdAlgoParams.Click
        Dim dlg As New dlgAlgoParams

        dlg.init(m_orderInfo.AlgoStrategy, m_orderInfo.AlgoParams)
        Dim res = dlg.ShowDialog()
        If res = DialogResult.OK Then
            m_orderInfo.AlgoStrategy = dlg.algoStrategy
            m_orderInfo.AlgoParams = dlg.algoParams
        End If
    End Sub

    Private Sub cmdSetShareAllocation_Click(sender As Object, e As EventArgs) Handles cmdSetShareAllocation.Click
        Dim dlg As New dlgSharesAlloc

        With dlg
            .init((m_mainWnd.FAManagedAccounts))
            .ShowDialog()
            If .ok Then
                m_faGroup = .faGroup
                m_faMethod = .faMethod
                m_faPercentage = .faPercentage
                m_faProfile = .faProfile
            End If
        End With
    End Sub

    Private Sub cmdDeltaNeutralContract_Click(sender As Object, e As EventArgs) Handles cmdDeltaNeutralContract.Click
        Dim dlg As New dlgDeltaNeutralContract

        With dlg
            .init(m_deltaNeutralContract)
            Dim res = .ShowDialog()
            Select Case res
                Case DialogResult.OK : m_contractInfo.DeltaNeutralContract = m_deltaNeutralContract
                Case DialogResult.Abort : m_contractInfo.DeltaNeutralContract = Nothing
            End Select
        End With
    End Sub

    Private Sub cmdOK_Click(sender As Object, e As EventArgs) Handles cmdOk.Click
        ' Move UI data into member fields
        m_orderId = CInt(txtReqId.Text)

        m_contractInfo.ConId = CInt(txtConId.Text)
        m_contractInfo.Symbol = txtSymbol.Text
        m_contractInfo.SecType = txtSecType.Text
        m_contractInfo.LastTradeDateOrContractMonth = txtLastTradeDateOrContractMonth.Text
        m_contractInfo.Strike = CDbl(txtStrike.Text)
        m_contractInfo.Right = txtRight.Text
        m_contractInfo.Multiplier = TextMultiplier.Text
        m_contractInfo.Exchange = txtExchange.Text
        m_contractInfo.PrimaryExch = TxtPrimaryExchange.Text
        m_contractInfo.Currency = txtCurrency.Text
        m_contractInfo.LocalSymbol = txtLocalSymbol.Text
        m_contractInfo.TradingClass = txtTradingClass.Text
        m_contractInfo.IncludeExpired = CBool(txtIncludeExpired.Text)
        m_contractInfo.SecIdType = txtSecIdType.Text
        m_contractInfo.SecId = txtSecId.Text
        m_contractInfo.IssuerId = txtIssuerId.Text

        m_orderInfo.Action = txtAction.Text
        m_orderInfo.TotalQuantity = CDbl(txtQuantity.Text)
        m_orderInfo.OrderType = txtOrderType.Text
        m_orderInfo.LmtPrice = dval(txtLmtPrice.Text)
        m_orderInfo.AuxPrice = dval(txtAuxPrice.Text)
        m_orderInfo.CashQty = dval(txtCashQty.Text)

        m_orderInfo.GoodAfterTime = tGAT.Text
        m_orderInfo.GoodTillDate = tGTD.Text

        m_orderInfo.FaGroup = m_faGroup
        m_orderInfo.FaMethod = m_faMethod
        m_orderInfo.FaPercentage = m_faPercentage
        m_orderInfo.FaProfile = m_faProfile

        m_orderInfo.UsePriceMgmtAlgo = If(chkUsePriceMgmtAlgo.CheckState = CheckState.Indeterminate, Nothing, CType(chkUsePriceMgmtAlgo.Checked, Boolean?))

        m_genericTickTags = txtGenericTickTags.Text
        m_snapshotMktData = chkSnapshotMktData.Checked
        m_regulatorySnapshotMktData = chkRegulatorySnapshotMktData.Checked

        m_numRows = CInt(txtNumRows.Text)
        m_isSmartDepth = chkSmartDepth.Checked

        m_endDateTime = txtEndDateTime.Text
        m_duration = txtDuration.Text
        m_barSizeSetting = txtBarSizeSetting.Text
        m_whatToShow = txtWhatToShow.Text
        m_useRTH = CInt(txtUseRTH.Text)
        m_formatDate = txtFormatDate.Text
        m_keepUpToDate = chkKeepUpToDate.Checked

        numberOfTicks = CInt(txtNumOfTicks.Text)
        ignoreSize = chkIgnoreSize.Checked
        histStartDateTime = txtStartDateTime.Text

        m_marketDataType = cmbMarketDataType.SelectedIndex + 1

        m_exerciseAction = CInt(txtExerciseAction.Text)
        m_exerciseQuantity = CInt(txtExerciseQuantity.Text)
        m_exerciseOverride = CInt(txtExerciseOverride.Text)

        m_tickByTickType = comboBoxTickByTickType.Text

        DialogResult = Windows.Forms.DialogResult.OK
        m_contractInfo = Nothing
        m_orderInfo = Nothing
        Hide()
    End Sub

    Private Sub cmdCancel_Click(sender As Object, e As EventArgs) Handles cmdCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel
        m_contractInfo = Nothing
        m_orderInfo = Nothing
        Hide()
    End Sub

    ' ========================================================
    ' Public Methods
    ' ========================================================
    '--------------------------------------------------------------------------------
    ' Sets the dialog field and button states based on the dialog type
    '--------------------------------------------------------------------------------
    Public Sub init(dlgType As DialogType, contractInfo As IBApi.Contract,
        orderInfo As IBApi.Order, deltaNeutralContract As IBApi.DeltaNeutralContract,
        options As List(Of IBApi.TagValue),
        mainWin As System.Windows.Forms.Form)
        DialogResult = Windows.Forms.DialogResult.Abort

        m_contractInfo = contractInfo
        m_orderInfo = orderInfo
        m_deltaNeutralContract = deltaNeutralContract
        m_options = options

        m_mainWnd = MainForm.DefInstance
        Text = m_arrDlgTitles.Item(dlgType)

        cmdSetShareAllocation.Enabled = (m_mainWnd.IsFAAccount() And dlgType = DialogType.PlaceOrder)
        cmdAddCmboLegs.Enabled =
            (dlgType = DialogType.PlaceOrder Or
            dlgType = DialogType.RequestHistoricalData Or
            dlgType = DialogType.RequestMarketData)

        cmdDeltaNeutralContract.Enabled =
            (dlgType = DialogType.PlaceOrder Or
            dlgType = DialogType.RequestMarketData)

        cmdAlgoParams.Enabled =
            (dlgType = DialogType.PlaceOrder)

        cmdSmartComboRoutingParams.Enabled =
            (dlgType = DialogType.PlaceOrder)

        cmdOptions.Enabled =
            (dlgType = DialogType.PlaceOrder Or
            dlgType = DialogType.RequestMarketData Or
            dlgType = DialogType.RequestMarketDepth Or
            dlgType = DialogType.RequestHistoricalData Or
            dlgType = DialogType.RequestHistoricalTicks Or
            dlgType = DialogType.RequestRealtimeBars)

        If Not (dlgType = DialogType.PlaceOrder Or
            dlgType = DialogType.RequestMarketData Or
            dlgType = DialogType.RequestMarketDepth Or
            dlgType = DialogType.RequestHistoricalData Or
            dlgType = DialogType.RequestRealtimeBars) Then
            cmdOptions.Text = "Options"
        End If

        txtReqId.Enabled = True
        txtBarSizeSetting.Enabled = (dlgType = DialogType.RequestHistoricalData Or
                            dlgType = DialogType.RequestRealtimeBars)
        txtDuration.Enabled = (dlgType = DialogType.RequestHistoricalData)
        txtEndDateTime.Enabled = (dlgType = DialogType.RequestHistoricalTicks Or dlgType = DialogType.RequestHistoricalData)
        txtWhatToShow.Enabled = (dlgType = DialogType.RequestHistoricalData Or
                                 dlgType = DialogType.RequestRealtimeBars Or
                                 dlgType = DialogType.RequestHistoricalTicks Or
                                 dlgType = DialogType.RequestFundamentalData)
        txtUseRTH.Enabled = (dlgType = DialogType.RequestHistoricalData Or
                             dlgType = DialogType.RequestHistoricalTicks Or
                             dlgType = DialogType.RequestRealtimeBars)
        txtFormatDate.Enabled = (dlgType = DialogType.RequestHistoricalData)
        txtGenericTickTags.Enabled = (dlgType = DialogType.RequestMarketData)
        chkSnapshotMktData.Enabled = (dlgType = DialogType.RequestMarketData)
        txtNumRows.Enabled = (dlgType = DialogType.RequestMarketDepth)
        txtExerciseAction.Enabled = (dlgType = DialogType.ExerciseOptions)
        txtExerciseQuantity.Enabled = (dlgType = DialogType.ExerciseOptions)
        txtExerciseOverride.Enabled = (dlgType = DialogType.ExerciseOptions)
        txtIncludeExpired.Enabled = (dlgType = DialogType.RequestHistoricalData Or
                                     dlgType = DialogType.RequestContractDetails)

        cmbMarketDataType.Enabled = (dlgType = DialogType.RequestMarketDataType)

        comboBoxTickByTickType.Enabled = (dlgType = DialogType.RequestTickByTick)

        ' enable or disable contract fields
        If dlgType = DialogType.CancelMarketData Or
           dlgType = DialogType.CancelMarketDepth Or
           dlgType = DialogType.CancelOrder Or
           dlgType = DialogType.CancelHistoricalData Or
           dlgType = DialogType.CancelRealtimeBars Or
           dlgType = DialogType.CancelCalculateImpliedVolatility Or
           dlgType = DialogType.CancelCalculateOptionPrice Or
           dlgType = DialogType.RequestMarketDataType Or
           dlgType = DialogType.RequestMatchingSymbols Or
           dlgType = DialogType.CancelTickByTick Then
            txtConId.Enabled = False
            txtSymbol.Enabled = False
            txtSecType.Enabled = False
            txtLastTradeDateOrContractMonth.Enabled = False
            txtStrike.Enabled = False
            txtRight.Enabled = False
            TextMultiplier.Enabled = False
            txtExchange.Enabled = False
            TxtPrimaryExchange.Enabled = False
            txtCurrency.Enabled = False
            txtLocalSymbol.Enabled = False
            txtTradingClass.Enabled = False
        Else
            txtConId.Enabled = True
            txtSymbol.Enabled = True
            txtSecType.Enabled = True
            txtLastTradeDateOrContractMonth.Enabled = True
            txtStrike.Enabled = True
            txtRight.Enabled = True
            TextMultiplier.Enabled = True
            txtExchange.Enabled = True
            txtCurrency.Enabled = True
            txtLocalSymbol.Enabled = True
            txtTradingClass.Enabled = True
            TxtPrimaryExchange.Enabled = True
        End If

        ' enable or disable order fields
        If dlgType = DialogType.PlaceOrder Then
            txtAction.Enabled = True
            txtQuantity.Enabled = True
            txtOrderType.Enabled = True
            txtLmtPrice.Enabled = True
            txtAuxPrice.Enabled = True
            tGAT.Enabled = True
            tGTD.Enabled = True
            txtCashQty.Enabled = True
        Else
            txtAction.Enabled = False
            txtQuantity.Enabled = False
            txtOrderType.Enabled = False
            txtLmtPrice.Enabled = False
            txtAuxPrice.Enabled = False
            tGAT.Enabled = False
            tGTD.Enabled = False
            txtCashQty.Enabled = False
        End If

        If dlgType = DialogType.CalculateImpliedVolatility Or dlgType = DialogType.CalculateOptionPrice Then
            txtLmtPrice.Enabled = True
            txtAuxPrice.Enabled = True
        End If

        If dlgType = DialogType.RequestContractDetails Then
            txtIssuerId.Enabled = True
        Else
            txtIssuerId.Enabled = False
        End If

        If dlgType = DialogType.PlaceOrder Or dlgType = DialogType.RequestContractDetails Then
            txtSecIdType.Enabled = True
            txtSecId.Enabled = True
        Else
            txtSecIdType.Enabled = False
            txtSecId.Enabled = False
        End If

        If dlgType = DialogType.RequestMatchingSymbols Then
            txtSymbol.Enabled = True
            txtConId.Enabled = False
            cmdConditions.Enabled = False
            cmdAdjustStop.Enabled = False
            cmdPegBench.Enabled = False
        End If

        If dlgType = DialogType.RequestMarketDataType Then
            cmbMarketDataType.Enabled = True
            txtReqId.Enabled = False
            txtConId.Enabled = False
            cmdAlgoParams.Enabled = False
            cmdSmartComboRoutingParams.Enabled = False
        End If

        If dlgType = DialogType.PlaceOrder Then
            m_optionsDlgTitle = "Order Misc Options"
            cmdOptions.Text = "Ord Misc Options"
        End If

        If dlgType = DialogType.RequestHistoricalData Then
            m_optionsDlgTitle = "Chart Options"
            cmdOptions.Text = "Chart Options"
        End If

        If dlgType = DialogType.RequestMarketData Then
            m_optionsDlgTitle = "Market Data Options"
            cmdOptions.Text = "Mkt Data Options"
        End If

        If dlgType = DialogType.RequestMarketDepth Then
            m_optionsDlgTitle = "Market Depth Options"
            cmdOptions.Text = "Mkt Depth Opts"
        End If

        If dlgType = DialogType.RequestRealtimeBars Then
            m_optionsDlgTitle = "Real Time Bars Options"
            cmdOptions.Text = "RTB Options"
        End If

    End Sub
    '--------------------------------------------------------------------------------
    ' Set the various dialog title string for each dialog type and the initial
    ' dialog data.
    '--------------------------------------------------------------------------------
    Private Sub Form_Initialize_Renamed()

        m_orderId = 0

        txtEndDateTime.Text = Format(Now().ToUniversalTime, "yyyyMMdd-HH:mm:ss")

        m_arrDlgTitles.Add("Request Market Data")
        m_arrDlgTitles.Add("Cancel Market Data")
        m_arrDlgTitles.Add("Request Market Depth")
        m_arrDlgTitles.Add("Cancel Market Depth")
        m_arrDlgTitles.Add("Place Order")
        m_arrDlgTitles.Add("Cancel Order")
        m_arrDlgTitles.Add("Request Contract Details")
        m_arrDlgTitles.Add("Request Historical Data")
        m_arrDlgTitles.Add("Exercise Options")
        m_arrDlgTitles.Add("Cancel Historical Data")
        m_arrDlgTitles.Add("Request Real Time Bars")
        m_arrDlgTitles.Add("Cancel Real Time Bars")
        m_arrDlgTitles.Add("Calculate Implied Volatility")
        m_arrDlgTitles.Add("Calculate Option Price")
        m_arrDlgTitles.Add("Cancel Calculate Implied Volatility")
        m_arrDlgTitles.Add("Cancel Calculate Option Price")
        m_arrDlgTitles.Add("Request Market Data Type")
        m_arrDlgTitles.Add("Request Fundamental Data")
        m_arrDlgTitles.Add("Cancel Fundamental Data")
        m_arrDlgTitles.Add("Request Matching Symbols")
        m_arrDlgTitles.Add("Request Historical Ticks")
        m_arrDlgTitles.Add("Request Tick-By-Tick")
        m_arrDlgTitles.Add("Cancel Tick-By-Tick")

        cmbMarketDataType.Items.Clear()
        Dim index = cmbMarketDataType.Items.Add("Real-Time")
        cmbMarketDataType.Items.Add("Frozen")
        cmbMarketDataType.Items.Add("Delayed")
        cmbMarketDataType.Items.Add("Delayed-Frozen")
        cmbMarketDataType.SelectedIndex = index

    End Sub

    Private Sub cmdSmartComboRoutingParams_Click(sender As System.Object, e As System.EventArgs) Handles cmdSmartComboRoutingParams.Click
        Dim dlg As New dlgSmartComboRoutingParams

        dlg.init(m_orderInfo.SmartComboRoutingParams, "Smart Combo Routing Params")
        Dim res = dlg.ShowDialog()
        If res = DialogResult.OK Then
            m_orderInfo.SmartComboRoutingParams = dlg.smartComboRoutingParams
        End If

    End Sub

    Private Sub cmdOptions_Click(sender As System.Object, e As System.EventArgs) Handles cmdOptions.Click
        Dim dlg As New dlgSmartComboRoutingParams

        dlg.init(m_options, m_optionsDlgTitle)
        Dim res = dlg.ShowDialog()
        If res = DialogResult.OK Then
            m_options = dlg.smartComboRoutingParams
        End If

    End Sub


    Private Function dval(text As String) As Double
        If Len(text) = 0 Then
            dval = Double.MaxValue
        Else
            dval = CDbl(text)
        End If
    End Function

    Private Sub Button3_Click(sender As Object, e As EventArgs) Handles cmdPegBench.Click
        Dim dlg = New dlgPegBench(m_orderInfo)
        dlg.ShowDialog()
    End Sub

    Private Sub cmdConditions_Click(sender As Object, e As EventArgs) Handles cmdConditions.Click
        Dim dlg = New dlgConditions(m_orderInfo)
        dlg.ShowDialog()
    End Sub

    Private Sub cmdAdjustStop_Click(sender As Object, e As EventArgs) Handles cmdAdjustStop.Click
        Dim dlg = New dlgAdjustStop(m_orderInfo)
        dlg.ShowDialog()
    End Sub
End Class
