E = 0.02;


module lExtrude(height, width, angle) {
    function lScale(angle, width, height) = 1 + 2 * tan(angle) * height / width;

    linear_extrude(height, scale = lScale(angle, width, height))
        children();
}


module fillet(r) {
    $fn = 36;

    offset(r)
    offset(- r)
        children();
}


module tray() {
    width = 150;
    height = 3;
    depth = 2;
    rounding = 5;
    wall = 1;
    angle = 30; // Degrees

    difference() {
        lExtrude(height, width + wall, angle)
        fillet(rounding)
            square(width + wall, center = true);

        translate([0, 0, height - depth + E])
        lExtrude(depth, width - wall, angle)
        fillet(rounding - wall)
            square(width - wall, center = true);
    }
}


tray();
