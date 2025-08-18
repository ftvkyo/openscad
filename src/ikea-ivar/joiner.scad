use <../../lib/util.scad>

leg_width = 70;
leg_margin = 5;

joiner_rounding = 5;
joiner_thickness = 4;

screw_r = 1.9;
screw_h = 19.2;
screw_cap_r = 3.75;
screw_cap_h = 2.8;

module screw(hole = false) {
    $fn = 24;

    translate(hole ? [0, 0, 0.05] : [0, 0, 0])
    mirror([0, 0, 1]) {
        cylinder(h = screw_cap_h, r1 = screw_cap_r, r2 = screw_r);
        cylinder(h = screw_h, r = screw_r);
    }

    if (hole) {
        cylinder(h = 1, r = screw_cap_r);
    }
}

module joiner() {
    x = leg_width - leg_margin * 2 - joiner_rounding * 2;
    y = leg_width * 2 - leg_margin * 2 - joiner_rounding * 2;

    module rounder() {
        $fn = 24;

        rotate_extrude()
        polygon([
            [0, 0],
            [joiner_rounding, 0],
            [0, joiner_thickness - 1],
        ]);
    }

    module plate() {
        minkowski() {
            linear_extrude(1)
            square([x, y], center = true);

            rounder();
        }
    }

    module screw_hole() {
        translate([0, 0, joiner_thickness])
        screw(hole = true);
    }

    module screw_hole_group() {
        o = leg_width / 2 - leg_margin * 3;

        translate([o, o, 0])
        screw_hole();

        translate([o, -o, 0])
        screw_hole();

        translate([-o, o, 0])
        screw_hole();

        translate([-o, -o, 0])
        screw_hole();
    }

    difference() {
        plate();

        translate([0, leg_width / 2, 0])
        screw_hole_group();


        translate([0, - leg_width / 2, 0])
        screw_hole_group();
    }
}

joiner();
