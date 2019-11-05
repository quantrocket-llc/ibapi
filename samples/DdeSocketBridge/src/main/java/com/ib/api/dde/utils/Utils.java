/* Copyright (C) 2019 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

package com.ib.api.dde.utils;

import java.io.ByteArrayOutputStream;
import java.io.DataOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Base64;
import java.util.Date;
import java.util.Hashtable;
import java.util.List;
import java.util.regex.Pattern;

import javax.xml.transform.OutputKeys;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;

import com.ib.api.dde.dde2socket.requests.DdeRequestType;
import com.ib.api.dde.dde2socket.requests.parser.RequestParser;
import com.ib.api.dde.socket2dde.data.AccountUpdateData;
import com.ib.api.dde.socket2dde.data.ExecutionData;
import com.ib.api.dde.socket2dde.data.NewsBulletinData;
import com.ib.api.dde.socket2dde.data.NewsData;
import com.ib.api.dde.socket2dde.data.PositionData;
import com.ib.api.dde.socket2dde.data.ScannerData;
import com.ib.api.dde.socket2dde.data.SecDefOptParamsData;
import com.ib.api.dde.socket2dde.data.SmartComponentData;
import com.ib.api.dde.socket2dde.data.TickByTickData;
import com.ib.client.Bar;
import com.ib.client.ComboLeg;
import com.ib.client.Contract;
import com.ib.client.ContractDescription;
import com.ib.client.ContractDetails;
import com.ib.client.DeltaNeutralContract;
import com.ib.client.DepthMktDataDescription;
import com.ib.client.Execution;
import com.ib.client.ExecutionCondition;
import com.ib.client.FamilyCode;
import com.ib.client.HistogramEntry;
import com.ib.client.MarginCondition;
import com.ib.client.NewsProvider;
import com.ib.client.Order;
import com.ib.client.OrderComboLeg;
import com.ib.client.OrderCondition;
import com.ib.client.PercentChangeCondition;
import com.ib.client.PriceCondition;
import com.ib.client.PriceIncrement;
import com.ib.client.SoftDollarTier;
import com.ib.client.TagValue;
import com.ib.client.TickType;
import com.ib.client.TimeCondition;
import com.ib.client.Types.SecType;
import com.ib.client.VolumeCondition;

/** Class contains some utility methods */
public class Utils {
    // some constants
    public static final String IMPLIED_VOL_STR = "ImpliedVol";
    public static final String OPT_PRICE_STR = "OptPrice";
    public static final String UND_PRICE_STR = "UndPrice";
    public static final String PV_DIVIDEND_STR = "PvDividend";
    public static final String DELTA_STR = "Delta";
    public static final String GAMMA_STR = "Gamma";
    public static final String VEGA_STR = "Vega";
    public static final String THETA_STR = "Theta";

    public static final String HOLD_DAYS_STR = "HoldDays";
    public static final String FUTURE_EXPIRY_STR = "FutureExpiry";
    public static final String DIVIDENDS_TO_EXPIRY_STR = "DividendsToExpiry";
    public static final String BASIS_POINTS_STR = "BasisPoints";
    public static final String FORMATTED_BASIS_POINTS_STR = "FormattedBasisPoints";
    public static final String IMPLIED_FUTURE_STR = "ImpliedFuture";
    public static final String DIVIDEND_IMPACT_STR = "DividendImpact";

    public static final String TIME = "time";
    public static final String PRICE = "price";
    public static final String SIZE = "size";
    public static final String PAST_LIMIT = "pastLimit";
    public static final String UNREPORTED = "unreported";
    public static final String BID_PRICE = "bidPrice";
    public static final String ASK_PRICE = "askPrice";
    public static final String BID_SIZE = "bidSize";
    public static final String ASK_SIZE = "askSize";
    public static final String BID_PAST_LOW = "bidPastLow";
    public static final String ASK_PAST_HIGH = "askPastHigh";
    public static final String MIDPOINT = "midPoint";

    public static final String POSITION = "position";
    public static final String DAILY_PNL = "dailyPnL";
    public static final String UNREALIZED_PNL = "unrealizedPnL";
    public static final String REALIZED_PNL = "realizedPnL";
    public static final String VALUE = "value";

    public static final String MARKET_DATA_TYPE = "mktDataType";

    public static final String MIN_TICK = "minTick";
    public static final String BBO_EXCHANGE = "bboExchange";
    public static final String SNAPSHOT_PERMISSIONS = "snapshotPermissions";
    
    public static final String LONGVALUE = "LONGVALUE";
    
    @SuppressWarnings("serial")
    static final Hashtable<Integer, String> delayedToRegularMap = new Hashtable<Integer, String>() {{
        put(TickType.DELAYED_BID.index(), TickType.BID.field());
        put(TickType.DELAYED_ASK.index(), TickType.ASK.field());
        put(TickType.DELAYED_LAST.index(), TickType.LAST.field());
        put(TickType.DELAYED_BID_SIZE.index(), TickType.BID_SIZE.field());
        put(TickType.DELAYED_ASK_SIZE.index(), TickType.ASK_SIZE.field());
        put(TickType.DELAYED_LAST_SIZE.index(), TickType.LAST_SIZE.field());
        put(TickType.DELAYED_HIGH.index(), TickType.HIGH.field());
        put(TickType.DELAYED_LOW.index(), TickType.LOW.field());
        put(TickType.DELAYED_VOLUME.index(), TickType.VOLUME.field());
        put(TickType.DELAYED_CLOSE.index(), TickType.CLOSE.field());
        put(TickType.DELAYED_OPEN.index(), TickType.OPEN.field());
        put(TickType.DELAYED_BID_OPTION.index(), TickType.BID_OPTION.field());
        put(TickType.DELAYED_ASK_OPTION.index(), TickType.ASK_OPTION.field());
        put(TickType.DELAYED_LAST_OPTION.index(), TickType.LAST_OPTION.field());
        put(TickType.DELAYED_MODEL_OPTION.index(), TickType.MODEL_OPTION.field());
    }};

    /** Method decodes string to byte array and saves it to PDF file 
     * Returns error or nul if succeeded */
    public static String saveTextToPDF(String path, String text) {
        byte[] bytes = Base64.getDecoder().decode(text);
        FileOutputStream fos = null;
        try {
            fos = new FileOutputStream(path);
            fos.write(bytes);
            fos.close();
            return null;
        } catch (IOException e) {
            System.out.println("Error saving binary/PDF: " + e.getMessage());
            return e.getMessage();
        }
    }
    
    /** Method converts long string value (>=255 symbols) to byte array */
    public static byte[] longStringValueToByteArray(String longStringValue) {
        ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
        ArrayList<String> item = new ArrayList<String>();
        // split long error message into substrings with length = 255, then merge these substrings in Excel
        item.addAll(Utils.chunkStringByLength(longStringValue, 255));
        list.add(new ArrayList<String>(item));
        item.clear();
        return list.size() > 0 ? Utils.convertTableToByteArray(list) : null;
    }
    
    /** Method converts data list to byte array */
    public static <T> byte[] dataListToByteArray(List<T> dataList) {
        return dataListToByteArray(dataList, false);
    }
    
    /** Method converts data list to byte array */
    public static <T> byte[] dataListToByteArray(List<T> dataList, boolean bValue1) {
        return dataListToByteArray(dataList, bValue1, DdeRequestType.NOTHING);
    }

    /** Method converts data list to byte array */
    public static <T> byte[] dataListToByteArray(List<T> dataList, boolean bValue1, DdeRequestType ddeRequestType) {
        return dataListToByteArray(dataList, bValue1, false, ddeRequestType);
    }

    /** Method converts data list to byte array */
    public static <T> byte[] dataListToByteArray(List<T> dataList, boolean bValue1, boolean bValue2) {
        return dataListToByteArray(dataList, bValue1, bValue2, DdeRequestType.NOTHING);
    }
    
    /** Method converts data list to byte array */
    public static <T> byte[] dataListToByteArray(List<T> dataList, boolean bValue1, boolean bValue2, DdeRequestType ddeRequestType) {
        ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
        for (int i = 0; i < dataList.size(); i++) {
            T data = dataList.get(i);
            ArrayList<String> item = createTableItem(data, bValue1, bValue2, ddeRequestType);
            if (item != null) {
                list.add(new ArrayList<String>(item));
                item.clear();
            }
        }
        byte[] bytes = list.size() > 0 ? Utils.convertTableToByteArray(list) : null;
        return bytes;
    }
    
    /** Method creates single table row (array of strings) from data */ 
    private static <T> ArrayList<String> createTableItem(T data, boolean bValue1, boolean bValue2, DdeRequestType ddeRequestType) {
        if (data instanceof SecDefOptParamsData) {
            return SecDefOptParamsUtils.createTableItem((SecDefOptParamsData)data);
        }
        if (data instanceof Bar) {
            return HistoricalDataUtils.createTableItem((Bar)data);
        }
        if (data instanceof TickByTickData) {
            return HistoricalDataUtils.createTableItem((TickByTickData)data);
        }
        if (data instanceof ScannerData) {
            return MarketScannerUtils.createTableItem((ScannerData)data);
        }
        if (data instanceof ExecutionData) {
            return ExecutionsUtils.createTableItem((ExecutionData)data, bValue1);
        }
        if (data instanceof ContractDetails) {
            return bValue1 ? ContractDetailsUtils.createTableItemFixedIncome((ContractDetails)data) : 
                    ContractDetailsUtils.createTableItem((ContractDetails)data);
        }
        if (data instanceof PositionData) {
            return PositionsUtils.createTableItem((PositionData)data, ddeRequestType, bValue1, bValue2);
        }
        if (data instanceof AccountUpdateData) {
            return AccountUpdatesUtils.createTableItem((AccountUpdateData)data, bValue1, bValue2);
        }
        if (data instanceof FamilyCode) {
            return AccountUpdatesUtils.createTableItem((FamilyCode)data);
        }
        if (data instanceof ContractDescription) {
            return ContractDetailsUtils.createTableItem((ContractDescription)data);
        }
        if (data instanceof DepthMktDataDescription) {
            return MarketDepthUtils.createTableItem((DepthMktDataDescription)data);
        }
        if (data instanceof NewsData) {
            return NewsUtils.createTableItem((NewsData)data, bValue1);
        }
        if (data instanceof NewsProvider) {
            return NewsUtils.createTableItem((NewsProvider)data);
        }
        if (data instanceof NewsBulletinData) {
            return NewsUtils.createTableItem((NewsBulletinData)data);
        }
        if (data instanceof PriceIncrement) {
            return ContractDetailsUtils.createTableItem((PriceIncrement)data);
        }
        if (data instanceof SmartComponentData) {
            return MiscUtils.createTableItem((SmartComponentData)data);
        }
        if (data instanceof SoftDollarTier) {
            return MiscUtils.createTableItem((SoftDollarTier)data);
        }
        if (data instanceof HistogramEntry) {
            return HistoricalDataUtils.createTableItem((HistogramEntry)data);
        }
        
        return null;
    }
    
    /** Method formats XML string with tabs and new lines */
    public static String formatXML(String input, int indent) {
        String ret = "";
        try {
            input = input.replaceAll(">\n*\r*\t*\\s*<", "><");
            Source xmlInput = new StreamSource(new StringReader(input));
            StringWriter stringWriter = new StringWriter();
            StreamResult xmlOutput = new StreamResult(stringWriter);
            TransformerFactory transformerFactory = TransformerFactory.newInstance();
            transformerFactory.setAttribute("indent-number", indent);
            Transformer transformer = transformerFactory.newTransformer(); 
            transformer.setOutputProperty(OutputKeys.INDENT, "yes");
            transformer.setOutputProperty(OutputKeys.OMIT_XML_DECLARATION, "yes");
            transformer.transform(xmlInput, xmlOutput);
            ret = xmlOutput.getWriter().toString();
        } catch (Exception e) {
            System.out.println("Error formatting XML: " + e.getMessage());
        }
        return ret;
    }
    
    /** Method converts xml to byte array */
    public static byte[] xmlToByteArray(String xml) {
        ArrayList<ArrayList<String>> list = new ArrayList<ArrayList<String>>();
        xml = formatXML(xml, 4);
        
        Pattern pattern = Pattern.compile("\\t");
        List<String> lines = Arrays.asList(xml.split("\\n"));
        for (String line : lines) {
            ArrayList<String> item = new ArrayList<String>();
            String itemStr = pattern.matcher(line).replaceAll("    ");
            int numOfChunks = Utils.calcNumOfChunks(itemStr, 255);
            if (Utils.isNotNull(itemStr) && numOfChunks > 1) {
                item.add(Utils.LONGVALUE + RequestParser.PARAM_SEPARATOR + numOfChunks);
                item.addAll(Utils.chunkStringByLength(itemStr, 255)); // long string
            } else {
                item.add(itemStr);
            }
            list.add(item);
        }
    
        byte[] bytes = list.size() > 0 ? Utils.convertTableToByteArray(list) : null;
        return bytes;
    }
    
    public static String longSecondsToDateTimeString(long longValueInSeconds, String format) {
        return new SimpleDateFormat(format).format(new Date(longValueInSeconds * 1000));
    }

    public static String longMilliSecondsToDateTimeString(long longValueInMilliSeconds, String format) {
        return new SimpleDateFormat(format).format(new Date(longValueInMilliSeconds));
    }
    
    public static long stringDateTimeToLong(String dateTime, String format) {
        try {
            return new SimpleDateFormat(format).parse(dateTime).getTime();
        } catch (ParseException e) {
            System.out.println("Error parsing date/time: " + e.getMessage());
        }
        return 0;
    }    
    
    public static boolean isFixedIncome(SecType secType) {
        return secType == SecType.BOND || secType == SecType.BILL || secType == SecType.FIXED;
    }
    
    /** Method compares two strings */
    public static int compare(String s1, String s2) {
        if (Utils.isNotNull(s1) && Utils.isNotNull(s2)) {
            int i = s1.compareTo(s2);
            if (i != 0) return i;
        } else if (Utils.isNotNull(s1)) {
            return -1;
        } else if (Utils.isNotNull(s2)) {
            return 1;
        }
        return Integer.MAX_VALUE;
    }        
    
    /** Method converts short value to byte array */
    private static byte[] convertShortToBytes(short value) {
        byte[] byteArray = new byte[2];
        byteArray[0] = (byte)(value & 0xFF);
        byteArray[1] = (byte)((value >>> 8) & 0xFF);
        return byteArray;
    }

    /** Method determines x-size of table */
    private static short determineTableSizeX(ArrayList<ArrayList<String>> table) {
        short sizeX = 0;
        for (int i = 0; i < table.size(); i++) {
            sizeX = (short)Math.max(sizeX, table.get(i).size());
        }
        return sizeX;
    }

    public static int calcNumOfChunks(String inputString, int numOfChar){
        if (numOfChar <= 0 || Utils.isNull(inputString)) {
            return 0;
        }
        int numOfChunks = (int)(inputString.length() / numOfChar) + 1;
        return numOfChunks;
    }
    
    /** Method splits string into substrings of numOfChar length */
    public static ArrayList<String> chunkStringByLength(String inputString, int numOfChar) {
        if (Utils.isNull(inputString) || numOfChar <= 0) {
            return null;
        }

        ArrayList<String> chunks = new ArrayList<String>();
        
        if (inputString.length() == numOfChar) {
            chunks.add(inputString);
        };

        int chunkCount = (int)Math.ceil(inputString.length() / numOfChar);
        for (int i = 0; i <= chunkCount; i++) {
            int endLen = numOfChar;
            if (i == chunkCount) {
                endLen = inputString.length() % numOfChar;
            }
            chunks.add(new String(inputString.getBytes(), i * numOfChar, endLen));
        }

        return chunks;
    }

    /** Method converts table (2D array) to byte array */
    public static byte[] convertTableToByteArray(ArrayList<ArrayList<String>> table) {

        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        DataOutputStream out = new DataOutputStream(baos);

         // 16,0;4,0;sizeY;sizeX;2,0;totalLenOfNextBlock;lenOfString;string;lenOfString;string;...
        try {
            out.write(convertShortToBytes((short)16)); // unknown
            out.write(convertShortToBytes((short)4)); // unknown
            short sizeY = (short)table.size();
            short sizeX = 0;
            if (sizeY != 0) {
                sizeX = determineTableSizeX(table);
            } else {
                // error empty table
                System.out.println("Table is empty");
                // send empty array (check this in VBA)
                out.write(convertShortToBytes((short)0));
                out.write(convertShortToBytes((short)0));
                out.write(convertShortToBytes((short)2)); // unknown
                out.close();
                baos.close();
                return baos.toByteArray();
            }
            out.write(convertShortToBytes(sizeY)); // sizeY
            out.write(convertShortToBytes(sizeX)); // sizeX
            out.write(convertShortToBytes((short)2)); // unknown
            int totalLength = 0;
            
            int maxIndexY = Short.toUnsignedInt(sizeY); 
            int maxIndexX = Short.toUnsignedInt(sizeX); 
            // calculate total length of block of items
            for (int j = 0; j < maxIndexY; j++) {
                for (int i = 0; i < maxIndexX; i++) {
                    int itemLength = 0;
                    if (i < table.get(j).size()) {
                        itemLength = table.get(j).get(i).length();
                    }
                    totalLength ++; // length of item (1 byte)
                    totalLength += itemLength; // item
                }
            }
            out.write(convertShortToBytes((short)totalLength)); // total length of block of items
            // write items
            for (int j = 0; j < maxIndexY; j++) {
                for (int i = 0; i < maxIndexX; i++) {
                    byte itemLength = (byte)"".length();
                    byte[] item = "".getBytes();
                    if (i < table.get(j).size()) {
                        itemLength = (byte)(table.get(j).get(i).length());
                        item = table.get(j).get(i).getBytes();
                    }
                    if (itemLength == 0) {
                        out.write((byte)0); // empty item
                    } else {
                        out.write(itemLength); // length of item
                        out.write(item); // item
                    }
                }
            }
            out.close();
            baos.close();
        } catch (IOException e) {
            System.out.println("Exception during table conversion: " + e.getMessage());
        }

        byte[] bytes = baos.toByteArray();

        return bytes;
    }
    
    /** Method converts byte array to short number */
    public short bytesToShort(byte[] bytes) {
        return ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).getShort();
    }    
    
    /** For debug only: method prints byte array as string */
    public static String print(byte[] bytes) {
        StringBuilder sb = new StringBuilder();
        sb.append("[ ");
        for (byte b : bytes) {
            sb.append(String.format("%d ", b));
        }
        sb.append("]");
        return sb.toString();
    }    
    
    /** Method converts byte array to table */
    public static ArrayList<String> convertArrayToTable(byte[] array) {
        ArrayList<String> table = new ArrayList<String>();
        ByteBuffer byteBuffer = ByteBuffer.wrap(array);
        byteBuffer.order(ByteOrder.LITTLE_ENDIAN);
        readHeader(byteBuffer);
          
        while(byteBuffer.hasRemaining()) {
            if (byteBuffer.getShort() == 5) { // empty cell marker
                // empty cell
                byteBuffer.getShort(); // always 2
                readEmptyBlock(byteBuffer, table);
            } else {
                // non-empty cell
                short totalLength = byteBuffer.getShort();
                readBlock(byteBuffer, totalLength, table);
            }
        }
        return table;
    }
    
    /** Method reads byte array/table header */
    private static void readHeader(ByteBuffer bb) {
        bb.getShort(); // unknown1 (always 16)
        bb.getShort(); // unknown2 (always 4)
        bb.getShort(); // sizeY
        bb.getShort(); // sizeX
    }
    
    /** Method reads byte array/table empty block */
    private static void readEmptyBlock(ByteBuffer bb, ArrayList<String> table) {
        short totalEmptyCells = bb.getShort(); // number of empty cells
        for (short i = 0; i < totalEmptyCells; i++) {
            table.add("");
        }
    }
    
    /** Method reads byte array/table block */
    private static void readBlock(ByteBuffer bb, short totalLength, ArrayList<String> table) {
        short count = 0;
        while (count < totalLength) {
            short length = (short)(bb.get() & 0xFF);
            count++;
            if (length ==  0) {
                table.add("");
            } else {
                StringBuffer sb = new StringBuffer();
                for (short i = 0; i < length; i++) {
                    sb.append((char)bb.get());
                    count++;
                }
                table.add(sb.toString());
            }
        }
    }
    
    /** For debug only: method creates short contract description */
    public static String shortContractString(Contract contract) {
        if (contract.conid() > 0 && contract.conid() != Integer.MAX_VALUE) {
            return contract.conid() + "@" + contract.exchange();
        }
        return contract.symbol() + " " + contract.secType().getApiString() + " " + contract.exchange() + " " + contract.currency();
    }

    /** For debug only: method creates short contract description */
    public static String shortOrderString(Order order) {
        StringBuilder sb = new StringBuilder();
        if (order.action() != null) {
            sb.append(order.action().getApiString()).append(" ");
        }
        sb.append(order.totalQuantity()).append(" ");
        if (order.orderType() != null) {
            sb.append(order.orderType().getApiString()).append(" ");
        }
        sb.append(order.lmtPrice());
        return sb.toString();
    }
    
    /** For debug only: method creates short execution description */
    public static String shortExecutionString(Execution execution) {
        StringBuilder sb = new StringBuilder();
        sb.append("OrderId: ").append(execution.orderId()).append(" ");
        sb.append("ExecId: ").append(execution.execId()).append(" ");
        sb.append("PermId: ").append(execution.permId()).append(" ");
        sb.append("Time: ").append(execution.time()).append(" ");
        sb.append("Account: ").append(execution.acctNumber()).append(" ");
        sb.append("Exchange: ").append(execution.exchange()).append(" ");
        sb.append("Side: ").append(execution.side()).append(" ");
        sb.append("Shares: ").append(execution.shares()).append(" ");
        sb.append("Price: ").append(execution.price()).append(" ");
        sb.append("CumQty: ").append(execution.cumQty()).append(" ");
        sb.append("AvgPrice: ").append(execution.avgPrice()).append(" ");
        sb.append("ModelCode: ").append(execution.modelCode()).append(" ");
        return sb.toString();
    }
    
    /** Method checks string for null */
    public static boolean isNotNull(String s) {
        return s != null && s.length() > 0;
    }

    /** Method checks string for null */
    public static boolean isNull(String s) {
        return s == null || s.length() == 0;
    }
    
    /** Method converts string to non-null string */
    public static String toString(String s) {
        return (s == null || s.isEmpty()) ? "" : s;
    }

    /** Method converts character to string */
    public static String toString(Character c) {
        return c.toString();
    }
    
    /** Method converts double to non-null string */
    public static String toString(Double d) {
        return (d == 0 || d == Double.MAX_VALUE) ? "" : String.valueOf(d);
    }

    /** Method converts double to non-null string with default value */
    public static String toString(Double d, String defaultString) {
        return (d == 0 || d == Double.MAX_VALUE) ? defaultString : String.valueOf(d);
    }
    
    /** Method converts integer to non-null string with default value */
    public static String toString(Integer i, String defaultString) {
        return (i == 0 || i == Integer.MAX_VALUE) ? defaultString : String.valueOf(i);
    }

    /** Method converts integer to non-null string */
    public static String toString(Integer i) {
        return (i == 0 || i == Integer.MAX_VALUE) ? "" : String.valueOf(i);
    }

    /** Method converts long to non-null string */
    public static String toString(Long l) {
        return (l == 0 || l == Long.MAX_VALUE) ? "" : String.valueOf(l);
    }

    /** Method converts long to non-null string with default value */
    public static String toString(Long l, String defaultString) {
        return (l == 0 || l == Long.MAX_VALUE) ? defaultString : String.valueOf(l);
    }
    
    /** Method converts boolean to non-null string */
    public static String toString(boolean b) {
        return b ? "1" : "0";
    }
    
    /** Method converts SoftDollarTier to non-null string */
    public static String toString(SoftDollarTier softDollarTier) {
        StringBuilder sb = new StringBuilder();
        if (softDollarTier != null) {
            if (Utils.isNotNull(softDollarTier.name())){
                sb.append(softDollarTier.name()).append(";");
            }
            if (Utils.isNotNull(softDollarTier.value())){
                sb.append(softDollarTier.value()).append(";");
            }
            if (Utils.isNotNull(softDollarTier.toString())){
                sb.append(softDollarTier.toString());
            }
        }
        return sb.toString();
    }

    /** Method converts TagValue list to non-null string */
    public static String tagValueListToString(List<TagValue> tagValueList) {
        StringBuilder sb = new StringBuilder();
        if (tagValueList != null) {
            for (TagValue tagValue : tagValueList) {
                sb.append(tagValue.m_tag).append("=").append(tagValue.m_value).append(";");
            }
        }
        return sb.toString();
    }

    /** Method converts OrderComboLegs list to non-null string */
    public static String orderComboLegsListToString(List<OrderComboLeg> orderComboLegs) {
        StringBuilder sb = new StringBuilder();
        if (orderComboLegs != null) {
            for (OrderComboLeg orderComboLeg : orderComboLegs) {
                sb.append(orderComboLeg.price()).append(";");
            }
        }
        return sb.toString();
    }

    /** Method converts ComboLegs list to non-null string */
    public static String comboLegsListToString(List<ComboLeg> comboLegs) {
        StringBuilder sb = new StringBuilder();
        if (comboLegs != null && comboLegs.size() > 0) {
            sb.append(comboLegs.size()).append("_");
            for (ComboLeg comboLeg : comboLegs) {
                sb.append(comboLeg.conid()).append("_");
                sb.append(comboLeg.ratio()).append("_");
                sb.append(comboLeg.getAction()).append("_");
                sb.append(comboLeg.exchange()).append("_");
                sb.append(comboLeg.getOpenClose()).append("_");
                sb.append(comboLeg.shortSaleSlot() > 0 ? comboLeg.shortSaleSlot() : "~").append("_");
                sb.append(isNotNull(comboLeg.designatedLocation()) ? comboLeg.designatedLocation() : "~").append("_");
                sb.append(comboLeg.exemptCode() > -1 ? comboLeg.exemptCode() : "~").append("_");
            }
        }
        return sb.toString();
    }

    /** Method converts DeltaNeutralContract to non-null string */
    public static String deltaNeutralContractToString(DeltaNeutralContract deltaNeutralContract) {
        StringBuilder sb = new StringBuilder();
        if (deltaNeutralContract != null) {
            sb.append(deltaNeutralContract.conid()).append("_");
            sb.append(deltaNeutralContract.delta()).append("_");
            sb.append(deltaNeutralContract.price());
        }
        return sb.toString();
    }
    
    /** Method converts OrdeConditions list to non-null string */
    public static String conditionsToString(List<OrderCondition> orderConditions) {
        StringBuilder sb = new StringBuilder();
        if (orderConditions != null) {
            for (OrderCondition orderCondition : orderConditions) {
                sb.append(orderCondition.type()).append("_");
                switch (orderCondition.type()) {
                case Execution:
                    sb.append(((ExecutionCondition)orderCondition).symbol()).append("_");
                    sb.append(((ExecutionCondition)orderCondition).secType()).append("_");
                    sb.append(((ExecutionCondition)orderCondition).exchange()).append(";");
                    break;
                case Margin:
                    sb.append(((MarginCondition)orderCondition).isMore()).append("_");
                    sb.append(((MarginCondition)orderCondition).percent()).append(";");
                    break;
                case PercentChange:
                    sb.append(((PercentChangeCondition)orderCondition).isMore()).append("_");
                    sb.append(((PercentChangeCondition)orderCondition).conId()).append("_");
                    sb.append(((PercentChangeCondition)orderCondition).exchange()).append("_");
                    sb.append(((PercentChangeCondition)orderCondition).changePercent()).append(";");
                    break;
                case Price:
                    sb.append(((PriceCondition)orderCondition).isMore()).append("_");
                    sb.append(((PriceCondition)orderCondition).conId()).append("_");
                    sb.append(((PriceCondition)orderCondition).exchange()).append("_");
                    sb.append(((PriceCondition)orderCondition).price()).append("_");
                    sb.append(((PriceCondition)orderCondition).triggerMethod()).append(";");
                    break;
                case Time:
                    sb.append(((TimeCondition)orderCondition).isMore()).append("_");
                    sb.append(((TimeCondition)orderCondition).time()).append(";");
                    break;
                case Volume:
                    sb.append(((VolumeCondition)orderCondition).isMore()).append("_");
                    sb.append(((VolumeCondition)orderCondition).conId()).append("_");
                    sb.append(((VolumeCondition)orderCondition).exchange()).append("_");
                    sb.append(((VolumeCondition)orderCondition).volume()).append(";");
                    break;            
                }
            }
        }
        return sb.toString();
    }

    /** Method converts integer TickType value to TickType string.
     * Also replaces delayed TickType strings with regular */
    public static String getField(int field) {
        return delayedToRegularMap.containsKey(field) ? delayedToRegularMap.get(field) : TickType.getField(field);
    }
}
