f_circle = function(t) [cos(t * 360), sin(t * 360)];


f_hexagon_point = function(n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = n % 6)
    let (r = sqrt(3) / 2)
    n == 0 ? [1, 0] :
    n == 1 ? [1/2, r] :
    n == 2 ? [- 1/2, r] :
    n == 3 ? [-1 , 0] :
    n == 4 ? [- 1/2, - r] :
    n == 5 ? [1/2, - r] :
    undef;

f_hexagon = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 6),
        sector_t = t * 6 - sector,
        sector_point_a = f_hexagon_point(sector),
        sector_point_b = f_hexagon_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);


f_star6_point = function(n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = n % 12)
    let (r = sqrt(3) / 2)
    n == 0 ? [1, 0] :
    n == 1 ? [1/2, 1/2 * tan(30)] :
    n == 2 ? [1/2, r] :
    n == 3 ? [0, 1/2 * 1/cos(30)] :
    n == 4 ? [- 1/2, r] :
    n == 5 ? [- 1/2, 1/2 * tan(30)] :
    n == 6 ? [-1 , 0] :
    n == 7 ? [- 1/2, - 1/2 * tan(30)] :
    n == 8 ? [- 1/2, - r] :
    n == 9 ? [0, - 1/2 * 1/cos(30)] :
    n == 10 ? [1/2, - r] :
    n == 11 ? [1/2, - 1/2 * tan(30)] :
    undef;

f_star6 = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 12),
        sector_t = t * 12 - sector,
        sector_point_a = f_star6_point(sector),
        sector_point_b = f_star6_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);


f_star12_point = function(n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = (n + 1) % 24)
    let (d = 1 + tan(15))
    let (r_outer = 1)
    let (p_outer = function(a) [r_outer * cos(a), r_outer * sin(a)])
    let (r_inner = sqrt(pow(1 / d, 2) + pow(1 - 1 / d, 2)))
    let (p_inner = function(a) [r_inner * cos(a), r_inner * sin(a)])
    n == 0 ? p_outer(0) :
    n == 1 ? p_inner(15) :
    n == 2 ? p_outer(30) :
    n == 3 ? p_inner(45) :
    n == 4 ? p_outer(60) :
    n == 5 ? p_inner(75) :
    n == 6 ? p_outer(90) :
    n == 7 ? p_inner(105) :
    n == 8 ? p_outer(120) :
    n == 9 ? p_inner(135) :
    n == 10 ? p_outer(150) :
    n == 11 ? p_inner(165) :
    n == 12 ? p_outer(180) :
    n == 13 ? p_inner(195) :
    n == 14 ? p_outer(210) :
    n == 15 ? p_inner(225) :
    n == 16 ? p_outer(240) :
    n == 17 ? p_inner(255) :
    n == 18 ? p_outer(270) :
    n == 19 ? p_inner(285) :
    n == 20 ? p_outer(300) :
    n == 21 ? p_inner(315) :
    n == 22 ? p_outer(330) :
    n == 23 ? p_inner(345) :
    undef;

f_star12 = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 24),
        sector_t = t * 24 - sector,
        sector_point_a = f_star12_point(sector),
        sector_point_b = f_star12_point(sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);

f_star12_rot1 = function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 24),
        sector_t = t * 24 - sector,
        sector_point_a = f_star12_point(sector + 1),
        sector_point_b = f_star12_point(sector + 2)
    ) lerp(sector_point_a, sector_point_b, sector_t);
