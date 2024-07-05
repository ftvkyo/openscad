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
