module base() {
    rotate_extrude()
    scale([10, 2])
    intersection() {
        circle(1, $fn = 72);
        square(1);
    }
}

module stem() {
    linear_extrude(50, twist = 360 * 2, scale = 0.5)
    translate([1, 0])
    circle(2.5);
}

module cap() {
    translate([0, 0, 50])
    rotate_extrude()
    intersection() {
        translate([-5, 0])
        circle(12.5, $fn = 72);
        square(12.5);
    }
}

base();
stem();
cap();
