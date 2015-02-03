TOSMAKE_PATH=../../support/make/

COMPONENT=RadioCountToLedsAppC
BUILD_EXTRA_DEPS = replay/SerialLogplayMsg.class
CLEAN_EXTRA = replay/SerialLogplayMsg.class replay/SerialLogplayMsg.java

CFLAGS += -DPRINTF_BUFFER_SIZE=1000 
CFLAGS += -I$(TOSDIR)/lib/printf

# SerialLogplayMsg.py: ../../tos/lib/logplay/LogPLay.h
# 	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=SerialLogplayMsg ../../tos/lib/logplay/LogPLay.h serial_logplay_msg -o $@

replay/SerialLogplayMsg.class: replay/SerialLogplayMsg.java
	javac replay/SerialLogplayMsg.java

replay/SerialLogplayMsg.java: ../../tos/lib/logplay/LogPLay.h
	mkdir -p replay
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=replay.SerialLogplayMsg ../../tos/lib/logplay/LogPLay.h serial_logplay_msg -o $@

include $(MAKERULES)
