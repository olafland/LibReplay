generic configuration LogC(typedef t, uint8_t id){
  provides{
    interface Log<t>;
  }
}

implementation{

  components new LogP(t);
  components LogCoreC; 
  components LedsC;

  Log = LogP;
  LogP.LogCore -> LogCoreC.LogCore[id];
  LogP.Leds -> LedsC;

}
