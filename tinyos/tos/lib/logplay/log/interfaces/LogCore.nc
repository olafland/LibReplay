interface LogCore{

  command error_t log(uint8_t fragment, uint8_t fragment_total, uint16_t timestamp, uint8_t* data, size_t len);

  command uint16_t getTimeStamp();
}
