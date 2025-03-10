h = 4;
l = 42;


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

module bars(s) {
    module bar() {
        translate([l / 2, 0, 0])
        rotate([90, 0, 0])
        linear_extrude(l + s, center = true)
        section(s);
    }

    translate([0, -2.5, - h * 2])
    intersection() {
        for(a = [0, 90, 180, 270])
        rotate([0, 0, a])
        bar();

        linear_extrude(h, center = true)
        offset(s * 2, $fn = 36)
        offset(-s * 2)
        square(l + s * 2, center = true);
    }
}

module pins(s) {
    module pin() {
        translate([l / 2, l / 2, 0])
        cylinder(h * 3/2 + 1, r = s / 2, $fn = 24);
    }

    translate([0, -2, - h * 2])
    for(a = [0, 90, 180, 270])
    rotate([0, 0, a])
    pin();
}

module assembly(what = 0) {
    s = 3;

    if (what == 0) {
        heart(19.75, s);
        bars(s);
        pins(s);
    } else if (what == 1) {
        rotate([0, 180, 0])
        difference() {
            heart(19.75, s);
            pins(s + 0.25);
        }
    } else if (what == 2) {
        bars(s);
        pins(s);
    }
}

assembly(0);
