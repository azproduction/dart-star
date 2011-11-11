// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

#library('DartStar');

#import('dart:dom');

#source('DartStarInterface.dart');
#source('DartStarCallbacks.dart');
#source('DartStarCss.dart');

class DartStarEventCollection {
  Map<String, List<Function>> events;
  
  DartStarEventCollection ([items]) {
    events = new Map<String, List>();
    add(items);
  }
  
  Map<String, List<Function>> _cast(items) {    
    if (items is DartStarEventCollection) {
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
  
  DartStarEventCollection add([items]) {
    _cast(items).forEach((String eventName, List handlers){
      if (!events.containsKey(eventName)) {
        events[eventName] = handlers;
      } else {
        events[eventName].addAll(handlers);
      }
    });
    
    return this;
  }
  
  DartStarEventCollection remove ([items, Function callback(String eventName, Function callback)]) {
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
  
  operator +([items]) => add(items);
  operator -([items]) => remove(items);
}

class DartStar implements DartStarInterface {
  
  /** Fields and Private fields */
  
  List<Node> all;
  DartStarCss _style;
  
  DartStarCss get style() {
    return _style;
  }
  
  DartStarCss set style(value) {
    _style.reset(value);
  }
  
  /** Factory and Constructors */
  
  factory DartStar([query]) {
    // It's DS pass as is
    if (query is DartStar) return query;
    
    // It's Dom ready event
    if (query is Function) {
      DartStar.ready(query);
    } else {
      return new DartStar._create(query);
    }
  }
  
  DartStar._create(query) {
    all = new List<Node>();
    _style = new DartStarCss(this);
    add(query);
  }
  
  /** Operators */
  
  HTMLElement operator [](int index) {
    int _realIndex;
    
    // 0 1 2 etc
    if (index >= 0) {
      _realIndex = index;
    }
    
    // -1 -2 etc
    if (index < 0) {
      _realIndex = all.length + index;
    }
    
    if (_realIndex >= 0 && all.length > _realIndex) {
      return all[_realIndex];
    }
    
    return null;
  }
  
  operator +(value) => add(value);
  operator -(value) => without(value);
  
  /** Static methods */
  
  static ready(Function callback) {
    if (document.readyState == "complete") {
      // Handle it asynchronously to allow scripts the opportunity to delay ready
      window.setTimeout(callback, 1);
    }
    Function _onceCallback = new DartStarCallbacks({"once": true}).add(callback).fireCallback;
    // Mozilla, Opera and webkit nightlies currently support this event
    // Use the handy event callback
    document.addEventListener("DOMContentLoaded", _onceCallback, false);
    // A fallback to window.onload, that will always work
    window.addEventListener("load", _onceCallback, false);
  }
  
  /** Private methods */
  
  DartStar _insertAllTo(String where, target, [bool isDoClone = false]) {
    DartStar _ds = new DartStar(target);
    if (_ds.all.length > 0) {
      HTMLElement _dest = _ds.all[0];
      each((HTMLElement element) {
        if (isDoClone) {
          element = element.cloneNode(false);
        }
        _dest.insertAdjacentElement(where, element);
      });
    }
    
    return this;
  }
  
  DartStar _insert(String where, what) {
    if (all.length == 0) return this;
    
    HTMLCollection _what = new DartStar(what).all;
    HTMLElement _target = all[0];
    _what.forEach((HTMLElement element) => _target.insertAdjacentElement(where, element));
    
    return this;
  }
  
  _addAllUnique(Collection<Node> items) {
    items.forEach((HTMLElement element) {
      if (all.indexOf(element, 0) == -1) {
        all.add(element);
      }  
    });  
  }
  
  /** Getters and Setters */
  
  int get length() => all.length;
  
  /** Public methods */
  
  /** # Util methods */
  
  DartStar add([elements]) {
    if (elements == null) return this;
    
    // case $.add($('<div>'))
    if (elements is DartStar) {
      _addAllUnique(elements.all);
      
    // case $.add(List<Eement>);
    } else if (elements is HTMLCollection || elements is NodeList || elements is List) {
      _addAllUnique(elements);
      
    // case $.add(Element)
    } else if (elements is HTMLElement) {
      List<Node> _elements = new List<Node>();
      _elements.add(elements);
      _addAllUnique(_elements);
      
    } else if (elements is String) {
      // case $.add('<div>')
      if (elements.startsWith('<')) {
        HTMLElement _wrapper = document.createElement('div');
        _wrapper.innerHTML = elements;
        _addAllUnique(_wrapper.children);
        
      // case $.add('.selector')
      } else { // Selector
        _addAllUnique(window.document.querySelectorAll(elements));
      }
    }
    
    return this;
  }
  
  DartStar filter(String selector) {
    List<Node> result = new List<Node>();
    HTMLElement _wrapper = document.createElement('div');
    
    each((HTMLElement element) {
      HTMLElement _element = element.cloneNode(false);
      _wrapper.innerHTML = '';
      _wrapper.insertAdjacentElement('beforeEnd', _element);
      if (_wrapper.querySelector(selector) === _element) {
        result.add(element);
      }
    });
    
    return new DartStar(result);
  }
  
  DartStar without([elements]) {
    DartStar _remove;
    if (elements is String && !elements.startsWith('<')) {
      _remove = filter(elements);
    } else {
      _remove = new DartStar(elements);
    }
    
    _remove.each((HTMLElement element) {
      int index = all.indexOf(element, 0);
      if (index != -1) {
        all.removeRange(index, 1);
      }
    });
    
    return this;
  }
  
  DartStar each([Function callback]) {
    if (callback == null) return this;
    
    all.forEach(callback);
    
    return this;
  }
  
  /** # Filters */ 
  
  DartStar find(String selector) {
    DartStar _ds = new DartStar();
    
    each((HTMLElement element) => _ds.add(element.querySelectorAll(selector)));
    
    return _ds;
  }
  
  /** # Element insertion, moving, removing */
  
  DartStar append(what) => _insert('beforeEnd', what);
  DartStar prepend(what) => _insert('afterBegin', what);
  
  DartStar before(what) => _insert('beforeBegin', what);
  DartStar after(what) => _insert('afterEnd', what);
  
  DartStar appendTo(target) => _insertAllTo('beforeEnd', target);
  DartStar prependTo(target) => _insertAllTo('afterBegin', target);
  
  /** # Element modification */
  
  Object attr(String key, [Object value]) {
    if (value == null && all.length > 0) {
      HTMLElement _first = all[0];
      return _first.getAttribute(key);
    }
    if (value == false) {
      each((HTMLElement element) => element.removeAttribute(key));
    } else {
      each((HTMLElement element) => element.setAttribute(key, value));
    }
    
    return this;
  }
  
  Object css(Object key_or_hash, [String value]) {
    if (value == null) {
      if (key_or_hash is String) {
        return style[key_or_hash];
      } else {
        _style += key_or_hash;
      }
    } else {
      _style[key_or_hash] = value;
    }
    
    return this;
  }
  
  /** ## Helpers */
  
  DartStar hide() {
    _style["display"] = "none";
    return this;
  }
  
  DartStar show() {
    _style["display"] = "";
    return this;
  }
  
  /** Pretty print */
  
  String toString() {
    HTMLElement wrapper = document.createElement('div');
    each((HTMLElement element) { 
      wrapper.insertAdjacentElement('beforeEnd', element.cloneNode(true));
      wrapper.insertAdjacentText('beforeEnd', ', ');
    });
    return '${all.length} elements: ' + wrapper.innerHTML;
  }
  
  /** Events */
  DartStarEventCollection bind(events, [data_or_handler, handler]) {
    var data;
    if (handler is! Function) {
      if (events is! Map<String, Function>) {
        handler = data_or_handler;
        data = null;
      } else {
        handler = null;
        if (data_or_handler is! Function) {
          data = data_or_handler;
        }
      }
    } else {
       data = data_or_handler;
    }
    
    Map<String, Function> _events = new Map<String, Function>();
    
    if (events is Map<String, Function>) {
      _events = events;
    } else {
      events.split(' ').forEach(function(String eventName){
        eventName = eventName.trim();
        if (eventName.length != 0) {
          _events[eventName] = handler;
        }
      });
    }
    
    _events.forEach((String eventName, Function handler) {
      
    });
    
    return new DartStarEventCollection(_events);
  }
  
}

DartStar $([query]) {
  return new DartStar(query);  
}
