use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


tip_width = 10.0; // [5.0 : 2.5 : 25.0]
tip_length = 20.0; // [10.0 : 2.5 : 30.0]
tip_angle = 45.0; // [10.0 : 5.0 : 60.0]

tip_rim_width = 0.5; // [0.0 : 0.25 : 1.0]
tip_rim_depth = 0.5; // [0.0 : 0.25 : 1.0]

handle_joiner_length = 20.0;

handle_sections = 4;
handle_section_length = 22.5;

handle_radius_low = 4.0;
handle_radius_high = 5.0;
handle_radius_hook = 3.0;

handle_hook_radius = 12.5;


module __hidden__() {}

assert(handle_radius_low <= handle_radius_high);

$fn = $preview ? 24 : 48;

tip_profile_length = tip_length / sin(tip_angle);
tip_back_halflength = tip_profile_length * (1 - cos(tip_angle));

handle_radius_high_inner = handle_radius_high * sqrt(3) / 2;


/* === *
 * Tip *
 * === */


module tip_profile() {
    o_inner = max(tip_rim_width, tip_rim_depth) * 3;
    o_outer = min(tip_rim_width, tip_rim_depth) * 2/3;

    offset(o_outer)
    offset(- o_inner - o_outer)
    offset(o_inner) {
        // Main surface
        translate([0, tip_rim_width])
        square([tip_profile_length, tip_width]);

        // Bottom rim
        square([tip_profile_length + tip_rim_depth, tip_rim_width]);

        // Top rim
        translate([0, tip_rim_width + tip_width])
        square([tip_profile_length + tip_rim_depth, tip_rim_width]);
    }
}

module tip_side() {
    intersection() {
        fn = $fn;

        translate([- tip_length / tan(tip_angle), 0, 0])
        rotate_extrude(angle = tip_angle, $fn = fn * (360 / tip_angle))
        tip_profile($fn = fn);

        cube([tip_back_halflength, tip_length + tip_rim_depth, tip_width + tip_rim_width * 2]);
    }
}

module tip_front() {
    translate([0, tip_length, 0])
    rotate([0, 0, tip_angle])
    rotate_extrude(angle = 180 - tip_angle * 2)
    intersection() {
        translate([- tip_profile_length, 0])
        tip_profile();

        square([tip_rim_depth, tip_width + tip_rim_width * 2]);
    }
}

module tip() {
    tip_side();

    mirror([1, 0, 0])
    tip_side();

    tip_front();
}


/* ====== *
 * Handle *
 * ====== */


module pts_slice(
    height,
    shape_a,
    shape_b,
    shape_ease,
    scale_a = 1,
    scale_b = 1,
    scale_ease = function(t) t
) {
    f = function(t)
        pts_translate3(
            pts_inflate(
                pts_scale2(
                    pts_f_interp_free(
                        shape_a,
                        shape_b,
                        shape_ease(t)
                    ),
                    [1, 1] * lerp_free(scale_a, scale_b, scale_ease(t))
                )
            ),
            [0, 0, t * height]
        );

    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f(t) ], loop = false);
}


module handle_section() {
    fn_edge = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y + sqrt(3) / 2];
    fn_middle = function(t)
        let (p = f_circle(t))
        [p.x, p.y + 4/5];

    pts_slice(
        height = handle_section_length / 2,
        shape_a = fn_edge,
        shape_b = fn_middle,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = handle_radius_high,
        scale_b = handle_radius_low,
        scale_ease = function(t) ease_in_out_sine(t)
    );

    translate([0, 0, handle_section_length / 2])
    pts_slice(
        height = handle_section_length / 2,
        shape_a = fn_middle,
        shape_b = fn_edge,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = handle_radius_low,
        scale_b = handle_radius_high,
        scale_ease = function(t) ease_in_out_sine(t)
    );
}


module handle_joiner() {
    fn_a = function(t)
        let (p = f_square6(t))
        [p.x * tip_back_halflength, (p.y + 1) * (tip_width / 2 + tip_rim_width)];
    fn_b = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y + sqrt(3) / 2] * handle_radius_high;

    pts_slice(
        height = handle_joiner_length,
        shape_a = fn_a,
        shape_b = fn_b,
        shape_ease = function(t) ease_in_out_sine(ease_out_sine(t))
    );
}


module handle_hook() {
    a = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y + sqrt(3) / 2];

    b = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y + 4/5];

    c = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y + 4/5];

    a_scale = handle_radius_high;
    b_scale = handle_radius_hook;
    c_scale = handle_radius_hook;

    ab_angle = 30;
    ab_ease_shape = function(t) ease_in_out_sine(t);
    ab_ease_scale = function(t) ease_in_out_sine(t);

    bc_angle = 180;
    bc_ease_shape = function(t) ease_in_out_sine(t);
    bc_ease_scale = function(t) ease_in_out_sine(t);

    angle_factor = 6.25;

    f_ab = function(t)
        pts_translate3(
            pts_rotate3(
                pts_translate3(
                    pts_inflate_xz(
                        pts_scale2(
                            pts_f_interp_free(
                                a,
                                b,
                                ab_ease_shape(t)
                            ),
                            [1, 1] * lerp_free(a_scale, b_scale, ab_ease_scale(t))
                        )
                    ),
                    [handle_hook_radius * angle_factor, 0, 0]
                ),
                [0, 0, t * ab_angle]
            ),
            [- handle_hook_radius * angle_factor, 0, 0]
        );

    bc_offset = [(cos(ab_angle) - 1) * handle_hook_radius, sin(ab_angle) * handle_hook_radius, 0] * (1 + angle_factor);

    f_bc = function(t)
        pts_translate3(
            pts_mirror_y(
                pts_rotate3(
                    pts_translate3(
                        pts_inflate_xz(
                            pts_scale2(
                                pts_f_interp_free(
                                    b,
                                    c,
                                    bc_ease_shape(t)
                                ),
                                [1, 1] * lerp_free(b_scale, c_scale, bc_ease_scale(t))
                            )
                        ),
                        [-handle_hook_radius, 0, 0]
                    ),
                    [0, 0, t * (bc_angle + ab_angle) - ab_angle]
                )
            ),
            [handle_hook_radius, 0, 0] + bc_offset
        );



    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f_ab(t) ], loop = false);

    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f_bc(t) ], loop = false);

    translate([- handle_hook_radius * angle_factor, 0, 0])
    rotate([0, 0, ab_angle])
    translate([handle_hook_radius * angle_factor, 0, 0])
    translate([handle_hook_radius, 0, 0])
    rotate([0, 0, - bc_angle - ab_angle])
    translate([- handle_hook_radius, 0, 0])
    translate([0, 0, handle_radius_hook * 4/5])
    rotate_extrude(angle = 180)
    intersection() {
        circle(handle_radius_hook, $fn = 6);

        translate([handle_radius_hook / 2, 0])
        square([handle_radius_hook, handle_radius_hook * 2], center = true);
    }
}


module handle() {
    rotate([90, 0, 0])
    handle_joiner();

    translate([0, - handle_joiner_length, 0])
    render()
    intersection() {
        rotate([90, 0, 0])
        union() {
            for (i = [0 : handle_sections - 1])
            translate([0, 0, i * handle_section_length])
            handle_section();

            translate([0, 0, handle_sections * handle_section_length])
            rotate([90, 0, 180])
            mirror([1, 0, 0])
            handle_hook();
        }

        boundary = [handle_radius_high * 8, handle_sections * handle_section_length * 2, handle_radius_high_inner * 2];

        translate([0, - boundary.y, boundary.z] / 2)
        cube([boundary.x, boundary.y, boundary.z], center = true);
    }
}


module assembly() {
    tip();
    handle();
}


assembly();
