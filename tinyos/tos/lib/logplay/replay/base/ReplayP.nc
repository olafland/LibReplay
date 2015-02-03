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
