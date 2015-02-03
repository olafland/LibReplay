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

#include "printf.h"

#include "LogPlay.h"

generic module ReplayP(typedef t){
  provides{
    interface Replay<t>;
  }

  uses{
    interface ReplayCore;
  }
}

implementation {

  t buffer;

  event error_t ReplayCore.replay(uint8_t fragment, uint8_t fragment_total, uint16_t timestamp, uint8_t len, uint8_t* data){
    //TODO: check fragment numbers, check total, check len, check timestamp...
    int i;
    printf("ReplayP: replay fragment %u of %u, timestamp %u, data %u, len %u\n", fragment, fragment_total, timestamp, data[0], len);
    memcpy((uint8_t*)&buffer + fragment * len, data, len);

    for( i = 0; i < len; i++ ){
      printf("%u, ", data[i]);
    }
    printf("\n");
    printfflush();


    if( fragment >= fragment_total - 1){
      printf("dump final\n");
      for( i = 0; i < sizeof(t); i++ ){
        printf("%u, ", ((uint8_t*) &buffer)[i]);
        if( i % 24 == 0 ){
          printf("\n");
        }
      }
      printf("\n");
      printfflush();

      signal Replay.replay(&buffer);
    }
    return SUCCESS;
  }
}
