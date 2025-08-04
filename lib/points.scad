use <maths.scad>
use <util.scad>


/* ============================ *
 * Working with lists of points *
 * ============================ */


function pts_f(f, edges) =
    assert(is_function(f), "'f' is not a function")
    assert(is_num(edges) && edges > 2, "'edges' is not a number greater than 2")
    [ for (e = [1 : 1 : edges]) f(e / edges) ];


function pts_f_interp(f1, f2, t) =
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        s1 = pts_f(f1, $fn),
        s2 = pts_f(f2, $fn)
    )
    [ for (i = [0 : $fn - 1]) lerp(s1[i], s2[i], t) ];


function pts_f_interp_free(f1, f2, t) =
    let (
        s1 = pts_f(f1, $fn),
        s2 = pts_f(f2, $fn)
    )
    [ for (i = [0 : $fn - 1]) lerp_free(s1[i], s2[i], t) ];


function pts_circle(radius, edges) =
    assert(is_num(radius) && radius > 0, "'radius' is not a number greater than 0")
    assert(is_undef(edges) || (is_num(edges) && edges > 2) , "'edges' is not a number greater than 2")
    let(edges = is_num(edges) ? edges : clamp(12, radius, 360))
    [ for (a = [0 : 360 / edges : 359.99999]) [cos(a) * radius, sin(a) * radius] ];


function pts_translate2(flat, t) =
    assert(_assert_flat(flat))
    assert(_assert_vec2(t))
    [ for (point = flat) point + t ];


function pts_translate3(slice, t) =
    assert(_assert_slice(slice))
    assert(_assert_vec3(t))
    [ for (point = slice) point + t ];


function pts_scale2(slice, s) =
    assert(_assert_flat(slice))
    assert(_assert_vec2(s))
    [ for (p = slice) [p.x * s.x, p.y * s.y] ];


function pts_scale3(slice, s) =
    assert(_assert_slice(slice))
    assert(_assert_vec3(s))
    [ for (p = slice) [p.x * s.x, p.y * s.y, p.z * s.z] ];


function pts_rotate2(flat, r) =
    assert(_assert_flat(flat))
    assert(is_num(r))
    [ for (p = flat) [p.x * cos(r) - p.y * sin(r), p.x * sin(r) + p.y * cos(r)] ];


function pts_rotate3(s, r) =
    assert(_assert_slice(s))
    assert(_assert_vec3(r))
    [ for (p0 = s)
        let (
            // 1. rotate around Z
            p1 = [
                p0.x * cos(r.z) - p0.y * sin(r.z),
                p0.x * sin(r.z) + p0.y * cos(r.z),
                p0.z,
            ],
            // 2. rotate around Y
            p2 = [
                p1.x * cos(r.y) + p1.z * sin(r.y),
                p1.y,
              - p1.x * sin(r.y) + p1.z * cos(r.y),
            ],
            // 3. rotate around X
            p3 = [
                p2.x,
                p2.y * cos(r.x) - p2.z * sin(r.x),
                p2.y * sin(r.x) + p2.z * cos(r.x),
            ]
        ) p3
    ];


function pts_inflate(flat) =
    assert(_assert_flat(flat))
    [ for (point = flat) [point.x, point.y, 0] ];


module pts_extrude(slices, loop = true, quads = true) {
    /* Validate the data */

    // Check that 'slices' is a list of slices
    assert(is_list(slices) && len(slices) > 2, "'slices' is not a list of more than 2 slices");

    // Check that the first slice has enough points
    assert(is_list(slices[0]) && len(slices[0]) > 2, "'slices[0]' is not a slice of more than 2 points");

    _num_slices = len(slices);
    _num_points = len(slices[0]);

    // Check that all the slices have the same number of points
    for (slice = slices) {
        assert(is_list(slice) && len(slice) == _num_points, "a slice has a wrong number of points");
    }

    // Check that all slices contain points of right dimensionality
    for (slice = slices) {
        for (point = slice) {
            assert(is_list(point) && len(point) == 3, "a point is not a list of 3 elements");
            assert(is_num(point.x) && is_num(point.y) && is_num(point.z), "a point component is not a number");
        }
    }

    /* Generate inputs */

    // Collect all the points
    points = [ for (slice = slices) each slice ];

    // If not loop, don't connect the last slice with the zeroth
    _last_slice = loop ? _num_slices - 1 : _num_slices - 2;

    // Define all the faces
    faces = [ for (slice = [0 : _last_slice]) each [
        // For each slice, define rectangular faces that connect it to the next slice
        if (quads)
            for (i = [0 : _num_points - 1])[
                // Two points on the current slice
                (slice * _num_points) + i,
                (slice * _num_points) + (i + 1) % _num_points,
                    // Two points on the next slice (possibly zeroth)
                ((slice + 1) % _num_slices * _num_points) + (i + 1) % _num_points,
                ((slice + 1) % _num_slices * _num_points) + i,
            ]
        else
            for (i = [0 : _num_points - 1]) each [
                [
                    // Two points on the current slice
                    (slice * _num_points) + i,
                    (slice * _num_points) + (i + 1) % _num_points,
                    // One point on the next slice (possibly zeroth)
                    ((slice + 1) % _num_slices * _num_points) + (i + 1) % _num_points,
                ],
                [
                    // One point on the current slice
                    (slice * _num_points) + i,
                    // Two points on the next slice (possibly zeroth)
                    ((slice + 1) % _num_slices * _num_points) + (i + 1) % _num_points,
                    ((slice + 1) % _num_slices * _num_points) + i,
                ]
            ]
    ]];

    /* Render */

    if (loop) {
        polyhedron(points, faces, convexity = 10);
    } else {
        // Add closing faces

        face_end_1 = [ for (i = [1 : _num_points]) _num_points - i ];
        face_end_2 = [ for (i = [0 : _num_points - 1]) i + (_num_slices - 1) * _num_points];

        faces = [ for (fs = [[face_end_1], faces, [face_end_2]]) each fs];

        polyhedron(points, faces, convexity = 10);
    }
}
