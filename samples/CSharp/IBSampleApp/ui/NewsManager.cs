/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */
using System;
using System.Collections.Generic;
using System.Windows.Forms;
using IBApi;
using IBSampleApp.messages;
using IBSampleApp.util;
using System.IO;

namespace IBSampleApp.ui
{
    class NewsManager
    {
        private const int TICK_NEWS_ID_BASE = 90000000;
        private const int TICK_NEWS_ID = TICK_NEWS_ID_BASE;

        private const int NEWS_ARTICLE_ID = TICK_NEWS_ID_BASE + 10000;
        private const int HISTORICAL_NEWS_ID = TICK_NEWS_ID_BASE + 20000;

        int rowCountHistoricalNewsGrid;
        int rowCountTickNewsGrid;

        public NewsManager(IBClient ibClient, DataGridView tickNewsDataGrid, DataGridView newsProvidersGrid, TextBox textBoxArticleText, DataGridView historicalNewsGrid)
        {
            IbClient = ibClient;
            TickNewsGrid = tickNewsDataGrid;
            NewsProvidersGrid = newsProvidersGrid;
            TextBoxArticleText = textBoxArticleText;
            HistoricalNewsGrid = historicalNewsGrid;
        }

        public void UpdateUI(HistoricalNewsMessage historicalNewsMessage)
        {
            if (historicalNewsMessage.RequestId == HISTORICAL_NEWS_ID)
            {
                HistoricalNewsGrid.Rows.Add();
                HistoricalNewsGrid[0, rowCountHistoricalNewsGrid].Value = historicalNewsMessage.Time;
                HistoricalNewsGrid[1, rowCountHistoricalNewsGrid].Value = historicalNewsMessage.ProviderCode;
                HistoricalNewsGrid[2, rowCountHistoricalNewsGrid].Value = historicalNewsMessage.ArticleId;
                HistoricalNewsGrid[3, rowCountHistoricalNewsGrid].Value = historicalNewsMessage.Headline;
                rowCountHistoricalNewsGrid++;
            }
        }

        public void UpdateUI(HistoricalNewsEndMessage historicalNewsEndMessage)
        {
            if (historicalNewsEndMessage.RequestId == HISTORICAL_NEWS_ID)
            {
                if (historicalNewsEndMessage.HasMore)
                {
                    HistoricalNewsGrid.Rows.Add();
                    HistoricalNewsGrid[3, rowCountHistoricalNewsGrid].Value = "has more ...";
                }
            }
        }

        public void UpdateUI(TickNewsMessage tickNewsMessage)
        {
            if (tickNewsMessage.TickerId == TICK_NEWS_ID)
            {
                TickNewsGrid.Rows.Add();
                TickNewsGrid[0, rowCountTickNewsGrid].Value = Utils.UnixMillisecondsToString(tickNewsMessage.TimeStamp, "yyyyMMdd-HH:mm:ss");
                TickNewsGrid[1, rowCountTickNewsGrid].Value = tickNewsMessage.ProviderCode;
                TickNewsGrid[2, rowCountTickNewsGrid].Value = tickNewsMessage.ArticleId;
                TickNewsGrid[3, rowCountTickNewsGrid].Value = tickNewsMessage.Headline;
                TickNewsGrid[4, rowCountTickNewsGrid].Value = tickNewsMessage.ExtraData;
                rowCountTickNewsGrid++;
            }
        }

        public void HandleNewsProviders(NewsProvidersMessage newsProvidersMessage)
        {
            NewsProvidersGrid.Rows.Clear();
            for (int i = 0; i < newsProvidersMessage.NewsProviders.Length; i++)
            {
                NewsProvidersGrid.Rows.Add(1);
                NewsProvidersGrid[0, NewsProvidersGrid.Rows.Count - 1].Value = newsProvidersMessage.NewsProviders[i].ProviderCode;
                NewsProvidersGrid[1, NewsProvidersGrid.Rows.Count - 1].Value = newsProvidersMessage.NewsProviders[i].ProviderName;
            }
        }

        public void UpdateUI(NewsArticleMessage newsArticleMessage)
        {
            if (newsArticleMessage.ArticleType == 0)
            {
                TextBoxArticleText.Text = newsArticleMessage.ArticleText;
            }
            else if (newsArticleMessage.ArticleType == 1)
            {
                byte[] bytes = Convert.FromBase64String(newsArticleMessage.ArticleText);
                File.WriteAllBytes(Path, bytes);
                TextBoxArticleText.Text = "Binary/pdf article was saved to " + Path;
            }
        }

        public void RequestNewsArticle(string providerCode, string articleId, string path)
        {
            Path = path + "\\" + articleId + ".pdf";
            TextBoxArticleText.Clear();
            IbClient.ClientSocket.reqNewsArticle(NEWS_ARTICLE_ID, providerCode, articleId, new List<TagValue>());
        }

        public void ClearArticleText()
        {
            TextBoxArticleText.Clear();
        }

        public void RequestNewsTicks(Contract contract)
        {
            if (!TickNewsGrid.Visible)
                TickNewsGrid.Visible = true;

            ClearTickNews();
            IbClient.ClientSocket.reqMktData(TICK_NEWS_ID, contract, "mdoff,292", false, false, new List<TagValue>());
        }

        public void ClearTickNews()
        {
            rowCountTickNewsGrid = 0;
            TickNewsGrid.Rows.Clear();
        }

        public void CancelTickNews()
        {
            IbClient.ClientSocket.cancelMktData(TICK_NEWS_ID);
            ClearTickNews();
        }

        public void ClearNewsProviders()
        {
            NewsProvidersGrid.Rows.Clear();
        }

        public void RequestNewsProviders()
        {
            if (!NewsProvidersGrid.Visible)
                NewsProvidersGrid.Visible = true;

            ClearNewsProviders();

            IbClient.ClientSocket.reqNewsProviders();
        }

        public void RequestHistoricalNews(int conId, string providerCodes, string startDateTime, string endDateTime, int totalResults)
        {
            if (!HistoricalNewsGrid.Visible)
                HistoricalNewsGrid.Visible = true;

            ClearHistoricalNews();
            IbClient.ClientSocket.reqHistoricalNews(HISTORICAL_NEWS_ID, conId, providerCodes, startDateTime, endDateTime, totalResults, new List<TagValue>());
        }

        public void ClearHistoricalNews() {
            rowCountHistoricalNewsGrid = 0;
            HistoricalNewsGrid.Rows.Clear();
        }

        public DataGridView HistoricalNewsGrid { get; set; }

        public DataGridView TickNewsGrid { get; set; }

        public DataGridView NewsProvidersGrid { get; set; }

        public TextBox TextBoxArticleText { get; set; }

        public IBClient IbClient { get; set; }

        public string Path { get; set; }
    }
}
