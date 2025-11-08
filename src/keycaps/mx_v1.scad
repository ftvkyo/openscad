use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


/* [General] */

// Keycap Row (0 = all, 1->5 = top->bottom)
row = 1; // [0 : 5]

// Add a tactile dot
dot = false;

inspect = false;


/* [Defaults] */

pad_squariness = 0.9; // [0.01 : 0.01 : 0.99]
pad_depression = 1.0; // [0.25 : 0.25 : 2.0]

base_squariness = 0.99; // [0.01 : 0.01 : 0.99]


module __hidden__() {}

// Static parameters

pad_side = 13.0;
pad_smoothness = 4;

base_side = 18.0;

base_gap = 0.8;

shell_thickness = 1.5;

stem_radius = 2.5;
stem_height = 4.5;
stem_offset = 1.0;

stem_hole_depth = 3.5;
stem_hole_width1 = 1.4;
stem_hole_width2 = 4.1;

support_width = 1.0;

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


fn_z = $preview ? 12 : 24;
fn_r = $preview ? 96 : 144;


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
}


module stem(row, hollow = true) {
    translate([0, 0, stem_offset])
    difference() {
        cylinder(h = pad_heights[row] - stem_offset, r = stem_radius, $fn = 24);

        if (hollow)
        translate([0, 0, stem_hole_depth / 2]) {
            cube([stem_hole_width1, stem_hole_width2, stem_hole_depth], center = true);
            cube([stem_hole_width2, stem_hole_width1, stem_hole_depth], center = true);
        }
    }
}


module supports(row) {
    support_height = pad_heights[row] - stem_offset - stem_height;

    difference() {
        translate([0, 0, stem_offset + stem_height + support_height / 2]) {
            cube([support_width, base_side, support_height], center = true);
            cube([base_side, support_width, support_height], center = true);
        }

        stem(row, hollow = false);
    }
}


module keycap(row) {
    module antishell() {
        antishell_scale_xy = (base_side - shell_thickness * 2) / base_side;
        antishell_scale_z = (pad_heights[row] - shell_thickness * 2) / pad_heights[row];

        scale([antishell_scale_xy, antishell_scale_xy, antishell_scale_z])
        body(row);
    }

    module shell() {
        difference() {
            body(row);

            depression_scale_xy = pad_side * sqrt(2) / 2;

            translate([0, pad_offsets[row], pad_heights[row] + pad_depression / 2])
            rotate([pad_angles[row], 0, 0])
            scale([depression_scale_xy, depression_scale_xy, pad_depression])
            sphere(1, $fn = 48);

            antishell();
        }
    }

    shell();

    intersection() {
        stem(row);
        antishell();
    }

    intersection() {
        supports(row);
        antishell();
    }

    if (dot) {
        translate([0, pad_offsets[row], pad_heights[row] - pad_depression / 2])
        rotate([pad_angles[row], 0, 0])
        sphere(1/2, $fn = 24);
    }
}


module assembly() {
    if (row == 0) {
        for (r = [0 : 4])
        translate([0, - r * (base_side + base_gap), 0])
        render()
        keycap(r);
    } else {
        render()
        keycap(row-1);
    }
}


if (inspect) {
    projection(cut = true)
    rotate([0, 90, 0])
    assembly();
} else {
    assembly();
}
