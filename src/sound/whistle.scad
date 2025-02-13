use <../../lib/ops.scad>

CUT = false;

// Length
L = 40;

// Width
W = 10;

// Wall thickness
wall = 1.5;

inlet = 1.5;

opening = 2;


module __hidden__() {};

resonator_x_f = 3/4;

wall_vec = [wall, wall, wall] * 2;

l = L - wall * 2;
w = W - wall * 2;

E = 0.01;
NOZ = 0.4;


module base() {
    rounden_xy(wall)
    cube([L, W, W] - wall_vec, center = true);
}

module resonator() {
    rounden_xy(wall / 2)
    translate([l * (1 - resonator_x_f) / 2, 0])
    cube([l * resonator_x_f, w, w] - wall_vec / 2, center = true);
}

module inlet() {
    h = 1.5;

    offset_x_base = l / 2 - l * resonator_x_f;

    translate([- L / 2 + offset_x_base + opening, w / 2 - inlet / 2, 0])
    cube([L, inlet, w], center = true);
}

module cutter() {
    cutter_a = 15;
    cutter_l = wall / sin(cutter_a);
    cutter_h = wall / cos(cutter_a);

    offset_x_base = l / 2 - l * resonator_x_f;

    translate([offset_x_base + opening, w / 2, 0]) {
        rotate([0, 0, cutter_a])
        translate([cutter_l / 2, cutter_h / 2, 0])
        cube([cutter_l, cutter_h, w], center = true);

        translate([-opening / 2, w / 4, 0])
        cube([opening, w / 2 + E, w], center = true);
    }
}

module hole() {
    translate([- l / 2, - w / 2, 0])
    cylinder(W + E, r = wall / 2, center = true, $fn = 24);
}

module whistle() {
    difference() {
        base();

        resonator();
        inlet();
        cutter();

        hole();
    }

    color("red")
    translate([0, 0, W / 2 - E])
    linear_extrude(NOZ) {
        size = 3;

        translate([0, 0.5, 0])
        text(str("L", L, " W", W, " w", wall),
            size = size,
            font = "JetBrains Mono:style=Bold",
            valign = "bottom",
            halign = "center"
        );

        translate([0, -0.5, 0])
        text(str("f", resonator_x_f, " i", inlet, " o", opening),
            size = size,
            font = "JetBrains Mono:style=Bold",
            valign = "top",
            halign = "center"
        );
    }
}


if (CUT) {
    projection(cut = true)
    whistle();
} else {
    whistle();
}
