/* Copyright (C) 2023 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Windows.Markup;

namespace IBSampleApp.types
{
    class AccountAlias
    {
        public AccountAlias(string account, string alias)
        {
            Account = account;
            Alias = alias;
        }

        public string ToXmlString()
        {
            string xml =
                 "\t<AccountAlias>"
                + "\t\t<Account>" + Account + "</Account>"
                + "\t\t\t<Alias>" + Alias + "</Alias>"
                + "\t</AccountAlias>";          
            
            return xml;
        }

        public string Account { get; set; }

        public string Alias { get; set; }
    }

    class AdvisorGroup
    {
        public AdvisorGroup(string name, string defaultMethod)
        {
            Name = name;
            Accounts = new List<Account>();
            DefaultMethod = defaultMethod;
        }

        public string ToXmlString()
        {
            string xml =
                 "  <Group>"
                +"      <name>"+Name+"</name>"
                +"      <ListOfAccts varName=\"list\">";
            foreach(Account account in Accounts)
                xml += account.ToXmlString();

            xml +=
                 "      </ListOfAccts>"
                +"      <defaultMethod>"+DefaultMethod+"</defaultMethod>"
                +"  </Group>";
            
            return xml;
        }

        public string AccountsToString()
        {
            string accountStr = "";
            for (int i = 0; i < Accounts.Count; i++)
                accountStr += (i == 0 ? "" : ";") + Accounts[i].Name + "," + Accounts[i].Amount;
            return accountStr;
        }

        public void AccountsFromString(string accStr)
        {
            string[] accts = accStr.Split(';');

            foreach (string s in accts)
            {
                string[] values = s.Split(',');
                Accounts.Add(new Account(values[0], values[1]));
            }
        }

        public string Name { get; set; }

        public string DefaultMethod { get; set; }

        public List<Account> Accounts { get; set; }
    }

    class Account
    {
        public Account(string name, string amount)
        {
            Name = name;
            Amount = amount;
        }

        public string Name { get; set; }

        public String Amount { get; set; }

        public string ToXmlString()
        {
            string xml =
                       "    <Account>"
                     + "        <acct>" + Name + "</acct>";
            if (Amount != null)
            {
                xml += "       <amount>" + Amount + "</amount>";
            }
            xml += "    </Account>";

            return xml;
        }
    }
}
