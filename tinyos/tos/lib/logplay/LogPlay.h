#ifndef LOG_PLAY_H
#define LOG_PLAY_H

#include "message.h"

typedef nx_struct serial_logplay_header {
	nx_uint16_t timestamp;	
	nx_uint8_t fragment:4, fragment_total:4;
	nx_uint8_t id;
	nx_uint8_t length;
} serial_logplay_header_t;

#define SERIAL_LOGPLAY_PAYLOAD_LEN (TOSH_DATA_LENGTH - sizeof(serial_logplay_header_t))

typedef nx_struct serial_logplay_msg {
	serial_logplay_header_t header;
	nx_uint8_t data[SERIAL_LOGPLAY_PAYLOAD_LEN];	
} serial_logplay_msg_t;

enum {
  AM_SERIAL_LOGPLAY_MSG = 23,
};

#endif