DEBUG = true;

STEP = 0.05;
STEP_DEBUG = 0.1;


function clamp(a, b, c) = max(a, min(b, c));

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

// Draw a stroke with `a` and `b` being start and end points
// and `ac` and `bc` being their corresponding control points.
// `tf` is a thickness function that takes values from [0; 1] and returns
// the thickness of the curve at that point.
module stroke_bezier(a, ac, b, bc, tf) {
    tff = tf ? tf : function (_p) 1.0;

    points = bezier_points(a, ac, b, bc);
    lp = len(points);

    points_outer = [ for (i = [1 : lp - 2]) points[i] + normal(points[i-1], points[i+1]) * tff(i / lp) / 2 ];
    points_inner = [ for (i = [lp - 2: -1 : 1]) points[i] - normal(points[i-1], points[i+1]) * tff(i / lp) / 2 ];

    normal_start = normal(points[0], points[1]) * tff(0) / 2;
    normal_end = normal(points[len(points) - 2], points[len(points) - 1]) * tff(1) / 2;

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


module test() {
    p0 = [0, 0];
    p1 = [20, 0];
    p2 = [0, 10];
    p3 = [10, 20];

    thickness = function(p) p * 2 + 0.5;

    %stroke_bezier(p0, p1, p2, p3, thickness);
}


translate([0, 50])
test();


E_NOZZLE = 0.4;
E_LAYER = E_NOZZLE / 2;


module feather() {
    a = [0, 0];
    ac = [0, 0];
    b = [150, 0];
    bc = [125, 25];

    thickness = function(p) clamp(E_NOZZLE * 2, p * E_NOZZLE * 8, E_NOZZLE * 4);

    stroke_bezier(a, ac, b, bc, thickness);
}

feather();
