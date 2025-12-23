use <../../lib/maths.scad>
use <../../lib/points.scad>
// use <../../lib/ease.scad>
use <../../lib/util.scad>

include <../../lib/points_shapes.scad>


/* [Parameters] */

// Module, mm
m = 2; // [1 : 0.5 : 5]

// Clearance, %
c = 15; // [5 : 5 : 30]

// Teeth, integer
z = 12; // [6 : 1 : 60]

// Pressure Angle, degrees
alpha_0 = 20; // [14.5, 17.5, 20, 25, 30]


module __hidden__() {}


/* ===================== *
 * Calculated Parameters *
 * ===================== */

// Standard Reference Pitch Diameter, mm
d_0 = m * z;

// Base Circle Diameter, mm
d_base = d_0 * cos(alpha_0);

// Circular Pitch, mm
p_0 = m * PI;

// Base Pitch, mm
p_base = p_0 * cos(alpha_0);

// Addendum, mm
h_add = m;

// Dedendum, mm
h_ded = m + m * (c / 100);

// Tip Diameter (addendum circle), mm
d_add = d_0 + h_add * 2;

// Root Diameter (dedendum circle), mm
d_ded = d_0 - h_ded * 2;

// Base Circle Circumference, mm
circ_base = d_base * PI;


/* ========= *
 * Functions *
 * ========= */

function fn_tooth_side_v(k) =
    let (
        rot = 360 * (k * p_base / circ_base),
        v_base = [sin(rot), cos(rot)] * d_base / 2,
        v_offset = [-cos(rot), sin(rot)] * k * p_base,
        v = v_base + v_offset,
        v_len2 = v.x * v.x + v.y * v.y
    )
    v_len2 <= (d_add * d_add / 4) ? v : undef;

function fn_tooth_side(acc = [], k = 0) =
    let (v = fn_tooth_side_v(k))
    is_undef(v)
    ? acc
    : fn_tooth_side(
        acc = [ for (l = [
            acc,
            [ v ],
        ]) each l ],
        k = k + 0.1
    );

// TODO: Need to calculate what angle to rotate the reflected left side of the tooth to produce the right side of the tooth.

function fn_tooth_side_other() =
    let (points = fn_tooth_side())
    [ for (i = [len(points) - 1 : -1 : 0])
        let (
            p0 = points[i],
            p1 = [-p0.x, p0.y]
            // p2 = [p1.x * cos]
        )
        undef
    ];

function fn_gear_sector() =
    [ for (l = [
        fn_tooth_side(),
        fn_tooth_side_other(),
    ]) each l ];

// fn_tooth_l = function(t) 0.1;
// fn_tip = function(t) 0.2;
// fn_tooth_r = function(t) 0.3;
// fn_groove = function(t) 0.4;

// fn_gear = function(t)
//     let (
//         sector = floor(t * z),
//         sector_t = t * z - sector,
//         sector_segment = floor(sector_t * 4),
//         sector_segment_t = sector_t * 4 - sector_segment
//     )
//     (sector_segment == 0) ? fn_tooth_l(sector_segment_t) :
//     (sector_segment == 1) ? fn_tip(sector_segment_t) :
//     (sector_segment == 2) ? fn_tooth_r(sector_segment_t) :
//     (sector_segment == 3) ? fn_groove(sector_segment_t) :
//     undef;


/* ======== *
 * Geometry *
 * ======== */

module gear() {
    points = fn_tooth_side();

    for (p = points) {
        if (p)
        translate(p)
        circle(0.1, $fn = 12);
    }
}

module debug() {
    color("#880000")
    %linear_extrude(2, center = true)
    circle(d_add / 2);

    color("#008800")
    %linear_extrude(4, center = true)
    circle(d_0 / 2);

    color("#008800")
    %linear_extrude(6, center = true)
    circle(d_base / 2);

    color("#000088")
    %linear_extrude(8, center = true)
    circle(d_ded / 2);

    color("#444444AA")
    %linear_extrude(10, center = true)
    gear();
}


debug();
