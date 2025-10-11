use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>
use <../../lib/util.scad>


rod_diameter = 16.0;

pummel_base_diameter = 20;
pummel_base_height = 50;

pummel_transition_length = 30;
pummel_transition_twist = 90;

pummel_tip_diameter = 32;


$fn = $preview ? 48 : 120;


f_circle = function(t) [cos(t * 360), sin(t * 360)];

f_square_point = function(n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = n % 4)
    n == 0 ? [1, 0] :
    n == 1 ? [0, 1] :
    n == 2 ? [-1, 0] :
    n == 3 ? [0, -1] :
    undef;

f_square = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 4),
        sector_t = t * 4 - sector,
        sector_point_a = f_square_point(sector),
        sector_point_b = f_square_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);

module rod() {
    translate([0, 0, 0.01])
    mirror([0, 0, 1])
    cylinder(h = 100, r = rod_diameter / 2);
}

module pummel_base() {
    translate([0, 0, -pummel_base_height])
    cylinder(h = pummel_base_height, r = pummel_base_diameter / 2);
}

module pummel_transition() {
    f_slice = function(t, ease_interp, ease_scale, ease_twist)
        pts_translate3(
            pts_inflate(
                pts_rotate2(
                    pts_scale2(
                        pts_f_interp(
                            f_circle,
                            f_square,
                            ease_interp(t)
                        ),
                        lerp(pummel_base_diameter / 2, pummel_tip_diameter / 2, ease_scale(t)) * [1, 1]
                    ),
                    ease_twist(t) * pummel_transition_twist
                )
            ),
            [0, 0, t * pummel_transition_length]
        );

    f_slice_eased = function(t) f_slice(t, function(t) ease_in_sine(t), function(t) ease_in_out_sine(t), function(t) ease_in_sine(t));

    pts_extrude([ for (t = [0 : 1 / floor(pummel_transition_length * 2) : 1]) f_slice_eased(t) ], loop = false);
}

module pummel_tip() {
    translate([0, 0, pummel_transition_length])
    rotate([0, 0, pummel_transition_twist])
    rotate_extrude($fn = 4)
    half2("y+")
    half2("x+")
    circle(pummel_tip_diameter / 2, $fn = 4);
}

module pummel() {
    difference() {
        pummel_base();

        rod();
    }

    pummel_transition();

    pummel_tip();
}

pummel();
