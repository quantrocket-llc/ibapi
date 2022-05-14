' Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
' and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable.

Public Class dlgWsh

    Public Property ReqId As Integer
    Public Property ConId As Integer
    Public Property Filter As String
    Public Property FillWatchlist As Boolean
    Public Property FillPortfolio As Boolean
    Public Property FillCompetitors As Boolean
    Public Property StartDate As String
    Public Property EndDate As String
    Public Property TotalLimit As Integer


    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles cmdOK.Click
        ReqId = If(String.IsNullOrWhiteSpace(txtWshReqId.Text), 0, Integer.Parse(txtWshReqId.Text))
        ConId = If(String.IsNullOrWhiteSpace(txtWshConId.Text), Integer.MaxValue, Integer.Parse(txtWshConId.Text))
        Filter = txtWshFilter.Text
        FillWatchlist = cbWshFillWatchlist.Checked
        FillPortfolio = cbWshFillPortfolio.Checked
        FillCompetitors = cbWshFillCompetitors.Checked
        StartDate = txtWshStartDate.Text
        EndDate = txtWshEndDate.Text
        TotalLimit = If(String.IsNullOrWhiteSpace(txtWshTotalLimit.Text), Integer.MaxValue, Integer.Parse(txtWshTotalLimit.Text))

        DialogResult = Windows.Forms.DialogResult.OK

        Close()
    End Sub

    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles cmdCancel.Click
        DialogResult = Windows.Forms.DialogResult.Cancel

        Close()
    End Sub
End Class