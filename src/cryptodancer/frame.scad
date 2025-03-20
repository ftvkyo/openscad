use <../../lib/util.scad>


PART = "all"; // ["all", "top", "bottom"]


plate_t = 1.25;
plate_pin_h = 1.25;

wall_w = 5;
wall_gap = 0.1;
wall_overlap_w = 2;
wall_top_h = 2;
wall_bottom_h = 2;


module __hidden__() {}

wall_h_plus = plate_t / 2 + wall_gap + wall_top_h;
wall_h_minus = plate_t / 2 + wall_gap + wall_bottom_h;
wall_h_offset = (wall_h_plus - wall_h_minus) / 2;

k_x = 300;
k_y = 150;

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


module k_outline() {
    translate([-k_x/2, -k_y/2])
    import("cryptodancer-edge.svg");
}


module k_pins() {
    // Note: these are not all of the pins
    translate([-k_x/2, -k_y/2])
    import("cryptodancer-holes.svg");
}


module plate() {
    color("#FFCCCC66")
    linear_extrude(plate_t, center = true)
    k_outline();

    color("#FF666666")
    translate([0, 0, - (plate_t + plate_pin_h) / 2])
    linear_extrude(plate_pin_h, center = true)
    k_pins();
}


module alignment(hole = false) {
    r = hole ? 1.05 : 1;

    color("red")
    translate([0, 0, wall_h_offset])
    for(p = alignment_pins) {
        translate([p.x, p.y, 0])
        cylinder(plate_t, r = r, center = true, $fn = 24);

        translate([-p.x, p.y, 0])
        cylinder(plate_t, r = r, center = true, $fn = 24);
    }
}


module wall() {
    module wall_base() {
        linear_extrude(wall_h_plus + wall_h_minus, center = true)
        difference() {
            offset(wall_gap + wall_w)
            k_outline();

            offset(- wall_overlap_w)
            k_outline();
        }
    }

    module wall_cut() {
        rotate([90, 0, 15])
        cylinder(50, r = 1.5, center = true, $fn = 24);
    }

    ds = [
        [143, 8.35],
        [138.2, 26],
        [133.5, 43.5],
    ];

    difference() {
        translate([0, 0, wall_h_offset])
        wall_base();

        linear_extrude(plate_t, center = true)
        offset(wall_gap)
        k_outline();

        for (d = ds)
        translate([d.x, d.y, wall_h_offset])
        cylinder(h = wall_h_plus + wall_h_minus + 0.1, r = 6, $fn = 48, center = true);
    }
}


// ===== //


module partitioner() {
    linear_extrude(20, center = true)
    polygon([
        [30, 100],
        [80, -100],
        [-80, -100],
        [-30, 100],
    ]);
}

module wall_top() {
    module base() {
        rotate([0, 180, 0]) {
            half3()
            wall();

            alignment();
        }

    }

    translate([0, -40, 0])
    intersection() {
        half3("y+")
        base();

        partitioner();
    }

    translate([0, 40, 0])
    intersection() {
        half3("y-")
        base();

        partitioner();
    }

    translate([-50, 0, 0])
    rotate([0, 0, -15])
    difference() {
        half3("x+")
        base();

        partitioner();
    }

    translate([50, 0, 0])
    rotate([0, 0, 15])
    difference() {
        half3("x-")
        base();

        partitioner();
    }
}

module wall_bottom() {
    module base() {
        difference() {
            half3("z-")
            wall();

            alignment(hole = true);
        }
    }

    translate([-60, -30, 0])
    rotate([0, 0, -10])
    half3("x+")
    base();

    translate([60, 30, 0])
    rotate([0, 0, 10])
    half3("x-")
    base();
}


if (PART == "all") {
    wall();
    %plate();

    %scale([1, 1, 10])
    alignment();
} else if (PART == "top") {
    wall_top();
} else if (PART == "bottom") {
    wall_bottom();
}
