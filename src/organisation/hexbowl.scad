use <../../lib/ops.scad>

HOLES = true;

r = 50;
h = 20;
rounden = 5;


module holes() {
    hr = 5;

    translate([0, 0, - 0.01])
    arrange_hex(hr * 2, 5)
    rotate([0, 0, 360 / 12])
    cylinder(h * 2, r = hr, $fn = 6);
}

module bowl() {

    difference() {
        rounden_xy(rounden, $fn = 48)
        translate([0, 0, rounden])
        cylinder(h, r = r - rounden, $fn = 6);

        f = 2;

        translate([0, 0, r * f + 10])
        sphere(r * f, $fn = 180);
    }
}

difference() {
    bowl();
    if (HOLES) {
        holes();
    }
}
