include <bone.scad>
include <joint.scad>


module bone_pair() {
    translate([bone_offset, bone_d * 0.75, joint_h + bone_raise])
        bone_capped();

    translate([bone_offset, - bone_d * 0.75, joint_h + bone_raise])
        bone_capped();
}


module bone_box_attachment(h, r) {
    translate([bone_offset, 0])
        cylinder(h, r = r, center = true);

    translate([bone_offset - bone_box_r, 0])
        cylinder(h, r = r, center = true);
}


module bone_box_attachment_holes() {
    translate([0, 0, - joint_h / 2 + screw_nut_l / 2 - E])
        bone_box_attachment(screw_nut_l, screw_nut_d / 2 + NOZZLE);

    translate([0, 0, - joint_h / 2 + screw_long_l / 2])
        bone_box_attachment(screw_long_l, screw_d / 2 + NOZZLE / 2);

    translate([0, 0, joint_h / 2 + (screw_long_l + bone_box_h) / 2 - E])
        bone_box_attachment(bone_box_h, screw_nut_d / 2 + NOZZLE);
}


module bone_box() {
    difference() {
        union() {
            translate([bone_offset, bone_d * 0.75, joint_h + bone_raise])
                cylinder(bone_box_h, r = bone_box_r, center = true);

            translate([bone_offset, - bone_d * 0.75, joint_h + bone_raise])
                cylinder(bone_box_h, r = bone_box_r, center = true);

            translate([bone_offset - bone_box_r, 0, joint_h + bone_raise])
                cylinder(bone_box_h, r = bone_box_r, center = true);

            translate([bone_offset, 0, joint_h + bone_raise])
                cube([bone_box_r * 2, bone_box_r * 2, bone_box_h], center = true);
        }

        translate([bone_offset + bone_box_r, bone_d * 0.75, joint_h + bone_raise])
            rotate([0, 90, 0])
            cylinder(bone_box_r * 2 + E, r = bone_inner_d / 2 + NOZZLE * 2, center = true);

        translate([bone_offset, bone_d * 0.75, joint_h + bone_raise])
            sphere(bone_d / 2 + NOZZLE);

        translate([bone_offset + bone_box_r, - bone_d * 0.75, joint_h + bone_raise])
            rotate([0, 90, 0])
            cylinder(bone_box_r * 2 + E, r = bone_inner_d / 2 + NOZZLE * 2, center = true);

        translate([bone_offset, - bone_d * 0.75, joint_h + bone_raise])
            sphere(bone_d / 2 + NOZZLE);

        bone_box_attachment_holes();
    }
}


module joint_with_attachment() {
    difference() {
        joint();

        bone_box_attachment_holes();
        rotate([0, 0, 180])
            bone_box_attachment_holes();
    }

}

module assembly() {
    joint_with_attachment();

    bone_pair();
    bone_box();

    rotate([0, 0, 180]) {
        bone_pair();
        bone_box();
    }
}

module print_joint() {
    rotate([-90, 0, 0])
        joint_with_attachment();
}

module print_bone_cap() {
    intersection() {
        rotate([90, 0, 0])
            bone_cap();

        translate([0, 0, bone_d / 2])
        cube([bone_d, bone_d * 5, bone_d], center = true);
    }
}

module print_bone_box() {
    intersection() {
        union() {
            translate([- joint_d * 0.75, 0, - (joint_h + bone_box_h) / 2 + NOZZLE])
                bone_box();

            rotate([0, 180, 0])
            translate([- joint_d * 0.75, 0, - (joint_h + bone_box_h) / 2 + NOZZLE])
                bone_box();
        }

        translate([0, 0, -50])
            cube([100, 100, 100], center = true);
    }
}


assembly();

// print_bone_cap();
// print_joint();
// print_bone_box();
