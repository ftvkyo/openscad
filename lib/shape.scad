INF = 10 ^ 5;

module capsule(points, radius) {
    $fn = 48;

    assert(is_list(points) && len(points) == 2, "'points' must be a list with 2 elements");

    let (a = points[0], b = points[1]) {
        assert(is_list(a) && len(a) == 3 && is_num(a.x) && is_num(a.y) && is_num(a.z), "'points[0]' must be a point in 3D space");
        assert(is_list(b) && len(b) == 3 && is_num(b.x) && is_num(b.y) && is_num(b.z), "'points[1]' must be a point in 3D space");

        let (dir = b - a, l = norm(dir), ndir = dir / l, rot_axis = [- ndir.y, ndir.x], angle = acos(ndir.z)) {
            translate(a)
                sphere(radius);

            translate(b)
                sphere(radius);

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

module flatten(thickness) {
    intersection() {
        children();
        cube([INF, INF, thickness], center = true);
    }
}
