r = 27.5;
t = 5;
hole = 1;

module ear_profile() {
    intersection() {
        circle(t / 2);
        square([t * 2, t * 4/5], center = true);
    }
}

module corner() {
    rotate_extrude()
    intersection() {
        ear_profile();

        translate([t, 0])
        square([t * 2, t], center = true);
    }
}

module half() {
    translate([- r, 0, 0])
    rotate_extrude(angle = 60)
    translate([r * 2, 0])
    ear_profile();
}

module ear() {
    half();

    mirror([1, 0, 0])
    half();

    translate([0, r * sqrt(3), 0])
    corner();
}

module attachment() {
    module profile() {
        translate([r, 0])
        ear_profile();

        translate([-r, 0])
        ear_profile();

        difference() {
            square([r * 2, t * 4/5], center = true);

            circle(hole);

            for (x = [t : t : r - t]) {
                translate([x, 0])
                circle(hole);

                translate([-x, 0])
                circle(hole);
            }
        }
    }

    rotate([90, 0, 0])
    linear_extrude(1, center = true)
    profile();
}

// corner();

// half();

// mirror([1, 0, 0])
// half();

$fn = 120;

ear();
attachment();
