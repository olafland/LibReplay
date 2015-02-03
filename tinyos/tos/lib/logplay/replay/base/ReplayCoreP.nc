/*
 * Copyright (c) 2014 Olaf Landsiedel
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * - Redistributions of source code must retain the above copyright
 *   notice, this list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright
 *   notice, this list of conditions and the following disclaimer in the
 *   documentation and/or other materials provided with the
 *   distribution.
 * - Neither the name of the Stanford University nor the names of
 *   its contributors may be used to endorse or promote products derived
 *   from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 * ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 * FOR A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL STANFORD
 * UNIVERSITY OR ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE.
 */

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
