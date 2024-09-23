use <../../lib/shape.scad>
use <../../lib/operators.scad>
include <_shared.scad>


fan_r = 70 / 2;
thickness = 5;
h = fan_r;
grip = 5;

leg = var_ivar_leg + [1, 1];


module holder() {
    flatten(thickness * 3/2)
        ring(thickness, fan_r + thickness);
}


module clamp() {
    $fn = 48;

    translate([0, 0, thickness * 3 / 4])
    mirror([0, 0, 1])
    linear_extrude(h)
    offset(thickness / 3)
    offset(- thickness / 3)
    difference() {
        square(leg + [thickness, thickness] * 2, center = true);

        square(leg, center = true);

        translate([0, -thickness])
            square(leg + [- grip * 2, thickness], center = true);
    }
}


module ribs() {
    $fn = 240;

    module p() {
        translate([0, leg.y / 2 + fan_r / 2 + thickness])
        difference() {
            square([leg.x + thickness * 2, fan_r + thickness * 2], center = true);

            translate([0, fan_r - thickness * 2])
            circle(fan_r + thickness);
        }
    }

    linear_extrude(thickness * 3/2, center = true)
        p();

    translate([0, 0, thickness * 3 / 4])
    mirror([0, 0, 1])
    intersection() {
        linear_extrude(h, convexity = 10)
            p();

        translate([0, leg.y / 2, 0])
        rotate([45, 0, 0])
            cube([leg.x + thickness * 2, h * sqrt(2), 100], center = true);
    }
}


module assembly() {
    translate([0, fan_r + thickness * 2 + leg.y / 2, 0])
        holder();

    clamp();

    ribs();

    %color("grey")
        ivar_leg();
}


assembly();
