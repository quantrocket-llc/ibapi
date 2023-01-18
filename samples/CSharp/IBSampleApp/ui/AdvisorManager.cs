/* Copyright (C) 2023 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

using System.Collections.Generic;
using System.Windows.Forms;
using IBSampleApp.types;
using IBSampleApp.messages;
using IBSampleApp.util;

namespace IBSampleApp.ui
{
    class AdvisorManager
    {
        public AdvisorManager(IBClient ibClient, DataGridView aliasesGrid, DataGridView groupsGrid)
        {
            IbClient = ibClient;
            AliasesGrid = aliasesGrid;
            GroupsGrid = groupsGrid;
        }

        public void UpdateUI(AdvisorDataMessage message)
        {
            switch (message.FaDataType)
            {
                case 1:
                {
                    HandleGroupsData(message.Data);
                    break;
                }
                case 3:
                {
                    HandleAliasesData(message.Data);
                    break;
                }
            }
        }

        private void HandleAliasesData(string aliasData)
        {
            List<AccountAlias> aliases = XmlHelper.ParseFAInformation<AccountAlias>(aliasData);
            for(int i=0; i < aliases.Count; i++)
            {
                AliasesGrid.Rows.Add(1);
                AliasesGrid[0, i].Value = aliases[i].Account;
                AliasesGrid[1, i].Value = aliases[i].Alias;
            }
        }

        private void HandleGroupsData(string groupsData)
        {
            List<AdvisorGroup> groups = XmlHelper.ParseFAInformation<AdvisorGroup>(groupsData);
            for (int i = 0; i < groups.Count; i++)
            {
                GroupsGrid.Rows.Add(1);
                GroupsGrid[0, i].Value = groups[i].Name;
                ((DataGridViewComboBoxCell)GroupsGrid[1, i]).Value = groups[i].DefaultMethod;
                GroupsGrid[2, i].Value = groups[i].AccountsToString();
            }
        }

        public void SaveGroups()
        {
            string xmlData = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                                        + "<ListOfGroups>";
            for (int i = 0; i < GroupsGrid.Rows.Count - 1; i++)
            {
                AdvisorGroup advisorGroup = new AdvisorGroup((string)GroupsGrid[0, i].Value, (string)GroupsGrid[1, i].Value);
                advisorGroup.AccountsFromString((string)GroupsGrid[2, i].Value);
                xmlData += advisorGroup.ToXmlString();
            }
            xmlData += "</ListOfGroups>";
            IbClient.ClientSocket.replaceFA(0, (int)FinancialAdvisorDataType.Groups.Value, xmlData);
        }

        public void RequestFAData(IBType dataType)
        {
            IbClient.ClientSocket.requestFA((int)(dataType.Value));
        }

        public IBClient IbClient { get; set; }

        public DataGridView AliasesGrid { get; set; }

        public DataGridView GroupsGrid { get; set; }
    }
}
