use <../lib/ops.scad>


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
    r = 2.5;

    spin2d(l, t)
    translate([d / 2, 0, 0])
        profile_helix(g, r);

    spin3d(l, t, 32)
    translate([d / 2, 0, 0])
        bridge(g, r / 4);
}


intersection() {
    cube(l, center = true);

    pin();
}
