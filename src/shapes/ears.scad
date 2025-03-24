r = 20;
t = 5;

module profile() {
    intersection() {
        circle(t / 2);
        square([t * 2, t * 4/5], center = true);
    }
}

module corner() {
    rotate_extrude()
    intersection() {
        profile();

        translate([t, 0])
        square([t * 2, t], center = true);
    }
}

module half() {
    translate([- r, 0, 0])
    rotate_extrude(angle = 60)
    translate([r * 2, 0])
    profile();
}

module ear() {
    half();

    mirror([1, 0, 0])
    half();

    translate([0, r * sqrt(3), 0])
    corner();
}

// corner();

// half();

// mirror([1, 0, 0])
// half();

ear();
