/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
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
        public AdvisorManager(IBClient ibClient, DataGridView aliasesGrid, DataGridView groupsGrid, DataGridView profilesGrid)
        {
            IbClient = ibClient;
            AliasesGrid = aliasesGrid;
            GroupsGrid = groupsGrid;
            ProfilesGrid = profilesGrid;
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
                case 2:
                {
                    HandleProfilesData(message.Data);
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

        private void HandleProfilesData(string profilesData)
        {
            List<AllocationProfile> profiles = XmlHelper.ParseFAInformation<AllocationProfile>(profilesData);
            for (int i = 0; i < profiles.Count; i++)
            {
                ProfilesGrid.Rows.Add(1);
                ProfilesGrid[0, i].Value = profiles[i].Name;
                ProfilesGrid[1, i].Value = profiles[i].Type;
                ProfilesGrid[2, i].Value = profiles[i].AllocationsToString();
            }
        }

        public void SaveProfiles()
        {
            string xmlData = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                            + "<ListOfAllocationProfiles>";
            for (int i = 0; i < ProfilesGrid.Rows.Count-1; i++)
            {
                AllocationProfile allocProfile = new AllocationProfile((string)ProfilesGrid[0, i].Value, (int)ProfilesGrid[1, i].Value);
                allocProfile.AllocationsFromString((string)ProfilesGrid[2, i].Value);
                xmlData += allocProfile.ToXmlString();
            }
            xmlData += "</ListOfAllocationProfiles>";
            IbClient.ClientSocket.replaceFA(0, (int)FinancialAdvisorDataType.Profiles.Value, xmlData);
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

        public DataGridView ProfilesGrid { get; set; }
    }
}
