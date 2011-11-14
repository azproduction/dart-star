class DartStarEventItem {
  DartStarEvent event;
  String name;
  
  DartStarEventItem(this.event, this.name);
  
  DartStarEventItem on(handlers) {
    if (handlers is Function) {
      event.on(name, handlers);
    } else if (handlers is List<Function>) {
      handlers.forEach((Function handler) {
        event.on(name, handler);  
      });
    }
    return this;
  }
  
  DartStarEventItem off(handlers) {
    if (handlers is Function) {
      event.off(name, handlers);
    } else if (handlers is List<Function>) {
      handlers.forEach((Function handler) {
        event.off(name, handler);  
      });
    }
    return this;
  }
  
  DartStarEventItem trigger(Object data) {
    event.fire(name, data);
    return this;
  }
  
  operator +(handlers) => on(handlers);
  operator -(handlers) => off(handlers);
}

class DartStarEvent implements 
DartStarEventHostInterface,
DartStarEventInterface {
  
  DartStar _ds;
  
  Map<String, List<Function>> events;
  
  DartStarEvent (this._ds) {
    events = new Map<String, List>();
  }
  
  Map<String, List<Function>> _cast(items) {    
    if (items is DartStarEvent) {
      return items.events;
    } else if (items is Map) {
      Map<String, List<Function>> result = new Map<String, List>();
      
      items.forEach((String eventName, handlers){
        List<Function> _handlers;
        if (handlers is List) {
          _handlers = handlers;  
        } else if (handlers is Function) {
          _handlers = new List<Function>();
          _handlers.add(handlers); 
        }
        
        if (!result.containsKey(eventName)) {
          result[eventName] = _handlers;
        } else {
          result[eventName].addAll(_handlers);
        }
      });
      
      return result;
    } else {
      throw new TypeError('Map<String, List<Function>>', items);
    }
  }
  
  DartStarEvent add ([items]) {
    // TODO(azproduction) implement
    _cast(items).forEach((String eventName, List handlers){
      if (!events.containsKey(eventName)) {
        events[eventName] = handlers;
      } else {
        events[eventName].addAll(handlers);
      }
    });
    
    return this;
  }
  
  DartStarEvent remove ([items, Function callback(String eventName, Function callback)]) {
    // TODO(azproduction) implement
    _cast(items).forEach((String eventName, List handlers){
      if (events.containsKey(eventName)) {
        handlers.forEach((Function handler){
          int index = events[eventName].indexOf(handler);
          if (index != -1) {
            if (callback is Function) callback(eventName, events[eventName][index]);
            events[eventName].removeRange(index, 1);
          }
        });
      }
    });
    
    return this;
  }
  
  DartStarEvent reset(value){
    // TODO(azproduction) implement 
  }
  
  DartStarEvent on([events, handlers]) {
    // TODO(azproduction) implement
  }
  
  DartStarEvent off([events, handlers]) {
    // TODO(azproduction) implement    
  }
  
  DartStarEvent pause([events, handlers]) {
    // TODO(azproduction) implement
  }
  
  DartStarEvent resume([events, handlers]) {
    // TODO(azproduction) implement
  }
  
  DartStarEvent fire(String events, Object data) {
    // TODO(azproduction) implement
  }
  
  operator +([items]) => add(items);
  operator -([items]) => remove(items);
  
  operator [](String event) {
    return new DartStarEventItem(this, event);  
  }
  
  operator []=(String event, handlers) {
    off(event);
    if (handlers is Function) {
      on(event, handlers);
    } else if (handlers is List<Function>) {
      handlers.forEach((Function handler) {
        on(event, handler);  
      });
    }
  }
}