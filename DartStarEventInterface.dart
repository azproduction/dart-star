interface DartStarEventInterface {
  DartStarEventInterface add ([items]);
  DartStarEventInterface remove ([items, Function callback(String eventName, Function callback)]);
  DartStarEvent reset(value);
  operator +([items]);
  operator -([items]);
  
  operator [](String event);
  operator []=(String event, Function handler);
}
