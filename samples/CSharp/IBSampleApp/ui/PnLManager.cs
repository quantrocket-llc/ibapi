﻿/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;

namespace IBSampleApp.ui
{
    class PnLManager
    {
        private int pnlReqId;
        private IBClient ibClient;
        private int pnlSingleReqId;

        public void ReqPnL(string account, string modelCode)
        {
            pnlReqId = new Random(DateTime.Now.Millisecond).Next();

            ibClient.ClientSocket.reqPnL(pnlReqId, account, modelCode);
        }

        public void CancelPnL()
        {
            if (pnlReqId != 0)
            {
                ibClient.ClientSocket.cancelPnL(pnlReqId);

                pnlReqId = 0;
            }
        }

        public void ReqPnLSingle(string account, string modelCode, int conId)
        {
            pnlSingleReqId = new Random(DateTime.Now.Millisecond).Next();

            ibClient.ClientSocket.reqPnLSingle(pnlSingleReqId, account, modelCode, conId);
        }

        public void CancelPnLSingle()
        {
            if (pnlSingleReqId != 0)
            {
                ibClient.ClientSocket.cancelPnLSingle(pnlSingleReqId);

                pnlSingleReqId = 0;
            }
        }

        public PnLManager(IBClient ibClient)
        {
            this.ibClient = ibClient;
        }
    }
}
