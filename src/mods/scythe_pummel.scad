use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>
use <../../lib/util.scad>

include <../../lib/points_shapes.scad>


rod_diameter = 16.0;

pummel_base_diameter = 20;
pummel_base_height = 50;

pummel_transition_length = 30;
pummel_transition_twist = 90;

pummel_tip_diameter = 32;


$fn = $preview ? 48 : 120;


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
                            f_diamond,
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
