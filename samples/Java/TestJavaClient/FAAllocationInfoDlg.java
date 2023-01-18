/* Copyright (C) 2023 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package TestJavaClient;

import java.awt.Color;

import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JLabel;
import javax.swing.JTextField;
import javax.swing.border.Border;
import javax.swing.border.TitledBorder;

class FAAllocationInfoDlg extends JDialog {
    private IBGridBagPanel mainJPanel = new IBGridBagPanel();
    private IBGridBagPanel faGroupJPanel = new IBGridBagPanel();

    private JLabel m_groupLabel = new JLabel("Group");
    private JLabel m_methodLabel = new JLabel("Method");
    private JLabel m_percentageLabel = new JLabel("Percentage");

    private JTextField m_groupTextField = new JTextField(20);
    private JTextField m_methodTextField = new JTextField(20);
    private JTextField m_percentageTextField = new JTextField(20);

    private JButton m_okButton = new JButton("OK");
    private JButton m_closeButton = new JButton("Close");

    private OrderDlg m_parent;

    FAAllocationInfoDlg(OrderDlg dlg) {
        super(dlg, false);
        m_parent = dlg;
        try {
            jbInit();
            pack();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private void jbInit() {
        Color etchedColor = new Color(148, 145, 140);
        Border border1 = BorderFactory.createEtchedBorder(Color.white, etchedColor);
        TitledBorder titledBorder1 = new TitledBorder(border1, "Group");

        faGroupJPanel.setBorder(titledBorder1);

        faGroupJPanel.SetObjectPlacement(m_groupLabel,           0, 0);
        faGroupJPanel.SetObjectPlacement(m_groupTextField,       1, 0);
        faGroupJPanel.SetObjectPlacement(m_methodLabel,          0, 1);
        faGroupJPanel.SetObjectPlacement(m_methodTextField,      1, 1);
        faGroupJPanel.SetObjectPlacement(m_percentageLabel,      0, 2);
        faGroupJPanel.SetObjectPlacement(m_percentageTextField,  1, 2);

        mainJPanel.SetObjectPlacement(faGroupJPanel,   0, 0, 4, 1);
        mainJPanel.SetObjectPlacement(m_okButton,      1, 2, 1, 1);
        mainJPanel.SetObjectPlacement(m_closeButton,   2, 2, 1, 1);

        setTitle("FA Allocation Info");
        getContentPane().add(mainJPanel);
        setSize( 600, 300);


        m_okButton.addActionListener(e -> onOk());
        m_closeButton.addActionListener(e -> onClose());
    }

    void onOk() {
        m_parent.faGroup(m_groupTextField.getText().trim());
        m_parent.faMethod(m_methodTextField.getText().trim());
        m_parent.faPercentage(m_percentageTextField.getText().trim());
        dispose();
    }

    void onClose() {
        dispose();
    }
}
