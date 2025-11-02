use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


umbrella_radius_a = 6.65;
umbrella_radius_b = 6.65;
umbrella_radius_c = 4.75;

umbrella_length_ab = 60.0;
umbrella_length_bc = 20.0;

clearance = 0.2;


tip_radius_a = 8.0;
tip_radius_b = 12.5;
tip_radius_c = 15.0;
tip_radius_d = 12.5;
tip_radius_e = 1.0;

tip_length = 100.0;

tip_twist_a = 0.0;
tip_twist_b = 60.0;
tip_twist_c = 120.0;
tip_twist_d = 60.0;
tip_twist_e = 0.0;


module pts_slice(
    height,
    shape_a,
    shape_b,
    shape_ease,
    scale_a = 1,
    scale_b = 1,
    scale_ease = function(t) t,
    twist_a = 0,
    twist_b = 0,
    twist_ease = function(t) t
) {
    $fn = $fn ? $fn : 24;

    f = function(t)
        pts_translate3(
            pts_inflate(
                pts_rotate2(
                    pts_scale2(
                        pts_f_interp_free(
                            shape_a,
                            shape_b,
                            shape_ease(t)
                        ),
                        [1, 1] * lerp_free(scale_a, scale_b, scale_ease(t))
                    ),
                    lerp_free(twist_a, twist_b, twist_ease(t))
                )
            ),
            [0, 0, height * t]
        );

    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f(t) ], loop = false);
}


module umbrella(hole = false) {
    $fn = 24;

    clearance = hole ? clearance : 0.0;

    translate([0, 0, - 0.01]) {
        cylinder(h = umbrella_length_ab, r1 = umbrella_radius_a + clearance, r2 = umbrella_radius_b + clearance);

        translate([0, 0, umbrella_length_ab])
        cylinder(h = umbrella_length_bc, r1 = umbrella_radius_b + clearance, r2 = umbrella_radius_c + clearance);

        translate([0, 0, umbrella_length_ab + umbrella_length_bc])
        sphere(umbrella_radius_c + clearance);
    }
}


module tip() {
    fn_a = function(t)
        let (p = f_circle(t))
        [p.x, p.y];
    fn_b = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y];
    fn_c = function(t)
        let (p = f_star12_rot23(t))
        [p.x, p.y];
    fn_d = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y];
    fn_e = function(t)
        let (p = f_hexagon(t))
        [p.x, p.y];

    pts_slice(
        height = tip_length / 4,
        shape_a = fn_a,
        shape_b = fn_b,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = tip_radius_a,
        scale_b = tip_radius_b,
        scale_ease = function(t) ease_in_out_sine(t),
        twist_a = tip_twist_a,
        twist_b = tip_twist_b,
        twist_ease = function(t) ease_in_sine(t)
    );

    translate([0, 0, tip_length * 1/4])
    pts_slice(
        height = tip_length / 4,
        shape_a = fn_b,
        shape_b = fn_c,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = tip_radius_b,
        scale_b = tip_radius_c,
        scale_ease = function(t) ease_in_out_sine(t),
        twist_a = tip_twist_b,
        twist_b = tip_twist_c,
        twist_ease = function(t) ease_out_sine(t)
    );

    translate([0, 0, tip_length * 2/4])
    pts_slice(
        height = tip_length / 4,
        shape_a = fn_c,
        shape_b = fn_d,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = tip_radius_c,
        scale_b = tip_radius_d,
        scale_ease = function(t) ease_in_out_sine(t),
        twist_a = tip_twist_c,
        twist_b = tip_twist_d,
        twist_ease = function(t) ease_in_sine(t)
    );

    translate([0, 0, tip_length * 3/4])
    pts_slice(
        height = tip_length / 4,
        shape_a = fn_d,
        shape_b = fn_e,
        shape_ease = function(t) ease_in_out_sine(t),
        scale_a = tip_radius_d,
        scale_b = tip_radius_e,
        scale_ease = function(t) ease_in_cubic(t),
        twist_a = tip_twist_d,
        twist_b = tip_twist_e,
        twist_ease = function(t) ease_out_sine(t)
    );
}

render()
difference() {
    tip();

    umbrella();
}
