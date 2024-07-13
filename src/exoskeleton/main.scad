include <bone.scad>
include <joint.scad>


module assembly() {
    joint();

    translate([bone_offset, bone_d * 0.75, joint_h + bone_raise])
        bone_capped();

    translate([bone_offset, - bone_d * 0.75, joint_h + bone_raise])
        bone_capped();

    rotate([0, 0, 180])
    translate([bone_offset, bone_d * 0.75, joint_h + bone_raise])
        bone_capped();

    rotate([0, 0, 180])
    translate([bone_offset, - bone_d * 0.75, joint_h + bone_raise])
        bone_capped();
}

module print_joint() {
    rotate([-90, 0, 0])
        joint();
}

module print_bone_cap() {
    intersection() {
        rotate([90, 0, 0])
            bone_cap();

        translate([0, 0, bone_d / 2])
        cube([bone_d, bone_d * 4, bone_d], center = true);
    }
}


assembly();
// print_bone_cap();
