use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>

include <../../lib/points_shapes.scad>


/* [Key] */

// 1 = top, 6 = bottom
key_row = 1; // [1 : 6]

// Width of the key in units
// key_units = 1.0; // [1.0 : 0.25 : 10.0]

// Add a tactile bump
key_bump = false;


/* [Debug] */

display_all = false;

display_hull_only = false;

display_section = false;


module __hidden__() {}


/* ================= *
 * Static parameters *
 * ================= */

pad_side = 13.0;
pad_squariness = 0.5;
pad_dimple_depth = 0.75;

base_side = 18.0;
base_squariness = 0.99;

shell_thickness = 1.0;

stem_radius = 2.5;
stem_height = 4.5;
stem_offset = 1.0;

stem_hole_depth = 3.5;
stem_hole_width1 = 1.4;
stem_hole_width2 = 4.1;

stem_support_width = 1.0;

key_gap = 0.8;


/* ================== *
 * Dynamic parameters *
 * ================== */

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
    -0.5,
    -1.0,
];


fn_pad = function(t)
    let (p = f_squircle(pad_squariness)(t))
    [p.x, p.y, 0];

fn_base = function(t)
    let (p = f_squircle(base_squariness)(t))
    [p.x, p.y, 0];


slices_counts = [
    24,
    72,
    1,
    12,
];

eases = [
    function(t) t,
    function(t) 1 - ease_in_pow(4)(1 - t),
    function(t) t,
    function(t) t,
];

eases_scl = [
    function(t) ease_in_out_asine(t),
    function(t) ease_in_asine(t),
    function(t) t,
    function(t) t,
];

eases_rot = [
    function(t) t,
    function(t) t,
    function(t) t,
    function(t) t,
];

eases_pos = [
    function(t) t,
    function(t) t,
    function(t) t,
    function(t) t,
];


$fn = $preview ? 48 : 192;


/* ======= *
 * Modules *
 * ======= */


module body(row) {
    slices_info = [
        make_slice_info(
            fn_pad,
            scl = 1,
            rot = [0, pad_angles[row], 0],
            pos = [pad_offsets[row], 0, pad_heights[row] - pad_dimple_depth / 2]
        ),
        make_slice_info(
            fn_pad,
            scl = pad_side / 2,
            rot = [0, pad_angles[row], 0],
            pos = [pad_offsets[row], 0, pad_heights[row] + pad_dimple_depth / 2]
        ),
        make_slice_info(
            fn_base,
            scl = base_side / 2
        ),
    ];

    pts_extrude_slice_info_sequence(
        slices_info,
        slices_counts = [
            slices_counts[0],
            slices_counts[1],
        ],
        eases = [
            eases[0],
            eases[1],
        ],
        eases_scl = [
            eases_scl[0],
            eases_scl[1],
        ],
        eases_rot = [
            eases_rot[0],
            eases_rot[1],
        ],
        eases_pos = [
            eases_pos[0],
            eases_pos[1],
        ]
    );
}


module shell(row) {
    slices_info = [
        make_slice_info(
            fn_pad,
            scl = 1,
            rot = [0, pad_angles[row], 0],
            pos = [pad_offsets[row], 0, pad_heights[row] - pad_dimple_depth / 2]
        ),
        make_slice_info(
            fn_pad,
            scl = pad_side / 2,
            rot = [0, pad_angles[row], 0],
            pos = [pad_offsets[row], 0, pad_heights[row] + pad_dimple_depth / 2]
        ),
        make_slice_info(
            fn_base,
            scl = base_side / 2
        ),
        make_slice_info(
            fn_base,
            scl = base_side / 2 - shell_thickness
        ),
        make_slice_info(
            fn_pad,
            scl = pad_side / 2 - shell_thickness,
            rot = [0, pad_angles[row], 0],
            pos = [pad_offsets[row], 0, pad_heights[row] - pad_dimple_depth / 2 - shell_thickness]
        ),
    ];

    pts_extrude_slice_info_sequence(
        slices_info,
        slices_counts = slices_counts,
        eases = eases,
        eases_scl = eases_scl,
        eases_rot = eases_rot,
        eases_pos = eases_pos
    );
}


module stem(row, hollow = true) {
    translate([0, 0, stem_offset])
    difference() {
        cylinder(h = pad_heights[row] - stem_offset, r = stem_radius, $fn = 24);

        if (hollow)
        translate([0, 0, stem_hole_depth / 2 - 0.01]) {
            cube([stem_hole_width1, stem_hole_width2, stem_hole_depth], center = true);
            cube([stem_hole_width2, stem_hole_width1, stem_hole_depth], center = true);
        }
    }
}


module stem_supports(row) {
    support_height = pad_heights[row] - stem_offset - stem_height;

    difference() {
        translate([0, 0, stem_offset + stem_height + support_height / 2]) {
            cube([stem_support_width, base_side, support_height], center = true);
            cube([base_side, stem_support_width, support_height], center = true);
        }

        stem(row, hollow = false);
    }
}


module row_marker(row) {
    spread = base_side - shell_thickness * 6;
    spread_gap = spread / 5;

    corner = [
        - base_side / 2 + shell_thickness,
        - spread / 2,
    ];

    for (i = [0 : row])
    translate([corner.x, corner.y + spread_gap * i, 0])
    cylinder(h = pad_heights[row], r = 3/4, $fn = 12);
}


module keycap(row, dot = false) {
    if (display_hull_only) {
        body(row);
    } else {
        shell(row);

        intersection() {
            stem(row);
            body(row);
        }

        intersection() {
            stem_supports(row);
            body(row);
        }

        intersection() {
            row_marker(row);
            body(row);
        }
    }

    if (dot) {
        translate([pad_offsets[row], 0, pad_heights[row] - pad_dimple_depth / 2])
        rotate([0, pad_angles[row], 0])
        scale([3/2, 3/2, 2/3])
        sphere(1/2, $fn = 24);
    }
}


module assembly() {
    if (display_all) {
        for (row = [0 : 5])
        translate([row * (base_side + key_gap), 0, 0])
        keycap(row, dot = key_bump);
    } else {
        keycap(key_row - 1, dot = key_bump);
    }
}


if (display_section) {
    projection(cut = true)
    rotate([-90, 0, 0])
    assembly();
} else {
    assembly();
}
