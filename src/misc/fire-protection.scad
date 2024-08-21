$fn = 48;
E = 0.05;

rod_l = 300;
rod_d_outer = 10;
rod_d_inner = 5.5;


module rod() {
    color("#80808080")
    difference() {
        cylinder(rod_l, r = rod_d_outer / 2, center = true);
        cylinder(rod_l + E, r = rod_d_inner / 2, center = true);
    }
}

module spike() {
    l = 50;
    ropel = 20;
    roped = 3;

    translate([0, 0, - l / 2])
    difference() {
        union() {
            cube([rod_d_outer, rod_d_outer, l], center = true);
            translate([0, 0, l / 2])
                cylinder(ropel, r = rod_d_inner / 2, center = true);
        }

        translate([rod_d_outer / 2, 0, 0])
        multmatrix([
            [1, 0, rod_d_outer / l, 0],
            [0, 1, 0, 0],
            [0, 0, 1, 0],
        ])
            cube([rod_d_outer + E, rod_d_outer + E, l + E], center = true);

        translate([0, 0, l / 2])
            cylinder(ropel + E, r = roped / 2, center = true);

        translate([0, 0, l / 2 - ropel / 2])
            sphere(roped * 0.75);

        translate([0, 0, l / 2 - ropel / 2])
        rotate([0, -90, 0])
            cylinder(ropel, r = roped * 0.75);

        translate([0, 0, - l * 0.8])
            cube([rod_d_outer + E, rod_d_outer + E, l + E], center = true);
    }
}

module cap() {
    l = 23;
    ropel = 20;
    roped = 3;

    translate([0, 0, l / 2])
    difference() {
        union() {
            cube([rod_d_outer, rod_d_outer, l], center = true);
            translate([0, 0, - l / 2])
                cylinder(ropel, r = rod_d_inner / 2, center = true);
        }

        translate([0, 0, - l / 2])
            cylinder(ropel + E, r = roped / 2, center = true);

        translate([0, 0, - l / 2 + ropel / 2])
            sphere(roped * 0.75);

        translate([0, 0, - l / 2 + rod_d_outer + roped * 2.425])
        rotate([90, 0, 0])
        rotate_extrude(angle = 270)
        translate([rod_d_outer / 2 + roped * 0.75, 0, 0])
            circle(roped * 0.75);
    }
}


translate([0, 0, rod_l / 2])
    cap();

%rod();

translate([0, 0, - rod_l / 2])
    spike();
