interface DartStarCssInterface {
  DartStarCss remove(value);
  DartStarCss add(value);
  DartStarCss reset(value);
  operator +(value);
  operator -(value);
  operator [](String property);
  operator []=(String property, String value);
}
