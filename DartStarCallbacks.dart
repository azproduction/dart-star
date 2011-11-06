// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

class DartStarCallbacks {
  List<Function> callbacks;
  bool isOnce = false;
  bool fired = false;
  DartStarCallbacks(Map<String, bool> options): callbacks = new List<Function>() {
    if (options.containsKey('once')) isOnce = true;  
  }
  
  DartStarCallbacks fire(Object data, [bool isCalledAsEvent = false]) {
    if (fired && isOnce) return this;
    fired = true;
    callbacks.forEach((callback) {
      callback();
    });
    return this;
  }
  
  DartStarCallbacks add(Function callback) {
    callbacks.add(callback);
    return this;
  }
  
  int get length() => callbacks.length;
  Function get fireCallback() => ([Object misc]) {
    fire(misc, misc is Event);
  };
}