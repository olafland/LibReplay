//#include "printf.h"

module PacketLogP{
  typedef struct container {message_t msg; size_t payload_offset; uint8_t len;} container_t;
	//typedef struct container {uint8_t data[CUSTOM_LOG_BYTES];} container_t;

  uses{
    interface Receive as SubReceive;
    interface Log<container_t>;
  }
  provides{
    interface Receive;
  }
}

implementation {

  event message_t* SubReceive.receive(message_t* bufPtr, void* payload, uint8_t len) {
    call Log.log((container_t) {*bufPtr, (uint8_t*)payload - (uint8_t*)bufPtr , len});
	//container_t c;
    //call Log.log((container_t) c);

    //printf("PacketLogP: buffer %u, payload %u, offset %lu, len %u\n", ((uint8_t*)bufPtr)[0], ((uint8_t*)payload)[0], (uint8_t*)payload - (uint8_t*)bufPtr, len);
    //printfflush();

    return signal Receive.receive(bufPtr, payload, len);
  }
}
