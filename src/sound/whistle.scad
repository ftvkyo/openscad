use <../../lib/ops.scad>

CUT = false;

/* [General] */

// Length of the tip that touches the mouth
tip_len = 20;

// Side of the whistle
side = 10;

// Wall thickness
wall = 1.5;

// Size of the air inlet
inlet = 1.5;

// Size of the air outlet in front of the cutting edge
outlet = 2;

/* [Resonator] */

// Length of the resonator
resonator_len = 40;

// Whether the end is open
open = false;


module __hidden__() {};

wall_vec = [wall, wall, wall] * 2;

L = resonator_len + tip_len + wall;

E = 0.01;
NOZ = 0.4;


module base() {
    reduction = open ? wall : 0;

    translate([- (tip_len - wall) / 2 - reduction / 2 - E, 0, 0])
    rounden_xy(wall)
    cube([L - reduction, side, side] - wall_vec, center = true);
}

module resonator() {
    extension = open ? wall : 0;

    translate([extension / 2, 0, 0])
    rounden_xy(wall / 2)
    cube([resonator_len + extension, side - wall * 2, side - wall * 2] - wall_vec / 2, center = true);
}

module inlet() {
    translate([- L / 2, side / 2 - inlet / 2 - wall, 0])
    cube([L, inlet, side - wall * 2], center = true);
}

module outlet() {
    cutter_a = 15;
    cutter_l = wall / sin(cutter_a);
    cutter_h = wall / cos(cutter_a);

    translate([- resonator_len / 2 + outlet, side / 2 - wall, 0]) {
        rotate([0, 0, cutter_a])
        translate([cutter_l / 2, cutter_h / 2, 0])
        cube([cutter_l, cutter_h, side - wall], center = true);

        translate([-outlet / 2, side / 4, 0])
        cube([outlet, side / 2 + E, side - wall], center = true);
    }
}

module hole() {
    translate([- resonator_len / 2 - wall * 3/2, - side / 2 + wall * 3/2, 0])
    cylinder(side + E, r = wall / 2, center = true, $fn = 24);
}

module info() {
    linear_extrude(NOZ) {
        size = 3;

        translate([0, 0.5, 0])
        text(str("s", side, " w", wall, " r", resonator_len),
            size = size,
            font = "JetBrains Mono:style=Bold",
            valign = "bottom",
            halign = "center"
        );

        translate([0, -0.5, 0])
        text(str( " i", inlet, " o", outlet),
            size = size,
            font = "JetBrains Mono:style=Bold",
            valign = "top",
            halign = "center"
        );
    }
}

module whistle() {
    difference() {
        base();

        resonator();
        inlet();
        outlet();

        hole();
    }

    color("red")
    translate([0, 0, side / 2 - E])
    info();
}


if (CUT) {
    projection(cut = true)
    whistle();
} else {
    whistle();
}
