/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using IBSampleApp.messages;
using IBApi;

namespace IBSampleApp.ui
{
    partial class MarginDialog : Form
    {
        delegate void UpdateMarginInformationDelegate(OrderState state);

        public MarginDialog()
        {
            InitializeComponent();
        }

        public void FillAndDisplay(OrderState state)
        {
            this.equityWithLoanBefore.Text = Util.formatDoubleString(state.EquityWithLoanBefore);
            this.initialMarginBefore.Text = Util.formatDoubleString(state.InitMarginBefore);
            this.maintenanceMarginBefore.Text = Util.formatDoubleString(state.MaintMarginBefore);
            this.equityWithLoanChange.Text = Util.formatDoubleString(state.EquityWithLoanChange);
            this.initialMarginChange.Text = Util.formatDoubleString(state.InitMarginChange);
            this.maintenanceMarginChange.Text = Util.formatDoubleString(state.MaintMarginChange);
            this.equityWithLoanAfter.Text = Util.formatDoubleString(state.EquityWithLoanAfter);
            this.initialMarginAfter.Text = Util.formatDoubleString(state.InitMarginAfter);
            this.maintenanceMarginAfter.Text = Util.formatDoubleString(state.MaintMarginAfter);
        }

        public void UpdateMarginInformation(OrderState state)
        {
            FillAndDisplay(state);
            this.ShowDialog();  
        }

        private void acceptMarginButton_Click(object sender, EventArgs e)
        {
            this.equityWithLoanBefore.Text = "";
            this.initialMarginBefore.Text = "";
            this.maintenanceMarginBefore.Text = "";
            this.equityWithLoanChange.Text = "";
            this.initialMarginChange.Text = "";
            this.maintenanceMarginChange.Text = "";
            this.equityWithLoanAfter.Text = "";
            this.initialMarginAfter.Text = "";
            this.maintenanceMarginAfter.Text = "";
            this.Visible = false;
        }

    }
}
