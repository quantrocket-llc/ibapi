/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
namespace IBSampleApp.ui
{
    partial class MarginDialog
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
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(MarginDialog));
            this.equityWithLoanLabel = new System.Windows.Forms.Label();
            this.initialMarginLabel = new System.Windows.Forms.Label();
            this.maintenanceMarginLabel = new System.Windows.Forms.Label();
            this.equityWithLoanBefore = new System.Windows.Forms.Label();
            this.initialMarginBefore = new System.Windows.Forms.Label();
            this.maintenanceMarginBefore = new System.Windows.Forms.Label();
            this.acceptMarginButton = new System.Windows.Forms.Button();
            this.currentLabel = new System.Windows.Forms.Label();
            this.changeLabel = new System.Windows.Forms.Label();
            this.equityWithLoanChange = new System.Windows.Forms.Label();
            this.initialMarginChange = new System.Windows.Forms.Label();
            this.maintenanceMarginChange = new System.Windows.Forms.Label();
            this.postTradeLabel = new System.Windows.Forms.Label();
            this.equityWithLoanAfter = new System.Windows.Forms.Label();
            this.initialMarginAfter = new System.Windows.Forms.Label();
            this.maintenanceMarginAfter = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // equityWithLoanLabel
            // 
            this.equityWithLoanLabel.AutoSize = true;
            this.equityWithLoanLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.equityWithLoanLabel.Location = new System.Drawing.Point(34, 40);
            this.equityWithLoanLabel.Name = "equityWithLoanLabel";
            this.equityWithLoanLabel.Size = new System.Drawing.Size(101, 13);
            this.equityWithLoanLabel.TabIndex = 0;
            this.equityWithLoanLabel.Text = "Equity with loan:";
            // 
            // initialMarginLabel
            // 
            this.initialMarginLabel.AutoSize = true;
            this.initialMarginLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.initialMarginLabel.Location = new System.Drawing.Point(52, 68);
            this.initialMarginLabel.Name = "initialMarginLabel";
            this.initialMarginLabel.Size = new System.Drawing.Size(83, 13);
            this.initialMarginLabel.TabIndex = 1;
            this.initialMarginLabel.Text = "Initial margin:";
            // 
            // maintenanceMarginLabel
            // 
            this.maintenanceMarginLabel.AutoSize = true;
            this.maintenanceMarginLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.maintenanceMarginLabel.Location = new System.Drawing.Point(10, 94);
            this.maintenanceMarginLabel.Name = "maintenanceMarginLabel";
            this.maintenanceMarginLabel.Size = new System.Drawing.Size(125, 13);
            this.maintenanceMarginLabel.TabIndex = 2;
            this.maintenanceMarginLabel.Text = "Maintenance margin:";
            // 
            // equityWithLoanBefore
            // 
            this.equityWithLoanBefore.Cursor = System.Windows.Forms.Cursors.Default;
            this.equityWithLoanBefore.Location = new System.Drawing.Point(141, 40);
            this.equityWithLoanBefore.Name = "equityWithLoanBefore";
            this.equityWithLoanBefore.Size = new System.Drawing.Size(119, 13);
            this.equityWithLoanBefore.TabIndex = 3;
            this.equityWithLoanBefore.Text = "0.00";
            this.equityWithLoanBefore.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // initialMarginBefore
            // 
            this.initialMarginBefore.Location = new System.Drawing.Point(141, 68);
            this.initialMarginBefore.Name = "initialMarginBefore";
            this.initialMarginBefore.Size = new System.Drawing.Size(119, 13);
            this.initialMarginBefore.TabIndex = 4;
            this.initialMarginBefore.Text = "0.00";
            this.initialMarginBefore.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // maintenanceMarginBefore
            // 
            this.maintenanceMarginBefore.Location = new System.Drawing.Point(141, 94);
            this.maintenanceMarginBefore.Name = "maintenanceMarginBefore";
            this.maintenanceMarginBefore.Size = new System.Drawing.Size(119, 13);
            this.maintenanceMarginBefore.TabIndex = 5;
            this.maintenanceMarginBefore.Text = "0.00";
            this.maintenanceMarginBefore.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // acceptMarginButton
            // 
            this.acceptMarginButton.Location = new System.Drawing.Point(223, 129);
            this.acceptMarginButton.Name = "acceptMarginButton";
            this.acceptMarginButton.Size = new System.Drawing.Size(49, 23);
            this.acceptMarginButton.TabIndex = 6;
            this.acceptMarginButton.Text = "OK";
            this.acceptMarginButton.UseVisualStyleBackColor = true;
            this.acceptMarginButton.Click += new System.EventHandler(this.acceptMarginButton_Click);
            // 
            // currentLabel
            // 
            this.currentLabel.AutoSize = true;
            this.currentLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.currentLabel.Location = new System.Drawing.Point(212, 9);
            this.currentLabel.Name = "currentLabel";
            this.currentLabel.Size = new System.Drawing.Size(48, 13);
            this.currentLabel.TabIndex = 7;
            this.currentLabel.Text = "Current";
            // 
            // changeLabel
            // 
            this.changeLabel.AutoSize = true;
            this.changeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.changeLabel.Location = new System.Drawing.Point(303, 9);
            this.changeLabel.Name = "changeLabel";
            this.changeLabel.Size = new System.Drawing.Size(50, 13);
            this.changeLabel.TabIndex = 8;
            this.changeLabel.Text = "Change";
            // 
            // equityWithLoanChange
            // 
            this.equityWithLoanChange.Location = new System.Drawing.Point(276, 40);
            this.equityWithLoanChange.Name = "equityWithLoanChange";
            this.equityWithLoanChange.Size = new System.Drawing.Size(77, 13);
            this.equityWithLoanChange.TabIndex = 9;
            this.equityWithLoanChange.Text = "0.00";
            this.equityWithLoanChange.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // initialMarginChange
            // 
            this.initialMarginChange.Location = new System.Drawing.Point(279, 68);
            this.initialMarginChange.Name = "initialMarginChange";
            this.initialMarginChange.Size = new System.Drawing.Size(74, 13);
            this.initialMarginChange.TabIndex = 10;
            this.initialMarginChange.Text = "0.00";
            this.initialMarginChange.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // maintenanceMarginChange
            // 
            this.maintenanceMarginChange.Location = new System.Drawing.Point(279, 94);
            this.maintenanceMarginChange.Name = "maintenanceMarginChange";
            this.maintenanceMarginChange.Size = new System.Drawing.Size(74, 13);
            this.maintenanceMarginChange.TabIndex = 11;
            this.maintenanceMarginChange.Text = "0.00";
            this.maintenanceMarginChange.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // postTradeLabel
            // 
            this.postTradeLabel.AutoSize = true;
            this.postTradeLabel.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.postTradeLabel.Location = new System.Drawing.Point(411, 9);
            this.postTradeLabel.Name = "postTradeLabel";
            this.postTradeLabel.Size = new System.Drawing.Size(69, 13);
            this.postTradeLabel.TabIndex = 12;
            this.postTradeLabel.Text = "Post-Trade";
            // 
            // equityWithLoanAfter
            // 
            this.equityWithLoanAfter.Location = new System.Drawing.Point(359, 40);
            this.equityWithLoanAfter.Name = "equityWithLoanAfter";
            this.equityWithLoanAfter.Size = new System.Drawing.Size(121, 13);
            this.equityWithLoanAfter.TabIndex = 13;
            this.equityWithLoanAfter.Text = "0.00";
            this.equityWithLoanAfter.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // initialMarginAfter
            // 
            this.initialMarginAfter.Location = new System.Drawing.Point(362, 68);
            this.initialMarginAfter.Name = "initialMarginAfter";
            this.initialMarginAfter.Size = new System.Drawing.Size(118, 13);
            this.initialMarginAfter.TabIndex = 14;
            this.initialMarginAfter.Text = "0.00";
            this.initialMarginAfter.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // maintenanceMarginAfter
            // 
            this.maintenanceMarginAfter.Location = new System.Drawing.Point(362, 94);
            this.maintenanceMarginAfter.Name = "maintenanceMarginAfter";
            this.maintenanceMarginAfter.Size = new System.Drawing.Size(118, 13);
            this.maintenanceMarginAfter.TabIndex = 15;
            this.maintenanceMarginAfter.Text = "0.00";
            this.maintenanceMarginAfter.TextAlign = System.Drawing.ContentAlignment.MiddleRight;
            // 
            // MarginDialog
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(492, 164);
            this.ControlBox = false;
            this.Controls.Add(this.maintenanceMarginAfter);
            this.Controls.Add(this.initialMarginAfter);
            this.Controls.Add(this.equityWithLoanAfter);
            this.Controls.Add(this.postTradeLabel);
            this.Controls.Add(this.maintenanceMarginChange);
            this.Controls.Add(this.initialMarginChange);
            this.Controls.Add(this.equityWithLoanChange);
            this.Controls.Add(this.changeLabel);
            this.Controls.Add(this.currentLabel);
            this.Controls.Add(this.acceptMarginButton);
            this.Controls.Add(this.maintenanceMarginBefore);
            this.Controls.Add(this.initialMarginBefore);
            this.Controls.Add(this.equityWithLoanBefore);
            this.Controls.Add(this.maintenanceMarginLabel);
            this.Controls.Add(this.initialMarginLabel);
            this.Controls.Add(this.equityWithLoanLabel);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Name = "MarginDialog";
            this.Text = "Margin Requirements";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label equityWithLoanLabel;
        private System.Windows.Forms.Label initialMarginLabel;
        private System.Windows.Forms.Label maintenanceMarginLabel;
        private System.Windows.Forms.Label equityWithLoanBefore;
        private System.Windows.Forms.Label initialMarginBefore;
        private System.Windows.Forms.Label maintenanceMarginBefore;
        private System.Windows.Forms.Button acceptMarginButton;
        private System.Windows.Forms.Label currentLabel;
        private System.Windows.Forms.Label changeLabel;
        private System.Windows.Forms.Label equityWithLoanChange;
        private System.Windows.Forms.Label initialMarginChange;
        private System.Windows.Forms.Label maintenanceMarginChange;
        private System.Windows.Forms.Label postTradeLabel;
        private System.Windows.Forms.Label equityWithLoanAfter;
        private System.Windows.Forms.Label initialMarginAfter;
        private System.Windows.Forms.Label maintenanceMarginAfter;
    }
}