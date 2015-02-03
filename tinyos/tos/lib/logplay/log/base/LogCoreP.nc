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

module LogCoreP{
	provides{
   	interface LogCore[uint8_t id];
  }

	uses{
    interface Pool<message_t>;
    interface Queue<message_t*>;
    interface AMSend;
    interface Boot;
    interface SplitControl as SerialControl;   
    interface Leds;
    interface Packet;
  }
}

implementation {

  bool sending;
  bool on;
  uint16_t ts = 0;

	event void Boot.booted() {
    sending = FALSE;
    on = FALSE;
    ts = 0;
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

  task void sendTask(){
	//call Leds.led1On();
   	if( call Queue.empty() || !on || sending ) {
      return;
    } else {
      message_t* msg = call Queue.head();
      if( call AMSend.send(AM_BROADCAST_ADDR, msg, sizeof(serial_logplay_msg_t)) == SUCCESS ){
        sending = TRUE;
        return;
      } else {
        //Drop packet. Don't retry.
        call Queue.dequeue();
        call Pool.put(msg);
        if (! call Queue.empty()){
          post sendTask();
        }
      }
    }
    return;
  }

  command error_t LogCore.log[uint8_t id](uint8_t fragment, uint8_t fragment_total, uint16_t timestamp, uint8_t* data, size_t len){
    message_t* msg = call Pool.get();
    size_t data_len = len <= SERIAL_LOGPLAY_PAYLOAD_LEN ? len : SERIAL_LOGPLAY_PAYLOAD_LEN;
    serial_logplay_msg_t* serial_msg = (serial_logplay_msg_t*) call AMSend.getPayload(msg, sizeof(serial_logplay_msg_t));;
    if(msg == NULL) {
      return FAIL;
    }
    serial_msg->header.id = id;
    serial_msg->header.fragment = fragment;
    serial_msg->header.fragment_total = fragment_total;
    serial_msg->header.timestamp = timestamp;
    serial_msg->header.length = data_len;
    memcpy(&serial_msg->data, data, data_len);
    //call Packet.setPayloadLength(msg, sizeof(serial_logplay_msg_t));
    if (call Queue.enqueue(msg) == SUCCESS) {
      post sendTask();
      return SUCCESS;
    } else {
      call Pool.put(msg);
      return FAIL;
    }
  }  

  command uint16_t LogCore.getTimeStamp[uint8_t id](){
    if( ts == 0xFFFF ){
      ts = 0;
    } else {
      ts++;      
    }
    return ts;
  }

  event void AMSend.sendDone(message_t *msg, error_t error) {
    message_t* qh = call Queue.head();
    if (qh == NULL || qh != msg) {
      //bad mojo
    } else {
      call Queue.dequeue();
      call Pool.put(msg);  
    }
    sending = FALSE;
    if (!call Queue.empty()){
      post sendTask();
    }
	//call Leds.led1Off();
  }
}
