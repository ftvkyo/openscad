use <../../lib/parts.scad>

/* ========== *
 * Parameters *
 * ========== */


// What to display and export
RENDER = "all"; // ["all", "bearing-outer", "bearing-inner-top", "bearing-inner-bottom", "bearing-cage", "handle"]

// Whether to show the model or its cuts
CUT = false;

// Resolution
$fn = 24; // [12, 24, 36, 48, 60]
// Rotational resolution
fn_rotate_extrude = 36; // [36, 72, 180]

/* [Hidden] */

// Faces on debug balls
fn_debug = 12;

// Floating point error correction
E = 0.01;

// Infinity
INF = 10 ^ 3;


/* ======= *
 * Modules *
 * ======= */


module _render(r) {
    if (RENDER == "all" || RENDER == r)
        children();
}


module handle(
    handle_d,
    handle_h
) {
    indent_top_scale = 1/12;
    indent_side_scale = 1/6;

    bump_count = 12;
    bump_size = handle_d / 12;
    bump_diameter = handle_d * 7/12; // Distribution

    module profile() {
        r = 2;

        intersection() {
            offset(r)
            offset(-r)
            difference() {
                wf = 6;
                hf = 12;

                translate([0, handle_h / 2])
                    square([handle_d, handle_h], center = true);

                translate([handle_d / 2, 0])
                scale([handle_d * indent_side_scale, handle_h / 2])
                translate([0, 1])
                    circle(1);

                translate([0, handle_h])
                scale([handle_d / 2, handle_h * indent_top_scale])
                    circle(1);
            }

            translate([handle_d / 4, handle_h / 2])
                square([handle_d / 2, handle_h], center = true);
        }
    }

    rotate_extrude($fn = fn_rotate_extrude)
        profile();

    bump_shift = handle_h * indent_top_scale * sin(acos(bump_diameter / handle_d));
    // Discovered by Rubber Duck Miwon:
    bump_tilt = acos(indent_top_scale * bump_diameter / handle_d) + 90;

    translate([
        0,
        0,
        handle_h - bump_shift
    ])
    for(a = [360 / bump_count : 360 / bump_count : 360]) {
        rotate([0, 0, a])
        translate([bump_diameter / 2, 0, 0])
        rotate([0, bump_tilt, 0])
        scale([1, 1, 1/2])
            sphere(bump_size / 2);
    }
}


module screw(
    screw_l,
    screw_d,
    cap_l,
    cap_d
) {
    translate([0, 0, cap_l + E])
    rotate([180, 0, 0]) {
        cylinder(cap_l + screw_l, r = screw_d / 2);
        cylinder(cap_l, r = cap_d / 2);
    }
}


module screw_M2x6(hole = false) {
    screw(
        screw_l = hole ? 6 : 5.5,
        screw_d = hole ? 2 : 1.75,
        cap_l = hole ? INF : 1.75,
        cap_d = hole ? 4 : 3.5
    );
}


module heat_insert(
    insert_l,
    insert_d,
    screw_l,
    screw_d,
) {
    translate([0, 0, E])
    rotate([180, 0, 0]) {
        cylinder(insert_l, r = insert_d / 2);
        if (is_num(screw_d)) {
            cylinder(is_num(screw_l) ? screw_l : INF, r = screw_d / 2);
        }
    }
}


module heat_insert_M2(hole = false) {
    heat_insert(
        insert_l = 3,
        insert_d = hole ? 3.2 : 3.5,
        screw_l = undef,
        screw_d = hole ? 2 : undef
    );
}


module magnet(
    magnet_d,
    magnet_h
) {
    cylinder(magnet_h, r = magnet_d / 2);
}


/* ======== *
 * Assembly *
 * ======== */


module assembly() {
    bearing(
        shell_height = 20,
        shell_outer_diameter = 30,
        shell_inner_diameter = 15,
        shell_inner_joiner_count = 3,
        shell_inner_joiner_height = 4,
        shell_inner_gap = 0,
        ball_diameter = 3.5,
        ball_count = 12,
        ball_margin = 0.15,
        cage_margin = 0.4
    ) {
        translate([0, 0, - 2]) screw_M2x6(hole = true);
        heat_insert_M2(hole = true);
    }

    _render("handle")
    translate([0, 0, 20])
        handle(
            handle_d = 60,
            handle_h = 30
        );
}

module cuts() {
    intersection() {
        union() {
            translate([25, 0, 0])
            rotate([90, 0, 0])
                assembly();

            translate([-25, 0, 0])
            rotate([90, 360 / 24, 0])
                assembly();
        }

        translate([0, 0, - INF / 2])
            cube(INF, center = true);
    }
}

if (CUT)
    cuts();
else
    assembly();
