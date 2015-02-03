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
