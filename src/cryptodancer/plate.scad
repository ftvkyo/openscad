use <../../lib/util.scad>


PART = "all"; // ["all", "top-1", "top-2", "bottom"]


board_t = 1.25;

plate_t = 1.3;
plate_gap = 0.5;

wall_t = 4;
wall_h = 3;
wall_gap = 0.25;

back_frame_t = 2;
back_frame_overlap = 2.5;

diode_h = 1;


module __hidden__() {}

k_x = 300;
k_y = 150;
k_o = [1.3, 5.5];

T = 0.15;
E = 0.01;

alignment_pins = [
    [10, -71],
    [30, -56.5],
    [50, -47],
    [70, -41.5],
    [90, -36],
    [110, -31],
    [130, -25.5],
    [150, 0],

    [10, 51],
    [30, 57.5],
    [50, 64.5],
    [70, 68.5],
    [90, 70],
    [110, 71],
    [130, 62],
];


module alignment(holes = false) {
    r = 1;

    module pins(r, d) {
        for(p = alignment_pins) {
            translate([p.x, p.y, 0])
            cylinder(d, r1 = r, r2 = r / 2, $fn = 24);

            translate([-p.x, p.y, 0])
            cylinder(d, r1 = r, r2 = r / 2, $fn = 24);
        }
    }

    color("red")
    if (holes) {
        translate([0, 0, E])
        mirror([0, 0, 1])
        pins(r + T, board_t + T);
    } else {
        pins(r, board_t);
    }
}


module k_edge() {
    translate([-k_x/2, -k_y/2])
    import("cryptodancer-edge.svg");
}

module k_holes() {
    // Note: these are not all of the pins
    translate([-k_x/2, -k_y/2])
    import("cryptodancer-holes.svg");
}

module k_controller() {
    translate([2.54 * 3, 17])
    square([2.54, 20 * 2.54], center = true);

    translate([- 2.54 * 3, 17])
    square([2.54, 20 * 2.54], center = true);
}

module k_diodes() {
    translate([-k_x/2, -k_y/2] - k_o)
    import("cryptodancer-diodes.svg");
}

module k_encoders() {
    translate([-k_x/2, -k_y/2] - k_o)
    import("cryptodancer-encoders.svg");
}

module k_switches() {
    offset(-0.5)
    translate([-k_x/2, -k_y/2] - k_o)
    import("cryptodancer-switches.svg");
}


module board() {
    color("#32328866")
    linear_extrude(5) {
        k_diodes();
        k_encoders();
        k_switches();
        k_controller();
    }

    color("#FFCCCC66")
    linear_extrude(board_t, center = true)
    k_edge();

    color("#00000066")
    linear_extrude(board_t + E, center = true)
    k_holes();
}


module plate() {
    translate([0, 0, board_t / 2])
    difference() {
        translate([0, 0, plate_gap])
        linear_extrude(plate_t)
        difference() {
            offset(wall_gap + wall_t)
            k_edge();

            k_switches();

            offset(T) {
                k_controller();
                k_encoders();
            }
        }

        linear_extrude(diode_h)
        offset(0.99, $fn = 36)
        offset(-0.99, $fn = 36)
        k_diodes();
    }
}


module wall() {
    translate([0, 0, board_t / 2 + plate_gap + E])
    mirror([0, 0, 1])
    linear_extrude(wall_h)
    difference() {
        offset(wall_gap + wall_t)
        k_edge();

        offset(wall_gap)
        k_edge();
    }
}


module back_frame() {
    translate([0, 0, board_t / 2 + plate_gap + E - wall_h])
    mirror([0, 0, 1])
    linear_extrude(back_frame_t)
    difference() {
        offset(wall_gap + wall_t)
        k_edge();

        offset(-back_frame_overlap)
        k_edge();

        offset(0.99, $fn = 36)
        offset(-0.99, $fn = 36)
        k_diodes();
    }
}


module assembly() {
    plate();
    wall();
    back_frame();
}

module assembly_top() {
    rotate([0, 180, 0])
    half3()
    assembly();

    alignment();
}

module assembly_bottom() {
    difference() {
        half3("z-")
        assembly();

        alignment(holes = true);
    }
}


module partitioner() {
    linear_extrude(50, center = true)
    polygon([
        [30, 100],
        [80, -100],
        [-80, -100],
        [-30, 100],
    ]);
}


if (PART == "all") {
    assembly();
    %board();
} else if (PART == "top-1") {
    half3("x-")
    assembly_top();
} else if (PART == "top-2") {
    half3("x+")
    assembly_top();
} else if (PART == "bottom") {
    translate([0, -40, 0])
    intersection() {
        half3("y+")
        assembly_bottom();
        partitioner();
    }

    translate([0, 40, 0])
    intersection() {
        half3("y-")
        assembly_bottom();
        partitioner();
    }

    translate([-50, 0, 0])
    rotate([0, 0, -15])
    difference() {
        half3("x+")
        assembly_bottom();
        partitioner();
    }

    translate([50, 0, 0])
    rotate([0, 0, 15])
    difference() {
        half3("x-")
        assembly_bottom();
        partitioner();
    }
} else {
    assert(false);
}


// %board();
