use <../../lib/util.scad>

crystal_l = 50;

rope_r = 2;

module crystal_rope_slot() {
    translate([0, 0, - crystal_l / 4])
    cylinder(crystal_l, r = rope_r, center = true, $fn = 24);

    translate([0, 0, - crystal_l / 2])
    cylinder(crystal_l / 5, r = crystal_l);
}

module crystal_base() {
    difference() {
        scale([0.3, 0.3, 1] * crystal_l)
        rotate([45, 35.25, 0])
        cube(sqrt(3) / 3, center = true);

        crystal_rope_slot();
    }
}

module crystal_half1() {
    half3("x+")
    crystal_base();
}

module crystal_half2() {
    half3("x-")
    crystal_base();
}

// crystal_base();

translate([10, 0, 0])
crystal_half1();

translate([-10, 0, 0])
crystal_half2();
