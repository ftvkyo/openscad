use <../../lib/maths.scad>
use <../../lib/debug.scad>

// Width of the nozzle
NOZZLE = 0.4;

// Length of the feather
stem = 300;

// Bend angle of the stem at the start
stem_bend1_a = 15;

// Bend strength of the stem at the start
stem_bend1_s = 75;

// Bend angle of the stem at the end
stem_bend2_a = 10;

// Bend strength of the stem at the end
stem_bend2_s = 75;

// How much of the feather is covered in barbs
coverage = 0.8;

barb_step = 0.01;

// Text to put on the stem
flavour_text = "ftvkyo.me";


/* [Hidden] */

N = NOZZLE;
L = NOZZLE / 2;

ft_stem = function(t) clamp(NOZZLE * 2, (1 - t) * NOZZLE * 14, NOZZLE * 12);
ft_barb = function(_t) NOZZLE * 2;

p0 = [0, 0];
p1 = p0 + [cos(stem_bend1_a), sin(stem_bend1_a)] * stem_bend1_s;

p3 = [stem, 0];
p2 = p3 + [- cos(stem_bend2_a), sin(stem_bend2_a)] * stem_bend2_s;


/* Modules */

module feather_stem() {
    stroke_bezier_4(p0, p1, p2, p3, 0.05, ft_stem);
}


module feather_barbs() {
    outer1_a = stem_bend1_a + 20;
    outer1_s = stem_bend1_s + 50;

    outer2_a = stem_bend2_a + 30;
    outer2_s = stem_bend2_s - 10;

    outer_p1 = p0 + [cos(outer1_a), sin(outer1_a)] * outer1_s;
    outer_p2 = p3 + [- cos(outer2_a), sin(outer2_a)] * outer2_s;

    inner1_a = stem_bend1_a - 30;
    inner1_s = stem_bend1_s + 40;

    inner2_a = stem_bend2_a - 10;
    inner2_s = stem_bend2_s - 10;

    inner_p1 = p0 + [cos(inner1_a), sin(inner1_a)] * inner1_s;
    inner_p2 = p3 + [- cos(inner2_a), sin(inner2_a)] * inner2_s;

    for (s = [1 - coverage : barb_step : 1]) {
        outer = bezier_4_single(p0, outer_p1, outer_p2, p3, s);
        center = bezier_4_single(p0, p1, p2, p3, s);
        inner = bezier_4_single(p0, inner_p1, inner_p2, p3, s);

        stroke_line(center, outer, N * 2);
        stroke_line(center, inner, N * 2);
    }
}


module feather_attachment() {
    $fn = 12;

    p0 = [0, 0];
    p1 = p0 + [cos(stem_bend1_a), sin(stem_bend1_a)] * stem_bend1_s;

    p3 = [stem, 0];
    p2 = p3 + [- cos(stem_bend2_a), sin(stem_bend2_a)] * stem_bend2_s;

    c1 = bezier_4_single(p0, p1, p2, p3, 0.02);
    c2 = bezier_4_single(p0, p1, p2, p3, 0.12);

    translate(c1)
        circle(r = 1);
    translate(c2)
        circle(r = 1);
}


module feather_flavour() {
    url = "ftvkyo.me";
    font = "JetBrains Mono:style=Bold";

    text(url, font = font, size = 3);
}


module feather() {
    linear_extrude(L * 5)
    difference() {
        feather_stem();
        feather_attachment();
    }

    color("green")
        linear_extrude(L * 2)
        feather_barbs();

    color("black")
        translate([6, 0])
        rotate(11.5)
        linear_extrude(L * 6)
        feather_flavour();
}

feather();
