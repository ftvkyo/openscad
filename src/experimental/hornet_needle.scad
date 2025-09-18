use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/ease.scad>
use <../../lib/util.scad>


tip_length = 90;
tip_width = 10;
tip_thickness = 6;

hilt_length = 10;

handle_thickness = 3.5;
handle_length = 40;

ring_thickness = 2.5;
ring_radius = 4;


$fn = $preview ? 48 : 120;

f_circle = function(r = 1) function(t) [cos(t * 360), sin(t * 360)] * r;

f_diamond_point = function(xf, yf, n)
    assert(is_num(n) && n >= 0, "'n' is not a number greater than 0")
    let (n = n % 4)
    n == 0 ? [xf, 0] :
    n == 1 ? [0, yf] :
    n == 2 ? [-xf, 0] :
    n == 3 ? [0, -yf] :
    undef;

f_diamond = function (xf = 1, yf = 1) function(t)
    assert(is_num(t) && 0 <= t && t <= 1, "'t' is not a number between 0 and 1")
    let (
        sector = floor(t * 4),
        sector_t = t * 4 - sector,
        sector_point_a = f_diamond_point(xf, yf, sector),
        sector_point_b = f_diamond_point(xf, yf, sector + 1)
    ) lerp(sector_point_a, sector_point_b, sector_t);


module tip() {
    translate([0, 0, hilt_length])
    scale([tip_width / 2, tip_thickness / 2, tip_length])
    rotate_extrude($fn = 4)
    polygon([
        [1, 0],
        [0, 1],
        [0, 0],
    ]);
}

module hilt() {
    f_slice = function(t, ease_interp)
        pts_translate3(
            pts_inflate(
                pts_f_interp(
                    f_circle(handle_thickness / 2),
                    f_diamond(tip_width / 2, tip_thickness / 2),
                    ease_interp(t)
                )
            ),
            [0, 0, hilt_length * t]
        );

    f_slice_eased = function(t) f_slice(t, function(t) ease_in_sine(t));

    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f_slice_eased(t) ], loop = false);
}

module handle() {
    mirror([0, 0, 1])
    cylinder(h = handle_length, r = handle_thickness / 2);
}

module ring() {
    translate([0, 0, - handle_length - ring_radius - ring_thickness])
    rotate([90, 0, 0])
    rotate_extrude()
    translate([ring_radius, 0])
    circle(ring_thickness / 2);
}

module ring_transition() {
    f_slice = function(t, ease_interp)
        pts_translate3(
            pts_inflate(
                pts_f_interp(
                    f_circle(handle_thickness / 2),
                    f_circle(ring_thickness / 2),
                    ease_interp(t)
                )
            ),
            [0, 0, ring_thickness * t]
        );

    f_slice_eased = function(t) f_slice(t, function(t) ease_in_out_sine(t));

    translate([0, 0, - handle_length])
    mirror([0, 0, 1])
    pts_extrude([ for (t = [0 : 1 / $fn : 1]) f_slice_eased(t) ], loop = false);
}

module assembly() {
    tip();
    hilt();
    handle();
    ring();
    ring_transition();
}

assembly();
