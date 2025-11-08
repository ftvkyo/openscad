use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>

// Keycap Row (0 = all, 1->5 = top->bottom)
row = 0; // [0 : 5]

pad_squariness = 0.9; // [0.01 : 0.01 : 0.99]
pad_depression = 1.0; // [0.25 : 0.25 : 2.0]

base_squariness = 0.99; // [0.01 : 0.01 : 0.99]


module __hidden__() {}

// Static parameters

pad_side = 13.0;
pad_smoothness = 4;

base_side = 18.0;

base_gap = 0.8;

// Calculated parameters

pad_heights = [
    12.5,
    9.5,
    7.4,
    7.5,
    8.5,
];

pad_angles = [
    10.0,
    7.5,
    3.0,
    -3.0,
    -7.0,
];

pad_offsets = [
    -1.0,
    -0.5,
    0.0,
    0.5,
    1.0,
];


fn_z = 24;
fn_r = 96;


f_pad = function(t) f_squircle(pad_squariness)(t);
f_base = function(t) f_squircle(base_squariness)(t);


module pts_slice(
    height,
    shape_a,
    shape_b,
    shape_ease,
    angle_a,
    angle_b,
    offset_a,
    offset_b,
    scale_a,
    scale_b,
    scale_ease
) {
    f = function(t)
        pts_translate3(
            pts_rotate3(
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
                [lerp(angle_a, angle_b, t), 0, 0]
            ),
            [0, lerp(offset_a, offset_b, t), t * height]
        );

    $fn = fn_r;

    pts_extrude([ for (t = [0 : 1 / fn_z : 1]) f(t) ], loop = false);
}


module body(row) {
    difference() {
        pts_slice(
            height = pad_heights[row] + pad_depression / 2,
            shape_a = f_base,
            shape_b = f_pad,
            shape_ease = function(t) ease_in_pow(16)(t),
            angle_a = 0,
            angle_b = pad_angles[row],
            offset_a = 0,
            offset_b = pad_offsets[row],
            scale_a = base_side / 2,
            scale_b = pad_side / 2,
            scale_ease = function(t) ease_in_sine(t)
        );

        scale_xy = pad_side * sqrt(2) / 2;

        translate([0, pad_offsets[row], pad_heights[row] + pad_depression / 2])
        rotate([pad_angles[row], 0, 0])
        scale([scale_xy, scale_xy, pad_depression])
        sphere(1, $fn = 48);
    }
}


if (row == 0) {
    for (r = [0 : 4])
    translate([0, - r * (base_side + base_gap), 0])
    render()
    body(r);
} else {
    render()
    body(row-1);
}
