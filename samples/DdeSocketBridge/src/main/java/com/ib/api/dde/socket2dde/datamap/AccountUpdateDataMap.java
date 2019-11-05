/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.socket2dde.datamap;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.utils.AccountUpdatesUtils.AccountUpdateKey;

/** Class represents account update data map received from TWS */
public class AccountUpdateDataMap extends BaseDataMap {

    private Map<AccountUpdateKey, AccountUpdateData> m_accountUpdateDataMap = Collections.synchronizedSortedMap(new TreeMap<AccountUpdateKey, AccountUpdateData>());

    public AccountUpdateDataMap(DdeRequest ddeRequest){
        super(ddeRequest);
    }

    public List<AccountUpdateData> syncCopyAccountUpdateDataValues() {
        synchronized(m_accountUpdateDataMap) {
            return new ArrayList<AccountUpdateData>(m_accountUpdateDataMap.values());
        }
    }

    public void addAccountUpdateData(AccountUpdateData accountUpdateData) {
        AccountUpdateKey key = new AccountUpdateKey(accountUpdateData.account(), accountUpdateData.modelCode(), 
                accountUpdateData.key(), accountUpdateData.currency());
        m_accountUpdateDataMap.put(key, accountUpdateData);
    }

    public void clearAccountUpdateDataMap() {
        m_accountUpdateDataMap.clear();
    }
}
