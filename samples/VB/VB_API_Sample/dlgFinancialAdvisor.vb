' Copyright (C) 2023 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.


Option Explicit On 
Friend Class dlgFinancialAdvisor
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
    Public WithEvents lstAliases As System.Windows.Forms.TextBox
    Public WithEvents lstGroups As System.Windows.Forms.TextBox
    Public WithEvents Frame1 As System.Windows.Forms.GroupBox
    Public WithEvents cmdClose As System.Windows.Forms.Button
    Public WithEvents Frame3 As System.Windows.Forms.GroupBox
    'NOTE: The following procedure is required by the Windows Form Designer
    'It can be modified using the Windows Form Designer.
    'Do not modify it using the code editor.
    <System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
        Me.components = New System.ComponentModel.Container()
        Me.ToolTip1 = New System.Windows.Forms.ToolTip(Me.components)
        Me.lstAliases = New System.Windows.Forms.TextBox()
        Me.Frame1 = New System.Windows.Forms.GroupBox()
        Me.lstGroups = New System.Windows.Forms.TextBox()
        Me.cmdClose = New System.Windows.Forms.Button()
        Me.Frame3 = New System.Windows.Forms.GroupBox()
        Me.Frame1.SuspendLayout()
        Me.SuspendLayout()
        '
        'lstAliases
        '
        Me.lstAliases.AcceptsReturn = True
        Me.lstAliases.BackColor = System.Drawing.SystemColors.Window
        Me.lstAliases.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.lstAliases.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.lstAliases.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lstAliases.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lstAliases.Location = New System.Drawing.Point(16, 363)
        Me.lstAliases.MaxLength = 0
        Me.lstAliases.Multiline = True
        Me.lstAliases.Name = "lstAliases"
        Me.lstAliases.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lstAliases.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.lstAliases.Size = New System.Drawing.Size(633, 150)
        Me.lstAliases.TabIndex = 3
        Me.lstAliases.Text = "Start" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.lstAliases.WordWrap = False
        '
        'Frame1
        '
        Me.Frame1.BackColor = System.Drawing.Color.Gainsboro
        Me.Frame1.Controls.Add(Me.lstGroups)
        Me.Frame1.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame1.ForeColor = System.Drawing.SystemColors.Highlight
        Me.Frame1.Location = New System.Drawing.Point(8, 16)
        Me.Frame1.Name = "Frame1"
        Me.Frame1.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame1.Size = New System.Drawing.Size(649, 313)
        Me.Frame1.TabIndex = 1
        Me.Frame1.TabStop = False
        Me.Frame1.Text = "Groups:"
        '
        'lstGroups
        '
        Me.lstGroups.AcceptsReturn = True
        Me.lstGroups.BackColor = System.Drawing.SystemColors.Window
        Me.lstGroups.BorderStyle = System.Windows.Forms.BorderStyle.None
        Me.lstGroups.Cursor = System.Windows.Forms.Cursors.IBeam
        Me.lstGroups.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.lstGroups.ForeColor = System.Drawing.SystemColors.WindowText
        Me.lstGroups.Location = New System.Drawing.Point(8, 24)
        Me.lstGroups.MaxLength = 0
        Me.lstGroups.Multiline = True
        Me.lstGroups.Name = "lstGroups"
        Me.lstGroups.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.lstGroups.ScrollBars = System.Windows.Forms.ScrollBars.Both
        Me.lstGroups.Size = New System.Drawing.Size(633, 276)
        Me.lstGroups.TabIndex = 2
        Me.lstGroups.Text = "Start" & Global.Microsoft.VisualBasic.ChrW(13) & Global.Microsoft.VisualBasic.ChrW(10)
        Me.lstGroups.WordWrap = False
        '
        'cmdClose
        '
        Me.cmdClose.BackColor = System.Drawing.SystemColors.Control
        Me.cmdClose.Cursor = System.Windows.Forms.Cursors.Default
        Me.cmdClose.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.cmdClose.ForeColor = System.Drawing.SystemColors.ControlText
        Me.cmdClose.Location = New System.Drawing.Point(293, 560)
        Me.cmdClose.Name = "cmdClose"
        Me.cmdClose.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.cmdClose.Size = New System.Drawing.Size(81, 25)
        Me.cmdClose.TabIndex = 0
        Me.cmdClose.Text = "Accept Edits"
        Me.cmdClose.UseVisualStyleBackColor = True
        '
        'Frame3
        '
        Me.Frame3.BackColor = System.Drawing.Color.Gainsboro
        Me.Frame3.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.Frame3.ForeColor = System.Drawing.SystemColors.Highlight
        Me.Frame3.Location = New System.Drawing.Point(8, 335)
        Me.Frame3.Name = "Frame3"
        Me.Frame3.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.Frame3.Size = New System.Drawing.Size(649, 194)
        Me.Frame3.TabIndex = 6
        Me.Frame3.TabStop = False
        Me.Frame3.Text = "Aliases"
        '
        'dlgFinancialAdvisor
        '
        Me.AutoScaleBaseSize = New System.Drawing.Size(5, 13)
        Me.BackColor = System.Drawing.Color.Gainsboro
        Me.ClientSize = New System.Drawing.Size(667, 595)
        Me.Controls.Add(Me.lstAliases)
        Me.Controls.Add(Me.Frame1)
        Me.Controls.Add(Me.cmdClose)
        Me.Controls.Add(Me.Frame3)
        Me.Cursor = System.Windows.Forms.Cursors.Default
        Me.Font = New System.Drawing.Font("Arial", 8.0!, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, CType(0, Byte))
        Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog
        Me.Location = New System.Drawing.Point(315, 341)
        Me.MaximizeBox = False
        Me.MinimizeBox = False
        Me.Name = "dlgFinancialAdvisor"
        Me.RightToLeft = System.Windows.Forms.RightToLeft.No
        Me.ShowInTaskbar = False
        Me.Text = "Financial Advisor"
        Me.Frame1.ResumeLayout(False)
        Me.Frame1.PerformLayout()
        Me.ResumeLayout(False)
        Me.PerformLayout()

    End Sub
#End Region
#Region "Upgrade Support "
    Private Shared m_vb6FormDefInstance As dlgFinancialAdvisor
    Private Shared m_InitializingDefInstance As Boolean
    Public Shared Property DefInstance() As dlgFinancialAdvisor
        Get
            If m_vb6FormDefInstance Is Nothing OrElse m_vb6FormDefInstance.IsDisposed Then
                m_InitializingDefInstance = True
                m_vb6FormDefInstance = New dlgFinancialAdvisor
                m_InitializingDefInstance = False
            End If
            DefInstance = m_vb6FormDefInstance
        End Get
        Set(Value As dlgFinancialAdvisor)
            m_vb6FormDefInstance = Value
        End Set
    End Property
#End Region

    Private m_utils As Utils
    Private m_ok As Boolean
    Public aliasesXML, groupsXML, CRSTR As Object
    Public CRLFSTR As String
    ' ========================================================
    ' Button Events
    ' ========================================================
    Private Sub cmdClose_Click(sender As Object, e As EventArgs) Handles cmdClose.Click
        ' clear any existing list details
        m_ok = True
        Hide()
    End Sub

    ' ========================================================
    ' Public methods
    ' ========================================================

    Public Sub init(utilities As Utils, faGroupXML As String, faAliasesXML As String)
        m_utils = utilities
        CRSTR = Chr(10)
        CRLFSTR = Chr(13) & Chr(10)
        lstGroups.Text = Replace(faGroupXML, CRSTR, CRLFSTR)
        lstAliases.Text = Replace(faAliasesXML, CRSTR, CRLFSTR)
        m_ok = False
    End Sub
    Public Function ok() As Object
        groupsXML = Replace(lstGroups.Text, CRLFSTR, CRSTR)
        aliasesXML = Replace(lstAliases.Text, CRLFSTR, CRSTR)
        ok = m_ok
    End Function
End Class
