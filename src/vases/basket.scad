use <../../lib/shape.scad>


N = 0.4;
L = N / 2;
E = 0.01;

$fn = 64;


radius = 50;
thickness = N * 3;
height = 100;


module stick() {
    capsule([
        [radius * 2 / 3, 0, 0],
        [0, radius, height],
    ], thickness, caps = true);
}

module walls() {
    for (a = [0 : 20 : 359])
    rotate(a) {
        stick();

        mirror([-1, 0, 0])
            stick();
    }
}

module bottom() {
    pancake(thickness, radius * 2 / 3);
}

module vase() {
    walls();
    bottom();
}

vase();
