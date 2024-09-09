use <../../../lib/shape.scad>


module side(l) {
    translate([cos(30) * l, 0, 0])
    rotate([90, 0, 0])
        spiral(l, 2, 0.4, 2, center = true, $fn = 12);
}

module hexagon(s) {
    for (a = [0 : 60 : 359]) {
        rotate([0, 0, a])
            side(s);
    }
}

module thing(s) {
    difference() {
        hexagon(s);

        translate([0, 0, 3])
        flatten(4)
        rotate([0, 90, -8])
            cylinder(s * 2, r = 2.5, center = true, $fn = 36);
    }
}

intersection() {
    translate([0, 0, 500])
        cube(1000, center = true);

    union() {
        translate([25, 0, 0])
        thing(20);

        translate([-25, 0, 0])
        rotate([0, 180, 180])
            thing(20);
    }
}
