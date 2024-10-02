
use <../../lib/parts.scad>
use <../../lib/fasteners.scad>


/* [Output] */

RENDER = "all"; // ["all", "bearing-outer", "bearing-inner-top", "bearing-inner-bottom", "bearing-cage"]


/* [Dimensions] */

height = 15;
diameter = 50;
tooth_r = 3;
tooth_twist = 45;

sphere_z_factor = 1/2;

center_hole_r = 3;


/* [Hidden] */

$fn = 24;
E = 0.01;


module _render(r) {
    if (RENDER == "all" || RENDER == r)
        children();
}


module fidget() {
    assert(diameter >= 40);

    difference() {
        bearing(
            shell_height = height,
            shell_outer_diameter = diameter,
            shell_inner_diameter = diameter - 20,
            shell_inner_joiner_count = 3,
            shell_inner_joiner_height = 4,
            shell_inner_gap = 0.2,
            ball_diameter = 3.5,
            ball_count = 12,
            ball_margin = 0.2,
            cage_margin = 0.5,
            cage_ball_margin = 0.3,
            solid = true,
            RENDER = RENDER
        ) {
            translate([0, 0, - 2]) screw_M2x6(hole = true);
            heat_insert_M2(hole = true);
        }

        cylinder(height, r = center_hole_r, center = true);
    }


    shell_circ = diameter * PI;

    // Half of the width of the base of the triangle
    tooth_hw = tooth_r * sin(60);
    tooth_h = tooth_r * cos(60) + tooth_r;
    tooth_count = floor(shell_circ / tooth_hw / 2);
    // Offset from the origin to the base of the tooth
    // such that its vertices are on the circumference
    tooth_offset = sqrt((diameter / 2) ^ 2 - tooth_hw ^ 2);
    // Offset from the origin to the center of the tooth
    tooth_offset_full = tooth_offset + tooth_r * cos(60) - E;

    module tooth_profile() {
        translate([tooth_offset_full, 0])
            circle(tooth_r, $fn = 3);
    }

    _render("bearing-outer")
    intersection() {
        scale([1, 1, sphere_z_factor])
            sphere(diameter / 2 + tooth_h, $fn = 48);

        for (tooth = [0 : tooth_count - 1])
        rotate([0, 0, tooth / (tooth_count - 1/2) * 360]) {
            linear_extrude(height / 2 - E, twist = tooth_twist / 2)
                tooth_profile();

            mirror([0, 0, 1])
            linear_extrude(height / 2 - E, twist = tooth_twist / 2)
                tooth_profile();
        }
    }
}


fidget();
