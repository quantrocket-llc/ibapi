/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;

using IBSampleApp.messages;
using IBApi;
using System.Windows.Forms;

namespace IBSampleApp.ui
{
    class OrderManager
    {        
        private OrderDialog orderDialog;
        private List<string> managedAccounts;

        private List<OpenOrderMessage> openOrders = new List<OpenOrderMessage>();
        private List<CompletedOrderMessage> completedOrders = new List<CompletedOrderMessage>();

        private DataGridView liveOrdersGrid;
        private DataGridView completedOrdersGrid;
        private DataGridView tradeLogGrid;

        public IBClient IBClient { get; }

        public OrderManager(IBClient ibClient, DataGridView liveOrdersGrid, DataGridView completedOrdersGrid, DataGridView tradeLogGrid)
        {
            IBClient = ibClient;
            orderDialog = new OrderDialog(this);
            this.liveOrdersGrid = liveOrdersGrid;
            this.completedOrdersGrid = completedOrdersGrid;
            this.tradeLogGrid = tradeLogGrid;
        }

        public List<string> ManagedAccounts
        {
            get { return managedAccounts; }
            set 
            {
                orderDialog.SetManagedAccounts(value);
                managedAccounts = value;
            }
        }

        public void PlaceOrder(Contract contract, Order order)
        {
            if (order.OrderId != 0)
            {
                IBClient.ClientSocket.placeOrder(order.OrderId, contract, order);
            }
            else
            {
                IBClient.ClientSocket.placeOrder(IBClient.NextOrderId, contract, order);
                IBClient.NextOrderId++;
            }
        }

        public void OpenOrderDialog()
        {
            orderDialog.ShowDialog();
        }

        public void OpenNewOrderDialog()
        {
            orderDialog = new OrderDialog(this);

            orderDialog.ShowDialog();
        }

        public void EditOrder()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[2].Value) != 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[1].Value) == IBClient.ClientId)
            {
                DataGridViewRow selectedRow = liveOrdersGrid.SelectedRows[0];
                int orderId = (int)selectedRow.Cells[2].Value;
                for (int i = 0; i < openOrders.Count; i++)
                {
                    if (openOrders[i].OrderId == orderId)
                    {
                        orderDialog.SetOrderContract(openOrders[i].Contract);
                        orderDialog.SetOrder(openOrders[i].Order);
                    }
                }

                orderDialog.ShowDialog();
            }
        }


        public void AttachOrder()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[2].Value) != 0 && (int)(liveOrdersGrid.SelectedRows[0].Cells[1].Value) == IBClient.ClientId)
            {
                DataGridViewRow selectedRow = liveOrdersGrid.SelectedRows[0];
                int orderId = (int)selectedRow.Cells[2].Value;
                for (int i = 0; i < openOrders.Count; i++)
                {
                    if (openOrders[i].OrderId == orderId)
                    {
                        orderDialog.SetOrderContract(openOrders[i].Contract);
                        orderDialog.SetOrder(openOrders[i].Order);

                        orderDialog.SetOrderId(IBClient.NextOrderId);
                        IBClient.NextOrderId++;
                        orderDialog.SetParentOrderId(orderId);
                    }
                }

                orderDialog.ShowDialog();
            }
        }

        public void CancelSelection()
        {
            if (liveOrdersGrid.SelectedRows.Count > 0)
            {
                for (int i = 0; i < liveOrdersGrid.SelectedRows.Count; i++)
                {
                    int orderId = (int)liveOrdersGrid.SelectedRows[i].Cells[2].Value;
                    int clientId = (int)liveOrdersGrid.SelectedRows[i].Cells[1].Value;
                    OpenOrderMessage openOrder = GetOpenOrderMessage(orderId, clientId);
                    if(openOrder != null)
                        IBClient.ClientSocket.cancelOrder(openOrder.OrderId);
                }
            }
        }

        private OpenOrderMessage GetOpenOrderMessage(int orderId, int clientId)
        {
            for (int i = 0; i < openOrders.Count; i++)
            {
                if (openOrders[i].Order.OrderId == orderId && openOrders[i].Order.ClientId == clientId)
                    return openOrders[i];
            }
            return null;
        }

        public void HandleCommissionMessage(CommissionMessage message)
        {
            for (int i = 0; i < tradeLogGrid.Rows.Count; i++)
            {
                if (((string)tradeLogGrid[0, i].Value).Equals(message.CommissionReport.ExecId))
                {
                    tradeLogGrid[8, i].Value = message.CommissionReport.Commission;
                    tradeLogGrid[9, i].Value = message.CommissionReport.RealizedPNL;
                }
            }
        }

        public void handleOpenOrder(OpenOrderMessage openOrder)
        {
            if (openOrder.Order.WhatIf)
                orderDialog.HandleOpenOrder(openOrder);
            else
            {
                UpdateLiveOrders(openOrder);
                UpdateLiveOrdersGrid(openOrder);
            }
        }

        public void handleCompletedOrder(CompletedOrderMessage completedOrder)
        {
            UpdateCompletedOrdersGrid(completedOrder);
        }

        public void HandleExecutionMessage(ExecutionMessage message)
        {
            for (int i = 0; i < tradeLogGrid.Rows.Count; i++)
            {
                if (((string)tradeLogGrid[0, i].Value).Equals(message.Execution.ExecId))
                {
                    PopulateTradeLog(i, message);
                }
            }
            tradeLogGrid.Rows.Add(1);
            PopulateTradeLog(tradeLogGrid.Rows.Count-1, message);
        }

        private void PopulateTradeLog(int index, ExecutionMessage message)
        {
            tradeLogGrid[0, index].Value = message.Execution.ExecId;
            tradeLogGrid[1, index].Value = message.Execution.Time;
            tradeLogGrid[2, index].Value = message.Execution.AcctNumber;
            tradeLogGrid[3, index].Value = message.Execution.ModelCode;
            tradeLogGrid[4, index].Value = message.Execution.Side;
            tradeLogGrid[5, index].Value = message.Execution.Shares;
            tradeLogGrid[6, index].Value = message.Contract.Symbol + " " + message.Contract.SecType + " " + message.Contract.Exchange;
            tradeLogGrid[7, index].Value = message.Execution.Price;
            tradeLogGrid["LastLiquidity", index].Value = message.Execution.LastLiquidity;
        }

        public void HandleOrderStatus(OrderStatusMessage statusMessage)
        {
            for (int i = 0; i < liveOrdersGrid.Rows.Count; i++)
            {
                if (liveOrdersGrid[0, i].Value.Equals(statusMessage.PermId))
                {
                    liveOrdersGrid[8, i].Value = statusMessage.Status;
                    return;
                }
            }
        }

        public void HandleSoftDollarTiers(SoftDollarTiersMessage msg)
        {
            orderDialog.HandleSoftDollarTiers(msg);
        }

        private void UpdateCompletedOrdersGrid(CompletedOrderMessage completedOrderMessage)
        {
            completedOrdersGrid.Rows.Add(1);
            PopulateCompletedOrderRow(completedOrdersGrid.Rows.Count - 1, completedOrderMessage);
        }

        private void UpdateLiveOrders(OpenOrderMessage orderMesage)
        {
            for (int i = 0; i < openOrders.Count; i++ )
            {
                if (openOrders[i].Order.OrderId == orderMesage.OrderId)
                {
                    openOrders[i] = orderMesage;
                    return;
                }
            }
            openOrders.Add(orderMesage);
        }

        private void UpdateLiveOrdersGrid(OpenOrderMessage orderMessage)
        {
            for (int i = 0; i<liveOrdersGrid.Rows.Count; i++)
            {
                if ((int)(liveOrdersGrid[2, i].Value) == orderMessage.Order.OrderId)
                {
                    PopulateOrderRow(i, orderMessage);
                    return;
                }
            }
            liveOrdersGrid.Rows.Add(1);
            PopulateOrderRow(liveOrdersGrid.Rows.Count - 1, orderMessage);
        }

        private void PopulateOrderRow(int rowIndex, OpenOrderMessage orderMessage)
        {
            liveOrdersGrid[0, rowIndex].Value = orderMessage.Order.PermId;
            liveOrdersGrid[1, rowIndex].Value = orderMessage.Order.ClientId;
            liveOrdersGrid[2, rowIndex].Value = orderMessage.Order.OrderId;
            liveOrdersGrid[3, rowIndex].Value = orderMessage.Order.Account;
            liveOrdersGrid[4, rowIndex].Value = orderMessage.Order.ModelCode;
            liveOrdersGrid[5, rowIndex].Value = orderMessage.Order.Action;
            liveOrdersGrid[6, rowIndex].Value = orderMessage.Order.TotalQuantity;
            liveOrdersGrid[7, rowIndex].Value = orderMessage.Contract.Symbol+" "+orderMessage.Contract.SecType+" "+orderMessage.Contract.Exchange;
            liveOrdersGrid[8, rowIndex].Value = orderMessage.OrderState.Status;
            liveOrdersGrid[9, rowIndex].Value = (orderMessage.Order.CashQty != double.MaxValue ? orderMessage.Order.CashQty.ToString() : "");
        }

        private void PopulateCompletedOrderRow(int rowIndex, CompletedOrderMessage completedOrderMessage)
        {
            completedOrdersGrid[0, rowIndex].Value = completedOrderMessage.Order.PermId;
            completedOrdersGrid[1, rowIndex].Value = Util.LongMaxString(completedOrderMessage.Order.ParentPermId);
            completedOrdersGrid[2, rowIndex].Value = completedOrderMessage.Order.Account;
            completedOrdersGrid[3, rowIndex].Value = completedOrderMessage.Order.Action;
            completedOrdersGrid[4, rowIndex].Value = completedOrderMessage.Order.TotalQuantity;
            completedOrdersGrid[5, rowIndex].Value = completedOrderMessage.Order.CashQty;
            completedOrdersGrid[6, rowIndex].Value = completedOrderMessage.Order.FilledQuantity;
            completedOrdersGrid[7, rowIndex].Value = completedOrderMessage.Order.LmtPrice;
            completedOrdersGrid[8, rowIndex].Value = completedOrderMessage.Order.AuxPrice;
            completedOrdersGrid[9, rowIndex].Value = completedOrderMessage.Contract.Symbol + " " + completedOrderMessage.Contract.SecType + " " + completedOrderMessage.Contract.Exchange;
            completedOrdersGrid[10, rowIndex].Value = completedOrderMessage.OrderState.Status;
            completedOrdersGrid[11, rowIndex].Value = completedOrderMessage.OrderState.CompletedTime;
            completedOrdersGrid[12, rowIndex].Value = completedOrderMessage.OrderState.CompletedStatus;
        }

    }
}
