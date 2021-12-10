package TestJavaClient;

import java.awt.GridLayout;
import java.awt.Window;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class WSHDlg extends JDialogBox {

    int m_conId;
    int m_reqId;
    
    private JTextField m_reqIdField = new JTextField();

    protected JPanel m_editsPanel = new JPanel(new GridLayout(0, 1));

    private JTextField m_conIdField = new JTextField();
    
    public WSHDlg(JFrame parent) {
        super(parent);
        
        m_editsPanel.add(new JLabel("Req id"));
        m_editsPanel.add(m_reqIdField);
        
        m_editsPanel.add(new JLabel("Con Id"));
        m_editsPanel.add(m_conIdField);
        
        getContentPane().add(m_editsPanel);
        pack();
    }
    
    @Override
    protected void onOk() {
        try {
            m_conId = m_conIdField.getText().length() > 0 ? Integer.parseInt(m_conIdField.getText()) : 0;
            m_reqId = m_reqIdField.getText().length() > 0 ? Integer.parseInt(m_reqIdField.getText()) : 0;
        } finally {        
            super.onOk();
        }
    }

}
