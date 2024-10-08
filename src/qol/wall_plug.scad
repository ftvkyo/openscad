use <../../lib/util.scad>
use <../../lib/maths.scad>


length = 50;

diameter_hole = 15; // [13, 15]
diameter_screw = 4;
diameter_cap = diameter_hole + 2;

section_count = 3;
section_length = length / section_count;
section_scale = 0.7;

cap_height = 1.5;


module __hidden__() {}


half_gap = 1;

r0 = diameter_screw / 2;
r1 = diameter_hole / 2;
r2 = lerp(diameter_screw, diameter_hole, 5/8) / 2;

E = 0.01;
$fn = 48;


module section() {
    module profile() {
        polygon([
            [0, 0],
            [0, section_length + E],
            [r2, section_length + E],
            [r1, 0],
        ]);
    }

    rotate_extrude()
    scale([0.9, 1])
    profile();

    rotate_extrude($fn = 4)
    scale([1.1, 1])
    profile();

    // rotate([0, 0, 45])
    // rotate_extrude($fn = 4)
    // profile();
}


module plug() {
    rotate([0, 90, 0])
    difference() {
        union() {
            for (sec = [0 : section_count - 1]) {
                s = lerp(1, section_scale, sec / section_count);

                translate([0, 0, sec * section_length])
                scale([s, s, 1])
                section();
            }

            cylinder(cap_height, r = diameter_cap / 2);
        }

        cylinder(length + E * 2, r = r0);

        translate([0, 0, -E])
        cylinder(cap_height * 2 + E * 2, r1 = r0 * 2, r2 = r0);
    }
}


module plug_export() {
    translate([0, 0, - diameter_cap])
    %plug();

    half3()
    translate([0, diameter_cap / 2 + 1/2, - half_gap / 2])
    plug();

    half3()
    translate([0, - diameter_cap / 2 - 1/2, - half_gap / 2])
    plug();

    translate([cap_height / 2, 0, 1/2])
    cube([cap_height, 2 + E, 1], center = true);
}


plug_export();
