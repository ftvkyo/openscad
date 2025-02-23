use <../../lib/ops.scad>


E = 0.01;


// Shapes


module profile_helix(g, r) {
    $fn = 36;

    translate([0, g / 2])
        circle(r);

    translate([0, - g / 2])
        circle(r);
}


module bridge(g, r) {
    $fn = 24;

    rotate([90, 0, 0])
        cylinder(g, r = r, center = true);
}


// Results


l = 100;


module pin() {
    t = 1.5;
    d = 6;
    g = 10;
    r = 3;
    s = 1/3;
    b = 32;

    module move(e = 1) {
        translate([d / 2, 0, 0] * e)
            children();
    }

    module tip(g, r) {
        $fn = 48;

        translate([0, g / 2, l / 2])
            sphere(r);

        translate([0, - g / 2, l / 2])
            sphere(r);
    }

    module base(g, r) {
        $fn = 48;

        translate([0, g / 2, - l / 2])
            sphere(r);

        translate([0, - g / 2, - l / 2])
            sphere(r);
    }

    spin2d(l, t, scal = s, slices = b)
    move()
        profile_helix(g, r);

    spin3d(l, t, b, scal = s)
    move()
        bridge(g, r / 3);

    move()
        base(g, r + 1);

    rotate([0, 0, t * 360])
    move(s)
        tip(g * s, r * s);
}


intersection() {
    pin();

    cube(l + 6, center = true);
}
