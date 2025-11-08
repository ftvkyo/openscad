use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


/* [General] */

key = "all"; // [all, row1, row2, row3, row4, row4dot, row5, row6]

inspect = false;


/* [Defaults] */

pad_inner_squariness = 0.5; // [0.01 : 0.01 : 0.99]

pad_squariness = 0.9; // [0.01 : 0.01 : 0.99]
pad_dimple = 1.0; // [0.25 : 0.25 : 2.0]

pad_edge_dz = 0.5; // [0.0 : 0.25 : 1.0]

base_squariness = 0.99; // [0.01 : 0.01 : 0.99]


module __hidden__() {}


// Static parameters

pad_side = 13.0;

base_side = 18.0;

shell_thickness = 1.0;

stem_radius = 2.5;
stem_height = 4.5;
stem_offset = 1.0;

stem_hole_depth = 3.5;
stem_hole_width1 = 1.4;
stem_hole_width2 = 4.1;

support_width = 1.0;

keycap_gap = 0.8;


// Calculated parameters

pad_heights = [
    12.5,
    9.5,
    7.5,
    7.5,
    8.5,
    8.5,
];

pad_angles = [
    10.0,
    7.5,
    3.0,
    -3.0,
    -7.5,
    -7.5,
];

pad_offsets = [
    -1.0,
    -1.0,
    -0.5,
    0.0,
    0.5,
    1.0,
];


$fn = $preview ? 48 : 192;


f_pad_inner = function(t)
    let (p = f_squircle(pad_inner_squariness)(t))
    [p.x, p.y, 0];

f_pad = function(t)
    let (p = f_squircle(pad_squariness)(t))
    let (t = t + 1/8)
    let (t = t * 4 - floor(t * 4))
    let (t = abs(t - 1/2) * 2)
    let (dz = ease_in_out_quadratic(t) * pad_edge_dz)
    [p.x, p.y, dz];

f_base = function(t)
    let (p = f_squircle(base_squariness)(t))
    [p.x, p.y, 0];


module pts_slice(
    shape_a,
    shape_b,
    shape_c,
    shape_ease_ab,
    shape_ease_bc,
    scale_a,
    scale_b,
    scale_c,
    scale_ease_ab,
    scale_ease_bc,
    height_a,
    height_b,
    height_c,
    angle_a,
    angle_b,
    angle_c,
    offset_a,
    offset_b,
    offset_c
) {
    f_ab = function(t)
        pts_translate3(
            pts_rotate3(
                pts_scale3(
                    pts_f_interp(
                        shape_a,
                        shape_b,
                        shape_ease_ab(t)
                    ),
                    [0, 0, 1] + [1, 1, 0] * lerp(scale_a, scale_b, scale_ease_ab(t))
                ),
                [lerp(angle_a, angle_b, t), 0, 0]
            ),
            [0, lerp(offset_a, offset_b, t), lerp(height_a, height_b, t)]
        );

    f_bc = function(t)
        pts_translate3(
            pts_rotate3(
                pts_scale3(
                    pts_f_interp(
                        shape_b,
                        shape_c,
                        shape_ease_bc(t)
                    ),
                    [0, 0, 1] + [1, 1, 0] * lerp(scale_b, scale_c, scale_ease_bc(t))
                ),
                [lerp(angle_b, angle_c, t), 0, 0]
            ),
            [0, lerp(offset_b, offset_c, t), lerp(height_b, height_c, t)]
        );

    fn_ab = max(24, ceil(abs(height_a - height_b) / 0.2));
    fn_bc = max(24, ceil(abs(height_b - height_c) / 0.2));

    pts_extrude([ for (s = [
        [ for (t = [0 : 1 / fn_ab : 1]) f_ab(t) ],
        [ for (t = [0 : 1 / fn_bc : 1]) f_bc(t) ],
    ]) each s ], loop = false);
}


module body(row) {
    pts_slice(
        shape_a = f_base,
        shape_b = f_pad,
        shape_c = f_pad_inner,
        shape_ease_ab = function(t) ease_in_pow(16)(t),
        shape_ease_bc = function(t) t,
        scale_a = base_side / 2,
        scale_b = pad_side / 2,
        scale_c = 1,
        scale_ease_ab = function(t) ease_out_asine(t),
        scale_ease_bc = function(t) ease_in_out_asine(t),
        height_a = 0,
        height_b = pad_heights[row] + pad_dimple / 2,
        height_c = pad_heights[row] - pad_dimple / 2,
        angle_a = 0,
        angle_b = pad_angles[row],
        angle_c = pad_angles[row],
        offset_a = 0,
        offset_b = pad_offsets[row],
        offset_c = pad_offsets[row]
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


module keycap(row, dot = false) {
    module antishell() {
        antishell_scale_xy = (base_side - shell_thickness * 2) / base_side;
        antishell_scale_z = (pad_heights[row] - shell_thickness * 2) / pad_heights[row];

        scale([antishell_scale_xy, antishell_scale_xy, antishell_scale_z])
        body(row);
    }

    module shell() {
        difference() {
            body(row);
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
        translate([0, pad_offsets[row], pad_heights[row] - pad_dimple / 2])
        rotate([pad_angles[row], 0, 0])
        scale([3/2, 3/2, 2/3])
        sphere(1/2, $fn = 24);
    }
}


module assembly() {
    render()
    if (key == "all") {
        for (r = [0 : 5])
        translate([0, - r * (base_side + keycap_gap), 0])
        keycap(r);
    } else if (key == "row1") {
        keycap(0);
    } else if (key == "row2") {
        keycap(1);
    } else if (key == "row3") {
        keycap(2);
    } else if (key == "row4") {
        keycap(3);
    } else if (key == "row4dot") {
        keycap(3, dot = true);
    } else if (key == "row5") {
        keycap(4);
    } else if (key == "row6") {
        keycap(5);
    }
}


if (inspect) {
    projection(cut = true)
    rotate([0, 90, 0])
    assembly();
} else {
    assembly();
}
