symbol = "";
dot = false;

NOZ = 0.4;

module __hidden__ () {}

x = 17.4;
y = 16.4;
z = 5.6;

pin_x = 1.1 - NOZ / 2;
pin_y = 2.8 - NOZ / 2;
pin_z = 3.2;

pin_dx = 4.6;

hat_z = 3.8;
hat_depth = 1.4;
hat_wall = 0.8;

chamfer_reduction = 0.4;

E = 0.01;


module pin() {
    translate([0, 0, - pin_z/2 + E])
    cube([pin_x, pin_y, pin_z], center = true);
}

module pins() {
    dx2 = (pin_x + pin_dx) / 2;

    translate([dx2, 0, 0])
    pin();

    translate([- dx2, 0, 0])
    pin();
}

module pad(rd = 0) {
    r = 80;
    $fn = 360;

    translate([0, 0, r + hat_z - hat_depth])
    sphere(r + rd);
}

module hat() {
    h = z - pin_z;

    module profile() {
        $fn = 1;
        offset(1)
        offset(-1)
        square([x, y], center = true);
    }

    module chamferer() {
        v = 5;
        rotate([30, 0, 0])
        translate([0, v / 2, v / 2])
        cube([max(x, y), v, v], center = true);
    }

    difference() {
        translate([0, 0, - hat_depth])
        linear_extrude(hat_z)
        profile();

        translate([0, 0, - hat_depth - E])
        linear_extrude(hat_depth)
        offset(- hat_wall)
        profile();

        for (ps = [[y / 2, 0], [x / 2, 90], [y / 2, 180], [x / 2, 270]])
        rotate([0, 0, ps[1]])
        translate([0, ps[0], chamfer_reduction])
        chamferer();

        pad(0.8);
    }
}

module cap(sym) {
    pins();
    hat();

    color("red")
    difference() {
        linear_extrude(hat_z, convexity = 4)
        text(
            sym,
            font = "Iosevka:style=Light Extended",
            valign = "center",
            halign = "center"
        );

        pad(0.6);
    }

    if (dot) {
        translate([0, - y / 2 + 2, hat_z - hat_depth - 0.5])
        rotate([0, 90, 0])
        cylinder(5, r = 0.25, center = true, $fn = 24);
    }
}

rotate([90, 0, 0])
cap(symbol);
