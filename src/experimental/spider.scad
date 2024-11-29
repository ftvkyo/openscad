use <../../lib/util.scad>


$fn = 48;


module body() {
    sphere(10);
}


module head() {
    // Base

    translate([0, 4, -2])
    scale([1, 0.9, 1.2])
    intersection() {
        sphere(7.5);
        cylinder(15, r = 7);
    }

    translate([0, -4, -2])
    scale([1, 0.9, 1.2])
    intersection() {
        sphere(7.5);
        cylinder(15, r = 7);
    }

    // Eyes

    translate([4, 3.5, 4])
    sphere(3);

    translate([4, -3.5, 4])
    sphere(3);

    translate([1, 7, 5])
    sphere(2);

    translate([1, -7, 5])
    sphere(2);

    // Chompers

    module chomper() {
        cylinder(h = 4, r1 = 1.5, r2 = 1);

        translate([0, 0, 4])
        sphere(1);
    }

    translate([5, 3, 0])
    rotate([0, 90, -15])
    chomper();

    translate([5, -3, 0])
    rotate([0, 90, 15])
    chomper();
}


module legs() {
    module leg(bend = 0) {
        rotate([90, 0, 0])
        translate([0, 0, 8])
        {
            cylinder(h = 5, r1 = 1.5, r2 = 1.25);

            translate([0, 0, 5])
            sphere(1.25);

            translate([0, 0, 5])
            rotate([0, bend, 0]) {
                cylinder(h = 8, r1 = 1.25, r2 = 1);

                translate([0, 0, 8])
                sphere(1);
            }
        }
    }

    module legs_side() {
        rotate([0, 0, 15])
        leg(75);

        rotate([0, 0, -5])
        leg(45);

        rotate([0, 0, -25])
        leg(-45);

        rotate([0, 0, -45])
        leg(-45);
    }

    legs_side();

    mirror([0, 1, 0])
    legs_side();
}


module spider() {
    half3() {
        body();

        translate([7.5, 0, 0.5])
        head();

        translate([0, 0, 0.5])
        legs();
    }
}


module attachment() {
    translate([2, 0, -2.5])
    rotate([90, 0, 0])
    rotate_extrude(angle = 180)
    translate([7, 0])
    circle(2.5);
}


difference() {
    spider();

    translate([0, 4, 0])
    attachment();

    translate([0, -4, 0])
    attachment();
}
