// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

#library('DartStarTest');

#import('dart:dom');

#import('TestFramework.dart');
#import('../DartStar.dart');

class DomTastCase extends TestCase {
  
  HTMLElement sandbox;
  
  DomTastCase(): super(), sandbox = document.querySelector('#sandbox');
  
  tearDown() {
    //sandbox.innerHTML = '';  
  }
  
  mapEquals (Map expected, Map actual, String message) {
    expected.forEach((key, value) {
      if (!actual.containsKey(key) || actual[key] != value) {
        Expect.fail(message);
      }
    });
    actual.forEach((key, value) {
      if (!expected.containsKey(key) || expected[key] != value) {
        Expect.fail(message);
      }
    });
  }
}

class DartStarTest extends DomTastCase {
  DartStarTest(): super();
  
  
  setUp() {
    sandbox.innerHTML = '''
<p class="p1">
    <span>ololo</span>
</p>
<p class="p2">
    <span>ololo</span>
    <span>ololo</span>
</p>
<p class="p3">
    <span>ololo</span>
    <span>ololo</span>
    <span>ololo</span>
</p>
''';
  }
  
  performTest() {
    constructorTest();
    addTest();
    eachTest();
    findTest();
    cssTest();
  }
  
  constructorTest() {
    DartStar ds;
    
    // 0. Should be DartStar instance
    Expect.isTrue($() is DartStar, "Result of \$() Should be DartStar instance");
    
    // 1. DartStar
    ds = $();
    Expect.identical(ds, $(ds), "Should return the same ds instance if it passed to constructor");
    
    // 2. Null
    Expect.equals(0, $().length, "If pass null - ignore");
    
    // 3. Selector
    Expect.equals(3, $('p').length, "Selector 'p' Should find 3 elements");
    Expect.equals(0, $('z').length, "Selector 'z' Should find 0 elements");
    
    // 4. Html
    Expect.equals(1, $('<p></p>').length, "Should create element");
    
    // 5. Element
    Expect.equals(1, $(document.querySelector('p')).length, 'If pass Element should grab it');
    
    // 6. ElementList
    Expect.equals(3, $(document.querySelectorAll('p')).length, 'If pass ElementList or NodeList should grab it all');
  }
  
  addTest() {
    DartStar ds, ds2;
    
    // 1. DartStar
    ds = $('.p1');
    ds2 = $('.p2').add(ds);
    
    Expect.equals(2, ds2.length, "Should should drain elements if ds instance passed");
    Expect.isTrue(ds !== ds2, "Should should drain elements if ds instance passed");    
    
    // 2. Null
    Expect.equals(0, $().add().length, "If pass null - ignore");
    
    // 3. Selector
    Expect.equals(2, $('.p1').add('.p2').length, "Should append founded .p2 element");
    Expect.equals(3, $('.p1').add('.p2').add('.p3').length, "Should append founded .p2 and .p3 element");
    
    // 4. Html
    Expect.equals(2, $('<p></p>').add('<p></p>').length, "Should append created from html element");
    
    // 5. Element
    Expect.equals(1, $().add(document.querySelector('p')).length, 'If pass Element should grab it');
    
    // 6. ElementList
    Expect.equals(3, $().add(document.querySelectorAll('p')).length, 'If pass ElementList or NodeList should grab it all');
    
    // 7. Should ignore trash items
    Expect.equals(0, $().add((){}).length, 'Should ignore trash items');
    Expect.equals(0, $().add(42).length, 'Should ignore trash items');
    Expect.equals(0, $().add([]).length, 'Should ignore trash items');
    Expect.equals(0, $().add({}).length, 'Should ignore trash items');
    Expect.equals(0, $().add(new RegExp('/.*/')).length, 'Should ignore trash items');
  }
  
  eachTest() {
    DartStar ds;
    
    // 1. Should iterate
    ds = $('p');
    int count = 0;
    
    ds.each((HTMLElement item) {
      count++;
    });
    
    Expect.equals(3, count, 'Should iterate 3 items');
  }
  
  findTest() {
    DartStar ds, ds2;
    ds = $('p');
    
    ds2 = ds.find('span');
    
    // Should create a new instance
    Expect.isTrue(ds !== ds2, 'Should create a new instance');
    
    // Should find all in all
    Expect.equals(6, ds2.length, 'Should find all in all: 6 <span> items in 3 <p>');
  }
  
  cssTest() {
    DartStar ds = $('p'), _ds;
    ds.style += {"display": "none", "width": "100%"}; // 'display: none; width: 100%' ; //
    mapEquals(
      DartStarCss.parseCssText("display: none; width: 100%; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should apply display and width as hash'
      );
    
    ds.style += "height: 100%; left: 200px;";
    mapEquals(
      DartStarCss.parseCssText("display: none; width: 100%; left: 200px; height: 100%; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should apply height and left as string'
      );
         
    ds.style -= "left;width";
    mapEquals(
      DartStarCss.parseCssText("display: none; height: 100%; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should remove left and width as string'
      );
    
    ds.style -= {"height": null};
    mapEquals(
      DartStarCss.parseCssText("display: none; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should remove height as hash'
      );
    
    ds.style += "height: 100px;";
    mapEquals(
      DartStarCss.parseCssText("display: none; height: 100px; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should add height as string'
      );
    
    Expect.equals('100px', ds.style["height"], "Should get height directly");
    
    ds.style["height"] = null;
    mapEquals(
      DartStarCss.parseCssText("display: none; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should remove height as null'
      );
    
    ds.style = {};
    mapEquals(
      {}, 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should reset as ={} assign'
      );
    
    ds.style = {"display": "none", "width": "100%"}; 
    mapEquals(
      DartStarCss.parseCssText("display: none; width: 100%; "), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should reset to "display: none; width: 100%; " as {"display": "none", "width": "100%"} assign'
      );
    
    ds.style = $('<div/>').css({"color": "red"});
    mapEquals(
      DartStarCss.parseCssText("color: red"), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should set value from Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style += $('<div/>').css({"bottom": "10px"});
    mapEquals(
      DartStarCss.parseCssText("color: red; bottom: 10px"), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should drain value from Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style -= $('<div/>').css({"bottom": "10px"});
    mapEquals(
      DartStarCss.parseCssText("color: red"), 
      DartStarCss.parseCssText(ds[0].style.cssText), 
      'Should remove value using Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style = {"left": "100px", "top": "100px"};
    _ds = $('<div/>').css({"left": "100px", "top": "100px"});
    
    mapEquals(
      DartStarCss.parseCssText(ds[0].style.cssText), 
      DartStarCss.parseCssText(_ds[0].style.cssText), 
      'css() shoud apply values as += expect string argument'
      );
    
    _ds = $('<div/>').css(ds.style);
    
    mapEquals(
      DartStarCss.parseCssText(ds[0].style.cssText), 
      DartStarCss.parseCssText(_ds[0].style.cssText), 
      'css() shoud apply values as += expect string argument'
      );
    
    _ds = $('<div/>').css(ds);
    
    mapEquals(
      DartStarCss.parseCssText(ds[0].style.cssText), 
      DartStarCss.parseCssText(_ds[0].style.cssText), 
      'css() shoud apply values as += expect string argument'
      );
    
    _ds = $('<div/>').css(ds);
    
    Expect.equals(
      _ds.css("top"), 
      ds.style["top"], 
      'css() retrun values as style[]'
      );
    
    _ds = $('<div/>').css(ds);
    _ds.css("top", "111px");
    ds.style["top"] = "111px";
    
    Expect.equals(
      ds.style["top"], 
      _ds.css("top"), 
      'css() should set values as style[]='
      );
  }
  
  removeTest() {
    // TODO(azproduction) write test
  }
}

main() {
  runTests([new DartStarTest()]);
}