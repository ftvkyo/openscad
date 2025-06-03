r = 27.5;
t = 5;
attachment_t = 1;
attachment_hole = 1;

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
    R = (r + t) * 2;
    b = acos((r + t) / 2 / R);
    a = (90 - b) * 2;

    h_base = t * 4/5;
    h_total = h_base * 2.1;

    translate([0, - attachment_t / 2, 0])
    intersection() {
        translate([0, - R * cos(a / 2) * 2, 0])
        rotate([0, 0, - a / 2 + 90])
        rotate_extrude(angle = a)
        translate([R * 2, (h_total - h_base) / 2])
        square([attachment_t, h_total], center = true);

        translate([0, -1, 0])
        rotate([-90, 0, 0])
        linear_extrude(r * 3)
        scale([r + t / 2, t * 1.75])
        circle(1.0);
    }
}

module assembly() {
    union() {
        difference() {
            ear();
            translate([0, -attachment_t, 0])
            attachment();
        }

        difference() {
            attachment();

            rotate([90, 0, 0])
            linear_extrude(r, center = true) {
                $fn = 4;

                circle(attachment_hole);

                for (x = [t : t : r - t]) {
                    translate([x, 0])
                    circle(attachment_hole);

                    translate([-x, 0])
                    circle(attachment_hole);
                }

                for (x = [t / 2 : t : r - t * 2]) {
                    translate([x, t * sin(60)])
                    circle(attachment_hole);

                    translate([-x, t * sin(60)])
                    circle(attachment_hole);
                }
            }
        }
    }
}

$fn = 120;
assembly();
