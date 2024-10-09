
use <../../lib/parts.scad>
use <../../lib/fasteners.scad>
use <../../lib/util.scad>


/* [Output] */

VIEW = "all"; // ["all", "bearing-outer", "bearing-inner-top", "bearing-inner-bottom", "bearing-cage", "axis"]

RESOLUTION = 12; // [12, 24, 36, 48]

CUT = false;

DEBUG = true;


/* [Dimensions] */

height = 18;
diameter = 50;

axis_r = 5;
axis_e = 20;

magnets = 6;

// tooth_r = 3;
// tooth_twist = 45;


module __hidden__() {}


inner_gap = 0.6;

$fn = RESOLUTION;
E = 0.01;
T = 0.25;


module _render(part) {
    if (VIEW == "all" || VIEW == part)
    children();
}


module part_axis(hole = false) {
    t = (hole ? T : 0);

    module lock() {
        if (hole) {
            cylinder(inner_gap / 2, r = axis_r * 3/2 + t, $fn = 6);

            translate([0, 0, inner_gap / 2])
            cylinder(inner_gap * 3, r1 = axis_r * 3/2 + t, r2 = axis_r + t, $fn = 6);
        } else {
            cylinder(inner_gap * 3, r1 = axis_r * 3/2 + t, r2 = axis_r + t, $fn = 6);
        }
    }

    module tip() {
        translate([0, 0, height / 2 + axis_e - axis_r])
        rotate([90, 0, 0])
        rotate_extrude()
        half2()
        circle(axis_r + t, $fn = 6);
    }

    intersection() {
            difference() {
                union() {
                    cylinder(height + axis_e * 2 - axis_r * 2, r = axis_r + t, center = true, $fn = 6);

                    lock();
                    tip();

                    mirror([0, 0, 1]) {
                        lock();
                        tip();
                    }
                }

                translate([0, 0, height / 2 + axis_e - axis_r])
                rotate([90, 0, 0])
                cylinder(axis_r * 2, r = 3/2, center = true);

                translate([0, 0, - height / 2 - axis_e + axis_r])
                rotate([90, 0, 0])
                cylinder(axis_r * 2, r = 3/2, center = true);
        }

        cube([diameter / 2, axis_r * cos(30) * 2, height + axis_e * 2,], center = true);
    }
}


module magnet(hole = false) {
    h = 1.75;
    d = 4.85;

    if (hole) {
        cylinder(h + T, r = d / 2 + T, center = true);
    } else {
        cylinder(h, r = d / 2, center = true, $fn = 12);
    }
}


module part_magnets(hole = false) {
    color("grey")
    for (m = [0 : magnets - 1])
    rotate([0, 0, 60 + 360 * m / magnets])
    translate([(diameter - 10) / 2, 0, 0]) {
        translate([2, 0, 0])
        magnet(hole);

        translate([- 4, 0, 0])
        if (hole) {
            translate([0, 0, inner_gap / 2])
            magnet(hole);

            translate([0, 0, - inner_gap / 2])
            magnet(hole);
        } else {
            magnet(hole);
        }
    }
}


module part_bearing() {
    difference() {
        bearing(
            shell_height = height,
            shell_outer_diameter = diameter,
            shell_inner_diameter = diameter - 20,
            shell_inner_joiner_count = 3,
            shell_inner_joiner_height = height / 2,
            shell_inner_gap = inner_gap,
            ball_diameter = 3.5,
            ball_count = 12,
            ball_margin = 0.1,
            cage_margin = 0.5,
            cage_ball_margin = 0.3,
            solid = true,
            // Render params
            PART = VIEW,
            DEBUG = DEBUG,
            fn_rotate_extrude = RESOLUTION * 2
        ) {
            translate([0, 0, - 2]) screw_M2x6(hole = true, hole_l = 16);
            heat_insert_M2(hole = true);
        }

        part_axis(hole = true);

        part_magnets(hole = true);
    }

    module grip_profile() {
        half2()
        offset(2)
        offset(- 2)
        difference() {
            square([20, height], center = true);

            translate([10, 0])
            scale([3, height * 2/3])
            circle(1);
        }
    }

    _render("bearing-outer") {
        rotate_extrude($fn = RESOLUTION * 2)
        translate([diameter / 2 - E, 0])
        grip_profile();

        for (n = [0 : 23])
        rotate([0, 0, 360 * n / 24])
        translate([diameter / 2 + 10 - 3.5, 0, 0])
        scale([1, 2, height / 3])
        sphere(1);
    }
}


module fidget() {
    assert(diameter >= 40);

    part_bearing();

    _render("axis")
    part_axis();

    if (DEBUG) {
        %part_magnets();
    }
}


if (!CUT) {
    fidget();
} else {
    half3("y+")
    fidget();
}
