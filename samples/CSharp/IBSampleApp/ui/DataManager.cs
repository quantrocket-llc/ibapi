/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Windows.Forms;

namespace IBSampleApp.ui
{
    abstract class DataManager
    {
        protected Control uiControl;
        protected IBClient ibClient;
        protected int currentTicker = 1;

        public DataManager(IBClient client, Control dataGrid)
        {
            ibClient = client;
            uiControl = dataGrid;
        }
        
        public abstract void NotifyError(int requestId);
        
        public abstract void Clear();
    }
}
