use <../lib/maths.scad>

module curve3(p0, p1, p2) {
    for (point = bezier_3(p0, p1, p2, 0.05)) {
        translate(point)
            circle(0.25);
    }

    color("red")
        translate(p0)
        circle(0.5);

    color("green")
        translate(p1)
        circle(0.5);

    color("blue")
        translate(p2)
        circle(0.5);
}

module curve4(p0, p1, p2, p3) {
    for (point = bezier_4(p0, p1, p2, p3, 0.05)) {
        translate(point)
            circle(0.25);
    }

    color("red")
        translate(p0)
        circle(0.5);

    color("green")
        translate(p1)
        circle(0.5);

    color("blue")
        translate(p2)
        circle(0.5);

    color("black")
        translate(p3)
        circle(0.5);
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

module test_all() {
    test_1();

    translate([20, 0])
        test_2();

    translate([0, 20])
        test_3();

    translate([20, 20])
        test_4();
}

test_all();
