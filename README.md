Dart Star
=========

jQuery/Zepto like library for Dart, with a jQuery-compatible chaining syntax.

Sugar
-----

    var p1 = $('.p1'),
        p2  = $('.p2');

    p1 += p2; // item collection union like p1.add(p2);
    p1 -= p2; // collection sub like $.without(p2);
    p1 -= 'p'; // remove all p items like $.without('p');
    p1 += "<p>ololo</p>"; // add items to collection as HTML. works as $.add("<p>ololo</p>")

    p1.css({"width": "100px"}); // like common jQuery css function
    p2.style = "width: 100px; height: 200px;"; // set style to all items directly

    p1.style['width']; // 100px as p1.css('width');
    p1.style += "height: 200px;" // add style. now: width + height
    p1.style -= {"width": null}; // remove width property
    p2.style -= "height"; // remove height
    p1.style -= p2.style; // remove p2 styles from p1 styles
    p1.style -= p2; // same as above
    p1.style = p2.style; // use p2 styles or just p2 same as p1.css(p2.style); or p1.css(p2);


see `test/DartStarTest.dart` for more examples