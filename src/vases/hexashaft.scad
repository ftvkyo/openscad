module shaft(radius, thickness, height, tilt, shaft_r1, shaft_r2) {
    h = height / cos(tilt) + max(shaft_r1, shaft_r2) * tan(tilt) * 2;

    rotate([- tilt, 0, 0]) {
        translate([radius / 2, 0, 0])
        cube([radius, thickness, h], center = true);

        translate([radius, 0, 0])
        cylinder(h, r1 = shaft_r1, r2 = shaft_r2, center = true, $fn = 72);
    }
}

module vase() {
    radius = 50;
    thickness = 5;
    height = 100;
    tilt = 15;
    r1 = 15;
    r2 = 25;

    for (a = [0, 180], b = [30, 90])
    rotate([a, 0, b])
    cylinder(height / 2, r1 = thickness / 2, r2 = radius / 2, $fn = 3);

    intersection() {
        for (a = [0 : 60 : 359])
        rotate([0, 0, a])
        shaft(
            radius = radius,
            thickness = thickness,
            height = height,
            tilt = tilt,
            shaft_r1 = r1,
            shaft_r2 = r2
        );

        cylinder(height, r = 10 ^ 3, center = true);
    }
}

vase();
