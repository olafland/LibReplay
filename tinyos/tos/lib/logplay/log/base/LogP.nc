//#include "printf.h"

#include "LogPlay.h"

generic module LogP(typedef t){
  provides{
    interface Log<t>;
  }

  uses{
    interface LogCore;
    interface Leds;
  }
}

implementation {

#define SERIAL_PACKETS ((sizeof(t) / SERIAL_LOGPLAY_PAYLOAD_LEN) + ((sizeof(t) % SERIAL_LOGPLAY_PAYLOAD_LEN) ? 1 : 0))

  command error_t Log.log(t v_){
    int i;
    uint16_t ts = call LogCore.getTimeStamp();
    //call Leds.led0On();
    //printf("LogP: logging total %u bytes, %u packets\n", sizeof(t), SERIAL_PACKETS);
    //printfflush();

    for(i = 0; i < SERIAL_PACKETS; i++){
      size_t len = i < SERIAL_PACKETS - 1 ? SERIAL_LOGPLAY_PAYLOAD_LEN : sizeof(t) - i * SERIAL_LOGPLAY_PAYLOAD_LEN;
      //printf("LogP: logging %u, %u bytes\n", i, len);
      //printfflush();
      call LogCore.log(i, SERIAL_PACKETS, ts, (uint8_t*) &v_ + i * SERIAL_LOGPLAY_PAYLOAD_LEN, len);
    }
    //call Leds.led0Off();
    return SUCCESS;
  }


}
