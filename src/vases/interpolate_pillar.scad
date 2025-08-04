use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

r1 = 35;
r2 = 50;
height = 75;
twist = 45;

$fn = 180;
slices = 180;

ease_interp = function(t) ease_in_out_sine(t);

ease_scale  = function(t) ease_in_bounce(t);

ease_twist1 = function(t) ease_in_cubic(t);
ease_twist2 = function(t) ease_out_cubic(t);

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
        sector = floor(t * 6),
        sector_t = t * 6 - sector,
        sector_point_a = f_hexagon_point(sector),
        sector_point_b = f_hexagon_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);


module vase() {
    fs_slice = [
        function(t)
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp_free(
                                f_hexagon,
                                f_circle,
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
                                f_circle,
                                f_hexagon,
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
