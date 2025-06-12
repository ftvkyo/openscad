use <../../lib/util.scad>

width = 10;
length = 20;
thickness = 1.5;
radius = 7.5 / 2;
loop_width = 12;

$fn = 72;
E = 0.01;

module profile_base() {
    translate([0, thickness / 2])
    square([length, thickness], center = true);

    translate([0, - radius])
    square([loop_width - radius, thickness], center = true);

    module semicircle() {
        half2("y-")
        difference() {
            circle(radius + thickness / 2);
            circle(radius - thickness / 2);
        }
    }

    translate([loop_width / 2 - radius / 2, 0])
    half2("x+")
    semicircle();

    translate([- loop_width / 2 + radius / 2, 0])
    half2("x-")
    semicircle();
}

linear_extrude(height = width, center = true)
profile_base();
