CXX=g++
CXXFLAGS=-pthread -Wall -Wno-switch -Wno-unused-function -std=c++11 -shared -fPIC
ROOT_DIR=.
BASE_SRC_DIR=${ROOT_DIR}
INCLUDES=-I${ROOT_DIR}
TARGET=libTwsSocketClient.so

$(TARGET):
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(BASE_SRC_DIR)/*.cpp lib/libbid.so -o$(TARGET)

clean:
	rm -f $(TARGET) *.o

