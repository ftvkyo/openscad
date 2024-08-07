use <../../lib/maths.scad>
use <../../lib/debug.scad>

// Width of the nozzle
NOZZLE = 0.4;

// Hacklab Voron bed dimensions
voron = [296, 290];

// Length of the feather
stem = norm(voron) - 15;

// How many layers for the stem
stem_layers = 6;

// How much of the feather is covered in barbs
coverage = 0.8;

// Bezier curve steps for the barbs
barb_steps = 125;

// How many layers for the barbs
barb_layers = 3;

// Text to put on the stem
flavour_text = "ftvkyo.me";


/* [Hidden] */

E = 0.01;
N = NOZZLE;
L = NOZZLE / 2;


// Bend angle of the stem at the start
a_sl = 15;

// Bend angle of the stem at the end
a_sr = 10;

// Bend strength of the stem at the start
s_sl = 75;

// Bend strength of the stem at the end
s_sr = 75;


/* ==== *
 * Stem *
 * ==== */

// Control points for the stem
c_stem = [
    [0, 0],
    [cos(a_sl), sin(a_sl)] * s_sl,
    [stem, 0] + [- cos(a_sr), sin(a_sr)] * s_sr,
    [stem, 0],
];

ft_stem = function(t) clamp(NOZZLE * 2, (1 - t) * NOZZLE * 16, NOZZLE * 14);


module feather_stem() {
    stroke_bezier3(c_stem[0], c_stem[1], c_stem[2], c_stem[3], 20, ft_stem);
}


/* ===== *
 * Barbs *
 * ===== */

ft_barb = function(_t) NOZZLE * 2;

module feather_barbs(c0, c1, c2, c3, ft) {
    echo(c0, c1, c2, c3);

    for (t = [1 - coverage : 1 / barb_steps : 0.999]) {
        b0 = _bezier3(c0, t);
        b1 = _bezier3(c1, t);
        b2 = _bezier3(c2, t);
        b3 = _bezier3(c3, t);

        l = norm(b3 - b0);

        // debug_point(b0);
        // debug_point(b1, "red");
        // debug_point(b2, "green");
        // debug_point(b3, "blue");

        if (l > N * 2) {
            stroke_bezier3(b0, b1, b2, b3, min(10, l / N), ft);
        }
    }
}


/* ========= *
 * Top barbs *
 * ========= */

a_tl = a_sl + 35;
a_tr = a_sr + 35;

s_tl = s_sl * 1.5;
s_tr = s_sr * 0.9;

// Control points for the edge of top barbs
c_t = [
    c_stem[0],
    [cos(a_tl), sin(a_tl)] * s_tl,
    [stem, 0] + [- cos(a_tr), sin(a_tr)] * s_tr,
    c_stem[3],
];

a_ttl = a_sl + 25;
a_ttr = a_sr + 25;

s_ttl = s_sl * 1.1;
s_ttr = s_sr * 1.0;

// Control points for the top bend of top barbs
c_tt = [
    c_stem[0],
    [cos(a_ttl), sin(a_ttl)] * s_ttl,
    [stem, 0] + [- cos(a_ttr), sin(a_ttr)] * s_ttr,
    c_stem[3],
];

a_tbl = a_sl + 10;
a_tbr = a_sr + 10;

s_tbl = s_sl * 1.2;
s_tbr = s_sr * 0.9;

// Control points for the bottom bend of top barbs
c_tb = [
    c_stem[0],
    [cos(a_tbl), sin(a_tbl)] * s_tbl,
    [stem, 0] + [- cos(a_tbr), sin(a_tbr)] * s_tbr,
    c_stem[3],
];

module feather_barbs_top() {
    feather_barbs(c_stem, c_tb, c_tt, c_t, ft_barb);
}


/* ============ *
 * Bottom barbs *
 * ============ */

a_bl = a_sl - 35;
a_br = a_sr - 20;

s_bl = s_sl * 1.3;
s_br = s_sr * 0.8;

// Control points for the edge of bottom barbs
c_b = [
    c_stem[0],
    [cos(a_bl), sin(a_bl)] * s_bl,
    [stem, 0] + [- cos(a_br), sin(a_br)] * s_br,
    c_stem[3],
];

a_bbl = a_sl - 20;
a_bbr = a_sr - 5;

s_bbl = s_sl * 1.1;
s_bbr = s_sr * 1.0;

// Control points for the bottom bend of bottom barbs
c_bb = [
    c_stem[0],
    [cos(a_bbl), sin(a_bbl)] * s_bbl,
    [stem, 0] + [- cos(a_bbr), sin(a_bbr)] * s_bbr,
    c_stem[3],
];

a_btl = a_sl - 10;
a_btr = a_sr - 10;

s_btl = s_sl * 1.2;
s_btr = s_sr * 0.9;

// Control points for the top bend of bottom barbs
c_bt = [
    c_stem[0],
    [cos(a_btl), sin(a_btl)] * s_btl,
    [stem, 0] + [- cos(a_btr), sin(a_btr)] * s_btr,
    c_stem[3],
];

module feather_barbs_bottom() {
    feather_barbs(c_stem, c_bt, c_bb, c_b, ft_barb);
}


module feather_attachment() {
    $fn = 12;

    c1 = _bezier3(c_stem, 0.02);
    c2 = _bezier3(c_stem, 0.14);

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
        feather_barbs_top();
        feather_barbs_bottom();
    }

    color("black")
    translate([8, 0.2, E])
    rotate(10)
    linear_extrude(L * (stem_layers + 1))
        feather_flavour();
}

feather();
