/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System;
using IBApi;

namespace IBSampleApp
{
    class WshManager
    {
        private int metaDataReqId;
        private IBClient ibClient;
        private int eventDataReqId;

        public void ReqMetaData()
        {
            metaDataReqId = new Random(DateTime.Now.Millisecond).Next();

            ibClient.ClientSocket.reqWshMetaData(metaDataReqId);
        }

        public void CancelMetaData()
        {
            if (metaDataReqId != 0)
            {
                ibClient.ClientSocket.cancelWshMetaData(metaDataReqId);

                metaDataReqId = 0;
            }
        }

        public void ReqEventData(WshEventData wshEventData)
        {
            eventDataReqId = new Random(DateTime.Now.Millisecond).Next();

            ibClient.ClientSocket.reqWshEventData(eventDataReqId, wshEventData);
        }

        public void CancelEventData()
        {
            if (eventDataReqId != 0)
            {
                ibClient.ClientSocket.cancelWshEventData(eventDataReqId);

                eventDataReqId = 0;
            }
        }

        public WshManager(IBClient ibClient)
        {
            this.ibClient = ibClient;
        }
    }
}