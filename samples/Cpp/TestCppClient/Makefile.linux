CXX=g++
CXXFLAGS=-pthread -Wall -Wno-switch -Wpedantic -Wno-unused-function -std=c++11
ROOT_DIR=../../../source/cppclient
BASE_SRC_DIR=${ROOT_DIR}/client
INCLUDES=-I${BASE_SRC_DIR} -I${ROOT_DIR}
SHARED_LIB_DIRS=${BASE_SRC_DIR}
SHARD_LIBS=libTwsSocketClient.so
TARGET=TestCppClient

$(TARGET)Static:
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(BASE_SRC_DIR)/*.cpp ./*.cpp $(BASE_SRC_DIR)/lib/libbid.a -o$(TARGET)Static

$(TARGET):
	$(CXX) $(CXXFLAGS) $(INCLUDES) ./*.cpp $(BASE_SRC_DIR)/lib/libbid.so $(SHARED_LIB_DIRS)/$(SHARD_LIBS) -o$(TARGET)

clean:
	rm -f $(TARGET) $(TARGET)Static *.o

