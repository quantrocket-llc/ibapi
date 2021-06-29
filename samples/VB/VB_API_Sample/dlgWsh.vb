' Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Public Class dlgWsh

    Public Property ReqId As Integer
    Public Property ConId As Integer

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles cmdOK.Click
        ReqId = If(String.IsNullOrWhiteSpace(txtReqId.Text), 0, Integer.Parse(txtReqId.Text))
        ConId() = If(String.IsNullOrWhiteSpace(txtConId.Text), 0, Integer.Parse(txtConId.Text))

        DialogResult = Windows.Forms.DialogResult.OK

        Close()
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles cmdCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel

        Close()
    End Sub
End Class