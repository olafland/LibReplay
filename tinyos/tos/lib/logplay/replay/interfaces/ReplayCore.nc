interface ReplayCore{

  event error_t replay(uint8_t fragment, uint8_t fragment_total, uint16_t timestamp, uint8_t len, uint8_t* data);

}