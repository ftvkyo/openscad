$fn = 48;

length = 50;
radius = 3;


module dring() {
    f = 4;

    rotate([90, 0, 0])
        cylinder(length, r = radius, center = true);

    translate([radius * f, 0, 0])
    rotate([90, 0, 0])
        cylinder(length, r = radius, center = true);

    translate([0, length / 2, 0])
        sphere(radius);

    translate([0, - length / 2, 0])
        sphere(radius);

    translate([radius * f, length / 2, 0])
    rotate([45, 90, 0])
        cylinder(length * sqrt(2) / 2, r = radius);

    translate([radius * f, - length / 2, 0])
    rotate([-45, 90, 0])
        cylinder(length * sqrt(2) / 2, r = radius);

    translate([length / 2 + radius * f, 0, 0])
        sphere(radius);

    translate([0, length / 2, 0])
    rotate([0, 90, 0])
        cylinder(radius * f, r = radius);

    translate([0, - length / 2, 0])
    rotate([0, 90, 0])
        cylinder(radius * f, r = radius);

    translate([radius * f, length / 2, 0])
        sphere(radius);

    translate([radius * f, - length / 2, 0])
        sphere(radius);
}


module dring_flattened() {
    intersection() {
        dring();

        cube([length * 2, length * 2, radius * 1.5], center = true);
    }
}


dring_flattened();
