N = 0.4;
L = N / 2;
E = 0.01;

module slice2d(extent) {
    square(extent, center = true);

    rotate([0, 0, 30])
    square(extent, center = true);

    rotate([0, 0, 60])
    square(extent, center = true);
}

module slice(e, h, w, t) {
    linear_extrude(
        h,
        scale = w,
        twist = t * 120,
        slices = h / L
    )
        slice2d(e);
}

module vase(radius, height, scale_factor) {
    f = scale_factor;

    slice(radius, height / 4, f, 1 / 4);

    translate([0, 0, height / 4 - E]) {
        slice(radius * f, height / 4, f, - 1 / 4);

        translate([0, 0, height / 4 - E]) {
            slice(radius * f ^ 2, height / 4, f, 1 / 4);

            translate([0, 0, height / 4 - E]) {
                slice(radius * f ^ 3, height / 4, f, - 1 / 4);
            }
        }
    }
}

vase(
    radius = 50,
    height = 150,
    scale_factor = 1.1
);
