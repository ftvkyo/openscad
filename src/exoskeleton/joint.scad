include <shared/parameters.scad>

$fn = 36;


module joint_primary_slice() {
    cap_h = joint_h * 0.3;
    cap_r = joint_d * 0.4;

    difference() {
        union() {
            // General slice
            polygon([
                [0, - joint_h / 2],
                [0, joint_h / 2],
                [joint_d / 2, joint_h / 2],
                [joint_d / 2, - joint_h / 2],
            ]);

            // Joint cap
            translate([0, joint_h / 2])
                scale([cap_r, cap_h])
                circle(1);
        }

        // Cut between the joint parts
        polygon([
            [joint_d / 4 - NOZZLE, - LAYER],
            [joint_d / 4 - NOZZLE, joint_h / 2 + E],
            [joint_d / 2 + E, joint_h / 2 + E],
            [joint_d / 2 + E, joint_h / 2 - LAYER * 2],
            [joint_d / 4, joint_h / 2 - LAYER * 2],
            [joint_d / 4, + LAYER],
            [joint_d / 2 + E, + LAYER],
            [joint_d / 2 + E, - LAYER],
        ]);

        // Remove excess of the joint cap
        polygon([
            [0, 0],
            [- joint_d / 2 - E, 0],
            [- joint_d / 2 - E, joint_h / 2 + cap_h + E],
            [0, joint_h / 2 + cap_h + E],
        ]);
    }
}

module joint_primary() {
    rotate_extrude()
        joint_primary_slice();
}

module joint_secondary_slice() {
    // The joint is positioned horizontally,
    // so it's diameter is the height of the primary joint
    d = joint_h;
    h = joint_d;

    difference() {
        // General slice
        polygon([
            [0, - h / 2],
            [0, h / 2],
            [d / 2, h / 2],
            [d / 2, - h / 2],
        ]);

        // Cut between the joint parts
        polygon([
            [d / 4 - NOZZLE, h / 4],
            [d / 2 + E, h / 4],
            [d / 2 + E, h / 4 - NOZZLE],
            [d / 4, h / 4 - NOZZLE],
            [d / 4, - h / 4 + NOZZLE],
            [d / 2 + E, - h / 4 + NOZZLE],
            [d / 2 + E, - h / 4],
            [d / 4 - NOZZLE, - h / 4],
        ]);
    }
}

module joint_secondary() {
    rotate([90, 0, 0])
        rotate_extrude()
        joint_secondary_slice();
}

module joint_interconnect() {
    length = (joint_d + joint_h) / 2 + NOZZLE;
    width = joint_d / 2 - NOZZLE * 2;
    height = joint_h / 2 - LAYER * 2;

    difference() {
        translate([0, 0, height / 2])
            cube([length, width, height], center = true);

        translate([length / 2, 0, - LAYER])
            rotate([90, 0, 0])
            cylinder(width + E * 2, r = joint_h / 4 + NOZZLE, center = true);

        translate([- length / 2, 0, height / 2])
            cylinder(height + E * 2, r = joint_d / 4 + NOZZLE, center = true);
    }
}

module joint_strap_attachment() {
    joiner_l = strap_width + NOZZLE + joint_h / 2;
    joiner_w = joint_d / 4;
    joiner_h = joint_h / 2 - LAYER;

    translate([
        - (bone_box_l + joiner_l) / 2 + E,
        (joint_d - joiner_w) / 2,
        - joiner_h - LAYER * 1.5
    ])
        cube([joiner_l, joiner_w, joiner_h], center = true);

    translate([
        - (bone_box_l + joiner_l) / 2 + E,
        - (joint_d - joiner_w) / 2,
        - joiner_h - LAYER * 1.5
    ])
        cube([joiner_l, joiner_w, joiner_h], center = true);
}

module joint_bone_box() {
    difference() {
        cube([bone_box_l, bone_box_w, bone_box_h], center = true);

        translate([0, 0, bone_box_bottom / 2])
            cube([bone_box_l - bone_box_wall * 2, bone_box_w - bone_box_wall * 2, bone_box_h - bone_box_bottom + E], center = true);

        translate([(bone_box_l - bone_box_wall) / 2, (bone_cap_d + NOZZLE) / 2, 0])
            rotate([0, 90, 0])
            cylinder(bone_box_wall + E, r = bone_d / 2, center = true);

        translate([(bone_box_l - bone_box_wall) / 2, - (bone_cap_d + NOZZLE) / 2, 0])
            rotate([0, 90, 0])
            cylinder(bone_box_wall + E, r = bone_d / 2, center = true);
    }
}

module joint() {
    joint_primary();

    translate([(joint_d + joint_h) / 2 + NOZZLE, 0, 0])
        joint_secondary();

    translate([(joint_d + joint_h + NOZZLE) / 4, 0, 0])
        joint_interconnect();

    // Attachment to the primary joint
    translate([
        - (joint_d + bone_box_l) / 2 - strap_width,
        0,
        bone_box_h / 2 - joint_h / 2,
    ])
        rotate([0, 0, 180])
        joint_bone_box();

    translate([
        - (joint_d + bone_box_l) / 2 - strap_width,
        0,
        joint_h / 4,
    ])
        rotate([0, 0, 180])
        joint_strap_attachment();

    translate([- joint_d / 4, 0, - joint_h / 4 - LAYER / 2])
        cube([joint_d / 2, joint_d, joint_h / 2 - LAYER], center = true);

    // Attachment to the secondary joint
    translate([
        joint_d / 2 + joint_h + bone_box_l / 2 + NOZZLE * 2 + strap_width,
        0,
        bone_box_h / 2 - joint_h / 2,
    ])
        joint_bone_box();

    translate([
        joint_d / 2 + joint_h + bone_box_l / 2 + NOZZLE * 2 + strap_width,
        0,
        joint_h / 4,
    ])
        joint_strap_attachment();
}
