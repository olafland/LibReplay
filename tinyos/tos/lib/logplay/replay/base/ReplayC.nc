generic configuration ReplayC(typedef t, int id){
  provides{
    interface Replay<t>;
  }
}

implementation{

  components new ReplayP(t);
  components ReplayCoreC;

  Replay = ReplayP;
  ReplayP.ReplayCore -> ReplayCoreC.ReplayCore[id];

}
