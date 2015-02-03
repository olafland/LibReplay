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
