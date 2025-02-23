use <../../lib/ops.scad>


// Shapes


module profile(r) {
    $fn = 36;

    o = 2;

    offset(-o)
    offset(o) {
        translate([0, r * 2])
            circle(r);

        translate([0, - r * 2])
            circle(r);

        square([1, r + 1], center = true);
    }
}


// Results


module pin() {
    l = 100;
    t = 1.5;
    d = 6;
    r = 3;

    spin2d(l, t)
    translate([d / 2, 0, 0])
        profile(r);
}

pin();
