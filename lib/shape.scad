use <ops.scad>
use <points.scad>


module capsule(points, radius, caps = true) {
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

module spiral(length, diameter, radius, turns, scale = 1, caps = true, center = false, $fn = 36) {
    linear_extrude(length, twist = turns * 360, slices = length, center = center, convexity = turns, scale = scale)
    translate([radius, 0])
        circle(diameter, $fn = $fn * 1);

    module the_caps() {
        translate([radius, 0, - length / 2])
            sphere(diameter, $fn = $fn * 2);

        rotate([0, turns * 360, 0])
        translate([radius * scale, 0, - length / 2])
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


module torus(
    radius,
    thickness,
    delta_z = 0,
    waves = 0,
    fn_profile = 36,
    fn_loop = 180,
) {
    function slice_tilt(t) = [- sin(waves * t * 360) * delta_z * waves * 2/3, 0, 0];
    function slice_displacement(t) = [0, 0, cos(waves * t * 360) * delta_z / 2];

    c_base = pts_translate3(
        pts_rotate3(
            pts_inflate(pts_circle(thickness / 2, fn_profile)),
            [90, 0, 0]
        ),
        [radius + thickness / 2, 0, 0]
    );

    cs = [ for (t = [1 / fn_loop : 1 / fn_loop : 1])
        pts_translate3(
            pts_rotate3(
                pts_rotate3(
                    c_base,
                    slice_tilt(t)
                ),
                [0, 0, t * 360]
            ),
            slice_displacement(t)
        )
    ];

    pts_extrude(cs);
}


module double_helix(
    radius_ring,
    radius_twist,
    thickness,
    gap,
    twists,
    fn_profile = 36,
    fn_loop = 180,
) {
    strand_base = pts_rotate3(
        pts_inflate(pts_circle(thickness / 2, fn_profile)),
        [90, 0, 0]
    );

    function trot(t) = twists * t * 360;

    module strand(dx, dz) {
        // The slice center will always be this far from the helix center
        init_distance = sqrt(dx^2 + dz^2);
        // Rotation of the init_distance to achieve dx and dz
        init_angle = atan(dz / dx);

        function slice_init(s, t) = pts_rotate3(
            pts_translate3(
                pts_rotate3(
                    s,
                    // Guesstimation to make the crossection more round
                    [- atan(1 / twists) * twists / 2, 0, 0]
                ),
                [init_distance, 0, 0]
            ),
            [0, init_angle, 0]
        );

        function slice_transform(s, t) = pts_translate3(
            pts_rotate3(
                slice_init(s, t),
                [0, trot(t), 0]
            ),
            [radius_ring, 0, 0]
        );

        strand_slices = [ for (t = [1 / fn_loop : 1 / fn_loop : 1])
            pts_rotate3(
                slice_transform(strand_base, t),
                [0, 0, t * 360]
            )
        ];

        pts_extrude(strand_slices);
    }

    strand(radius_twist, (gap + thickness) / 2);
    strand(radius_twist, - (gap + thickness) / 2);
}


module double_helix_bridges(
    radius_ring,
    radius_twist,
    thickness,
    gap,
    twists,
    steps
) {
    $fn = 16;

    module bridge() {
        cylinder(gap, r = thickness / 2, center = true);
    }

    for (t = [1 / steps : 1 / steps : 1]) {
        rotate([0, 0, t * 360])
        translate([radius_ring, 0, 0])
        rotate([0, twists * t * 360])
        translate([radius_twist, 0, 0])
            bridge();
    }
}
