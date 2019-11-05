' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Imports System.Windows.Forms

Public Class dlgDeltaNeutralContract

    ' ========================================================
    ' Member variables
    ' ========================================================
    Private m_deltaNeutralContract As IBApi.DeltaNeutralContract

    ' ===============================================================================
    ' Public Methods
    ' ===============================================================================
    Public Sub init(deltaNeutralContract As IBApi.DeltaNeutralContract)

        m_deltaNeutralContract = deltaNeutralContract

        With deltaNeutralContract
            txtConId.text = .conId
            txtDelta.text = .delta
            txtPrice.text = .price
        End With

    End Sub
    
    ' ========================================================
    ' Button Events
    ' ========================================================
    Private Sub cmdOK_Click(sender As System.Object, e As System.EventArgs) Handles cmdOk.Click

        With m_deltaNeutralContract
            .conId = txtConId.Text
            .delta = txtDelta.Text
            .price = txtPrice.Text
        End With

        m_deltaNeutralContract = Nothing

        Me.DialogResult = System.Windows.Forms.DialogResult.OK
        Me.Close()

    End Sub

    Private Sub cmdReset_Click(sender As System.Object, e As System.EventArgs) Handles cmdReset.Click

        With m_deltaNeutralContract
            .conId = 0
            .delta = 0
            .price = 0
        End With

        m_deltaNeutralContract = Nothing

        Me.DialogResult = System.Windows.Forms.DialogResult.Abort
        Me.Close()

    End Sub

    Private Sub cmdCancel_Click(sender As System.Object, e As System.EventArgs) Handles cmdCancel.Click

        m_deltaNeutralContract = Nothing

        Me.DialogResult = System.Windows.Forms.DialogResult.Cancel
        Me.Close()

    End Sub

End Class
