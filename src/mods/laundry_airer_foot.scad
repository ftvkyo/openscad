frame_r = 8;

frame_ext_bend_r = 62.7;
frame_int_bend_r = 45;

frame_gap_x = 14;
frame_gap_z = 7;

foot_clip_thickness = 2;
foot_clip_length = 30;
foot_clip_offset = 10;

foot_thickness = 4;
foot_length = 20;


/* ===== *
 * Frame *
 * ===== */

module frame_ext() {
    for (a = [0, 90])
    rotate([0, a, 0])
    translate([0, 0, frame_ext_bend_r])
    cylinder(h = 100, r = frame_r);

    translate([frame_ext_bend_r, 0, frame_ext_bend_r])
    rotate([90, 180, 0])
    rotate_extrude(angle = 90)
    translate([frame_ext_bend_r, 0])
    circle(frame_r);
}

module frame_int() {
    translate([
        frame_r * 2 + frame_gap_x,
        0,
        frame_r * 2 + frame_gap_z,
    ]) {
        for (a = [0, 90])
        rotate([0, a, 0])
        translate([0, 0, frame_int_bend_r])
        cylinder(h = 100, r = frame_r);

        translate([frame_int_bend_r, 0, frame_int_bend_r])
        rotate([90, 180, 0])
        rotate_extrude(angle = 90)
        translate([frame_int_bend_r, 0])
        circle(frame_r);
    }
}

module frame() {
    frame_ext();
    frame_int();
}


/* ==== *
 * Foot *
 * ==== */

module foot_clip_profile() {
    offset(+ foot_clip_thickness / 2)
    offset(- foot_clip_thickness / 2)
    difference() {
        r_hex = (frame_r + foot_clip_thickness) * 2 / sqrt(3);
        circle(r_hex, $fn = 6);

        circle(frame_r);

        translate([0, frame_r])
        square([frame_r * 5/4, frame_r * 2], center = true);
    }
}

module foot_clip() {
    linear_extrude(foot_clip_length)
    foot_clip_profile();
}

module foot_connector_profile() {
    polygon([
        [- foot_clip_length / 2, foot_clip_thickness],
        [0, foot_thickness],
        [foot_clip_length / 2, foot_clip_thickness],
        [foot_clip_length / 2, 0],
        [- foot_clip_length / 2, 0],
    ]);
}

module foot_end() {
    rotate([-90, 0, 0])
    rotate_extrude(angle = 180) {
        polygon([
            [0, foot_thickness],
            [foot_clip_length / 2, foot_clip_thickness],
            [foot_clip_length / 2, 0],
            [0, 0],
        ]);
    }
}

module foot_connector_ext() {
    $fn = 72;

    translate([0, - frame_r - foot_clip_thickness, 0])
    rotate([-90, -90, 0])
    rotate_extrude(angle = 90)
    translate([frame_ext_bend_r + foot_clip_offset + foot_clip_length / 2, 0])
    foot_connector_profile();
}

module foot_ext() {
    translate([
        0,
        0,
        frame_ext_bend_r + foot_clip_offset,
    ])
    foot_clip();

    translate([
        frame_ext_bend_r + foot_clip_offset,
        0,
        0,
    ])
    rotate([0, 90, 0])
    foot_clip();

    foot_connector_ext();

    translate([
        frame_ext_bend_r + foot_clip_offset + foot_clip_length / 2,
        - frame_r - foot_clip_thickness,
        0,
    ])
    foot_end();
}

module foot_connector_int() {
    $fn = 72;

    translate([0, - frame_r - foot_clip_thickness, 0])
    rotate([-90, -90, 0])
    rotate_extrude(angle = 90)
    translate([frame_int_bend_r + foot_clip_offset + foot_clip_length / 2, 0])
    foot_connector_profile();
}

module foot_int() {
    translate([
        frame_r * 2 + frame_gap_x,
        0,
        frame_r * 2 + frame_gap_z + frame_int_bend_r + foot_clip_offset,
    ])
    mirror([0, 1, 0])
    foot_clip();

    translate([
        frame_r * 2 + frame_gap_x + frame_int_bend_r + foot_clip_offset,
        0,
        frame_r * 2 + frame_gap_z,
    ])
    mirror([0, 1, 0])
    rotate([0, 90, 0])
    foot_clip();

    translate([
        frame_r * 2 + frame_gap_x,
        0,
        frame_r * 2 + frame_gap_z,
    ])
    mirror([0, 1, 0])
    foot_connector_int();

    translate([
        frame_r * 2 + frame_gap_x + frame_int_bend_r + foot_clip_offset + foot_clip_length / 2,
        frame_r + foot_clip_thickness,
        frame_r * 2 + frame_gap_z,
    ])
    mirror([0, 1, 0])
    mirror([0, 0, 1])
    linear_extrude(frame_r * 2 + frame_gap_z)
    foot_connector_profile();

    translate([
        frame_r * 2 + frame_gap_x + frame_int_bend_r + foot_clip_offset + foot_clip_length / 2,
        frame_r + foot_clip_thickness,
        0,
    ])
    mirror([0, 1, 0])
    foot_end();
}


/* ====== *
 * Render *
 * ====== */

%frame();

difference() {
    foot_ext();
    frame_ext();
}

!difference() {
    foot_int();
    frame_int();
}
