use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


tip_width = 10.0; // [10.0 : 5.0 : 30.0]
tip_length = 20.0;

tip_front_end_thickness = 0.5;
tip_front_end_rounding = 0.5;

tip_back_end_thickness = 4.0;
tip_back_end_rounding = 2.0;

handle_joiner_length = 20.0;
handle_length = 100.0;
handle_radius = 4.0;


tip_thickness = max(tip_front_end_thickness, tip_back_end_thickness);

$fn = $preview ? 24 : 48;


function tip_top_point(t) =
    assert(0 <= t && t <= 1, str("0 <= t && t <= 1, got t = ", t))
    [- tip_length * (1 - t), tip_front_end_thickness + (tip_back_end_thickness - tip_front_end_thickness) * (t ^ 2)];

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

module pts_slice(f) {
    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f(t) ], loop = false);
}


module tip() {
    intersection() {
        rotate([90, 0, 0])
        linear_extrude(tip_width, center = true)
        polygon([ for (p = [
            [[- tip_length, 0]],
            [ for (t = [0 : 1 / $fn : 1]) tip_top_point(t)],
            [[0, 0]],
        ]) each p ]);

        linear_extrude(tip_thickness)
        offset(tip_front_end_rounding)
        offset(-tip_front_end_rounding)
        polygon([
            [- tip_length, tip_width / 2],
            [tip_front_end_rounding, tip_width / 2],
            [tip_front_end_rounding, - tip_width / 2],
            [- tip_length, - tip_width / 2],
        ]);

        linear_extrude(tip_thickness)
        offset(tip_back_end_rounding)
        offset(-tip_back_end_rounding)
        polygon([
            [- tip_length - tip_back_end_rounding, tip_width / 2],
            [0, tip_width / 2],
            [0, - tip_width / 2],
            [- tip_length - tip_back_end_rounding, - tip_width / 2],
        ]);
    }
}

module handle() {
    f_tip_back_slice = function(t)
        let (p = f_square(t))
        [p.x, p.y];

    f_handle_slice = function(t)
        let (p = f_circle_45(t))
        [p.x + 1/5, p.y];

    intersection() {
        translate([0, 0, tip_back_end_thickness / 2])
        render()
        rotate([180, 270, 0]) {
            pts_slice(f_slice(
                shape_a = f_tip_back_slice,
                shape_b = f_handle_slice,
                r_a = tip_back_end_thickness / 2,
                r_b = handle_radius,
                twist = 0,
                twist_offset = 0,
                height = handle_joiner_length,
                height_offset = 0,
                ease_interp = function(t) t,
                ease_scale = function(t) ease_in_out_sine(t),
                ease_twist = function(t) t
            ));

            translate([0, 0, handle_joiner_length])
            pts_slice(f_slice(
                shape_a = f_handle_slice,
                shape_b = f_handle_slice,
                r_a = handle_radius,
                r_b = handle_radius,
                twist = 0,
                twist_offset = 0,
                height = handle_length,
                height_offset = 0,
                ease_interp = function(t) t,
                ease_scale = function(t) t,
                ease_twist = function(t) t
            ));

            translate([handle_radius / 5, 0, handle_joiner_length + handle_length])
            sphere(handle_radius);
        }

        translate([0, 0, handle_radius * 4/5])
        cube([handle_length * 3, handle_radius * 2, handle_radius * 8/5], center = true);
    }
}

module label(t) {
    translate([handle_joiner_length + 4, 0, handle_radius * 8/5])
    color("grey")
    linear_extrude(t * 2, center = true, convexity = 10)
    text(
        str("L", tip_length, " W", tip_width, " T", tip_front_end_thickness),
        font = "JetBrains Mono:bold",
        size = handle_radius * 3/4,
        halign = "left",
        valign = "center"
    );
}


module assembly() {
    tip();

    difference() {
        handle();
        label(0.4);
    }
}

assembly();
