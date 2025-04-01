use <../../lib/util.scad>


PART = "all"; // ["all", "screw", "export-1", "export-2"]

crystal_l = 60;
crystal_f = 0.35;
rope_r = 3;

screw_wall = 0.8;
screw_h = 7.5;
screw_hole_r = 4.5;

T = 0.25;
E = 0.01;


module crystal_rope_slot() {
    translate([0, 0, E])
    mirror([0, 0, 1])
    cylinder(crystal_l, r = rope_r, $fn = 24);
}

module crystal_cutoff() {
    translate([0, 0, - crystal_l / 2])
    cylinder(crystal_l / 5, r = crystal_l);
}

module crystal_base() {
    module crystal() {
        for (a = [0, 180])
        rotate([0, 0, a])
        scale([crystal_f, crystal_f, 1] * crystal_l)
        rotate([45, 35.25, 0])
        cube(sqrt(3) / 3, center = true);
    }

    difference() {
        crystal();

        crystal_rope_slot();
        crystal_cutoff();
    }
}

module screw_outside(wall) {
    translate([0, 0, - E])
    intersection() {
        linear_extrude(screw_h, twist = 360 * screw_h / 5, slices = 120, convexity = 10)
        scale([1.2, 1, 1])
        circle(screw_hole_r + wall, $fn = 48);

        cylinder(screw_h, r1 = screw_hole_r * 2.5, r2 = screw_hole_r + wall, $fn = 48);
    }
}

module screw_inside() {
    cylinder(screw_h * 2 + E, r = screw_hole_r, $fn = 48, center = true);
}

module crystal_top() {
    difference() {
        half3("z+")
        crystal_base();

        screw_outside(screw_wall + T);
    }
}

module crystal_bottom() {
    difference() {
        union() {
            half3("z-")
            crystal_base();

            screw_outside(screw_wall);
        }

        screw_inside();
    }
}


if (PART == "all") {
    crystal_top();

    translate([0, 0, - screw_h - 2.5])
    crystal_bottom();
} else if (PART == "screw") {
    difference() {
        screw_outside(screw_wall);
        screw_inside();
    }

    translate([20, 0, 0])
    difference() {
        screw_outside(screw_wall + T);
        scale([1, 1, 1.001])
        screw_outside(screw_wall);
    }
} else if (PART == "export-1") {
    crystal_top();
} else if (PART == "export-2") {
    crystal_bottom();
} else {
    assert(false);
}
