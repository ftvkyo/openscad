use <../../lib/fasteners.scad>
use <../../lib/util.scad>


PART = "all"; // ["all", "plate", "screws", "top-1", "top-2", "bottom"]


board_t = 1.25;

plate_t = 1.3;
plate_gap = 0.5;

wall_t = 5;
wall_h = 3;
wall_gap = 0.25;

back_frame_t = 2;
back_frame_overlap = 2.5;

diode_h = 1.5;


module __hidden__() {}

k_x = 300;
k_y = 150;
k_o = [1.3, 5.5];

T = 0.15;
E = 0.01;

screw_locations = [
    [10, -70.7],
    [56, -45.2],

    [68, -42],
    [137.1, -23],
    [152.5, 4.5],
    [137.7, 58.3],
    [110.3, 70.9],
    [40, 61.2],

    [30, 57.8],
    [10, 51],
];


module fastening_screws(holes = false) {
    assert(is_bool(holes));

    $fn = 24;

    color("#FF00FF")
    translate([0, 0, 1])
    for (s = screw_locations) {
        translate([s.x, s.y, 0])
        screw_M2x4(hole = holes);

        translate([-s.x, s.y, 0])
        screw_M2x4(hole = holes);
    }
}

module fastening_inserts(holes = false) {
    assert(is_bool(holes));

    $fn = 24;

    color("#FFFF00")
    translate([0, 0, - wall_h / 2 - back_frame_t])
    mirror([0, 0, 1])
    for (s = screw_locations) {
        translate([s.x, s.y, 0])
        heat_insert_M2(hole = holes);

        translate([-s.x, s.y, 0])
        heat_insert_M2(hole = holes);
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
    header_pins = 20;
    header_w = 2.54;
    header_l = (header_pins + 1) * 2.54;

    translate([2.54 * 3, 17])
    square([header_w, header_l], center = true);

    translate([- 2.54 * 3, 17])
    square([header_w, header_l], center = true);
}

module k_diodes() {
    offset(0.99, $fn = 36)
    offset(-0.99, $fn = 36)
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
    color("#66666666")
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
    translate([0, 0, board_t / 2]) {
        difference() {
            color("#FF8888")
            translate([0, 0, plate_gap])
            linear_extrude(plate_t, convexity = 20)
            difference() {
                offset(wall_gap + wall_t)
                k_edge();

                k_switches();
                k_encoders();
                k_controller();
            }

            color("#FF0000")
            linear_extrude(diode_h, convexity = 20)
            k_diodes();
        }

        linear_extrude(plate_gap + E, convexity = 4)
        difference() {
            offset(2, $fn = 1)
            k_encoders();

            k_encoders();
        }
    }
}


module wall() {
    color("#88FF88")
    translate([0, 0, board_t / 2 + plate_gap + E])
    mirror([0, 0, 1])
    linear_extrude(wall_h, convexity = 2)
    difference() {
        offset(wall_gap + wall_t)
        k_edge();

        offset(wall_gap)
        k_edge();
    }
}


module back_frame() {
    color("#8888FF")
    translate([0, 0, board_t / 2 + plate_gap + E - wall_h])
    mirror([0, 0, 1])
    linear_extrude(back_frame_t, convexity = 2)
    difference() {
        offset(wall_gap + wall_t)
        k_edge();

        offset(-back_frame_overlap)
        k_edge();

        k_diodes();
    }
}


module assembly() {
    difference() {
        union() {
            plate();
            wall();
            back_frame();
        }

        fastening_screws(holes = true);
        fastening_inserts(holes = true);
    }
}

module assembly_top() {
    rotate([0, 180, 0])
    half3("z+")
    assembly();
}

module assembly_bottom() {
    half3("z-")
    assembly();
}


module partitioner() {
    linear_extrude(50, center = true)
    polygon([
        [24, 100],
        [77, -100],
        [-77, -100],
        [-24, 100],
    ]);
}


// !assembly_top();
// !assembly_bottom();


if (PART == "all") {
    assembly();
    %board();
    %fastening_screws();
    %fastening_inserts();
} else if (PART == "plate") {
    assembly();
    %partitioner();
} else if (PART == "screws") {
    fastening_screws();
    color("#FFFF0044")
    fastening_inserts();
} else if (PART == "top-1") {
    translate([k_x / 4, 0, 0])
    half3("x-")
    assembly_top();
} else if (PART == "top-2") {
    translate([- k_x / 4, 0, 0])
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

    translate([-45, 0, 0])
    rotate([0, 0, -15])
    difference() {
        half3("x+")
        assembly_bottom();
        partitioner();
    }

    translate([45, 0, 0])
    rotate([0, 0, 15])
    difference() {
        half3("x-")
        assembly_bottom();
        partitioner();
    }
} else {
    assert(false);
}
