module repeat_row(step, count) {
    assert(is_list(step) && 2 <= len(step) && len(step) <= 3);
    for (comp = step) assert(is_num(comp));
    assert(is_num(count));

    for (i = [0 : count - 1])
    translate(step * i)
        children();
}


module arrange_row(step) {
    assert(is_list(step) && 2 <= len(step) && len(step) <= 3);
    for (comp = step) assert(is_num(comp));

    for (i = [0 : $children - 1])
    translate(step * i)
        children(i);
}


module arrange_hex(d, e) {
    h = d * sin(60);
    r = d / 2;

    cols = e;
    rows = ceil((e + 1) / 2);

    module repeat(row, col) {
        children();

        if (row < rows - 1 && col < cols - 1)
        translate([
            r / 2,
            h / 2,
            0
        ])
            children();
    }

    translate([
        - cols / 2 * r + r / 2,
        - rows / 2 * h + h / 2,
        0,
    ])
    for (
        col = [0 : cols - 1],
        row = [0 : rows - 1]
    )
    translate([
        col * r,
        row * h,
        0
    ]) {
        repeat(row, col)
            children();
    }

        // if (abs(col) + abs(row) * 2 <= e) {
        //     translate([col * d / 2, row * h, 0])
        //         children();
        // }
}


module flatten(thickness) {
    INF = 10 ^ 5;

    intersection() {
        children();
        cube([INF, INF, thickness], center = true);
    }
}


module spin2d(length, turns, scal = undef, slices = undef) {
    linear_extrude(length, twist = turns * 360, slices = is_undef(slices) ? length * turns : slices, scale = scal, center = true, convexity = abs(turns) * 2)
        children();
}


module spin3d(length, turns, steps, scal) {
    translate([0, 0, - length / 2])
    for (p = [0 : 1 / steps : 1]) {
        a = - turns * p * 360;
        z = length * p;

        s = lerp(1, scal, p);

        translate([0, 0, z])
        rotate([0, 0, a])
        scale(s)
            children();
    }
}

module rounden_xyz(r, $fn = 24) {
    minkowski() {
        children();
        sphere(r);
    }
}

module rounden_xy(r, $fn = 24) {
    minkowski() {
        children();
        cylinder(r * 2, r = r, center = true);
    }
}
