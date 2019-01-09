/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.util.ArrayList;

import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.utils.Utils;
import com.ib.client.FamilyCode;

/** Class contains some utility methods related to account updates requests */
public class AccountUpdatesUtils {

    /** Method creates single table row (array of strings) from FamilyCode */
    static ArrayList<String> createTableItem(FamilyCode familyCode) {
        ArrayList<String> item = new ArrayList<String>();
        item.add(Utils.toString(familyCode.accountID()));
        item.add(Utils.toString(familyCode.familyCodeStr()));
        return item;
    }

    /** Method creates single table row (array of strings) from AccountUpdateData */
    static ArrayList<String> createTableItem(AccountUpdateData data, boolean hasModel, boolean isNew) {
        ArrayList<String> item = new ArrayList<String>();

        if (isNew) {
            item.add(Utils.toString(data.account()));
            if (hasModel) {
                item.add(Utils.toString(data.modelCode()));
            }
            item.add(Utils.toString(data.key()));
            item.add(Utils.toString(data.value()));
            item.add(Utils.toString(data.currency()));
        } else {
            item.add(Utils.toString(data.key()));
            item.add(Utils.toString(data.value()));
            item.add(Utils.toString(data.currency()));
            item.add(Utils.toString(data.account()));
        }

        return item;
    }

    /** Class used as key in account updates list */
    public static class AccountUpdateKey implements Comparable<AccountUpdateKey> {
        private String m_account;
        private String m_modelCode;
        private String m_key;
        private String m_currency;

        // gets
        public String account()   { return m_account; }
        public String modelCode() { return m_modelCode; }
        public String key()       { return m_key; }
        public String currency()  { return m_currency; }

        public AccountUpdateKey(String account, String modelCode, String key, String currency) {
            m_account = account;
            m_modelCode = modelCode;
            m_key = key;
            m_currency = currency;
        }

        @Override
        public int compareTo(AccountUpdateKey other) {
            int res = Utils.compare(account(), other.account());
            if (res != Integer.MAX_VALUE) return res;
            res = Utils.compare(modelCode(), other.modelCode());
            if (res != Integer.MAX_VALUE) return res;
            res = Utils.compare(currency(), other.currency());
            if (res != Integer.MAX_VALUE) return res;
            res = Utils.compare(key(), other.key());
            if (res != Integer.MAX_VALUE) return res;
            return 0;
        }
    }
}
