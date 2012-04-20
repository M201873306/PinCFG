PINTOOL = IFR_PinDriver.so
MARKDOWN = /usr/bin/markdown

SRCS = IFR_BasicBlock.cpp IFR_MemoryRef.cpp

BLDTYPE=pin
ifeq ($(BLDTYPE),pin)
PIN_KIT=$(PIN_HOME)
KIT=1
include $(PIN_HOME)/source/tools/makefile.gnu.config
CXXFLAGS += -DPIN
SRCS += IFR_PinDriver.cpp
TARG = $(PINTOOL)
else
CXXFLAGS += -UPIN
LDFLAGS = -lpthread -ldl
SRCS += CacheTestDriver.cpp
TARG = $(PROG)
endif


CXXFLAGS += -I. -g -O0 -Wno-deprecated 

OBJS = $(SRCS:%.cpp=%.o)
FACOBJS = $(FACSRCS:%.cpp=%.so)


all: $(TARG)


## build rules
%.o : %.cpp
	$(CXX) -c $(CXXFLAGS) $(PIN_CXXFLAGS) -o $@ $<

%.so : %.cpp
	$(CXX) -fPIC -shared $(CXXFLAGS) $(PIN_CXXFLAGS) -o $@ $< SMPCache.cpp Snippets.cpp nanassert.cpp

$(PROG): $(OBJS) 
	$(CXX) $(LDFLAGS) -o $@ $+ $(DBG)

$(PINTOOL): $(OBJS)
	$(CXX) $(PIN_LDFLAGS) $(LDFLAGS) -o $@ $+ $(PIN_LIBS) $(DBG)

doc: README $(MARKDOWN) 
	echo "<html><head><title>MultiCacheSim Documentation</title></head><body>" >README.html
	$(MARKDOWN) README >> README.html
	echo "</body></html>" >> README.html

## cleaning
clean:
	-rm -f *.o $(PROG) $(PINTOOL)

-include *.d
