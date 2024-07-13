include <shared/parameters.scad>

module bone() {
    color("#80808080")
    difference() {
        cylinder(bone_l, r = bone_d / 2, center = true);

        cylinder(bone_l + E, r = bone_inner_d / 2, center = true);
    }
}


module bone_cap() {
    sphere(bone_d / 2);

    translate([0, 0, - bone_d])
        cylinder(NOZZLE * 4, r = bone_d / 2);

    difference() {
        translate([0, 0, - bone_d])
            cylinder(bone_d * 1.75, r = bone_inner_d / 2, center = true);

        translate([0, 0, - bone_d * 1.5])
        rotate([90, 0, 0])
            cylinder(bone_d, r = screw_d / 2, center = true);
    }
}


module bone_capped() {
    rotate([0, -90, 0])
    translate([0, 0, - bone_l / 2 - bone_d]) {
        %bone();

        translate([0, 0, bone_l / 2 + bone_d])
            bone_cap();

        rotate([180, 0, 0])
        translate([0, 0, bone_l / 2 + bone_d])
            bone_cap();
    }
}
