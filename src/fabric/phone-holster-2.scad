use <../../lib/util.scad>

height = 13;
wall = 2;
rounding = 3;
strap = 25;

phone = [77.5, 9];


$fn = 48;


module base() {
    linear_extrude(height)
    difference() {
        offset(rounding + wall)
        offset(- rounding - wall)
        square(phone + [wall, wall] * 2, center = true);

        offset(rounding)
        offset(-rounding)
        square(phone, center = true);
    }
}

module bracket_strap() {
    t = wall;
    g = 7;
    a = 15;
    o = 100;

    module profile() {
        difference() {
            offset(rounding + t)
            offset(- rounding - t)
            square([t * 2 + g, strap + rounding * 2 + t * 2], center = true);

            offset(rounding)
            offset(-rounding)
            square([g, strap + rounding * 2], center = true);
        }
    }

    translate([- phone.x / 2 + strap / 2 + rounding, - phone.y / 2 - t / 2, 0])
    rotate([90, 0, 90])
    translate([- o - g / 2 - t / 2, 0, 0])
    rotate_extrude(angle = a, $fn = 360)
    translate([o, 0])
    profile();
}

module bracket_slider() {
    w = 5;
    t = wall;
    g = 3;

    module arc() {
        translate([0, 0, t])
        rotate([90, 0, 0])
        rotate_extrude(angle = 90)
        translate([height - w / 2 - t, 0])
        square([w, t], center = true);

        translate([height - w / 2 - t, - g / 2, t / 2])
        cube([w, t + g, t], center = true);
    }

    module bar() {
        cube([strap, t, w], center = true);

        translate([- strap / 2, - g - t / 2, 0])
        rotate([0, 0, 90])
        rotate_extrude(angle = 90)
        translate([g + t / 2, 0])
        square([t, w], center = true);
    }

    module slider() {
        translate([
            - strap / 2 + phone.x / 2 - height - w / 2 + t / 2,
            phone.y / 2 + wall + t / 2 + g,
            0
        ]) {
            translate([strap / 2, 0, 0])
            arc();

            translate([0, 0, height - w / 2])
            bar();
        }
    }

    slider();

    mirror([0, 1, 0])
    slider();
}

module assembly() {
    base();
    bracket_strap();
    bracket_slider();
}

assembly();
