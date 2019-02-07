/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.handlers;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.ib.api.dde.TwsService;
import com.ib.api.dde.dde2socket.requests.DdeRequest;
import com.ib.api.dde.dde2socket.requests.DdeRequestStatus;
import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.TickRequest;
import com.ib.api.dde.dde2socket.requests.news.HistoricalNewsRequest;
import com.ib.api.dde.dde2socket.requests.news.NewsArticleRequest;
import com.ib.api.dde.dde2socket.requests.news.NewsBulletinsRequest;
import com.ib.api.dde.dde2socket.requests.news.NewsTicksRequest;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.handlers.base.BaseHandler;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.data.NewsData;
import com.ib.api.dde.socket2dde.datamap.BaseDataMap;
import com.ib.api.dde.socket2dde.datamap.BaseListDataMap;
import com.ib.api.dde.socket2dde.datamap.BaseStringDataMap;
import com.ib.api.dde.utils.Utils;
import com.ib.client.Contract;
import com.ib.client.EClientSocket;
import com.ib.client.NewsProvider;

/** Class handles news data related requests, data and messages */
public class NewsDataHandler extends BaseHandler {
    // parser
    private NewsRequestParser m_requestParser = new NewsRequestParser();

    // news requests
    private Map<Integer, BaseListDataMap<NewsData>> m_newsRequests = Collections.synchronizedMap(new HashMap<Integer, BaseListDataMap<NewsData>>());
    
    // news providers
    private DdeRequestStatus m_newsProvidersRequestStatus = DdeRequestStatus.UNKNOWN;
    private List<NewsProvider> m_newsProviders = Collections.synchronizedList(new ArrayList<NewsProvider>());
    
    // news article requests
    private Map<Integer, BaseStringDataMap> m_newsArticleRequests = Collections.synchronizedMap(new HashMap<Integer, BaseStringDataMap>());

    // news bulletins
    private NewsBulletinsRequest m_newsBulletinsRequest = null;
    private DdeRequestStatus m_newsBulletinsRequestStatus = DdeRequestStatus.UNKNOWN;
    private List<NewsBulletinData> m_newsBulletins = Collections.synchronizedList(new ArrayList<NewsBulletinData>());

    public NewsDataHandler(EClientSocket clientSocket, TwsService twsService) {
        super(clientSocket, twsService);
    }

    /* *****************************************************************************************************
     *                                          Requests
    /* *****************************************************************************************************/
    /** Method sends news ticks request to TWS */
    public byte[] handleNewsTicksRequest(String requestStr, byte[] data) {
        NewsTicksRequest request = m_requestParser.parseNewsTicksRequest(requestStr, data);
        System.out.println("Sending news ticks request: id=" + request.requestId() + " contract=" + Utils.shortContractString(request.contract()));
        clientSocket().reqMktData(request.requestId(), request.contract(), "mdoff,292", false, false, null);
        handleNewsBaseRequest(request, DdeRequestType.NEWS_TICKS_TICK.topic());
        return null;
    }

    /** Method sends historical news request to TWS */
    public byte[] handleHistoricalNewsRequest(String requestStr, byte[] data) {
        HistoricalNewsRequest request = m_requestParser.parseHistoricalNewsRequest(requestStr, data);
        if (request == null) {
            return null;
        }
        System.out.println("Sending historical news request: id=" + request.requestId() + " conId=" + request.conId() + " providerCodes=" + request.providerCodes());
        clientSocket().reqHistoricalNews(request.requestId(), request.conId(), request.providerCodes(), 
                request.startDateTime(), request.endDateTime(), request.totalResults(), null);
        handleNewsBaseRequest(request, DdeRequestType.HISTORICAL_NEWS_TICK.topic());
        return null;
    }

    public void handleNewsBaseRequest(DdeRequest request, String topic) {
        BaseListDataMap<NewsData> dataMap = new BaseListDataMap<NewsData>(request);
        m_newsRequests.put(request.requestId(), dataMap);
        updateNewsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED, topic);
    }
    
    /** Method handles news ticks cancel request */
    public byte[] handleNewsTicksCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_NEWS_TICKS);
        System.out.println("Cancelling news ticks: id=" + request.requestId());
        handleNewsBaseCancel(request);
        return null;
    }

    /** Method handles historical news cancel request */
    public byte[] handleHistoricalNewsCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_HISTORICAL_NEWS);
        System.out.println("Cancelling historical news: id=" + request.requestId());
        handleNewsBaseCancel(request);
        return null;
    }
    
    public void handleNewsBaseCancel(DdeRequest request) {
        BaseListDataMap<NewsData> dataMap = m_newsRequests.get(request.requestId());
        if(dataMap != null) {
            switch(request.ddeRequestType()){
                case CANCEL_NEWS_TICKS:
                    // send cancelMktData
                    clientSocket().cancelMktData(request.requestId());
                    updateNewsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED, DdeRequestType.NEWS_TICKS_TICK.topic());
                    break;
                case CANCEL_HISTORICAL_NEWS:
                    updateNewsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED, DdeRequestType.HISTORICAL_NEWS_TICK.topic());
                    break;
                default:
                    break;
            }
        }
        m_newsRequests.remove(request.requestId());
    }
        
    /** Method handles news ticks tick request */
    public String handleNewsTicksTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.NEWS_TICKS_TICK);
        System.out.println("Handling news ticks tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleNewsBaseTickRequest(tickRequest);
    }

    /** Method handles historical news tick request */
    public String handleHistoricalNewsTickRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.NEWS_TICKS_TICK);
        System.out.println("Handling historical news tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        return handleNewsBaseTickRequest(tickRequest);
    }

    public String handleNewsBaseTickRequest(TickRequest tickRequest) {
        BaseListDataMap<NewsData> dataMap = m_newsRequests.get(tickRequest.requestId());
        return handleTickRequest(tickRequest, dataMap);
    }
    
    /** Method handles news ticks array request */
    public byte[] handleNewsTicksArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQ_NEWS_TICKS);
        System.out.println("Handling news ticks array request: id=" + request.requestId());
        return handleNewsBaseArrayRequest(request);
    }

    /** Method handles historical news array request */
    public byte[] handleHistoricalNewsArrayRequest(String requestStr) {
        DdeRequest request = m_requestParser.parseRequest(requestStr, DdeRequestType.REQUEST_HISTORICAL_NEWS);
        System.out.println("Handling historical news array request: id=" + request.requestId());
        return handleNewsBaseArrayRequest(request);
    }

    public byte[] handleNewsBaseArrayRequest(DdeRequest request) {
        BaseListDataMap<NewsData> dataMap = m_newsRequests.get(request.requestId());
        byte[] array = null;
        if (dataMap != null) {
            int requestId = request.requestId();
            switch(request.ddeRequestType()){
                case REQ_NEWS_TICKS:
                    updateNewsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.SUBSCRIBED, DdeRequestType.NEWS_TICKS_TICK.topic());
                    array = Utils.dataListToByteArray(syncCopyNewsData(requestId), true);
                    break;
                case REQUEST_HISTORICAL_NEWS:
                    updateNewsRequestStatus(request.requestId(), dataMap, DdeRequestStatus.SUBSCRIBED, DdeRequestType.HISTORICAL_NEWS_TICK.topic());
                    array = Utils.dataListToByteArray(syncCopyNewsData(requestId), false);
                    break;
                default:
                    break;
            }
            dataMap.clearAllItems();
        }
        return array;
    }
    
    /** Method handles news providers request */
    public String handleNewsProvidersRequest(String requestStr) {
        if (m_newsProvidersRequestStatus == DdeRequestStatus.UNKNOWN) {
            System.out.println("Handling news providers request.");
            clientSocket().reqNewsProviders();
            m_newsProvidersRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_newsProvidersRequestStatus.toString();
    }

    /** Method handles news providers array request */
    public byte[] handleNewsProvidersArrayRequest(String requestStr) {
        byte[] array = null;
        if (m_newsProvidersRequestStatus == DdeRequestStatus.RECEIVED) {
            System.out.println("Handling news providers array request.");
            array = Utils.dataListToByteArray(syncCopyNewsProviders());
            m_newsProvidersRequestStatus = DdeRequestStatus.FINISHED;
            notifyDde(DdeRequestType.REQ_NEWS_PROVIDERS.topic(), RequestParser.ID_ZERO);
        }
        return array;
    }

    /** Method handles news providers cancel */
    public String handleNewsProvidersCancel(String requestStr) {
        if (m_newsProvidersRequestStatus == DdeRequestStatus.FINISHED) {
            System.out.println("Handling news providers cancel.");
            m_newsProvidersRequestStatus = DdeRequestStatus.UNKNOWN;
            m_newsProviders.clear();
        }
        return m_newsProvidersRequestStatus.toString();
    }
    
    /** Method sends news article request to TWS */
    public byte[] handleNewsArticleRequest(String requestStr, byte[] data) {
        NewsArticleRequest request = m_requestParser.parseNewsArticleRequest(requestStr, data);
        if (request == null) {
            return null;
        }
        System.out.println("Sending news article request: id=" + request.requestId() + " providerCode=" + request.providerCode() 
            + " articleId=" + request.articleId());
        clientSocket().reqNewsArticle(request.requestId(), request.providerCode(), request.articleId(), null); 
        BaseStringDataMap dataMap = new BaseStringDataMap(request);
        m_newsArticleRequests.put(request.requestId(), dataMap);
        updateNewsArticleRequestStatus(request.requestId(), dataMap, DdeRequestStatus.REQUESTED);
        return null;
    }

    /** Method handles news article cancel request */
    public byte[] handleNewsArticleCancel(String requestStr) {
        DdeRequest request =  m_requestParser.parseRequest(requestStr, DdeRequestType.CANCEL_NEWS_ARTICLE);
        System.out.println("Cancelling news article: id=" + request.requestId());
        BaseStringDataMap dataMap = m_newsArticleRequests.get(request.requestId());
        if(dataMap != null) {
            updateNewsArticleRequestStatus(request.requestId(), dataMap, DdeRequestStatus.CANCELLED);
            m_newsArticleRequests.remove(request.requestId());
        }
        return null;
    }

    /** Method handles news article tick request */
    public String handleNewsArticleTickRequest(String requestStr) {
        String ret = "";
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.NEWS_ARTICLE_TICK);
        System.out.println("Handling news article tick request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_newsArticleRequests.get(tickRequest.requestId());
        if (dataMap != null) {
            if (tickRequest.tickType().equals(DdeRequestType.NEWS_ARTICLE.topic()) && Utils.isNotNull(dataMap.getString())) {
                if (dataMap.getInt() == 0) {
                    ret= Utils.LONGVALUE;
                } else {
                    String directoryToSavePDF = ((NewsArticleRequest)dataMap.ddeRequest()).directoryToSavePDF();
                    String articleId = ((NewsArticleRequest)dataMap.ddeRequest()).articleId();
                    String path = directoryToSavePDF.trim() + "\\" + articleId + ".pdf";
                    String result = Utils.saveTextToPDF(path, dataMap.getString());
                    if (result == null) {
                        ret = "Binary/PDF news article [" + articleId + ".pdf] was saved to: " + directoryToSavePDF;
                    } else {
                        ret = "Binary/PDF news article [" + articleId + ".pdf] was NOT saved. Error: " + result;
                    }
                }
                updateNewsArticleRequestStatus(tickRequest.requestId(), dataMap, DdeRequestStatus.FINISHED);
            } else {
                ret = handleTickRequest(tickRequest, dataMap);
            }
        }
        return ret;
    }
    
    /** Method returns array with long value */
    public byte[] handleNewsArticleLongValueRequest(String requestStr) {
        TickRequest tickRequest = m_requestParser.parseTickRequest(requestStr, DdeRequestType.NEWS_ARTICLE_TICK);
        
        System.out.println("Handling news article long value request: id=" + tickRequest.requestId() + " tickType=" + tickRequest.tickType());
        BaseStringDataMap dataMap = m_newsArticleRequests.get(tickRequest.requestId());
        byte[] bytes = null;
        if(dataMap != null) {
            int articleType = dataMap.getInt();
            String articleText = dataMap.getString();
            if(articleType == 0 && articleText != null) {
                bytes = Utils.longStringValueToByteArray(articleText);
            }
        }
        return bytes;
    }

    /** Method handles news bulletins request */
    public String handleNewsBulletinsRequest(String requestStr) {
        if (m_newsBulletinsRequestStatus == DdeRequestStatus.UNKNOWN) {
            m_newsBulletinsRequest = m_requestParser.parseNewsBulletinsRequest(requestStr);
            System.out.println("Handling news bulletins request.");
            clientSocket().reqNewsBulletins(m_newsBulletinsRequest.allMsgs());
            m_newsBulletinsRequestStatus = DdeRequestStatus.REQUESTED;
        }
        return m_newsBulletinsRequestStatus.toString();
    }

    /** Method handles news bulletins array request */
    public byte[] handleNewsBulletinsArrayRequest(String requestStr) {
       byte[] array = null;
        if (m_newsBulletinsRequestStatus == DdeRequestStatus.RECEIVED) {
            System.out.println("Handling news bulletins array request.");
            array = Utils.dataListToByteArray(syncCopyNewsBulletins());
            m_newsBulletinsRequestStatus = DdeRequestStatus.SUBSCRIBED;
            m_newsBulletins.clear();
            notifyDde(DdeRequestType.REQ_NEWS_BULLETINS.topic(), m_newsBulletinsRequest.ddeRequestString());
        }
        return array;
    }

    /** Method handles news bulletins cancel */
    public String handleNewsBulletinsCancel(String requestStr) {
        if (m_newsBulletinsRequestStatus == DdeRequestStatus.SUBSCRIBED) {
            System.out.println("Handling news bulletins cancel.");
            clientSocket().cancelNewsBulletins();
            m_newsBulletinsRequestStatus = DdeRequestStatus.UNKNOWN;
            m_newsBulletins.clear();
        }
        return m_newsBulletinsRequestStatus.toString();
    }    
    
    /* *****************************************************************************************************
     *                                          Responses
    /* *****************************************************************************************************/
    
    /** Method updates news data for requestId */
    public void updateNewsData(int requestId, NewsData newsData, DdeRequestType ddeRequestType) {
        BaseListDataMap<NewsData> dataMap = m_newsRequests.get(requestId);
        if(dataMap != null) {
            dataMap.addItem(newsData);
            if (ddeRequestType == DdeRequestType.NEWS_TICKS_TICK) {
                updateDataEnd(requestId, dataMap, ddeRequestType.topic());
            }
        }
    }
    
    /** Method updates news data end for requestId */
    public void updateNewsDataEnd(int requestId, DdeRequestType ddeRequestType) {
        updateDataEnd(requestId, m_newsRequests.get(requestId), ddeRequestType.topic());
    }
    
    
    /** Method updates news ticks request error field for requestId */
    public void updateNewsDataRequestError(int requestId, String errorMsgStr, DdeRequestType ddeRequestType) {
        updateRequestError(requestId, errorMsgStr, m_newsRequests.get(requestId), ddeRequestType.topic());
    }

    /** Method updates news request status field for requestId */
    public void updateNewsRequestStatus(int requestId, BaseDataMap dataMap, DdeRequestStatus status, String topic) {
        updateRequestStatus(requestId, dataMap, status, topic);
    }
    
    public void updateNewsProviders(NewsProvider[] newsProviders) {
        m_newsProviders = Arrays.asList(newsProviders);
        m_newsProvidersRequestStatus = DdeRequestStatus.RECEIVED;
        notifyDde(DdeRequestType.REQ_NEWS_PROVIDERS.topic(), RequestParser.ID_ZERO);
    }
    
    /** Method updates news article for requestId */
    public void updateNewsArticle(int requestId, int articleType, String articleText) {
        BaseStringDataMap dataMap = m_newsArticleRequests.get(requestId);
        if(dataMap != null) {
            dataMap.setInt(articleType);
            dataMap.setString(articleText);
            notifyDde(requestId, DdeRequestType.NEWS_ARTICLE_TICK.topic(), DdeRequestType.NEWS_ARTICLE.topic());
        }
    }

    /** Method updates news article request status field for requestId */
    public void updateNewsArticleRequestStatus(int requestId, BaseStringDataMap dataMap, DdeRequestStatus status) {
        updateRequestStatus(requestId, dataMap, status, DdeRequestType.NEWS_ARTICLE_TICK.topic());
    }

    /** Method updates news article request error field for requestId */
    public void updateNewsArticleRequestError(int requestId, String errorMsgStr) {
        updateRequestError(requestId, errorMsgStr, m_newsArticleRequests.get(requestId), DdeRequestType.NEWS_ARTICLE_TICK.topic());
    }
    
    /** Method saves news bulletin */
    public void updateNewsBulletinData(NewsBulletinData newsBulletinData) {
        if (m_newsBulletinsRequest != null) {
            m_newsBulletins.add(newsBulletinData);
            m_newsBulletinsRequestStatus = DdeRequestStatus.RECEIVED;
            notifyDde(DdeRequestType.REQ_NEWS_BULLETINS.topic(), m_newsBulletinsRequest.ddeRequestString());
        }
    }
    

    /* *****************************************************************************************************
     *                                          Other methods
    /* *****************************************************************************************************/
    private List<NewsData> syncCopyNewsData(int requestId) {
        synchronized(m_newsRequests) {
            BaseListDataMap<NewsData> dataMap = m_newsRequests.get(requestId);
            return (dataMap != null ? dataMap.syncCopyList() : new ArrayList<NewsData>());
        }
    }
    
    private List<NewsProvider> syncCopyNewsProviders() {
        synchronized(m_newsProviders) {
            return new ArrayList<NewsProvider>(m_newsProviders);
        }
    }

    private List<NewsBulletinData> syncCopyNewsBulletins() {
        synchronized(m_newsBulletins) {
            return new ArrayList<NewsBulletinData>(m_newsBulletins);
        }
    }
    
    /* *****************************************************************************************************
     *                                          Parser
    /* *****************************************************************************************************/
    /** Class represents parser which parses DDE request strings to appropriate requests */
    private class NewsRequestParser extends RequestParser {

        /** Method parses DDE request string to NewsTicksRequest */
        public NewsTicksRequest parseNewsTicksRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            Contract contract = parseContract(table, true, true, true, false, false);
            
            return new NewsTicksRequest(requestId, contract, requestStr);
        }
        
        /** Method parses DDE request string to HistoricalNewsRequest */
        public HistoricalNewsRequest parseHistoricalNewsRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            
            int conId = 0;
            String providerCodes = "";
            String startDateTime = "";
            String endDateTime = "";
            int totalResults = 0;

            if (table.size() < 5) {
                System.out.println("Cannot extract historical news request fields");
                return null;
            }
            
            if (Utils.isNotNull(table.get(0))) {
                conId = getIntFromString(table.get(0));
            }
            if (Utils.isNotNull(table.get(1))) {
                providerCodes = table.get(1);
            }
            if (Utils.isNotNull(table.get(2))) {
                startDateTime = table.get(2);
            }
            if (Utils.isNotNull(table.get(3))) {
                endDateTime = table.get(3);
            }
            if (Utils.isNotNull(table.get(4))) {
                totalResults = getIntFromString(table.get(4));
            }
            return new HistoricalNewsRequest(requestId, conId, providerCodes, startDateTime, endDateTime, totalResults, requestStr);
        }
        
        /** Method parses DDE request string to NewsArticleRequest */
        public NewsArticleRequest parseNewsArticleRequest(String requestStr, byte[] data) {
            if (data == null) {
                return null;
            }
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            ArrayList<String> table = Utils.convertArrayToTable(data);
            
            String providerCode = "";
            String articleId = "";
            String directoryToSavePDF = "";

            if (table.size() < 3) {
                System.out.println("Cannot extract news article request fields");
                return null;
            }
            
            if (Utils.isNotNull(table.get(0))) {
                providerCode = table.get(0);
            }
            if (Utils.isNotNull(table.get(1))) {
                articleId = table.get(1);
            }
            if (Utils.isNotNull(table.get(2))) {
                directoryToSavePDF = table.get(2);
            }
            return new NewsArticleRequest(requestId, providerCode, articleId, directoryToSavePDF, requestStr);
        }
        
        /** Method parses DDE request string to NewsBulletinsRequest */
        public NewsBulletinsRequest parseNewsBulletinsRequest(String requestStr) {
            int requestId = -1;
            String[] messageTokens = requestStr.split(DDE_REQUEST_SEPARATOR_PARSE);
            if (messageTokens.length > 0) {
                requestId = parseRequestId(messageTokens[0]);
            }
            boolean allMessages = false;
            if (messageTokens.length > 1) {
                allMessages = getBooleanFromString(messageTokens[1]);
            }
            return new NewsBulletinsRequest(requestId, allMessages, requestStr);
        }        
    }
}
