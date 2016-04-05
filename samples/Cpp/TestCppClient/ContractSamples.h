#pragma once
#ifndef CONTRACTSAMPLE
#define CONTRACTSAMPLE

class Contract;

class ContractSamples {
public:
	static Contract EurGbpFx();
	static Contract Index();
	static Contract CFD();
	static Contract EuropeanStock();
	static Contract OptionAtIse();
	static Contract USStock();
	static Contract USStockAtSmart();
	static Contract USOptionContract();
	static Contract OptionAtBox();
	static Contract NormalOption();
	static Contract OptionWithTradingClass();
	static Contract OptionWithLoacalSymbol();
	static Contract SimpleFuture();
	static Contract FutureWithLocalSymbol();
	static Contract FutureWithMultiplier();
	static Contract WrongContract();
	static Contract FuturesOnOptions();
	static Contract ByISIN();
	static Contract ByConId();
	static Contract OptionForQuery();
	static Contract StockComboContract();
	static Contract FutureComboContract();
	static Contract OptionComboContract();
};

#endif