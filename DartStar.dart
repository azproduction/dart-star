// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

#library('DartStar');

#import('dart:dom');

#source('DartStarInterface.dart');
#source('DartStarCallbacks.dart');
#resource('README.md');

class DartStar implements DartStarInterface {
  
  /** Fields and Private fields */
  
  List<Node> all;
  
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
    add(query);
  }
  
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
  
  DartStar _insertAllTo(String where, target) {
    DartStar _ds = new DartStar(target);
    if (_ds.all.length > 0) {
      HTMLElement _dest = _ds.all[0];
      each((HTMLElement element) => _dest.insertAdjacentElement(where, element));
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
  
  /** Getters and Setters */
  
  int get length() => all.length;
  
  /** Public methods */
  
  /** # Util methods */
  
  DartStar add([elements]) {
    if (elements == null) return this;
    
    // case $.add($('<div>'))
    if (elements is DartStar) {
      all.addAll(elements.all);
      
    // case $.add(List<Eement>);
    } else if (elements is HTMLCollection || elements is NodeList) {
      all.addAll(elements);
      
    // case $.add(Element)
    } else if (elements is HTMLElement) {
      all.add(elements);
      
    } else if (elements is String) {
      // case $.add('<div>')
      if (elements.startsWith('<')) {
        HTMLElement _wrapper = document.createElement('div');
        _wrapper.innerHTML = elements;
        all.addAll(_wrapper.children);
        
      // case $.add('.selector')
      } else { // Selector
        
        all.addAll(window.document.querySelectorAll(elements));
      }
    }
    
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
  
  DartStar css(Map<String, String> css) {
    each((HTMLElement element) {
      css.forEach((String property, String value) => element.style.setProperty(property, value));
    });
    
    return this;
  }
  
  /** ## Helpers */
  
  DartStar hide() => css({"display": "none"});
  DartStar show() => css({"display": ""});
  
  /** Pretty print */
  
  String toString() {
    HTMLElement wrapper = document.createElement('div');
    each((HTMLElement element) { 
      wrapper.insertAdjacentElement('beforeEnd', element.cloneNode(true));
      wrapper.insertAdjacentText('beforeEnd', ', ');
    });
    return '${all.length} elements: ' + wrapper.innerHTML;
  }
}

DartStar $([query]) {
  return new DartStar(query);  
}
