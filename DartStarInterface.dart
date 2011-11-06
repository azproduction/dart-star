interface DartStarInterface {
  HTMLCollection all;

  /** Getters and Setters */
  
  int get length();
  
  /** Public methods */
  
  /** # Util methods */
  
  DartStarInterface add([elements]);
  DartStarInterface each([Function callback]);
  
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
  DartStarInterface css(Map<String, String> css);
  
  /** ## Helpers */
  
  DartStarInterface hide();
  DartStarInterface show();
}