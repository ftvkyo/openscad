INF = 10 ^ 5;

module capsule(points, radius, caps = true) {
    $fn = 48;

    assert(is_list(points) && len(points) == 2, "'points' must be a list with 2 elements");

    let (a = points[0], b = points[1]) {
        assert(is_list(a) && len(a) == 3 && is_num(a.x) && is_num(a.y) && is_num(a.z), "'points[0]' must be a point in 3D space");
        assert(is_list(b) && len(b) == 3 && is_num(b.x) && is_num(b.y) && is_num(b.z), "'points[1]' must be a point in 3D space");

        let (dir = b - a, l = norm(dir), ndir = dir / l, rot_axis = [- ndir.y, ndir.x], angle = acos(ndir.z)) {
            if (caps) {
                translate(a)
                    sphere(radius);
                translate(b)
                    sphere(radius);
            }

            translate(a)
            rotate(angle, rot_axis)
                cylinder(l, r = radius);
        }
    }
}

module ring(thickness, radius) {
    rotate_extrude($fn = 180)
    translate([radius, 0])
        circle(thickness, $fn = 48);
}

module ringify(sides, side, thickness) {
    side_a = 360 / sides;
    for (a = [0 : side_a : 359]) {
        rotate([0, 0, a])
            children();
    }
}

module multiring(sides, side, thickness) {
    // Correct (roughly) for the sides intersecting at the corners
    side_y = side + thickness;
    side_a = 360 / sides;
    side_x = side_y / tan(side_a / 2) / 2;
    ringify(sides, side, thickness)
        capsule([
            [side_x, side_y / 2, 0],
            [side_x, - side_y / 2, 0],
        ], thickness / 2);
}

module multiray(sides, side, thickness) {
    // Correct (roughly) for the sides intersecting at the corners
    side_y = side + thickness;
    side_a = 360 / sides;
    side_x = side_y / sin(side_a / 2) / 2;

    // p1 = [side_x, side_y / 2, 0];
    // p2 = [side_x, - side_y / 2, 0];

    p1 = [side_x, 0, 0];
    p2 = [side_x + side_y, 0, 0];

    ringify(sides, side, thickness)
        rotate([0, 0, side_a / 2])
        capsule([p1, p2], thickness / 2);
}

module pancake(thickness, radius) {
    rotate_extrude($fn = 180) {
        translate([radius, 0])
            circle(thickness, $fn = 48);

        polygon([
            [0, thickness],
            [radius, thickness],
            [radius, - thickness],
            [0, - thickness],
        ]);
    }
}

module flatten(thickness) {
    intersection() {
        children();
        cube([INF, INF, thickness], center = true);
    }
}

module spiral(length, diameter, radius, turns, scale = 1, caps = true, center = false, $fn = 36) {
    linear_extrude(length, twist = turns * 360, slices = length, center = center, convexity = turns, scale = scale)
    translate([radius, 0])
        circle(diameter, $fn = $fn * 1);

    module the_caps() {
        translate([radius, 0, - length / 2])
            sphere(diameter, $fn = $fn * 2);

        rotate([0, turns * 360, 0])
        translate([radius * scale, 0, length / 2])
            sphere(diameter * scale, $fn = $fn * 2);
    }

    if (caps) {
        if (center) {
            the_caps();
        } else {
            translate([0, 0, length / 2])
                the_caps();
        }
    }
}
