use <../../lib/maths.scad>
use <../../lib/debug.scad>

NOZZLE = 0.4;
LAYER = NOZZLE / 2;

module feather_stem(p0, p1, p2, p3) {
    ft = function(t) clamp(NOZZLE * 2, (1 - t) * NOZZLE * 14, NOZZLE * 12);

    stroke_bezier_4(p0, p1, p2, p3, 0.05, ft);
}

module feather_barbs(p0, p1, p2, p3) {
    tf = function(_t) NOZZLE * 2;

    function barb_len_inner(t) = (1 - abs(t - 0.5)) * (1 - t ^ 8);
    function barb_len_outer(t) = (1.2 - abs(t - 0.5)) * (1 - t ^ 10);

    connections = bezier_4(p0, p1, p2, p3, 0.01);
    start = len(connections) / 5;

    for (i = [start : len(connections) - 1]) {
        c = connections[i];

        mods1 = [
            [0, 0],
            [5, 10],
            [6, 15],
            [10, 20],
        ];

        mods1_scaled = [ for (mod = mods1) mod * barb_len_outer(i / len(connections)) ];

        a1 = c + mods1_scaled[0];
        a1c = c + mods1_scaled[1];
        b1 = c + mods1_scaled[2];
        b1c = c + mods1_scaled[3];

        stroke_bezier_4(a1, a1c, b1, b1c, 0.2, tf);
    }

    for (i = [start : len(connections) - 1]) {
        c = connections[i];

        mods2 = [
            [0, 0],
            [5, -10],
            [6, -15],
            [10, -20],
        ];

        mods2_scaled = [ for (mod = mods2) mod * barb_len_inner(i / len(connections)) ];

        a2 = c + mods2_scaled[0];
        a2c = c + mods2_scaled[1];
        b2 = c + mods2_scaled[2];
        b2c = c + mods2_scaled[3];

        stroke_bezier_4(a2, a2c, b2, b2c, 0.2, tf);
    }
}

module attachment() {
    $fn = 6;

    translate([12.5, 0])
        cylinder(10, r = 1, center = true);
    translate([-12.5, 0])
        cylinder(10, r = 1, center = true);
}

module website() {
    url = "ftvkyo.me";
    font = "JetBrains Mono:style=Bold";

    text(url, font = font, size = 3);
}

module feather() {
    p0 = [0, 0];
    p1 = [75, 15];
    p2 = [125, 10];
    p3 = [200, 0];

    difference() {
        linear_extrude(LAYER * 5)
            feather_stem(p0, p1, p2, p3);

        #translate([15, 2.65])
            rotate(9.75)
            attachment();
    }

    color("green")
        linear_extrude(LAYER * 2)
        feather_barbs(p0, p1, p2, p3);

    color("black")
        translate([4.5, -0.5])
        rotate(10.5)
        linear_extrude(LAYER * 6)
        website();
}


feather();
