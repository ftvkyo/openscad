use <../../lib/util.scad>

width = 10;
length = 20;
thickness = 1.5;
radius = 7.5 / 2;
offst = 3;

$fn = 72;
E = 0.01;

module profile_base() {
    translate([0, thickness / 2])
    square([length, thickness], center = true);

    translate([radius, - offst / 2 - E])
    square([thickness, offst], center = true);

    translate([0, - offst - E * 2])
    half2("y-")
    difference() {
        circle(radius + thickness / 2);
        circle(radius - thickness / 2);
    }
}

linear_extrude(height = width, center = true)
profile_base();
