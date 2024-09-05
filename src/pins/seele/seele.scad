N = 0.4;
L = N / 2;
T = L * 15;

enlarge = 1;
w = 35 * enlarge;

strap_w = 26;
strap_h = 2.5;

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

module outline() {
    offset(0.1)
    difference() {
        children();

        offset(- N * 1.5)
            children();
    }
}

module rounded(f) {
    $fn = 36;
    offset(N * f)
    offset(- N * f * 2)
    offset(N * f)
        children();
}

module seele_2d() {
    scale(enlarge) {
        difference() {
            outline()
                svg_triangle();

            svg_eyes();
        }

        translate([0, 0.25])
        rotate(-0.25)
            square([N * 1.5, 23.5], center = true);

        outline()
            svg_eyes();

        outline()
            svg_pupils();
    }
}

module base_2d() {
    rounded(8)
    square([w, w], center = true);
}

module edge_2d() {
    outline()
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

module bracket() {
    $fn = 36;

    color("red")
    translate([0, 0, 0.01])
    linear_extrude(T - 0.02)
    rounded(2)
    difference() {
        rounded(8)
            square([w + strap_h + N * 10, strap_w + N * 10], center = true);

        rounded(4)
            square([w + strap_h, strap_w], center = true);

        square([w + strap_w, strap_h], center = true);
    }
}

pin();
bracket();
