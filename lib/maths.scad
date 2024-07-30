/**
    Clamp `t` between `v_min` and `v_max`.
*/
function clamp(v_min, t, v_max) = max(v_min, min(t, v_max));


/**
    Calculate a normal for a line defined by two points.
*/
function normal(a, b) = let (t = b - a) [-t.y, t.x] / norm(t);


/* ================================= *
 * Calculations of individual points *
 * ================================= */


/**
    Performs linear interpolation between values `v0` and `v1`.

    Parameter `t` determines the weights of `v0` and `v1`.
    Its valid values are in the interval [0, 1].
*/
function lerp(v0, v1, t) = assert(t >= 0 && t <= 1) (1 - t) * v0 + t * v1;

_b2 = function (pts, t) lerp(lerp(pts[0], pts[1], t), lerp(pts[1], pts[2], t), t);

/**
    Calculates a single point for a quadratic Bézier curve.
    It has 3 control points.

    Parameter `t` determines the extent from the start of the curve.
    Its valid values are in the interval [0, 1].
*/
function _bezier2(pts, t) = _b2(pts, t);

_b3 = function (pts, t) lerp(_b2([pts[0], pts[1], pts[2]], t), _b2([pts[1], pts[2], pts[3]], t), t);

/**
    Calculates a single point for a cubic Bézier curve.
    It has 4 control points.

    Parameter `t` determines the extent from the start of the curve.
    Its valid values are in the interval [0, 1].
*/
function _bezier3(pts, t) = _b3(pts, t);

_b3_tangent = function (pts, t) let (ot = 1 - t) 3 * ot * ot * (pts[1] - pts[0]) + 6 * ot * t * (pts[2] - pts[1]) + 3 * t * t * (pts[3] - pts[2]);

/**
    Calculates a single tangent to a 2-dimensional cubic Bézier curve.

    Arguments like for `_bezier3`.
 */
function _bezier3_tangent(pts, t) = _b3_tangent(pts, t);

_b3_normal = function (pts, t) let (tangent = _b3_tangent(pts, t)) [- tangent.y, tangent.x] / norm(tangent);

/**
    Calculates a single normal to a 2-dimensional cubic Bézier curve.

    Arguments like for `_bezier3`.
 */
function _bezier3_normal(pts, t) = _b3_normal(pts, t);


/* ============================ *
 * Calculations of point arrays *
 * ============================ */


/**
 *  Generate an array of values of `f(arg, t)` where `t` is from `[0, 1]` subdivided into `steps` steps.
 */
function _step_through(f, arg, steps) = assert(steps > 1, "`steps` should be larger than 1") [ for (t = [0 : 1 / steps : 1]) f(arg, t) ];

/**
    Calculates points for a quadratic Bézier curve.
    It has 3 control points.

    Parameter `steps` determines how many steps the curve is subdivided into.
*/
function bezier2(pts, steps) = _step_through(_b2, pts, steps);

/**
    Calculates points for a cubic Bézier curve.
    It has 4 control points.

    Parameter `steps` determines how many steps the curve is subdivided into.
*/
function bezier3(pts, steps) = _step_through(_b3, pts, steps);

function bezier3_tangents(pts, steps) = _step_through(_b3_tangent, pts, steps);

function bezier3_normals(pts, steps) = _step_through(_b3_normal, pts, steps);


/* ======= *
 * Drawing *
 * ======= */


module stroke_line(p0, p1, thickness) {
    assert(is_list(p0) && len(p0) == 2);
    assert(is_list(p1) && len(p1) == 2);
    assert(is_num(thickness), "thickness must be a number");

    n = normal(p0, p1) * thickness / 2;

    points = [
        p0 + n,
        p1 + n,
        p1 - n,
        p0 - n,
    ];

    polygon(points);
}

module stroke_bezier3(p0, p1, p2, p3, steps, f_thickness) {
    assert(is_list(p0) && len(p0) == 2);
    assert(is_list(p1) && len(p1) == 2);
    assert(is_list(p2) && len(p2) == 2);
    assert(is_list(p3) && len(p3) == 2);
    assert(is_num(steps) && steps > 1, "steps must be a number larger than 1");
    assert(is_function(f_thickness), "f_thickness must be a function");

    pts = [p0, p1, p2, p3];

    points = bezier3(pts, steps);
    normals = bezier3_normals(pts, steps);

    points_outer = [ for (i = [0 : steps]) points[i] + normals[i] * f_thickness(i / steps) / 2 ];
    points_inner = [ for (i = [steps : -1 : 0]) points[i] - normals[i] * f_thickness(i / steps) / 2 ];

    points_polygon = [ for (l = [
        points_outer,
        points_inner,
    ]) each l ];

    polygon(points_polygon);
}
