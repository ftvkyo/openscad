
use <../../lib/parts.scad>
use <../../lib/fasteners.scad>


/* [Output] */

RENDER = "all"; // ["all", "bearing-outer", "bearing-inner-top", "bearing-inner-bottom", "bearing-cage"]


/* [Dimensions] */

height = 15;
diameter = 50;
groove_twist = 45;


/* [Hidden] */

$fn = 24;
E = 0.01;


module _render(r) {
    if (RENDER == "all" || RENDER == r)
        children();
}


module fidget() {
    assert(diameter >= 40);

    bearing(
        shell_height = height,
        shell_outer_diameter = diameter,
        shell_inner_diameter = diameter - 20,
        shell_inner_joiner_count = 3,
        shell_inner_joiner_height = 4,
        shell_inner_gap = 0.1,
        ball_diameter = 3.5,
        ball_count = 12,
        ball_margin = 0.2,
        cage_margin = 0.5,
        RENDER = RENDER
    ) {
        translate([0, 0, - 2]) screw_M2x6(hole = true);
        heat_insert_M2(hole = true);
    }

    _render("bearing-outer") {
        circ = diameter * PI;
        groove_count = floor(circ) / 4;

        for (groove = [0 : groove_count - 1])
        rotate([0, 0, groove / (groove_count - 1/2) * 360]) {
            linear_extrude(height / 2 - E, twist = groove_twist / 2)
            translate([diameter / 2, 0])
                circle(2, $fn = 3);

            mirror([0, 0, 1])
            linear_extrude(height / 2 - E, twist = groove_twist / 2)
            translate([diameter / 2, 0])
                circle(2, $fn = 3);
        }
    }
}


fidget();
