use <../fabric/phone-holder.scad>

N = 0.4;
L = N / 2;
T = L * 15;

enlarge = 1.5;

strap_w = 25;

module svg_triangle() {
    import("seele-triangle.svg", center = true);
}

module svg_triangle_mid() {
    import("seele-triangle-mid.svg", center = true);
}

module svg_eyes() {
    import("seele-eyes.svg", center = true);
}

module svg_pupils() {
    import("seele-pupils.svg", center = true);
}

module unsvg() {
    difference() {
        children();

        offset(-N)
            children();
    }
}

module seele_2d() {
    difference() {
        unsvg()
            svg_triangle();

        svg_eyes();
    }

    translate([0, 0.25])
    rotate(-0.25)
        square([N, 23.5], center = true);

    unsvg()
        svg_eyes();

    unsvg()
        svg_pupils();
}

module base_2d() {
    $fn = 36;
    offset(N * 8)
    offset(- N * 8)
    square([35, 35], center = true);
}

module edge_2d() {
    unsvg()
        offset(- 0.01)
        base_2d();
}

module pin() {
    linear_extrude(T)
        base_2d();

    color("grey")
    translate([0, 0, 0.01]) {
        linear_extrude(T + L * 5)
            edge_2d();

        linear_extrude(T + L * 5)
            seele_2d();
    }
}

scale([enlarge, enlarge, 1])
    pin();

difference() {
    rotate([-90, 0, 90])
    translate([0, 4, -15 * enlarge])
        brracket([25, 7.5], L * 5, 30 * enlarge);

    cube([20, 35, 100] * enlarge, center = true);
}
