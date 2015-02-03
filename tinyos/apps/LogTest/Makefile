TOSMAKE_PATH=../../support/make/

COMPONENT=RadioCountToLedsAppC
BUILD_EXTRA_DEPS = log/SerialLogplayMsg.class
CLEAN_EXTRA = log/SerialLogplayMsg.class log/SerialLogplayMsg.java

#CFLAGS += -DPRINTF_BUFFER_SIZE=1000
#CFLAGS += -I$(TOSDIR)/lib/printf

#SerialLogplayMsg.py: ../../tos/lib/logplay/LogPLay.h
#	mig python -target=$(PLATFORM) $(CFLAGS) -python-classname=SerialLogplayMsg ../../tos/lib/logplay/LogPLay.h serial_logplay_msg -o $@

ifdef CUSTOM_BUFFER_ENTRIES
CFLAGS += -DCUSTOM_BUFFER_ENTRIES=$(CUSTOM_BUFFER_ENTRIES)
else
CFLAGS += -DCUSTOM_BUFFER_ENTRIES=10
endif

#ifdef CUSTOM_LOG_BYTES
#CFLAGS += -DCUSTOM_LOG_BYTES=$(CUSTOM_LOG_BYTES)
#else
#CFLAGS += -DCUSTOM_LOG_BYTES=1
#endif

log/SerialLogplayMsg.class: log/SerialLogplayMsg.java
	javac log/SerialLogplayMsg.java

log/SerialLogplayMsg.java: ../../tos/lib/logplay/LogPLay.h
	mkdir -p log
	mig java -target=$(PLATFORM) $(CFLAGS) -java-classname=log.SerialLogplayMsg ../../tos/lib/logplay/LogPLay.h serial_logplay_msg -o $@

include $(MAKERULES)
