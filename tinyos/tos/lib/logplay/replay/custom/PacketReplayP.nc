#include "printf.h"

module PacketReplayP{
  typedef struct container {message_t msg; size_t payload_offset; uint8_t len;} container_t;

  uses{
    interface Replay<container_t>;
    interface Receive as SubReceive;
    interface Leds; 
  }
  provides{
    interface Receive; 
  }
}

implementation {

  event error_t Replay.replay(container_t* container) {
    call Leds.led1Toggle();
    
    printf("PacketReplayP: buffer %u, payload %u, offset %u, len %u\n", 
      ((uint8_t*)&container->msg)[0], 
      ((uint8_t*)&container->msg + container->payload_offset)[0], 
      container->payload_offset,
      container->len);
    printfflush();    

    signal Receive.receive(&container->msg, (uint8_t*) &container->msg + container->payload_offset, container->len);
    return SUCCESS;
  }

  event message_t* SubReceive.receive(message_t* bufPtr, void* payload, uint8_t len) {
    return bufPtr;
  }

}
