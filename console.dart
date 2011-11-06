class console {
  static log(Object value, [Object value2, Object value3, Object value4, Object value5]) {
    String result = '';
    result += console._render(value);
    if (value2 != null) result += console._render(value2);
    if (value3 != null) result += console._render(value3);
    if (value4 != null) result += console._render(value4);
    if (value5 != null) result += console._render(value5);
    print(result);
  }
  static _render(value) {
    if (value is Element) {
      return '<${value.nodeName}>';
    }
    return value.toString();    
  }
}
