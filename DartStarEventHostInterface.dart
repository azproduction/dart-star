interface DartStarEventHostInterface {
  DartStarEventInterface on([events, handlers]);
  DartStarEventInterface off([events, handlers]);
  DartStarEventInterface pause([events, handlers]);
  DartStarEventInterface resume([events, handlers]);
  DartStarEventInterface fire(String events, Object data);
}