cmake_minimum_required( VERSION 3.0 )
project( IBKR
         LANGUAGES CXX )

# this is the TWS api library, use this target for your own programs
add_library( twsapi
    source/cppclient/client/ContractCondition.cpp
    source/cppclient/client/DefaultEWrapper.cpp
    source/cppclient/client/EClient.cpp
    source/cppclient/client/EClientSocket.cpp
    source/cppclient/client/EDecoder.cpp
    source/cppclient/client/EMessage.cpp
    source/cppclient/client/EMutex.cpp
    source/cppclient/client/EOrderDecoder.cpp
    source/cppclient/client/EReader.cpp
    source/cppclient/client/EReaderOSSignal.cpp
    source/cppclient/client/ESocket.cpp
    source/cppclient/client/executioncondition.cpp
    source/cppclient/client/MarginCondition.cpp
    source/cppclient/client/OperatorCondition.cpp
    source/cppclient/client/OrderCondition.cpp
    source/cppclient/client/PercentChangeCondition.cpp
    source/cppclient/client/PriceCondition.cpp
    source/cppclient/client/SoftDollarTier.cpp
    source/cppclient/client/StdAfx.cpp
    source/cppclient/client/TimeCondition.cpp
    source/cppclient/client/VolumeCondition.cpp
)

# TestCppClient has includes both with and without "client/" prefixed!
# (Users of the API may do the same thing. Let's add support for both cases lest we break/complicate anything.)
target_include_directories( twsapi
    INTERFACE
        source/cppclient/
        source/cppclient/client/
)

# On Windows (including MinGW), link against Winsock 2
if( WIN32 )
    target_link_libraries( twsapi
        PUBLIC
            ws2_32
    )
endif()

option( IBKR_BUILD_TESTCPPCLIENT "Whether or not to build the TWS API example/test client" FALSE )
if( IBKR_BUILD_TESTCPPCLIENT )
    # this is the example/test client
    add_executable( TestCppClient
        samples/Cpp/TestCppClient/AccountSummaryTags.cpp
        samples/Cpp/TestCppClient/AvailableAlgoParams.cpp
        samples/Cpp/TestCppClient/ContractSamples.cpp
        samples/Cpp/TestCppClient/Main.cpp
        samples/Cpp/TestCppClient/OrderSamples.cpp
        samples/Cpp/TestCppClient/ScannerSubscriptionSamples.cpp
        samples/Cpp/TestCppClient/StdAfx.cpp
        samples/Cpp/TestCppClient/TestCppClient.cpp
        samples/Cpp/TestCppClient/Utils.cpp
    )

    # set example's own include dirs
    target_include_directories( TestCppClient
        PUBLIC
            samples/Cpp/TestCppClient/
    )

    # link/include example against the lib
    target_link_libraries( TestCppClient
        PRIVATE
            twsapi
    )

    # link example against thread library
    find_package( Threads )
    target_link_libraries( TestCppClient
        PUBLIC
            Threads::Threads
    )

    if( MSVC )
        target_compile_options( TestCppClient PRIVATE /W3 )
    else()
        target_compile_options( TestCppClient PRIVATE -Wall -Wextra -pedantic -Wno-unused-parameter )
    endif()
endif()

if( MSVC )
    target_compile_options( twsapi PRIVATE /W3 )
else()
    target_compile_options( twsapi PRIVATE -Wall -Wextra -pedantic -Wno-unused-parameter )
endif()
