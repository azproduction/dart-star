// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

#library('DartStar');

#import('dart:dom');

#source('DartStarInterface.dart');
#source('DartStarCallbacks.dart');

class DartStarCss {
  DartStar _ds;
  
  DartStarCss(this._ds);
  
  static Map<String, String> parseCssText(String cssString) {
    Map<String, String> _css = new Map<String, String>();
    
    List<String> cssParts = cssString.split(';');
    
    cssParts.forEach((String cssItem) {
      List<String> _propValue = cssItem.split(':');
      if (_propValue.length >= 1) {
        // trim
        _propValue[0] = _propValue[0].trim();
        if (_propValue[0] != "") {
          if (_propValue.length == 2) {
            _css[_propValue[0]] = _propValue[1].trim();
          } else if (_propValue.length == 1) {
            _css[_propValue[0]] = null;
          }
        }
      }
    });
    
    return _css;
  }
  
  Map<String, String> _makeCss(value) {
    HTMLElement _element;
    Map<String, String> _css = new Map<String, String>();
    
    // case $()
    if (value is DartStar) {
      if (value.length > 0) {
        _element = value.all[0];
        _css = DartStarCss.parseCssText(_element.style.cssText);
      }
      
    // case $().css
    } else if (value is DartStarCss) {
      if (value._ds.length > 0) {
        _element = value._ds.all[0];
        _css = DartStarCss.parseCssText(_element.style.cssText);
      }
      
    // case 'left: 10px; top: 20px;' or 'left;top;height'
    } else if (value is String) {
      _css = DartStarCss.parseCssText(value);
      
    // case {'left': '10px', 'top': '20px'}
    } else if (value is Map<String, String>) {
      _css = value; // as is
      
    // case ['left', 'width', 'top']
    } else if (value is List<String>) {
      value.forEach((String key) => _css[key] = null);
    
    // case HTMLCollection
    } else if (value is HTMLCollection || value is NodeList) {
      if (value.length > 0) {
        _element = value[0];
        _css = DartStarCss.parseCssText(_element.style.cssText);
      }
      
    // case Element
    } else if (value is HTMLElement) {
      _css = DartStarCss.parseCssText(value.style.cssText);
    }
    
    return _css;
  }
  
  DartStarCss add(value) {
    Map<String, Object> _css = _makeCss(value);
    _ds.each((HTMLElement element) {
      _css.forEach((String property, Object value) {
        if (value == null || value == "" || value == false) {
          element.style.removeProperty(property);
        } else {
          element.style.setProperty(property, value);
        }
      });
    });
    
    return this;
  }
  
  DartStarCss remove(value) {
    Map<String, Object> _css = _makeCss(value);
    
    _ds.each((HTMLElement element) {
      _css.forEach((String property, Object value) => element.style.removeProperty(property));
    });
    
    return this;
  }
  
  DartStarCss reset(value) {
    if (value === this) {
      return this;
    }
    Map<String, Object> _css = _makeCss(value);
    
    // remove All styles;
    _ds.each((HTMLElement element) {
      element.style.cssText = '';
    });
    
    add(_css);
    
    return this;
  }
  
  operator +(value) => add(value);
  
  operator -(value) => remove(value);
  
  operator [](String property) {
    if (_ds.length > 0) {
      HTMLElement _element = _ds.all[0];
      return _element.style.getPropertyValue(property);
    }
    return null;
  }
  
  operator []=(String property, String value) {
    _ds.each((HTMLElement element) {
      if (value == null || value == "" || value == false) {
        element.style.removeProperty(property);
      } else {
        element.style.setProperty(property, value);
      }
    });
  }
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
  
  DartStar without([elements]) {
    DartStar _remove = new DartStar(elements);
    
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
}

DartStar $([query]) {
  return new DartStar(query);  
}
