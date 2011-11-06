// DartStar may be freely distributed under the MIT license. (c) 2011 azproduction

#library('DartStarTest');

#import('dart:dom');

#import('TestFramework.dart');
#import('../DartStar.dart');

class DomTastCase extends TestCase {
  
  HTMLElement sandbox;
  
  DomTastCase(): super(), sandbox = document.querySelector('#sandbox');
  
  tearDown() {
    sandbox.innerHTML = '';  
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
}

/*
void main() {
  $((){
    $('pre').append('<pre id="ololo">Ololo</pre>');
    console.log($('body>*'));
    // .find('div').add('pre').add('<pre id="ololo">Ololo</pre>')
  });
}*/

main() {
  runTests([new DartStarTest()]);
}