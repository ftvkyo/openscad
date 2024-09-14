use <../../lib/shape.scad>

thickness_d = 5;
stick_l = 80;
side_l = 20;

module hexagon() {
    flatten(thickness_d * 4 / 5)
        multiring(6, side_l, thickness_d);
}

module stick() {
    $fn = 64;

    e1 = [- stick_l / 2, 0, 0];
    e2 = [stick_l / 2, 0, 0];

    flatten(thickness_d * 4 / 5) {
        capsule([e1, e2], thickness_d / 2);

        translate(e1)
            sphere(r = thickness_d);
    }
}

module pin() {
    difference() {
        hexagon();

        translate([0, 0, thickness_d * 0.6])
        stick();
    }
}

pin();

translate([0, side_l * 2, 0])
    stick();
