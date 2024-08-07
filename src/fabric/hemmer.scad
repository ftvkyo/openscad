w = 30; // Width
w_fold = 10; // How much to fold
t = 2; // Thickness of plastic
t_handle = 5; // Thickness of the handle
l = 30; // Length

gap = 2; // Where the fabric goes
round = 0.75;

$fn = 48;


module capsule(x, y, r) {
    r = is_undef(r) ? t * 0.49 : r;

    offset(r)
    offset(- r)
        square([x, y]);
}


module profile() {
    offset(- round)
    offset(round) {
        // Bottom
        capsule(w, t);

        // Left
        capsule(t, t * 3 + gap * 2);

        // Top
        translate([0, t * 2 + gap * 2])
            capsule(t * 2 + w_fold + gap, t);

        // Right
        translate([t + gap + w_fold, t + gap])
            capsule(t, t * 2 + gap);

        // Center
        translate([t + gap, t + gap])
            capsule(t + w_fold, t);
    }
}


module profile_extrusion() {
    rotate([90, 0, 0])
    linear_extrude(l, center = true)
        profile();
}


module handle() {
    linear_extrude(t)
    offset(round)
    offset(- round * 2)
    offset(round)
    translate([t_handle, 0]) {
        translate([- w / 2, 0])
            square([t_handle, l], center = true);

        translate([- w / 4, l / 2 - t_handle / 2])
            square([w / 2, t_handle], center = true);

        translate([- w / 4, - l / 2 + t_handle / 2])
            square([w / 2, t_handle], center = true);
    }
}


module assembly() {
    profile_extrusion();
    handle();
}


assembly();
