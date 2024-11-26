ring_thickness = 5;
ring_rounding = 1;
ring_radius = 20;


module ring() {
    rotate_extrude($fn = 120)
    translate([ring_radius, 0])
    offset(ring_rounding, $fn = 24)
    offset(- ring_rounding, $fn = 24)
    circle(ring_thickness / 2, $fn = 6);
}


antiring_thickness = 3;
antiring_count = 24;


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
