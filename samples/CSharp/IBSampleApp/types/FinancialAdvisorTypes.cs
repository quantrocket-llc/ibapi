/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;

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
            Accounts = new List<string>();
            DefaultMethod = defaultMethod;
        }

        public string ToXmlString()
        {
            string xml =
                 "  <Group>"
                +"      <name>"+Name+"</name>"
                +"      <ListOfAccts varName=\"list\">";
            foreach(string account in Accounts)
                xml+="         <String>"+account+"</String>";

            xml +=
                 "      </ListOfAccts>"
                +"      <defaultMethod>"+DefaultMethod+"</defaultMethod>"
                +"  </Group>";
            
            return xml;
        }

        public string AccountsToString()
        {
            string accountStr = Accounts[0];
            for (int i = 1; i < Accounts.Count; i++)
                accountStr += "," + Accounts[i];
            return accountStr;
        }

        public void AccountsFromString(string accStr)
        {
            string[] accts = accStr.Split(',');
            foreach (string s in accts)
                Accounts.Add(s);
        }

        public string Name { get; set; }

        public string DefaultMethod { get; set; }

        public List<string> Accounts { get; set; }
    }

    class AllocationProfile
    {
        public AllocationProfile(string name, int type)
        {
            Name = name;
            Type = type;
            Allocations = new List<Allocation>();
        }

        public string ToXmlString()
        {
            string xml = 
                 "  <AllocationProfile>"
                +"      <name>"+Name+"</name>"
                +"      <type>"+Type+"</type>"
                +"      <ListOfAllocations varName=\"listOfAllocations\">";

            foreach (Allocation profileAllocation in Allocations)
                xml += profileAllocation.ToXmlString();

            xml +=
                 "      </ListOfAllocations>"
                +"  </AllocationProfile>";

            return xml;
        }

        public string AllocationsToString()
        {
            string str = Allocations[0].Account+"/"+Allocations[0].Amount;
            for(int i=1; i<Allocations.Count; i++)
            {
                str += "," + Allocations[i].Account + "/" + Allocations[i].Amount;
            }
            return str;
        }

        public bool AllocationsFromString(string allocString)
        {
            try
            {
                string[] allocations = allocString.Split(',');
                foreach (string s in allocations)
                {
                    string[] accountAndValue = s.Split('/');
                    Allocations.Add(new Allocation(accountAndValue[0], double.Parse(accountAndValue[1])));
                }
                return true;
            }
            catch(Exception)
            {
                return false;
            }                
        }

        public string Name { get; set; }

        public int Type { get; set; }

        public List<Allocation> Allocations { get; set; }
    }

    class Allocation
    {
        public Allocation(string account, double amount)
        {
            Account = account;
            Amount = amount;
        }

        public string ToXmlString()
        {
            string xml = 
                 "          <Allocation>"
                +"              <acct>"+Account+"</acct>"
                +"              <amount>"+Amount+"</amount>"
                +"              <posEff>O</posEff>"
                +"          </Allocation>";

            return xml;
        }

        public string Account { get; set; }

        public double Amount { get; set; }
    }
}
