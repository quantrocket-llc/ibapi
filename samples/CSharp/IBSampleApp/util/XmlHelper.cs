/* Copyright (C) 2023 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Linq;
using System.Xml;
using IBSampleApp.types;

namespace IBSampleApp.util
{
    class XmlHelper
    {
        private static string LIST_OF_ALIASES = "ListOfAccountAliases";
        private static string LIST_OF_GROUPS = "ListOfGroups";

        public static List<T> ParseFAInformation<T>(string faInformation)
        {
            XmlDocument document = new XmlDocument();
            document.LoadXml(faInformation);
            if (document.DocumentElement.Name.Equals(LIST_OF_ALIASES))
                return GetAliasesList(document).Cast<T>().ToList();
            if (document.DocumentElement.Name.Equals(LIST_OF_GROUPS))
                return GetGroupsList(document).Cast<T>().ToList();
            return null;
        }

        public static string ListToXML<T>(List<T> objects)
        {
            return "";
        }

        private static List<AccountAlias> GetAliasesList(XmlDocument xmlDocument)
        {
            List<AccountAlias> accountAliases = new List<AccountAlias>();
            XmlNode accountListNode = xmlDocument.GetElementsByTagName(LIST_OF_ALIASES).Item(0);
            XmlNodeList aliasesList = accountListNode.ChildNodes;
            for (int i = 0; i < aliasesList.Count; i++)
            {
                XmlNode aliasNode = aliasesList.Item(i);
                accountAliases.Add(new AccountAlias(aliasNode.ChildNodes[0].InnerText, aliasNode.ChildNodes[1].InnerText));
            }
            return accountAliases;
        }

        private static List<AdvisorGroup> GetGroupsList(XmlDocument xmlDocument)
        {
            List<AdvisorGroup> advisorGroups = new List<AdvisorGroup>();
            XmlNode groupsListNode = xmlDocument.GetElementsByTagName(LIST_OF_GROUPS).Item(0);
            XmlNodeList groupsList = groupsListNode.ChildNodes;
            for (int i = 0; i < groupsList.Count; i++)
            {
                AdvisorGroup advisorGroup = new AdvisorGroup(groupsList.Item(i).ChildNodes[0].InnerText, groupsList.Item(i).ChildNodes[1].InnerText);
                XmlNodeList accountNodes = groupsList.Item(i).ChildNodes[2].ChildNodes;
                for (int j = 0; j < accountNodes.Count; j++)
                {
                    string accountName = accountNodes[j].ChildNodes[0].InnerText;
                    string amount = null;
                    if (accountNodes[j].ChildNodes.Count > 1)
                    {
                        amount = accountNodes[j].ChildNodes[1].InnerText;
                    }

                    advisorGroup.Accounts.Add(new Account(accountName, amount));
                }
                advisorGroups.Add(advisorGroup);
            }
            return advisorGroups;
        }

    }

    
}
