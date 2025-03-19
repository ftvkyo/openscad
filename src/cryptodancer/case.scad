use <../../lib/util.scad>

PART = 1; // [1, 2, 3, 4, 5]

plate_t = 1.25;
plate_pin_h = 1.25;

wall_w = 2;
wall_gap = 0.1;
wall_overlap_w = 1;
wall_top_h = 1;
wall_bottom_h = 2;


module __hidden__() {}

wall_h_plus = plate_t / 2 + wall_gap + wall_top_h;
wall_h_minus = plate_t / 2 + wall_gap + wall_bottom_h;

k_x = 300;
k_y = 150;


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


module wall() {
    wall_h_offset = (wall_h_plus - wall_h_minus) / 2;

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


module wall_top() {
    rotate([0, 180, 0])
    half3()
    wall();
}

module wall_bottom() {
    half3("z-")
    wall();
}


if (PART == 1) {
    half3("x+")
    wall_top();
} else if (PART == 2) {
    half3("x-")
    wall_top();
} else if (PART == 3) {
    half3("y-")
    translate([0, 30, 0])
    wall_bottom();
} else if (PART == 4) {
    half3("x+")
    half3("y+")
    translate([0, 30, 0])
    wall_bottom();
} else if (PART == 5) {
    half3("x-")
    half3("y+")
    translate([0, 30, 0])
    wall_bottom();
} else {
    assert(false);
}


// %plate();
