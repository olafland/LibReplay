#include "LogPlay.h"

module ReplayCoreP{
  provides{
    interface ReplayCore[uint8_t id];
  }

  uses{
    interface Receive;
    interface Boot;
    interface SplitControl as SerialControl;  
    interface Leds; 
  }
}

implementation {

  bool on;

  event void Boot.booted() {
    on = FALSE;
    call SerialControl.start();        
  }

  event void SerialControl.startDone(error_t err) {
    if( err != SUCCESS ){ 
      call SerialControl.start();
    } else{
      on = TRUE;
    } 
  }

  event void SerialControl.stopDone(error_t err) {
    on = FALSE;
  }  

  event message_t* Receive.receive(message_t* bufPtr, void* payload, uint8_t len){
    serial_logplay_msg_t* log_msg = (serial_logplay_msg_t*)payload;
    call Leds.led0Toggle();
    signal ReplayCore.replay[(uint8_t)log_msg->header.id](log_msg->header.fragment, log_msg->header.fragment_total, log_msg->header.timestamp, log_msg->header.length, (uint8_t*)&log_msg->data[0] );
    return bufPtr;
  }

  default event error_t ReplayCore.replay[uint8_t id](uint8_t fragment, uint8_t fragment_total, uint16_t timestamp, uint8_t len, uint8_t* data){
    return SUCCESS;
  }
}
