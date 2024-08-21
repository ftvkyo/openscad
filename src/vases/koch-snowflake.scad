// https://en.wikipedia.org/wiki/Koch_snowflake

N = 0.4;
L = N / 2;
E = 0.01;


module slice2d(extent) {
    $fn = 3;

    circle(extent);

    rotate(60)
        circle(extent);

    for (r1 = [0 : 60 : 359]) {
        rotate(r1)
        translate([extent * 2 / 3, 0, 0]) {
            rotate(60)
                circle(extent / 3);

            for (r2 = [0 : 60 : 359]) {
                rotate(r2)
                translate([extent * 2 / 9, 0, 0]) {
                    rotate(60)
                        circle(extent / 9);

                    for (r3 = [0 : 60 : 359]) {
                        rotate(r3)
                        translate([extent * 2 / 27, 0, 0])
                        rotate(60)
                            circle(extent / 27);
                    }
                }
            }
        }
    }
}


module vase(radius, height, scale_factor, twist) {
    r = radius;
    h = height;
    f = scale_factor;
    t = twist;

    linear_extrude(
        h,
        scale = f,
        twist = t * 120,
        slices = h / L
    )
        slice2d(r);
}

vase(
    radius = 30,
    height = 100,
    scale_factor = 1.5,
    twist = 0.5
);
