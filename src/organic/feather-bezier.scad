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

// How many layers for the stem
stem_layers = 6;

// How much of the feather is covered in barbs
coverage = 0.8;

// Bezier curve step for the barbs
barb_step = 0.008;

// How many layers for the barbs
barb_layers = 3;

// Text to put on the stem
flavour_text = "ftvkyo.me";


/* [Hidden] */

E = 0.01;
N = NOZZLE;
L = NOZZLE / 2;

ft_stem = function(t) clamp(NOZZLE * 2, (1 - t) * NOZZLE * 16, NOZZLE * 14);
ft_barb = function(_t) NOZZLE * 2;

p0 = [0, 0];
p1 = p0 + [cos(stem_bend1_a), sin(stem_bend1_a)] * stem_bend1_s;

p3 = [stem, 0];
p2 = p3 + [- cos(stem_bend2_a), sin(stem_bend2_a)] * stem_bend2_s;


/* Modules */

module feather_stem() {
    stroke_bezier_4(p0, p1, p2, p3, 0.05, ft_stem);
}


module feather_barbs_side(a1, s1, a2, s2) {
    // Control points for barb p3 (b3)

    b3_start_a = stem_bend1_a + a1;
    b3_start_s = stem_bend1_s + s1;

    b3_end_a = stem_bend2_a + a2;
    b3_end_s = stem_bend2_s + s2;

    b3_p1 = p0 + [cos(b3_start_a), sin(b3_start_a)] * b3_start_s;
    b3_p2 = p3 + [- cos(b3_end_a), sin(b3_end_a)] * b3_end_s;

    // Control points for barb p2 (b2)

    b2_start_a = stem_bend1_a + a1 * 0.75;
    b2_start_s = stem_bend1_s + s1 * 0.6;

    b2_end_a = stem_bend2_a + a2 * 0.75;
    b2_end_s = stem_bend2_s + s2 * 0.8;

    b2_p1 = p0 + [cos(b2_start_a), sin(b2_start_a)] * b2_start_s;
    b2_p2 = p3 + [- cos(b2_end_a), sin(b2_end_a)] * b2_end_s;

    // Control points for barb p1 (b1)

    b1_start_a = stem_bend1_a * 1.2;
    b1_start_s = stem_bend1_s + s1 * 0.5;

    b1_end_a = stem_bend2_a * 1.2;
    b1_end_s = stem_bend2_s + s2 * 0.5;

    b1_p1 = p0 + [cos(b1_start_a), sin(b1_start_a)] * b1_start_s;
    b1_p2 = p3 + [- cos(b1_end_a), sin(b1_end_a)] * b1_end_s;

    // Render

    for (s = [1 - coverage : barb_step : 0.999]) {
        b0 = bezier_4_single(p0, p1, p2, p3, s);
        b1 = bezier_4_single(p0, b1_p1, b1_p2, p3, s);
        b2 = bezier_4_single(p0, b2_p1, b2_p2, p3, s);
        b3 = bezier_4_single(p0, b3_p1, b3_p2, p3, s);

        l = norm(b3 - b0);

        if (l > N * 2) {
            stroke_bezier_4(b0, b1, b2, b3, max(0.1, N / l), ft_barb);
        }
    }
}


module feather_attachment() {
    $fn = 12;

    p0 = [0, 0];
    p1 = p0 + [cos(stem_bend1_a), sin(stem_bend1_a)] * stem_bend1_s;

    p3 = [stem, 0];
    p2 = p3 + [- cos(stem_bend2_a), sin(stem_bend2_a)] * stem_bend2_s;

    c1 = bezier_4_single(p0, p1, p2, p3, 0.02);
    c2 = bezier_4_single(p0, p1, p2, p3, 0.16);

    translate(c1)
        circle(r = 1);
    translate(c2)
        circle(r = 1);
}


module feather_flavour() {
    url = "ftvkyo.me";
    font = "JetBrains Mono:style=Bold";

    text(url, font = font, size = 4);
}


module feather() {
    linear_extrude(L * stem_layers)
    difference() {
        offset(N / 2)
        offset(- N / 2)
        feather_stem();
        feather_attachment();
    }

    color("green")
    translate([0, 0, E])
    linear_extrude(L * barb_layers) {
        feather_barbs_side(20, 50, 30, -10);
        feather_barbs_side(-30, 40, -10, -10);
    }

    color("black")
    translate([8, 0.2, E])
    rotate(11)
    linear_extrude(L * (stem_layers + 1))
        feather_flavour();
}

feather();
