side = 75;
height = 5;
depth = 4;
rounding = 5;
wall = 4;

E = 0.02;

module _round(r) {
    $fn = 36;

    offset(r)
    offset(- r)
        children();
}


module base() {
    linear_extrude(height)
    _round(rounding)
        square([side, side] + [wall, wall] / 2, center = true);
}


module compartment(dim) {
    module shape() {
        linear_extrude(dim.z)
        _round(rounding * 2/3)
            square([dim.x, dim.y], center = true);
    }

    translate([0, 0, height - dim.z + E])
        shape();
}


module compartment_1x1() {
    compartment([side / 3, side / 3, depth] - [wall, wall, 0] / 2);
}

module compartment_1x2() {
    compartment([side / 3, side * 2 / 3, depth] - [wall, wall, 0] / 2);
}

module compartment_3x1() {
    compartment([side, side / 3, depth] - [wall, wall, 0] / 2);
}


module tray() {
    difference() {
        base();

        compartment_1x1();

        translate([0, - side / 3, 0])
            compartment_1x1();

        translate([side / 3, - side / 6, 0])
            compartment_1x2();

        translate([- side / 3, - side / 6, 0])
            compartment_1x2();

        translate([0, side / 3, 0])
            compartment_3x1();
    }
}


tray();
