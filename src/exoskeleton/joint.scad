include <shared/parameters.scad>

$fn = 36;


module joint_axis_slice() {
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

module joint_axis() {
    rotate_extrude()
        joint_axis_slice();
}

module joint_extender() {
    difference() {
        translate([bone_offset / 2, 0, - NOZZLE / 2])
            cube([bone_offset, joint_d, joint_h / 2 - NOZZLE], center = true);

        cylinder(joint_h, r = joint_d / 4, center = true);
    }
}

module joint_elevator() {
    translate([0, 0, - joint_h / 4])
    intersection() {
        rotate([0, 0, -45])
            cube([joint_d, joint_d, joint_h / 2]);

        translate([0, - joint_d / 2, 0])
            cube([joint_d / 2 + E, joint_d, joint_h / 2]);
    }

    translate([joint_d / 2, - joint_d / 2, - joint_h / 4])
        cube([bone_box_r * sqrt(2) + E, joint_d, joint_h / 2]);
}

module joint_strap_attachment() {
    joiner_l = strap_width;
    joiner_w = joint_d / 4;
    joiner_h = joint_h / 2;

    translate([strap_end_offset / 2, 0, 0]) {
        translate([(joiner_l + strap_end_offset) / 2, (joint_d - joiner_w) / 2, 0])
            cube([joiner_l, joiner_w, joiner_h], center = true);

        translate([(joiner_l + strap_end_offset) / 2, - (joint_d - joiner_w) / 2, 0])
            cube([joiner_l, joiner_w, joiner_h], center = true);

        translate([E, 0, 0])
            cube([strap_end_offset, joint_d, joiner_h], center = true);

        translate([joiner_l + strap_end_offset - E, 0, 0])
            cube([strap_end_offset, joint_d, joiner_h], center = true);
    }

    rotate([90, 0, 0])
    linear_extrude(height = joint_d, center = true)
        polygon([
            [strap_end_offset, joint_h * 0.25],
            [-E, joint_h * 0.25],
            [-E, joint_h * 0.75 - NOZZLE],
            [strap_end_offset / 2, joint_h * 0.75 - NOZZLE],
        ]);
}

module joint_top() {
    translate([0, 0, joint_h / 4])
        joint_extender();

    translate([joint_d * sqrt(2) / 2, 0, - joint_h / 4 + E])
        joint_elevator();

    translate([
        bone_offset - E,
        0,
        - joint_h / 4,
    ])
        joint_strap_attachment();
}

module joint_bottom() {
    translate([0, 0, - joint_h / 4])
        joint_extender();

    translate([joint_d * sqrt(2) / 2, 0, + joint_h / 4 - LAYER * 2 - E])
        joint_elevator();

    translate([
        bone_offset - E,
        0,
        - joint_h / 4,
    ])
        joint_strap_attachment();
}

module joint() {
    joint_axis();

    joint_top();

    rotate([0, 0, 180])
        joint_bottom();
}
