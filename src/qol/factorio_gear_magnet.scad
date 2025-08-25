circle_thickness = 5;
circle_inner_radius = 7.5;
circle_outer_radius = 20;

teeth_thickness = 3;
teeth_radius = 25;
teeth_width = 7.5;

magnet_thickness = 3;
magnet_radius = 3.05;

$fn = $preview ? 12 : 48;


module rounder(r, t) {
    $fn = 12;

    rotate_extrude()
    polygon([
        [0, 0],
        [r, 0],
        [0, t],
    ]);
}

module circle_profile() {
    difference() {
        circle(circle_outer_radius);
        circle(circle_inner_radius);
    }
}

module tooth_profile() {
    difference() {
        translate([0, teeth_radius / 2])
        square([teeth_width, teeth_radius], center = true);

        circle((circle_inner_radius + circle_outer_radius) / 2);
    }
}

module gear() {
    minkowski() {
        r = 3;

        linear_extrude(1)
        offset(-r)
        circle_profile();

        rounder(r, circle_thickness - 1);
    }

    for(a = [45 : 45 : 360])
    rotate([0, 0, a])
    minkowski() {
        linear_extrude(1)
        offset(-1)
        tooth_profile();

        scale([1/2, 2, 1])
        rounder(1, teeth_thickness - 1);
    }
}

module magnet() {
    translate([0, 0, -0.01])
    cylinder(h = magnet_thickness, r = magnet_radius);
}

module gear_magnet() {
    dy = (circle_inner_radius + circle_outer_radius) / 2;

    difference() {
        gear();

        translate([0, (circle_inner_radius + circle_outer_radius) / 2, 0])
        magnet();

        translate([0, - (circle_inner_radius + circle_outer_radius) / 2, 0])
        magnet();
    }
}

gear_magnet();
