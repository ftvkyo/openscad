use <../../lib/shape.scad>

h = 150;


module a_cube() {
    x = sqrt(2) / 2;
    z = 1 / 2;

    a = atan2(x, z);

    translate([0, 0, sqrt(3) / 2])
    rotate([0, a, 0])
    rotate([0, 0, 45])
    cube(1, center = true);
}


module a_uncube() {
    ch = sqrt(3);

    f = h / ch;

    scale([f / 2, f / 2, f])
        a_cube();
}


module vase() {
    $fn = 120;

    cut = 2 / 3;

    scale(1 / cut) {
        intersection() {
            for (a = [0 : 45 : 359]) {
                rotate([0, 0, a])
                    a_uncube();
            }

            cube(h * 2 * cut, center = true);
        }

        difference() {
            cylinder(h = h / 3, r1 = h / 4, r2 = h / 6);

            translate([0, 0, h / 6])
                ring(h / 20, h / 4.2);

            translate([0, 0, h / 6 - h / 20])
                ring(h / 20, h / 4);
        }
    }
}


vase();
