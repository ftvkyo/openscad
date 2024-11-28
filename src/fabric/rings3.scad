ring_radius = 25;
ring_thickness = 8;
ring_rounding = 1;

cut_thickness = 4;
cut_count = 24;


module ring(angle = 360, radius, thickness, rounding) {
    rotate([0, 0, - angle / 2])
    rotate_extrude(angle = angle, $fn = 120)
    translate([radius, 0]) {
        offset(rounding, $fn = 24)
        offset(- rounding, $fn = 24)
        circle(thickness / 2, $fn = 6);

        intersection() {
            circle(thickness / 2, $fn = 6);

            translate([0, - thickness / 2])
            square([thickness * 2/3, thickness], center = true);
        }
    }
}


module cut(rthickness, cthickness) {
    rotate_extrude(angle = 180, $fn = 24)
    translate([rthickness / 2 + cthickness / 2, 0])
    circle(cthickness / 2, $fn = 24);
}


module model_base(angle = 360, radius = ring_radius, thickness = ring_thickness, rounding = ring_rounding, cuts = cut_count, cthickness = cut_thickness) {
    difference() {
        ring(angle, radius = radius, thickness = thickness, rounding = rounding);

        rotate([0, 0, 360 / cuts / 2])
        translate([0, 0, - cut_thickness / 2])
        for (a = [0 : 360 / cuts : 359]) {
            rotate([90, 0, a])
            translate([radius, 0, 0])
            cut(thickness, cthickness);
        }
    }
}

module model_mega() {
    r = 20;
    t = 12;

    for (a = [0, 60, 120, 180, 240, 300])
    rotate([0, 0, a]) {
        translate([r * 2 + r * sqrt(2), 0, 0])
        model_base(angle = 180, radius = r, thickness = t, rounding = 4, cuts = 12, cthickness = 6);

        rotate([0, 0, 30])
        translate([r * 4, 0, 0])
        rotate([0, 0, 180])
        model_base(angle = 120, radius = r, thickness = t, rounding = 4, cuts = 12, cthickness = 6);
    }
}


// model_base();
model_mega();
