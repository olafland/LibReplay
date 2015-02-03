#include "LogPlay.h"

configuration LogCoreC{
  provides{
    interface LogCore[uint8_t id];
  }
}

implementation{
	components LogCoreP; 
	components new PoolC(message_t, CUSTOM_BUFFER_ENTRIES);
	components new QueueC(message_t*, CUSTOM_BUFFER_ENTRIES);
	components new SerialAMSenderC(AM_SERIAL_LOGPLAY_MSG);
	components LedsC, MainC;
	components SerialActiveMessageC;

  LogCore = LogCoreP;
  LogCoreP.Queue -> QueueC;
  LogCoreP.Boot -> MainC;
  LogCoreP.Pool -> PoolC;
  LogCoreP.AMSend -> SerialAMSenderC;
  LogCoreP.SerialControl -> SerialActiveMessageC;
  LogCoreP.Packet -> SerialActiveMessageC;
  LogCoreP.Leds -> LedsC;
}



  
