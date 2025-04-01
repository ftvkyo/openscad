use <../../lib/util.scad>


PART = "all"; // ["all", "top", "bottom"]

crystal_l = 50;
rope_r = 2;

screw_wall = 0.8;
screw_h = 7.5;
screw_hole_r = 3.5;

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
        scale([0.4, 0.4, 1] * crystal_l)
        rotate([45, 35.25, 0])
        cube(sqrt(3) / 3, center = true);
    }

    difference() {
        crystal();

        crystal_rope_slot();
        crystal_cutoff();
    }
}

module crystal_top() {
    f = 1.05;

    difference() {
        half3("z+")
        crystal_base();

        scale(f)
        screw_outside();
    }
}

module crystal_bottom() {
    difference() {
        union() {
            half3("z-")
            crystal_base();

            screw_outside();
        }

        screw_inside();
    }
}

module screw_outside() {
    translate([0, 0, - E])
    linear_extrude(screw_h, twist = 360 * screw_h / 5, slices = 120, convexity = 10)
    scale([1.2, 1, 1])
    circle(screw_hole_r + screw_wall, $fn = 48);
}

module screw_inside() {
    cylinder(screw_h * 2 + E, r = screw_hole_r, $fn = 48, center = true);
}


if (PART == "all") {
    crystal_top();

    translate([0, 0, - screw_h - 2.5])
    crystal_bottom();
} else if (PART == "top") {
    crystal_top();
} else if (PART == "bottom") {
    crystal_bottom();
} else {
    assert(false);
}
