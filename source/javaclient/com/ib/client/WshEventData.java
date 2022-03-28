/* Copyright (C) 2022 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.client;

public class WshEventData {

    private int m_conId;
    private String m_filter;
    private boolean m_fillWatchlist;
    private boolean m_fillPortfolio;
    private boolean m_fillCompetitors;

    public int conId() { return m_conId; }
    public String filter() { return m_filter; }
    public boolean fillWatchlist() { return m_fillWatchlist; }
    public boolean fillPortfolio() { return m_fillPortfolio; }
    public boolean fillCompetitors() { return m_fillCompetitors; }

    public WshEventData(int conId) {
        m_conId = conId;
        m_filter = "";
        m_fillWatchlist = false;
        m_fillPortfolio = false;
        m_fillCompetitors = false;
    }

    public WshEventData(String filter, boolean fillWatchlist, boolean fillPortfolio, boolean fillCompetitors) {
        m_conId = Integer.MAX_VALUE;
        m_filter = filter;
        m_fillWatchlist = fillWatchlist;
        m_fillPortfolio = fillPortfolio;
        m_fillCompetitors = fillCompetitors;
    }

}
