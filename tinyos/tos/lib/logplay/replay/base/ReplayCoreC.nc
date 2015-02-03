#include "LogPlay.h"

configuration ReplayCoreC{
  provides{
    interface ReplayCore[uint8_t id];
  }
}

implementation{

  components ReplayCoreP;
  components new SerialAMReceiverC(AM_SERIAL_LOGPLAY_MSG);
  components LedsC, MainC;
  components SerialActiveMessageC;

  ReplayCore = ReplayCoreP;
  ReplayCoreP.Boot -> MainC;
  ReplayCoreP.Receive -> SerialAMReceiverC;
  ReplayCoreP.SerialControl -> SerialActiveMessageC;
  ReplayCoreP.Leds -> LedsC;
}
