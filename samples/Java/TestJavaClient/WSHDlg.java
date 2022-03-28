/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package TestJavaClient;

import java.awt.GridLayout;

import javax.swing.JCheckBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import com.ib.client.WshEventData;

public class WSHDlg extends JDialogBox {

    int m_reqId;
    WshEventData m_wshEventData;

    private JTextField m_reqIdField = new JTextField();

    protected JPanel m_editsPanel = new JPanel(new GridLayout(0, 1));

    private JTextField m_conIdField = new JTextField();
    private JTextField m_filterField = new JTextField();
    private JCheckBox m_fillWatchlistCheckbox = new JCheckBox("Fill Watchlist", false);
    private JCheckBox m_fillPortfolioCheckbox = new JCheckBox("Fill Portfolio", false);
    private JCheckBox m_fillCompetitorsCheckbox = new JCheckBox("Fill Competitors", false);

    public WSHDlg(JFrame parent, boolean isWshEventDlg) {
        super(parent);

        m_editsPanel.add(new JLabel("Req id"));
        m_editsPanel.add(m_reqIdField);

        if (isWshEventDlg) {
            m_editsPanel.add(new JLabel("Con Id"));
            m_editsPanel.add(m_conIdField);
            m_editsPanel.add(new JLabel("Filter"));
            m_editsPanel.add(m_filterField);
            m_editsPanel.add(m_fillWatchlistCheckbox);
            m_editsPanel.add(m_fillPortfolioCheckbox);
            m_editsPanel.add(m_fillCompetitorsCheckbox);
        }

        getContentPane().add(m_editsPanel);
        pack();
    }

    @Override
    protected void onOk() {
        try {
            m_reqId = m_reqIdField.getText().length() > 0 ? Integer.parseInt(m_reqIdField.getText()) : 0;
            if (m_conIdField.getText().length() > 0) {
                m_wshEventData = new WshEventData(Integer.parseInt(m_conIdField.getText()));
            } else {
                m_wshEventData = new WshEventData(m_filterField.getText(), m_fillWatchlistCheckbox.isSelected(), m_fillPortfolioCheckbox.isSelected(), m_fillCompetitorsCheckbox.isSelected());
            }

        } finally {
            super.onOk();
        }
    }

}
