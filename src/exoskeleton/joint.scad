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
            [joint_d / 4 - NOZZLE, - NOZZLE],
            [joint_d / 4 - NOZZLE, joint_h / 2 + E],
            [joint_d / 2 + E, joint_h / 2 + E],
            [joint_d / 2 + E, joint_h / 2 - NOZZLE],
            [joint_d / 4, joint_h / 2 - NOZZLE],
            [joint_d / 4, 0],
            [joint_d / 2 + E, 0],
            [joint_d / 2 + E, - NOZZLE],
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

module joint_extender() {
    difference() {
        translate([joint_d / 2, 0, - NOZZLE / 2])
            cube([joint_d, joint_d, joint_h / 2 - NOZZLE], center = true);

        cylinder(joint_h, r = joint_d / 4, center = true);
    }
}

module joint_elevator() {
    translate([0, 0, - joint_h / 4])
    intersection() {
        rotate([0, 0, -45])
            cube([joint_d, joint_d, joint_h / 2]);

        translate([0, - joint_d / 2, 0])
            cube([joint_d / sqrt(2), joint_d, joint_h / 2]);
    }
}

module joint_strap_attachment() {
    joiner_l = strap_width;
    joiner_w = joint_d / 4;
    joiner_h = joint_h / 2;

    translate([strap_offset / 2, 0, 0]) {
        translate([(joiner_l + strap_offset) / 2, (joint_d - joiner_w) / 2, 0])
            cube([joiner_l, joiner_w, joiner_h], center = true);

        translate([(joiner_l + strap_offset) / 2, - (joint_d - joiner_w) / 2, 0])
            cube([joiner_l, joiner_w, joiner_h], center = true);

        translate([E, 0, 0])
            cube([strap_offset, joint_d, joiner_h], center = true);

        translate([joiner_l + strap_offset / 2 + joiner_h / 2 - E, 0, 0])
            cube([joiner_h, joint_d, joiner_h], center = true);
    }
}

module joint_bone_box() {
    difference() {
        cube([bone_box_l, bone_box_w, bone_box_h], center = true);

        translate([0, 0, bone_box_bottom / 2])
            cube([bone_box_l - bone_box_wall * 2, bone_box_w - bone_box_wall * 2, bone_box_h - bone_box_bottom + E], center = true);

        // Hole for bone
        translate([(bone_box_l - bone_box_wall) / 2, (bone_cap_d + NOZZLE) / 2, bone_box_bottom / 2])
            rotate([0, 90, 0])
            cylinder(bone_box_wall + E, r = bone_d / 2 + NOZZLE / 2, center = true);

        // Hole for bone
        translate([(bone_box_l - bone_box_wall) / 2, - (bone_cap_d + NOZZLE) / 2, bone_box_bottom / 2])
            rotate([0, 90, 0])
            cylinder(bone_box_wall + E, r = bone_d / 2 + NOZZLE / 2, center = true);

        // Make sure the bone cap fits
        translate([0, - (bone_cap_d + NOZZLE) / 2, bone_box_bottom / 2])
            rotate([0, 90, 0])
            cylinder(bone_cap_h, r = bone_cap_d / 2, center = true);

        // Make sure the bone cap fits
        translate([0, (bone_cap_d + NOZZLE) / 2, bone_box_bottom / 2])
            rotate([0, 90, 0])
            cylinder(bone_cap_h, r = bone_cap_d / 2, center = true);
    }
}

module joint() {
    joint_primary();

    translate([0, 0, joint_h / 4])
        joint_extender();

    translate([joint_d * sqrt(2) / 2, 0, - joint_h / 4 + E])
        joint_elevator();

    translate([
        joint_d + bone_box_l / 2 - E,
        0,
        bone_box_h / 2 - E,
    ])
        joint_bone_box();

    translate([
        joint_d * sqrt(2) - E,
        0,
        - joint_h / 4,
    ])
        joint_strap_attachment();

    rotate([0, 0, 180]) {
        translate([0, 0, - joint_h / 4])
            joint_extender();

        translate([
            joint_d + bone_box_l / 2 - E,
            0,
            bone_box_h / 2 - E,
        ])
            joint_bone_box();

        translate([
            joint_d - E,
            0,
            - joint_h / 4,
        ])
            #joint_strap_attachment();
    }
}
