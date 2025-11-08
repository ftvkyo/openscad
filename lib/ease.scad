// Credit: https://easings.net/

function ease_in_sine(t) = 1 - cos(t * 90);
function ease_out_sine(t) = sin(t * 90);
function ease_in_out_sine(t) = (cos(t * 180) - 1) / -2;

function ease_in_asine(t) = acos(1 - t) / 90;
function ease_out_asine(t) = asin(t) / 90;
function ease_in_out_asine(t) = acos(1 - t * 2) / 180;

function ease_in_quadratic(t) = t * t;
function ease_out_quadratic(t) = 1 - pow(1 - t, 2);
function ease_in_out_quadratic(t) =
    t < 0.5
    ? 2 * t * t
    : 1 - pow(-2 * t + 2, 2) / 2;

function ease_in_cubic(t) = t * t * t;
function ease_out_cubic(t) = 1 - pow(1 - t, 3);
function ease_in_out_cubic(t) =
    t < 0.5
    ? 4 * t * t * t
    : 1 - pow(-2 * t + 2, 3) / 2;

function ease_in_pow(n) = function(t) pow(t, n);
function ease_out_pow(n) = function(t) 1 - pow(1 - t, n);

function ease_in_elastic(t) =
    let (c4 = 360 / 3)
    t == 0 ? 0 :
    t == 1 ? 1 :
    - pow(2, 10 * t - 10) * sin((t * 10 - 10.75) * c4);

function ease_out_elastic(t) =
    let (c4 = 360 / 3)
    t == 0 ? 0 :
    t == 1 ? 1 :
    pow(2, -10 * t) * sin((t * 10 - 0.75) * c4) + 1;

function ease_in_out_elastic(t) =
    let (c5 = 360 / 4.5)
    t == 0 ? 0 :
    t == 1 ? 1 :
    t < 0.5
    ? - pow(2, 20 * t - 10) * sin((20 * t - 11.125) * c5) / 2
    : pow(2, -20 * t + 10) * sin((20 * t - 11.125) * c5) / 2 + 1;

function ease_out_bounce(t) =
    let (
        n1 = 7.5625,
        d1 = 2.75,
        t1 = t - 1.5 / d1,
        t2 = t - 2.25 / d1,
        t3 = t - 2.625 / d1
    )
    t < (1 / d1) ? n1 * t * t :
    t < (2 / d1) ? n1 * t1 * t1 + 0.75 :
    t < (2.5 / d1) ? n1 * t2 * t2 + 0.9375 :
    n1 * t3 * t3 + 0.984375;

function ease_in_bounce(t) =
    1 - ease_out_bounce(1 - t);

function ease_in_out_bounce(t) =
    t < 0.5
    ? (1 - ease_out_bounce(1 - 2 * t)) / 2
    : (1 + ease_out_bounce(2 * t - 1)) / 2;
