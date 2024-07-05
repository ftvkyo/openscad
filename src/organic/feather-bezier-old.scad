DEBUG = false;


function clamp(a, b, c) = max(a, min(b, c));

function interp(a, b, f) = a * f + b * (1 - f);

function bezier(a, ac, b, bc, f) = interp(interp(a, ac, f), interp(bc, b, f), f);

function bezier_points(a, ac, b, bc, step) = [ for (s = [0 : step : 1]) bezier(a, ac, b, bc, s) ];

function normal(a, b) = let (t = b - a) [-t.y, t.x] / norm(t);

module polygon_debug(a, ac, b, bc) {
    STEP_DEBUG = 0.1;

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


module polygon_bezier(a, ac, b, bc, step) {
    points = bezier_points(a, ac, b, bc, step);
    polygon(points, convexity=4);
    polygon_debug(a, ac, b, bc);
}

// Draw a stroke with `a` and `b` being start and end points
// and `ac` and `bc` being their corresponding control points.
// `tf` is a thickness function that takes values from [0; 1] and returns
// the thickness of the curve at that point.
module stroke_bezier(a, ac, b, bc, step, tf) {
    _step = step ? step : 0.05;
    _tf = tf ? tf : function (_p) 1.0;

    points = bezier_points(a, ac, b, bc, _step);
    lp = len(points);

    points_outer = [ for (i = [1 : lp - 2]) points[i] + normal(points[i-1], points[i+1]) * _tf(i / lp) / 2 ];
    points_inner = [ for (i = [lp - 2: -1 : 1]) points[i] - normal(points[i-1], points[i+1]) * _tf(i / lp) / 2 ];

    normal_start = normal(points[0], points[1]) * _tf(0) / 2;
    normal_end = normal(points[len(points) - 2], points[len(points) - 1]) * _tf(1) / 2;

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

    %stroke_bezier(p0, p1, p2, p3, undef, thickness);
}


E_NOZZLE = 0.4;
E_LAYER = E_NOZZLE / 2;


module feather_stem(a, ac, b, bc) {
    thickness = function(p) clamp(E_NOZZLE * 2, p * E_NOZZLE * 12, E_NOZZLE * 10);
    stroke_bezier(a, ac, b, bc, tf = thickness);
}

module feather_barbs(a, ac, b, bc) {
    thickness = function(_p) E_NOZZLE * 2;

    function barb_len_inner(p) = (1 - abs(p - 0.5)) * (1 - p ^ 8);
    function barb_len_outer(p) = (1.2 - abs(p - 0.5)) * (1 - p ^ 10);

    connections = bezier_points(a, ac, b, bc, 0.01);
    start = len(connections) / 5;
    for (i = [start : len(connections) - 1]) {
        c = connections[len(connections) - 1 - i];

        mods1 = [
            [0, 0],
            [5, 0],
            [10, 20],
            [10, 10],
        ];

        mods1_scaled = [ for (mod = mods1) mod * barb_len_outer(i / len(connections)) ];

        a1 = c + mods1_scaled[0];
        a1c = c + mods1_scaled[1];
        b1 = c + mods1_scaled[2];
        b1c = c + mods1_scaled[3];

        stroke_bezier(a1, a1c, b1, b1c, 0.2, thickness);

        mods2 = [
            [0, 0],
            [5, 0],
            [10, -20],
            [10, -10],
        ];

        mods2_scaled = [ for (mod = mods2) mod * barb_len_inner(i / len(connections)) ];

        a2 = c + mods2_scaled[0];
        a2c = c + mods2_scaled[1];
        b2 = c + mods2_scaled[2];
        b2c = c + mods2_scaled[3];

        stroke_bezier(a2, a2c, b2, b2c, 0.2, thickness);
    }
}


module socket_plug() {
    module plug() {
        offset(1)
        offset(-1)
            square(5, center=true);
    }

    rotate(14) {
        translate([0, 0, - E_LAYER * 1.5])
        linear_extrude(height = E_LAYER * 11) {
            plug();
            translate([25, 0])
                plug();
        }

        translate([0, 0, E_LAYER * 6.5])
        linear_extrude(height = E_LAYER * 3) {
            translate([-2, 0])
            plug();
            translate([27, 0])
                plug();
        }
        }
}


module feather() {
    a = [0, 0];
    ac = [0, 0];
    b = [200, 0];
    bc = [175, 50];

    linear_extrude(E_LAYER * 3, center = true)
        feather_stem(a, ac, b, bc);
    linear_extrude(E_LAYER, center = true)
        feather_barbs(a, ac, b, bc);
}

module feather_for_hat() {
    feather();

    translate([10, 4, 0])
        cube([3, 60, E_LAYER * 3], center = true);
}

module feather_for_socket() {
    feather();
    socket_plug();
}


translate([0, 50])
test();


feather_for_socket();
