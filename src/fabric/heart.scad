h = 4;


module section(s) {
    intersection() {
        circle(s, $fn = 36);
        square([s * 2, h], center = true);
    }
}

module heart_half(r, s) {
    // r = 17.5;
    a = 160;

    module top() {
        translate([r * cos(180 - a), 0, 0])
        rotate([0, 0, -45])
        rotate_extrude(angle = a + 45, $fn = 72)
        translate([r, 0])
        section(s);
    }

    module bottom() {
        l = r * (1 + cos(180 - a) / sin(45));
        o = r * (sqrt(2) + cos(180 - a));

        translate([0, -o, 0])
        rotate([-90, 0, -45])
        linear_extrude(l)
        section(s);
    }

    intersection() {
        translate([s * cos(a), 0, 0])
        union() {
            top();
            bottom();
        }

        translate([r * 3/2, 0, 0])
        cube([r * 3, r * 6, r * 3], center = true);
    }
}

module heart(r, s) {
    heart_half(r, s);

    mirror([1, 0, 0])
    heart_half(r, s);
}

heart(20, 3);
