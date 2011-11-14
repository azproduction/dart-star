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
  
  mapEquals(Map expected, Map actual, String message) {
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
  
  cssEquals(String expected, String actual, String message) => 
  mapEquals(DartStarCss.parseCssText(expected), DartStarCss.parseCssText(actual), message);
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
    filetrTest();
    removeTest();
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
    
    // 8. Should be unique
    ds = $('.p1');
    ds.add('.p1');
    Expect.equals(1, ds.length, 'Should be unique');
    
    
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
    
    ds.style += {"display": "none", "width": "100%"};
    cssEquals(
      "display: none; width: 100%; ", 
      ds[0].style.cssText, 
      'Should apply display and width as hash'
      );
    
    ds.style += "height: 100%; left: 200px;";
    cssEquals(
      "display: none; width: 100%; left: 200px; height: 100%; ", 
      ds[0].style.cssText, 
      'Should apply height and left as string'
      );
         
    ds.style -= "left;width";
    cssEquals(
      "display: none; height: 100%; ", 
      ds[0].style.cssText, 
      'Should remove left and width as string'
      );
    
    ds.style -= {"height": null};
    cssEquals(
      "display: none; ", 
      ds[0].style.cssText, 
      'Should remove height as hash'
      );
    
    ds.style += "height: 100px;";
    cssEquals(
      "display: none; height: 100px; ", 
      ds[0].style.cssText, 
      'Should add height as string'
      );
    
    Expect.equals('100px', ds.style["height"], "Should get height directly");
    
    ds.style["height"] = null;
    cssEquals(
      "display: none; ", 
      ds[0].style.cssText, 
      'Should remove height as null'
      );
    
    ds.style = {};
    cssEquals(
      '', 
      ds[0].style.cssText, 
      'Should reset as ={} assign'
      );
    
    ds.style = {"display": "none", "width": "100%"}; 
    cssEquals(
      "display: none; width: 100%; ", 
      ds[0].style.cssText, 
      'Should reset to "display: none; width: 100%; " as {"display": "none", "width": "100%"} assign'
      );
    
    ds.style = $('<div/>').css({"color": "red"});
    cssEquals(
      "color: red", 
      ds[0].style.cssText, 
      'Should set value from Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style += $('<div/>').css({"bottom": "10px"});
    cssEquals(
      "color: red; bottom: 10px", 
      ds[0].style.cssText, 
      'Should drain value from Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style -= $('<div/>').css({"bottom": "10px"});
    cssEquals(
      "color: red", 
      ds[0].style.cssText, 
      'Should remove value using Element/DartStar/ElementCollection/DartStarCss'
      );
    
    ds.style = {"left": "100px", "top": "100px"};
    _ds = $('<div/>').css({"left": "100px", "top": "100px"});
    cssEquals(
      ds[0].style.cssText, 
      _ds[0].style.cssText, 
      'css() shoud apply values as += expect string argument'
      );
    
    _ds = $('<div/>').css(ds.style);
    cssEquals(
      ds[0].style.cssText, 
      _ds[0].style.cssText, 
      'css() shoud apply values as += expect string argument'
      );
    
    _ds = $('<div/>').css(ds);
    cssEquals(
      ds[0].style.cssText, 
      _ds[0].style.cssText, 
      'css() shoud apply values as += expect string argument');
    
    _ds = $('<div/>').css(ds);
    Expect.equals(
      _ds.css("top"), 
      ds.style["top"], 
      'css() retruns values as style[]'
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
  
  filetrTest() {
    DartStar ds;
    
    ds = $('p').add('<a class="p1"></a>').filter('.p1'); // 3
    Expect.equals(2, ds.length, "Should be 2 items after filter '.p1'");
  }
  
  removeTest() {
    // TODO(azproduction) write test
    DartStar ds;
    
    ds = $('p'); // 3
    ds += '<p class="p1"></p>'; // 4
    ds -= '.p1'; // 2; eq ds.without('.p1');
    Expect.equals(2, ds.length, "Should remove 2 elements using without '.p1'");
    
    ds = $('p'); // 3
    ds += '<p class="p1"></p>'; // 4
    ds -= '<p class="p1"></p>'; // 4
    Expect.equals(4, ds.length, "Nothing");
    
    ds = $('p'); // 3
    ds -= $('p'); // 0
    Expect.equals(0, ds.length, "Should be Zero items");
  }
  
  eventTest() {
    DartStar ds;
    
    // returns event object
    DartStarEvent click = $('p').on('click', (Event event){});
    
    // stack few events in one event collection
    DartStarEvent collection = $('p')
    .on('click', (){})
    .on('mouseover mouseout', (){})
    .on(['keydown'], (){})
    .on({
      'focus': (){},
      'blur': (){}
    });
    
    collection.off('click'); // unbind click
    collection.off('mouseover mouseout'); // unbind mouseover mouseout
    collection.off(['focus']); // unbind focus
    collection.off({'focus': null, 'blur': null}); // unbind focus and blur
    collection.off(); // unbind the rest
    collection.pause(); // pause/suspend all (not unbind)
    collection.on(); // resume all same as collection.resume();
    
    // event object with .p1 events
    DartStarEvent p1_click = $('.p1')
    .on('click', (){});
    
    // event object with .p2 events
    DartStarEvent p2_click = $('.p2')
    .on('click', (){});
    
    // Stack object .p1 + .p2 events there with DS of 2 object (in memory DS)
    DartStarEvent p2_p1_click = p1_click + p2_click;
   
    // event object with .p3 events
    DartStarEvent p3_p2_p1_click = $('.p3')
    .on('click', (){});
    
    // Stack object .p1 + .p2 + .p3 events with DS of 3 objects (in memory DS)
    p3_p2_p1_click += p2_p1_click;
    
    // unbinds all clicks
    p3_p2_p1_click.off();
    
    DartStarEvent p1_events = $('.p1,.p2').on('click', () {});
    
    Function tmp = () {};
    Function tmp2 = () {};
    p1_events['click'] += [tmp, tmp2]; // same as .on('click', tmp).on('click', tmp2);
    p1_events['click'] -= tmp; // same as .off('click', tmp);
    p1_events['click'] = tmp; // same as .off().on('click', tmp);
    
    
  }
}

main() {
  runTests([new DartStarTest()]);
}