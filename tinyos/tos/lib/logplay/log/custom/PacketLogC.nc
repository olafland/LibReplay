#define NEW_PRINTF_SEMANTICS
//#include "printf.h"

generic configuration PacketLogC(uint8_t id){

  uses{
    interface Receive;
  }
  provides{
    interface Receive as SubReceive;
  }
}

implementation{

  components PacketLogP;
  components new LogC(PacketLogP.container_t, id);

//  components PrintfC;
  components SerialStartC;

  SubReceive = PacketLogP;
  PacketLogP = Receive;
  PacketLogP.Log -> LogC;
}
