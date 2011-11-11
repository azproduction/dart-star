// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

interface DartStarInterface {
  HTMLCollection all;
  DartStarCss _style;
  
  /** Operators */
  
  HTMLElement operator [](int index);
  operator +(value);
  operator -(value);
  
  /** Getters and Setters */
  
  int get length();
  DartStarCss get style();
  DartStarCss set style(value);
  
  /** Public methods */
  
  /** # Util methods */
  
  DartStarInterface add([elements]);
  DartStarInterface filter(String selector);
  DartStarInterface each([Function callback]);
  DartStarInterface without([elements]);
  
  /** # Filters */ 
  
  DartStarInterface find(String selector);
  
  /** # Element insertion, moving, removing */
  
  DartStarInterface append(what);
  DartStarInterface prepend(what);
  DartStarInterface before(what);
  DartStarInterface after(what);
  DartStarInterface appendTo(target);
  DartStarInterface prependTo(target);
  
  /** # Element modification */
  
  Object attr(String key, [Object value]);
  
  /** ## Helpers */
  
  DartStarInterface hide();
  DartStarInterface show();
  
  /*

  */
}