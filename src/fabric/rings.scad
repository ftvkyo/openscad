use <../../lib/shape.scad>
use <../../lib/operators.scad>


w = 25;
r = 2.5;


module the_circle() {
    ww = w + r;

    flatten(r * 1.5)
        ring(r, ww);
}

module the_diamond() {
    ww = w * 0.9 + r * 2;

    f1 = 0.5;
    f2 = 0.9;

    p0 = [- ww, - ww, 0] * f1;
    p1 = [- ww, ww, 0] * f2;
    p2 = [ww, ww, 0] * f1;
    p3 = [ww, - ww, 0] * f2;

    flatten(r * 1.5) {
        capsule([p0, p1], r);
        capsule([p1, p2], r);
        capsule([p2, p3], r);
        capsule([p3, p0], r);

        capsule([p0, p2], r);
    }
}


module the_triangle() {
    ww = w * 0.9;

    a = 120;
    p0 = [ww, 0, 0];
    p1 = [p0.x * cos(a) - p0.y * sin(a), p0.x * sin(a) + p0.y * cos(a), 0];
    p2 = [p1.x * cos(a) - p1.y * sin(a), p1.x * sin(a) + p1.y * cos(a), 0];

    flatten(r * 1.5) {
        capsule([p0, p1], r);
        capsule([p1, p2], r);
        capsule([p2, p0], r);
    }
}

// the_circle();
the_diamond();
// the_triangle();
