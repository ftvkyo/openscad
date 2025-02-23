use <../../lib/ops.scad>

DISPLAY = "cut"; // ["cut", "whistle", "slider"]

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
        cube([cutter_l, cutter_h, side - wall * 2], center = true);

        translate([-outlet / 2, side / 4, 0])
        cube([outlet, side / 2 + E, side - wall * 2], center = true);
    }
}

module hole() {
    translate([- resonator_len / 2 - wall * 3/2, - side / 2 + wall * 3/2, 0])
    cylinder(side + E * 2, r = wall * 3/4, center = true, $fn = 24);
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

module slider() {
    $fn = 48;

    w = side - wall * 2 - NOZ;
    l = resonator_len + 20;

    module profile() {
        offset(wall / 2)
        offset(- wall)
        offset(wall / 2 + E) {
            square([wall, w], center = true);

            translate([l / 2, 0, 0])
            square([l, wall], center = true);
        }
    }

    module hole() {
        translate([l - w * 3/4, 0, 0])
        rotate([90, 0, 0])
        cylinder(h = wall * 2, r = w / 4, center = true);
    }

    // Only render the slider if open
    if (open) {
        difference() {
            linear_extrude(w, center = true)
            profile();

            hole();
        }
    }
}


if (DISPLAY == "cut") {
    projection(cut = true) {
        whistle();
        slider();
    }
} else if (DISPLAY == "whistle") {
    whistle();
} else if (DISPLAY == "slider") {
    assert(open, "Needs to be 'open'");
    slider();
}
