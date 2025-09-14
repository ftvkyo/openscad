/* [General] */

radius = 15;
ring_position = "vertex"; // [vertex, edge]

/* [Detail] */

thickness_connection = 1;
thickness_a = 1.5;
thickness_b = 2;

ring_thickness = 1;
ring_radius = 1.5;

/* [Colors] */

color_a = "415e9a";
color_b = "699ad7";

/* [Debug] */

enable_gap = true;


module __hidden__ () {}

radius_outer_circumscribed = radius;
radius_outer_inscribed = radius_outer_circumscribed * sqrt(3) / 2;

radius_inner_circumscribed = radius_outer_circumscribed * 2/5;
radius_inner_inscribed = radius_outer_inscribed * 2/5;

gap = enable_gap ? (radius_outer_circumscribed / 85) : 0;

rounding = radius_outer_circumscribed / 40;

lambda_thickness = radius_outer_circumscribed / 5;

T = 0.01;


/* ======= *
 * Helpers *
 * ======= */

module hexagon(r) {
    assert(is_num(r));

    circle(r, $fn = 6);
}

module rounder(r, t) {
    $fn = 12;

    rotate_extrude()
    polygon([
        [0, 0],
        [r, 0],
        [0, t],
    ]);
}


/* ===== *
 * Parts *
 * ===== */

module ring() {
    $fn = $preview ? 12 : 48;

    rotate_extrude()
    translate([ring_radius, 0]) {
        translate([0, ring_thickness / 2])
        circle(ring_thickness / 2);

        translate([0, ring_thickness / 4])
        square([ring_thickness, ring_thickness / 2], center = true);
    }
}

module lambda() {
    module mask() {
        intersection() {
            hexagon(radius_outer_circumscribed);

            translate([radius_inner_circumscribed - radius_outer_circumscribed - gap * sqrt(3), 0, 0])
            hexagon(radius_outer_circumscribed);

            translate([(radius_inner_circumscribed - radius_outer_circumscribed) / 2, radius_outer_inscribed + radius_inner_inscribed, 0])
            hexagon(radius_outer_circumscribed);
        }
    }

    module base() {
        translate([(radius_inner_circumscribed - radius_outer_circumscribed) / 2 - gap * sqrt(3), radius_inner_inscribed])
        translate([0, lambda_thickness / 2])
        square([radius_outer_circumscribed, lambda_thickness], center = true);

        rotate(120)
        square([radius_outer_circumscribed * 2, lambda_thickness], center = true);
    }

    intersection() {
        base();
        mask();
    }
}

module lambda_connection() {
    difference() {
        hexagon((radius_inner_inscribed + lambda_thickness) / (sqrt(3) / 2));
        hexagon(radius_inner_circumscribed);
    }
}


/* ======== *
 * Assembly *
 * ======== */

module assembly() {
    color(str("#", color_a))
    for(a = [0, 2, 4])
    rotate(a * 60)
    minkowski() {
        linear_extrude(thickness_a - rounding)
        offset(-rounding)
        lambda();

        rounder(rounding, rounding);
    }

    color(str("#", color_b))
    for(a = [1, 3, 5])
    rotate(a * 60)
    minkowski() {
        linear_extrude(thickness_b - rounding)
        offset(-rounding)
        lambda();

        rounder(rounding, rounding);
    }

    color("grey")
    translate([0, 0, T])
    linear_extrude(thickness_connection - T * 2)
    offset(-rounding)
    lambda_connection();

    color("grey")
    if (ring_position == "edge") {
        o = radius_outer_inscribed + ring_radius - ring_thickness * 2/3;
        translate([0, o])
        ring();
    } else if (ring_position == "vertex") {
        o = radius_outer_circumscribed + ring_radius - ring_thickness * 2/3;
        translate([o * cos(60), o * sin(60)])
        ring();
    }
}

assembly();
