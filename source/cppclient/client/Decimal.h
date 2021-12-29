/* Copyright (C) 2021 Interactive Brokers LLC. All rights reserved. This code is subject to the terms
 * and conditions of the IB API Non-Commercial License or the IB API Commercial License, as applicable. */

#pragma once
#ifndef TWS_API_CLIENT_DECIMAL_H
#define TWS_API_CLIENT_DECIMAL_H

#include <sstream>

// Decimal type
typedef unsigned long long Decimal;

#define UNSET_DECIMAL ULLONG_MAX

// external functions
extern "C" Decimal __bid64_add(Decimal, Decimal, unsigned int, unsigned int*);
extern "C" Decimal __bid64_sub(Decimal, Decimal, unsigned int, unsigned int*);
extern "C" Decimal __bid64_mul(Decimal, Decimal, unsigned int, unsigned int*);
extern "C" Decimal __bid64_div(Decimal, Decimal, unsigned int, unsigned int*);
extern "C" Decimal __bid64_from_string(char*, unsigned int, unsigned int*);
extern "C" void __bid64_to_string(char*, Decimal, unsigned int*);

// static functions
static Decimal add(Decimal decimal1, Decimal decimal2) {
    unsigned int flags;
    return __bid64_add(decimal1, decimal2, 0, &flags);
}

static Decimal sub(Decimal decimal1, Decimal decimal2) {
    unsigned int flags;
    return __bid64_sub(decimal1, decimal2, 0, &flags);
}

static Decimal mul(Decimal decimal1, Decimal decimal2) {
    unsigned int flags;
    return __bid64_mul(decimal1, decimal2, 0, &flags);
}

static Decimal div(Decimal decimal1, Decimal decimal2) {
    unsigned int flags;
    return __bid64_div(decimal1, decimal2, 0, &flags);
}

static Decimal stringToDecimal(std::string str) {
    unsigned int flags;
    if (str.compare(std::string{ "2147483647" }) == 0 || str.compare(std::string{ "9223372036854775807" }) == 0 || str.compare(std::string{ "1.7976931348623157E308" }) == 0) {
        str.clear();
    }
    return __bid64_from_string(const_cast<char*>(str.c_str()), 0, &flags);
}

static std::string decimalToString(Decimal value) {
    char buf[64];
    unsigned int flags;
    __bid64_to_string(buf, value, &flags); // convert Decimal value to string using bid64_to_string function
    return buf;
}

static std::string decimalStringToDisplay(Decimal value) {
    // convert string with scientific notation to string with decimal notation (e.g. +1E-2 to 0.01)
    return std::to_string(atof(decimalToString(value).c_str()));
}

#endif
