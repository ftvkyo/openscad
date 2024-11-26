ring_thickness = 8;
ring_rounding = 1;
ring_radius = 25;

antiring_thickness = 4;
antiring_count = 24;

module ring() {
    rotate_extrude($fn = 120)
    translate([ring_radius, 0]) {
        offset(ring_rounding, $fn = 24)
        offset(- ring_rounding, $fn = 24)
        circle(ring_thickness / 2, $fn = 6);

        intersection() {
            circle(ring_thickness / 2, $fn = 6);

            translate([0, - ring_radius / 8])
            square(ring_radius / 4, center = true);
        }
    }
}


module antiring() {
    rotate_extrude(angle = 180, $fn = 24)
    translate([ring_thickness / 2 + antiring_thickness / 2, 0])
    circle(antiring_thickness / 2, $fn = 24);
}


difference() {
    ring();

    translate([0, 0, - antiring_thickness / 2])
    for (a = [0 : 360 / antiring_count : 359]) {
        rotate([90, 0, a])
        translate([ring_radius, 0, 0])
        antiring();
    }
}
