DISPLAY = "all"; // ["all", "slice", "spike_base", "spike_tip"]

fabric_thickness = 1.6;
fabric_width = 12.5;
fabric_hole_radius = 2.5;

spike_length = 20;
spike_base_radius = 5;
spike_screw_length = 6;
spike_screw_factor = 1.25;
spike_counter_thickness = 2.5;
spike_counter_radius = 7.5;

E = 0.01;
T = 0.15;

module fabric() {
    $fn = 24;

    translate([0, 0, - fabric_thickness / 2])
    difference() {
        cube([fabric_width * 2, fabric_width, fabric_thickness], center = true);
        cylinder(h = fabric_thickness * 2, r = fabric_hole_radius, center = true);
    }
}

module screw(hole = false) {
    $fn = 24;

    o = hole ? T : 0;

    intersection() {
        linear_extrude(spike_screw_length, twist = - 360 * spike_screw_length / 2.5, convexity = 10)
        scale([spike_screw_factor, 1])
        circle(fabric_hole_radius / spike_screw_factor + o);

        cylinder(spike_screw_length, r1 = spike_screw_length - 1 + o, r2 = fabric_hole_radius - 1 + o);
    }
}

module spike_base() {
    $fn = 24;

    module profile_base() {
        polygon([
            [0, E],
            [fabric_hole_radius, E],
            [fabric_hole_radius, - fabric_thickness],
            [spike_counter_radius, - fabric_thickness - spike_counter_thickness / 2],
            [fabric_hole_radius, - fabric_thickness - spike_counter_thickness],
            [0, - fabric_thickness - spike_counter_thickness],
        ]);
    }

    intersection() {
        union() {
            rotate_extrude()
            profile_base();

            screw();
        }

        cube([spike_counter_radius * 2, fabric_hole_radius * 2 * 0.7, spike_screw_length * 3], center = true);
    }
}

module spike_tip() {
    difference() {
        translate([0, 0, E])
        cylinder(spike_length, r1 = spike_base_radius, r2 = 1.5, $fn = 6);
        screw(hole = true);
    }
}


if (DISPLAY == "all") {
    %fabric();
    spike_base();
    spike_tip();
} else if (DISPLAY == "slice") {
    %fabric();
    intersection() {
        union() {
            spike_base();
            spike_tip();
        }

        translate([0, 50, 0])
        cube([100, 100, 100], center = true);
    }
} else if (DISPLAY == "spike_base") {
    rotate([90, 0, 0])
    spike_base();
} else if (DISPLAY == "spike_tip") {
    spike_tip();
}
