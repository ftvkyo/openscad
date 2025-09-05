use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>


$fn = 120;

f_circle = function(t) [cos(t * 360), sin(t * 360)];

f_hexagon_point = function(n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = n % 6)
    let (r = sqrt(3) / 2)
    n == 0 ? [1, 0] :
    n == 1 ? [1/2, r] :
    n == 2 ? [- 1/2, r] :
    n == 3 ? [-1 , 0] :
    n == 4 ? [- 1/2, - r] :
    n == 5 ? [1/2, - r] :
    undef;

f_hexagon = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        r = sqrt(3) / 2,
        sector = floor(t * 6),
        sector_t = t * 6 - sector,
        sector_point_a = f_hexagon_point(sector),
        sector_point_b = f_hexagon_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);


base_radius = 37.75;
base_height = 5;

ear_offset = 7.6;
ear_thickness = 3;
ear_width = 12;
ear_extent = 99.5;
ear_hole_radius = 2.25;

back_radius = 34.5;
back_height = 51.2;
back_thickness = 3;

elevation_height = 10;
elevation_twist = 0;

bend_radius1 = 35;
bend_radius2 = 3.5;
bend_angle = 45;
bend_factor = 2.5;
bend_twist = 180;

ball_radius = 8.55;

module base() {
    translate([0, 0, - base_height])
    cylinder(h = base_height, r = base_radius);
}

module ears() {
    module profile() {
        difference() {
            union() {
                square([ear_extent - ear_width, ear_width], center = true);

                translate([ear_extent / 2 - ear_width / 2, 0])
                circle(ear_width / 2);

                translate([- ear_extent / 2 + ear_width / 2, 0])
                circle(ear_width / 2);
            }

            circle(back_radius - back_thickness);

            translate([ear_extent / 2 - ear_width / 2, 0])
            circle(ear_hole_radius);

            translate([- ear_extent / 2 + ear_width / 2, 0])
            circle(ear_hole_radius);
        }
    }

    translate([0, 0, - ear_thickness / 2 - ear_offset])
    linear_extrude(ear_thickness, center = true)
    profile();

    translate([0, 0, - ear_offset / 2])
    linear_extrude(ear_offset, center = true)
    intersection() {
        profile();
        circle(base_radius);
    }
}

module back() {
    translate([0, 0, - back_height / 2])
    difference() {
        cylinder(h = back_height, r = back_radius, center = true);
        cylinder(h = back_height + 1, r = back_radius - back_thickness, center = true);
    }
}

module elevation() {
    f_slice = function(t, ease_interp, ease_twist)
    pts_translate3(
        pts_inflate(
            pts_rotate2(
                pts_scale2(
                    pts_f_interp(
                        f_circle,
                        f_hexagon,
                        ease_interp(t)
                    ),
                    [bend_radius1, bend_radius1]
                ),
                ease_twist(t) * elevation_twist
            )
        ),
        [0, 0, elevation_height * t]
    );

    f_slice_eased = function(t) f_slice(t, function(t) ease_out_sine(t), function(t) ease_in_out_sine(t));

    pts_extrude([ for (t = [0 : 1 / bend_angle : 1]) f_slice_eased(t) ], loop = false);
}

module bend() {
    f_slice = function(t, ease_interp, ease_scale, ease_twist)
    pts_translate3(
        pts_rotate3(
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp(
                                // f_circle,
                                f_hexagon,
                                f_hexagon,
                                // f_circle,
                                ease_interp(t)
                            ),
                            lerp(bend_radius1, bend_radius2, ease_scale(t)) * [1, 1]
                        ),
                        ease_twist(t) * bend_twist
                    )
                ),
                [-bend_radius1 * bend_factor, 0, 0]
            ),
            [0, bend_angle * t, 0]
        ),
        [bend_radius1 * bend_factor, 0, 0]
    );

    f_slice_eased = function(t) f_slice(t, function(t) ease_in_sine(t), function(t) ease_in_out_sine(t), function(t) ease_in_sine(t));

    pts_extrude([ for (t = [0 : 1 / bend_angle : 1]) f_slice_eased(t) ], loop = false);
}

module ball() {
    sphere(ball_radius);
}


module assembly() {
    base();

    ears();

    back();

    elevation();

    rotate([0, 0, elevation_twist])
    translate([0, 0, elevation_height]) {
        bend();

        translate([bend_radius1 * bend_factor, 0, 0])
        rotate([0, bend_angle, 0])
        translate([- bend_radius1 * bend_factor, 0, ball_radius * 3/4])
        ball();
    }
}


assembly();
