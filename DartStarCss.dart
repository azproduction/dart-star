class DartStarCss implements
DartStarCssInterface {
  
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
    } else if (value is HTMLCollection || value is NodeList || value is List) {
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
