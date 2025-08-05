use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>

r1 = 35;
r2 = 50;
height = 75;
twist = 45;

$fn = 180;
slices = 180;

ease_interp = function(t) ease_in_out_sine(t);

ease_scale  = function(t) ease_in_cubic(t);

ease_twist1 = function(t) ease_in_cubic(t);
ease_twist2 = function(t) ease_out_cubic(t);

module vase() {
    fs_slice = [
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp_free(
                                f_hexagon,
                                f_star6,
                                ease_interp(t)
                            ),
                            [1, 1] * lerp_free(r1, r2, ease_scale(t / 2))
                        ),
                        ease_twist1(t) * twist
                    )
                ),
                [0, 0, t * height / 2]
            ),
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp_free(
                                f_star6,
                                f_circle,
                                ease_interp(t)
                            ),
                            [1, 1] * lerp_free(r1, r2, ease_scale((t + 1) / 2))
                        ),
                        ease_twist2(t) * twist + twist
                    )
                ),
                [0, 0, (t + 1) * height / 2]
            ),
    ];

    pts_extrude([ for (t = [0 : 1 / (slices / 2) : 1]) fs_slice[0](t) ], loop = false);
    pts_extrude([ for (t = [0 : 1 / (slices / 2) : 1]) fs_slice[1](t) ], loop = false);
}

vase();
