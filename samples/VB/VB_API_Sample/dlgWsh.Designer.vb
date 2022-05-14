' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()>
Partial Class dlgWsh
    Inherits System.Windows.Forms.Form

    'Form overrides dispose to clean up the component list.
    <System.Diagnostics.DebuggerNonUserCode()>
    Protected Overrides Sub Dispose(ByVal disposing As Boolean)
        Try
            If disposing AndAlso components IsNot Nothing Then
                components.Dispose()
            End If
        Finally
            MyBase.Dispose(disposing)
        End Try
    End Sub

    'Required by the Windows Form Designer
    Private components As System.ComponentModel.IContainer

    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.  
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()>
    Private Sub InitializeComponent()
        Me.cmdOK = New System.Windows.Forms.Button()
        Me.cmdCancel = New System.Windows.Forms.Button()
        Me.LabelWshReqId = New System.Windows.Forms.Label()
        Me.txtWshReqId = New System.Windows.Forms.TextBox()
        Me.txtWshConId = New System.Windows.Forms.TextBox()
        Me.LabelWshConId = New System.Windows.Forms.Label()
        Me.LabelWshFilter = New System.Windows.Forms.Label()
        Me.txtWshFilter = New System.Windows.Forms.TextBox()
        Me.cbWshFillWatchlist = New System.Windows.Forms.CheckBox()
        Me.cbWshFillPortfolio = New System.Windows.Forms.CheckBox()
        Me.cbWshFillCompetitors = New System.Windows.Forms.CheckBox()
        Me.txtWshStartDate = New System.Windows.Forms.TextBox()
        Me.LavelWshStartDate = New System.Windows.Forms.Label()
        Me.txtWshEndDate = New System.Windows.Forms.TextBox()
        Me.LabelWshEndDate = New System.Windows.Forms.Label()
        Me.txtWshTotalLimit = New System.Windows.Forms.TextBox()
        Me.LabelWshTotalLimit = New System.Windows.Forms.Label()
        Me.SuspendLayout()
        '
        'cmdOK
        '
        Me.cmdOK.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdOK.Location = New System.Drawing.Point(31, 287)
        Me.cmdOK.Name = "cmdOK"
        Me.cmdOK.Size = New System.Drawing.Size(75, 23)
        Me.cmdOK.TabIndex = 0
        Me.cmdOK.Text = "OK"
        Me.cmdOK.UseVisualStyleBackColor = True
        '
        'cmdCancel
        '
        Me.cmdCancel.Anchor = CType((System.Windows.Forms.AnchorStyles.Bottom Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.cmdCancel.Location = New System.Drawing.Point(112, 287)
        Me.cmdCancel.Name = "cmdCancel"
        Me.cmdCancel.Size = New System.Drawing.Size(75, 23)
        Me.cmdCancel.TabIndex = 1
        Me.cmdCancel.Text = "Cancel"
        Me.cmdCancel.UseVisualStyleBackColor = True
        '
        'LabelWshReqId
        '
        Me.LabelWshReqId.AutoSize = True
        Me.LabelWshReqId.Location = New System.Drawing.Point(13, 13)
        Me.LabelWshReqId.Name = "LabelWshReqId"
        Me.LabelWshReqId.Size = New System.Drawing.Size(39, 13)
        Me.LabelWshReqId.TabIndex = 2
        Me.LabelWshReqId.Text = "Req Id"
        '
        'txtWshReqId
        '
        Me.txtWshReqId.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshReqId.Location = New System.Drawing.Point(87, 6)
        Me.txtWshReqId.Name = "txtWshReqId"
        Me.txtWshReqId.Size = New System.Drawing.Size(100, 20)
        Me.txtWshReqId.TabIndex = 4
        '
        'txtWshConId
        '
        Me.txtWshConId.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshConId.Location = New System.Drawing.Point(87, 32)
        Me.txtWshConId.Name = "txtWshConId"
        Me.txtWshConId.Size = New System.Drawing.Size(100, 20)
        Me.txtWshConId.TabIndex = 6
        '
        'LabelWshConId
        '
        Me.LabelWshConId.AutoSize = True
        Me.LabelWshConId.Location = New System.Drawing.Point(13, 39)
        Me.LabelWshConId.Name = "LabelWshConId"
        Me.LabelWshConId.Size = New System.Drawing.Size(38, 13)
        Me.LabelWshConId.TabIndex = 5
        Me.LabelWshConId.Text = "Con Id"
        '
        'LabelWshFilter
        '
        Me.LabelWshFilter.AutoSize = True
        Me.LabelWshFilter.Location = New System.Drawing.Point(12, 65)
        Me.LabelWshFilter.Name = "LabelWshFilter"
        Me.LabelWshFilter.Size = New System.Drawing.Size(29, 13)
        Me.LabelWshFilter.TabIndex = 7
        Me.LabelWshFilter.Text = "Filter"
        '
        'txtWshFilter
        '
        Me.txtWshFilter.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshFilter.Location = New System.Drawing.Point(87, 58)
        Me.txtWshFilter.Name = "txtWshFilter"
        Me.txtWshFilter.Size = New System.Drawing.Size(100, 20)
        Me.txtWshFilter.TabIndex = 8
        '
        'cbWshFillWatchlist
        '
        Me.cbWshFillWatchlist.AutoSize = True
        Me.cbWshFillWatchlist.Location = New System.Drawing.Point(88, 84)
        Me.cbWshFillWatchlist.Name = "cbWshFillWatchlist"
        Me.cbWshFillWatchlist.Size = New System.Drawing.Size(85, 17)
        Me.cbWshFillWatchlist.TabIndex = 9
        Me.cbWshFillWatchlist.Text = "Fill Watchlist"
        Me.cbWshFillWatchlist.UseVisualStyleBackColor = True
        '
        'cbWshFillPortfolio
        '
        Me.cbWshFillPortfolio.AutoSize = True
        Me.cbWshFillPortfolio.Location = New System.Drawing.Point(87, 107)
        Me.cbWshFillPortfolio.Name = "cbWshFillPortfolio"
        Me.cbWshFillPortfolio.Size = New System.Drawing.Size(79, 17)
        Me.cbWshFillPortfolio.TabIndex = 10
        Me.cbWshFillPortfolio.Text = "Fill Portfolio"
        Me.cbWshFillPortfolio.UseVisualStyleBackColor = True
        '
        'cbWshFillCompetitors
        '
        Me.cbWshFillCompetitors.AutoSize = True
        Me.cbWshFillCompetitors.Location = New System.Drawing.Point(88, 130)
        Me.cbWshFillCompetitors.Name = "cbWshFillCompetitors"
        Me.cbWshFillCompetitors.Size = New System.Drawing.Size(96, 17)
        Me.cbWshFillCompetitors.TabIndex = 11
        Me.cbWshFillCompetitors.Text = "Fill Competitors"
        Me.cbWshFillCompetitors.UseVisualStyleBackColor = True
        '
        'txtWshStartDate
        '
        Me.txtWshStartDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshStartDate.Location = New System.Drawing.Point(87, 151)
        Me.txtWshStartDate.Name = "txtWshStartDate"
        Me.txtWshStartDate.Size = New System.Drawing.Size(100, 20)
        Me.txtWshStartDate.TabIndex = 13
        '
        'LavelWshStartDate
        '
        Me.LavelWshStartDate.AutoSize = True
        Me.LavelWshStartDate.Location = New System.Drawing.Point(13, 158)
        Me.LavelWshStartDate.Name = "LavelWshStartDate"
        Me.LavelWshStartDate.Size = New System.Drawing.Size(55, 13)
        Me.LavelWshStartDate.TabIndex = 12
        Me.LavelWshStartDate.Text = "Start Date"
        '
        'txtWshEndDate
        '
        Me.txtWshEndDate.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshEndDate.Location = New System.Drawing.Point(87, 177)
        Me.txtWshEndDate.Name = "txtWshEndDate"
        Me.txtWshEndDate.Size = New System.Drawing.Size(100, 20)
        Me.txtWshEndDate.TabIndex = 15
        '
        'LabelWshEndDate
        '
        Me.LabelWshEndDate.AutoSize = True
        Me.LabelWshEndDate.Location = New System.Drawing.Point(12, 184)
        Me.LabelWshEndDate.Name = "LabelWshEndDate"
        Me.LabelWshEndDate.Size = New System.Drawing.Size(52, 13)
        Me.LabelWshEndDate.TabIndex = 14
        Me.LabelWshEndDate.Text = "End Date"
        '
        'txtWshTotalLimit
        '
        Me.txtWshTotalLimit.Anchor = CType((System.Windows.Forms.AnchorStyles.Top Or System.Windows.Forms.AnchorStyles.Right), System.Windows.Forms.AnchorStyles)
        Me.txtWshTotalLimit.Location = New System.Drawing.Point(88, 203)
        Me.txtWshTotalLimit.Name = "txtWshTotalLimit"
        Me.txtWshTotalLimit.Size = New System.Drawing.Size(100, 20)
        Me.txtWshTotalLimit.TabIndex = 0
        '
        'LabelWshTotalLimit
        '
        Me.LabelWshTotalLimit.AutoSize = True
        Me.LabelWshTotalLimit.Location = New System.Drawing.Point(12, 210)
        Me.LabelWshTotalLimit.Name = "LabelWshTotalLimit"
        Me.LabelWshTotalLimit.Size = New System.Drawing.Size(55, 13)
        Me.LabelWshTotalLimit.TabIndex = 16
        Me.LabelWshTotalLimit.Text = "Total Limit"
        '
        'dlgWsh
        '
        Me.AutoScaleDimensions = New System.Drawing.SizeF(6.0!, 13.0!)
        Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
        Me.BackColor = System.Drawing.Color.Gainsboro
        Me.ClientSize = New System.Drawing.Size(199, 322)
        Me.Controls.Add(Me.txtWshTotalLimit)
        Me.Controls.Add(Me.LabelWshTotalLimit)
        Me.Controls.Add(Me.txtWshEndDate)
        Me.Controls.Add(Me.LabelWshEndDate)
        Me.Controls.Add(Me.txtWshStartDate)
        Me.Controls.Add(Me.LavelWshStartDate)
        Me.Controls.Add(Me.cbWshFillCompetitors)
        Me.Controls.Add(Me.cbWshFillPortfolio)
        Me.Controls.Add(Me.cbWshFillWatchlist)
        Me.Controls.Add(Me.txtWshFilter)
        Me.Controls.Add(Me.LabelWshFilter)
        Me.Controls.Add(Me.txtWshConId)
        Me.Controls.Add(Me.LabelWshConId)
        Me.Controls.Add(Me.txtWshReqId)
        Me.Controls.Add(Me.LabelWshReqId)
        Me.Controls.Add(Me.cmdCancel)
        Me.Controls.Add(Me.cmdOK)
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Name = "dlgWsh"
        Me.Text = "Req WSH"
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
    Friend WithEvents cmdOK As System.Windows.Forms.Button
    Friend WithEvents cmdCancel As System.Windows.Forms.Button
    Friend WithEvents LabelWshReqId As System.Windows.Forms.Label
    Friend WithEvents txtWshReqId As System.Windows.Forms.TextBox
    Friend WithEvents txtWshConId As System.Windows.Forms.TextBox
    Friend WithEvents LabelWshConId As System.Windows.Forms.Label
    Friend WithEvents LabelWshFilter As Label
    Friend WithEvents txtWshFilter As TextBox
    Friend WithEvents cbWshFillWatchlist As CheckBox
    Friend WithEvents cbWshFillPortfolio As CheckBox
    Friend WithEvents cbWshFillCompetitors As CheckBox
    Friend WithEvents txtWshStartDate As TextBox
    Friend WithEvents LavelWshStartDate As Label
    Friend WithEvents txtWshEndDate As TextBox
    Friend WithEvents LabelWshEndDate As Label
    Friend WithEvents txtWshTotalLimit As TextBox
    Friend WithEvents LabelWshTotalLimit As Label
End Class
