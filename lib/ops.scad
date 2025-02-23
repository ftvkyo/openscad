use <maths.scad>

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


module arrange_hex(distance, extent) {
    h = distance * sin(60);

    module row(count) {
        for (i = [1 : 1 : count]) {
            translate([distance * i, 0, 0])
            children();
        }
    }

    module sector(extent) {
        row(extent)
        children();

        if (extent > 1)
        translate([distance / 2, h, 0])
        sector(extent - 1)
        children();
    }

    for (a = [0, 60, 120, 180, 240, 300, 360])
    rotate([0, 0, a])
    sector(extent - 1)
    children();

    if (extent > 0)
    children();
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
