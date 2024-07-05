/**
    Clamp `t` between `v_min` and `v_max`.
*/
function clamp(v_min, t, v_max) = max(v_min, min(t, v_max));

/**
    Performs linear interpolation between values `v0` and `v1`.

    Parameter `t` determines the weights of `v0` and `v1`.
    Its valid values are in the interval [0, 1].
*/
function lerp(v0, v1, t) = (1 - t) * v0 + t * v1;

/**
    Calculates a single point for a quadratic Bézier curve.
    It has 3 control points.

    Parameter `t` determines the extent from the start of the curve.
    Its valid values are in the interval [0, 1].
*/
function bezier_3_single(p0, p1, p2, t) = lerp(lerp(p0, p1, t), lerp(p1, p2, t), t);

/**
    Calculates points for a quadratic Bézier curve.
    It has 3 control points.

    Parameter `steps` determines how many steps the curve is subdivided into.
*/
function bezier_3(p0, p1, p2, step) = [ for (s = [0 : step : 1]) bezier_3_single(p0, p1, p2, s) ];

/**
    Calculates a single point for a cubic Bézier curve.
    It has 4 control points.

    Parameter `t` determines the extent from the start of the curve.
    Its valid values are in the interval [0, 1].
*/
function bezier_4_single(p0, p1, p2, p3, t) = lerp(bezier_3_single(p0, p1, p2, t), bezier_3_single(p1, p2, p3, t), t);

/**
    Calculates points for a cubic Bézier curve.
    It has 4 control points.

    Parameter `steps` determines how many steps the curve is subdivided into.
*/
function bezier_4(p0, p1, p2, p3, step) = [ for (s = [0 : step : 1]) bezier_4_single(p0, p1, p2, p3, s) ];

/**
    Calculate a normal for a line defined by two points.
*/
function normal(a, b) = let (t = b - a) [-t.y, t.x] / norm(t);

module stroke_bezier_4(p0, p1, p2, p3, step, f_thickness) {
    assert(is_list(p0) && len(p0) == 2);
    assert(is_list(p1) && len(p1) == 2);
    assert(is_list(p2) && len(p2) == 2);
    assert(is_list(p3) && len(p3) == 2);
    assert(is_num(step), "step must be a number");
    assert(0 < step && step < 1, "step must be in the (0, 1) range");
    assert(is_function(f_thickness), "f_thickness must be a function");

    points = bezier_4(p0, p1, p2, p3, step);
    lp = len(points);

    points_outer = [ for (i = [1 : lp - 2]) points[i] + normal(points[i-1], points[i+1]) * f_thickness(i / lp) / 2 ];
    points_inner = [ for (i = [lp - 2: -1 : 1]) points[i] - normal(points[i-1], points[i+1]) * f_thickness(i / lp) / 2 ];

    normal_start = normal(points[0], points[1]) * f_thickness(0) / 2;
    normal_end = normal(points[len(points) - 2], points[len(points) - 1]) * f_thickness(1) / 2;

    points_polygon = [ for (l = [
        [points[0] + normal_start],
        points_outer,
        [points[len(points) - 1] + normal_end],
        [points[len(points) - 1] - normal_end],
        points_inner,
        [points[0] - normal_start],
    ]) each l ];

    polygon(points_polygon);
}
