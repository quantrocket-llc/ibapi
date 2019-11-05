/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.io.OutputStream;
import java.io.PrintStream;
import java.text.SimpleDateFormat;
import java.util.Date;

public class DdeSocketBridgePrintStream extends PrintStream {

    public DdeSocketBridgePrintStream(OutputStream out) {
        super(out);
    }
    
    @Override
    public void println(String string) {
        super.println(timestamp() + string);
    }
    
    public static String timestamp() {
        return new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS ").format(new Date(System.currentTimeMillis()));
    }
}
