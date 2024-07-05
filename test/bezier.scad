use <../lib/maths.scad>
use <../lib/debug.scad>

STEP = 0.05;


module curve3(p0, p1, p2) {
    for (debug_point = bezier_3(p0, p1, p2, STEP)) {
        translate(debug_point)
            circle(0.25);
    }

    debug_point(p0, "red");
    debug_point(p1, "green");
    debug_point(p2, "blue");
}

module curve4(p0, p1, p2, p3) {
    for (debug_point = bezier_4(p0, p1, p2, p3, STEP)) {
        translate(debug_point)
            circle(0.25);
    }

    debug_point(p0, "red");
    debug_point(p1, "green");
    debug_point(p2, "blue");
    debug_point(p3, "black");
}

module stroke4(p0, p1, p2, p3, ft) {
    f_thickness = ft ? ft : function(_t) 1;

    stroke_bezier_4(p0, p1, p2, p3, STEP, f_thickness);

    debug_point(p0, "red");
    debug_point(p1, "green");
    debug_point(p2, "blue");
    debug_point(p3, "black");
}

module test_1() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [10, 10];

    curve3(p0, p1, p2);
}

module test_2() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [0, 10];

    curve3(p0, p1, p2);
}

module test_3() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [0, 10];
    p3 = [10, 10];

    curve4(p0, p1, p2, p3);
}

module test_4() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [10, 10];
    p3 = [0, 10];

    curve4(p0, p1, p2, p3);
}

module test_5() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [0, 10];
    p3 = [10, 10];

    stroke4(p0, p1, p2, p3);
}

module test_6() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [10, 10];
    p3 = [0, 10];

    stroke4(p0, p1, p2, p3);
}

module test_7() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [0, 10];
    p3 = [10, 10];

    ft = function(t) sin(t * 1080) + 1;

    stroke4(p0, p1, p2, p3, ft);
}

module test_8() {
    p0 = [0, 0];
    p1 = [10, 0];
    p2 = [10, 10];
    p3 = [0, 10];

    ft = function(t) t * 2;

    stroke4(p0, p1, p2, p3, ft);
}

module test_all() {
    translate([0, 0])
    test_1();

    translate([0, 20])
        test_2();

    translate([20, 0])
        test_3();

    translate([20, 20])
        test_4();

    translate([40, 0])
        test_5();

    translate([40, 20])
        test_6();

    translate([60, 0])
        test_7();

    translate([60, 20])
        test_8();
}

test_all();
