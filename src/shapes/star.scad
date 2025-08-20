radius = 10; // [ 5 : 0.5 : 20 ]
rounding = 1.0; // [ 0 : 0.5 : 2.5 ]

module star_flat(r) {
    x = tan(18) * r;
    y = r;

    for (a = [1 : 5])
    rotate(360 / 5 * a)
    polygon([
        [-x, 0],
        [x, 0],
        [0, y],
    ]);
}

module rounder(r, t) {
    $fn = 24;

    rotate_extrude()
    polygon([
        [0, 0],
        [r, 0],
        [0, t],
    ]);
}

module star(r, t) {
    minkowski() {
        linear_extrude(max(t - 1, 0.01))
        star_flat(r - rounding);

        rounder(rounding, 1);
    }
}

star(radius, 2);
