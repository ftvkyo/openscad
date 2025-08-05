use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


function f_slice(shape_a, shape_b, r_a, r_b, twist, twist_offset, height, height_offset, ease_interp, ease_scale, ease_twist) =
    function(t)
        pts_translate3(
            pts_inflate(
                pts_rotate2(
                    pts_scale2(
                        pts_f_interp_free(
                            shape_a,
                            shape_b,
                            ease_interp(t)
                        ),
                        [1, 1] * lerp_free(r_a, r_b, ease_scale(t))
                    ),
                    ease_twist(t) * twist + twist_offset
                )
            ),
            [0, 0, t * height + height_offset]
        );


slices = 3;


module pts_slice(f) {
    pts_extrude([ for (t = [0 : 1 / ($fn / slices) : 1]) f(t) ], loop = false);
}


r1 = 30;
r2 = 40;
r3 = 35;
r4 = 45;

height = 100;
twist = 45;

$fn = 120;


module vase() {
    pts_slice(f_slice(
        shape_a = f_hexagon,
        shape_b = f_star12,
        r_a = r1,
        r_b = r2,
        twist = 30,
        twist_offset = 0,
        height = height / 3,
        height_offset = 0,
        ease_interp = function(t) ease_in_out_sine(t),
        ease_scale = function(t) ease_in_out_quadratic(t),
        ease_twist = function(t) ease_in_cubic(t)
    ));

    pts_slice(f_slice(
        shape_a = f_star12,
        shape_b = f_star12_rot1,
        r_a = r2,
        r_b = r3,
        twist = 30,
        twist_offset = 30,
        height = height / 3,
        height_offset = height / 3,
        ease_interp = function(t) ease_in_out_sine(t),
        ease_scale = function(t) ease_in_out_quadratic(t),
        ease_twist = function(t) ease_out_cubic(t)
    ));

    pts_slice(f_slice(
        shape_a = f_star12_rot1,
        shape_b = f_circle,
        r_a = r3,
        r_b = r4,
        twist = - 30,
        twist_offset = 60,
        height = height / 3,
        height_offset = height * 2 / 3,
        ease_interp = function(t) ease_in_out_sine(t),
        ease_scale = function(t) ease_in_out_quadratic(t),
        ease_twist = function(t) ease_in_out_cubic(t)
    ));
}

vase();
