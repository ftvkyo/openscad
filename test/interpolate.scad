use <../lib/maths.scad>
use <../lib/points.scad>
use <../lib/ease.scad>

radius = 10;

bend_radius = 25;
bend_angle = 45;

twist = 30;

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

f_slice = function(t, ease_interp, ease_twist)
    pts_translate3(
        pts_rotate3(
            pts_translate3(
                pts_inflate(
                    pts_rotate2(
                        pts_scale2(
                            pts_f_interp(
                                f_circle,
                                f_hexagon,
                                ease_interp(t)
                            ),
                            [radius, radius]
                        ),
                        ease_twist(t) * twist
                    )
                ),
                [-bend_radius, 0, 0]
            ),
            [0, bend_angle * t, 0]
        ),
        [bend_radius, 0, 0]
    );

f_slice_eased = function(t) f_slice(t, function(t) ease_in_sine(t), function(t) ease_in_out_cubic(t));

pts_extrude([ for (t = [0 : 1 / bend_angle : 1]) f_slice_eased(t) ], loop = false);
