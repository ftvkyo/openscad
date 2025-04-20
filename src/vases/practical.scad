height = 50;
radius_bottom = 40;
radius_top = 60;
turns = 1/6;

rounding = radius_bottom / 4;

module profile() {
    $fn = 72;

    offset(- rounding)
    offset(rounding * 2)
    offset(- rounding) {
        circle(radius_bottom, $fn = 3);

        rotate(60)
        circle(radius_bottom, $fn = 3);
    }
}

linear_extrude(height, scale = radius_top / radius_bottom, twist = 360 * turns, slices = height / 2)
profile();
