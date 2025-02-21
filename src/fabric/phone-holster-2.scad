use <../../lib/util.scad>

height = 15;
wall = 1.6;
rounding = 3;
strap = 25;

phone = [77.5, 9];


$fn = 48;


module base() {
    module profile() {
        difference() {
            offset(rounding + wall)
            offset(- rounding - wall)
            square(phone + [wall, wall] * 2, center = true);

            offset(rounding)
            offset(-rounding)
            square(phone, center = true);
        }
    }

    linear_extrude(height)
    half2("x-")
    profile();

    linear_extrude(height / 2)
    half2("x+")
    profile();

    a = 50;
    o = 50;

    intersection() {
        translate([0, 0, height / 2])
        half3("x+")
        rotate([90, 0, 180])
        translate([-o, 0, 0])
        rotate_extrude(angle = a, $fn = 120)
        translate([o, 0])
        profile();

        translate([0, 0, height * 3/4])
        cube([10 ^ 3, phone.y + wall * 2, height / 2], center = true);
    }
}

module button_cutout() {
    r = 1;

    translate([0, 0, height / 2])
    minkowski() {
        cube([phone.x - r * 2 + 1, r, height], center = true);
        sphere(r);
    }
}

module bracket_strap() {
    t = wall;
    g = 7;
    a = 15;
    o = 100;

    module profile() {
        half2("x-")
        difference() {
            offset(rounding + t)
            offset(- rounding - t)
            square([t * 2 + g, strap + rounding * 2 + t * 2], center = true);

            offset(rounding)
            offset(-rounding)
            square([g, strap + rounding * 2], center = true);
        }

        half2("x+")
        difference() {
            square([t * 2 + g, strap + rounding * 2 + t * 2], center = true);
            square([g, strap + rounding * 2], center = true);
        }
    }

    translate([- phone.x / 2 + strap / 2 + rounding, - phone.y / 2 - t / 2, 0])
    rotate([90, 0, 90])
    translate([- o - g / 2 - t / 2, 0, 0])
    rotate_extrude(angle = a, $fn = 360)
    translate([o, 0])
    profile();

    translate([- phone.x / 2 - t / 2, - phone.y / 4 - t / 2, height / 2])
    cube([t, phone.y / 2 + t, height], center = true);
}

module bracket_slider() {
    w = 5;
    t = wall;
    g = 3;

    module bar() {
        cube([strap, t, w], center = true);
    }

    module connection() {
        translate([- strap / 2, - g - t / 2, 0])
        rotate([0, 0, 90])
        rotate_extrude(angle = 90)
        translate([g + t / 2, 0])
        square([t, w], center = true);
    }

    module slider() {
        translate([
            phone.x / 2 - strap / 2 - g - t - rounding,
            phone.y / 2 + wall + t / 2 + g,
            w / 2
        ]) {
            bar();

            connection();

            mirror([1, 0, 0])
            connection();
        }
    }

    slider();

    mirror([0, 1, 0])
    slider();
}

module assembly() {
    difference() {
        union() {
            base();
            bracket_strap();
            bracket_slider();
        }
        button_cutout();
    }
}

assembly();
