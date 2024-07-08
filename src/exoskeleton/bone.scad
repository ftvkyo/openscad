include <shared/parameters.scad>

module bone() {
    color("grey")
    difference() {
        cylinder(bone_l, r = bone_d / 2, center = true);

        cylinder(bone_l + E, r = bone_inner_d / 2, center = true);
    }
}
