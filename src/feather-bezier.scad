DEBUG = true;

STEP = 0.05;
STEP_DEBUG = 0.1;

function interp(a, b, f) = a * f + b * (1 - f);

function bezier(a, ac, b, bc, f) = interp(interp(a, ac, f), interp(bc, b, f), f);

function bezier_points(a, ac, b, bc) = [ for (s = [0 : STEP : 1]) bezier(a, ac, b, bc, s) ];

function normal(a, b) = let (t = b - a) [-t.y, t.x] / norm(t);

module polygon_debug(a, ac, b, bc) {
    if (DEBUG) {
        %color("red")
            translate(a)
            sphere(0.5);
        %color("green")
            translate(ac)
            sphere(0.5);
        %color("grey")
            for (s = [0 : STEP_DEBUG : 1])
            translate(interp(a, ac, s))
                sphere(0.25);

        %color("red")
            translate(b)
            sphere(0.5);
        %color("green")
            translate(bc)
            sphere(0.5);
        %color("grey")
            for (s = [0 : STEP_DEBUG : 1])
            translate(interp(b, bc, s))
                sphere(0.25);
    }
}


module polygon_bezier(a, ac, b, bc) {
    points = bezier_points(a, ac, b, bc);
    polygon(points, convexity=4);
    polygon_debug(a, ac, b, bc);
}

module stroke_bezier(a, ac, b, bc) {
    points = bezier_points(a, ac, b, bc);

    points_outer = [ for (i = [1 : len(points) - 2]) points[i] + normal(points[i-1], points[i+1]) ];
    points_inner = [ for (i = [len(points) - 2: -1 : 1]) points[i] - normal(points[i-1], points[i+1]) ];

    normal_start = normal(points[0], points[1]);
    normal_end = normal(points[len(points) - 2], points[len(points) - 1]);

    points_polygon = [ for (l = [
        [points[0] + normal_start],
        points_outer,
        [points[len(points) - 1] + normal_end],
        [points[len(points) - 1] - normal_end],
        points_inner,
        [points[0] - normal_start],
    ]) each l ];

    polygon(points_polygon);
    polygon_debug(a, ac, b, bc);
}


p0 = [0, 0];
p1 = [20, 0];
p2 = [0, 10];
p3 = [10, 20];

stroke_bezier(p0, p1, p2, p3);
