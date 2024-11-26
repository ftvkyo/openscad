ring_thickness = 8;
ring_rounding = 1;

radius_in = 20;
radius_out = 25;
radius_cut = 2;


module ring() {
    rotate_extrude($fn = 120)
    translate([radius_in, 0])
    offset(ring_rounding, $fn = 24)
    offset(-ring_rounding, $fn = 24)
    square([radius_out - radius_in, ring_thickness]);
}


module holes(count) {
    for (a = [0 : 360 / (count) : 359]) {
        rotate([90, 0, a])
        translate([0, 0, radius_in - 1])
        cylinder(radius_out - radius_in + 2, r = radius_cut, $fn = 36);
    }
}


difference() {
    ring();

    translate([0, 0, ring_thickness / 2])
    holes(24);
}
