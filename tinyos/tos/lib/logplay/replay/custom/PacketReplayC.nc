#define NEW_PRINTF_SEMANTICS
#include "printf.h"

generic configuration PacketReplayC(int id){

  uses{
    interface Receive;
  }
  provides{
    interface Receive as SubReceive;
  }
}

implementation{

  components PacketReplayP;
  components new ReplayC(PacketReplayP.container_t, id);
  components LedsC;

  components PrintfC;
  components SerialStartC;

  Receive = PacketReplayP;
  PacketReplayP = SubReceive;
  PacketReplayP.Replay -> ReplayC;
  PacketReplayP.Leds -> LedsC;
}
