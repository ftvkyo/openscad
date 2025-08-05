use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>

r1 = 30;
r2 = 50;
height = 75;
twist = 30;

$fn = 180;
slices = 72;

ease_interp = function(t) ease_in_out_cubic(t);
ease_scale = function(t) ease_out_quadratic(t);
ease_twist1 = function(t) ease_in_out_sine(t);
ease_twist2 = function(t) ease_in_out_sine(t);
ease_twist3 = function(t) ease_in_out_sine(t);

module vase() {
    fs_slice = [
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp(
                                f_hexagon,
                                f_star6,
                                ease_interp(t)
                            ),
                            [1, 1] * lerp(r1, r2, ease_scale(t / 3))
                        ),
                        ease_twist1(t) * twist
                    )
                ),
                [0, 0, t * height / 3]
            ),
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp(
                                f_star6,
                                f_hexagon,
                                ease_interp(t)
                            ),
                            [1, 1] * lerp(r1, r2, ease_scale((t + 1) / 3))
                        ),
                        ease_twist2(t) * - twist + twist
                    )
                ),
                [0, 0, (t + 1) * height / 3]
            ),
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp(
                                f_hexagon,
                                f_circle,
                                ease_interp(t)
                            ),
                            [1, 1] * lerp(r1, r2, ease_scale((t + 2) / 3))
                        ),
                        ease_twist3(t) * twist
                    )
                ),
                [0, 0, (t + 2) * height / 3]
            ),
    ];

    pts_extrude([ for (t = [0 : 1 / (slices / 3) : 1]) fs_slice[0](t) ], loop = false);
    pts_extrude([ for (t = [0 : 1 / (slices / 3) : 1]) fs_slice[1](t) ], loop = false);
    pts_extrude([ for (t = [0 : 1 / (slices / 3) : 1]) fs_slice[2](t) ], loop = false);
}

vase();
