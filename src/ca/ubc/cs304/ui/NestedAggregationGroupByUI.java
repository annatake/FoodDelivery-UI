package ca.ubc.cs304.ui;

import ca.ubc.cs304.controller.FoodDeliveryApp;
import ca.ubc.cs304.model.CustomerAnalysis;
import ca.ubc.cs304.model.OrderAnalysis;

import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.math.BigDecimal;
import java.util.ArrayList;

public class NestedAggregationGroupByUI extends JFrame implements ActionListener {
    private static final int TEXT_FIELD_WIDTH = 10;
    private JPanel container;
    private JTextField subTotalField;
    private JPanel tablePanel;

    public NestedAggregationGroupByUI() {
        super("Nested Aggregation with Group By Query");
        this.container = new JPanel();
        container.setPreferredSize(new Dimension(350, 375));
    }

    public void showFrame() {
        container.removeAll();
        JPanel selectionPanel = new JPanel();
        // set layout
        selectionPanel.setLayout(new GridBagLayout());
        selectionPanel.setPreferredSize(new Dimension(300, 200));
        selectionPanel.setBorder(BorderFactory.createLineBorder(Color.lightGray, 1));
        // add labels, fields, button
        String text = "Find customers who made orders with the largest avg subtotal:";
        JTextArea subTotalLabel = new JTextArea(2, 20);
        subTotalLabel.setPreferredSize(new Dimension(275, 30));
        subTotalLabel.setText(text);
        subTotalLabel.setWrapStyleWord(true);
        subTotalLabel.setLineWrap(true);
        subTotalLabel.setOpaque(false);
        subTotalLabel.setEditable(false);
        subTotalLabel.setFocusable(false);
        subTotalLabel.setBackground(UIManager.getColor("Label.background"));
        subTotalLabel.setFont(UIManager.getFont("Label.font"));
        subTotalLabel.setBorder(UIManager.getBorder("Label.border"));
        JButton submitQuery = new JButton("Submit Query");
        submitQuery.addActionListener(this);
        tablePanel = new JPanel();

        // add formatting and add components to panel
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.fill = GridBagConstraints.HORIZONTAL;
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(10, 5,0,0);
        selectionPanel.add(subTotalLabel, gbc);
        gbc.gridx = 0;
        gbc.gridy = 2;
        gbc.gridwidth = 2;
        gbc.insets = new Insets(10, 0,0,0);
        selectionPanel.add(submitQuery, gbc);
        // display the frame
        container.add(selectionPanel);
        container.add(tablePanel);
        this.add(container);
        this.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
        this.pack();
        this.setVisible(true);
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        System.out.println("Submit Query button clicked!");
        try {
            tablePanel.removeAll();
            ArrayList<Integer> results = FoodDeliveryApp.dbTransactions.handleNestedAggrGroupByQuery();
            // display the data
            String[] columnNames = {"CustomerID"};
            Object[][] data = new Object[results.size()][];
            for (int i = 0; i < results.size(); i++) {
                String customerIDData = String.valueOf(results.get(i));
                String[] rowData = {customerIDData};
                data[i] = rowData;
            }
            JTable table = new JTable(data, columnNames);
            table.setBounds(30, 40, 200, 150);
            JScrollPane scrollPane = new JScrollPane(table);
            scrollPane.setPreferredSize(new Dimension(300, 150));
            // table.setFillsViewportHeight(true);
            tablePanel.add(scrollPane);
            this.revalidate();
            this.repaint();
            ((JFrame) SwingUtilities.getRoot(container)).pack();
        } catch (Exception err) {
            JOptionPane.showMessageDialog(null, "Something went wrong with the nested aggregation " +
                            "with group by query.",
                    "Error", JOptionPane.ERROR_MESSAGE);
        }

    }
}
