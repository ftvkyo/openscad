use <../../lib/shape.scad>
use <../../lib/ops.scad>


side_length = 25;


module side(l) {
    translate([cos(30) * l, 0, 0])
    rotate([90, 0, 0])
        spiral(l, 2.5, 0.4, 2, center = true, $fn = 20);
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

        translate([0, 0, 3.5])
        flatten(4)
        rotate([0, 90, -8])
            cylinder(s * 2, r = 2.75, center = true, $fn = 36);
    }
}


/* Assembly */


module assembly_to_glue() {
    intersection() {
        translate([0, 0, 500])
            cube(1000, center = true);

        union() {
            translate([side_length * 3/2, 0, 0])
            thing(side_length);

            translate([- side_length * 3/2, 0, 0])
            rotate([0, 180, 180])
                thing(side_length);
        }
    }
}


module assembly_flattened() {
    intersection() {
        translate([0, 0, 500])
            cube(1000, center = true);

        translate([0, 0, 1.33])
            thing(side_length);
    }
}


/* Export */


// assembly_to_glue();
assembly_flattened();
