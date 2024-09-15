table_thickness = 16.2;
table_edge_hole_offset = 10.1;
screw_hole_d = 5;
screw_cap_d = 8.5;


E = 0.01;


module hook() {
    $fn = 128;

    width = 25;
    length = 50;
    thickness = 7.5;

    // How thick is the place that is squished against the table by the screw
    bearing = 2.5;

    module under_table() {
        translate([0, 0, - thickness / 2])
        difference() {
            linear_extrude(thickness, center = true)
            translate([thickness / 4, 0])
                square([table_edge_hole_offset * 2 + thickness / 2, width], center = true);

            cylinder(thickness + E, r = screw_hole_d / 2, center = true);

            translate([0, 0, - thickness / 2 - bearing])
            scale([0.86, 1.25, 1])
            rotate([0, 0, 45])
            translate([0, 0, thickness / 2])
                cube([screw_cap_d, screw_cap_d, thickness], center = true);
        }
    }

    module profile() {
        flatten = 0.95;

        intersection() {
            scale([thickness, width * (2 - flatten)])
                circle(1 / 2);

            square([thickness, width], center = true);
        }
    }

    module side() {
        translate([thickness / 2 - E, 0, - length / 2])
        linear_extrude(length, center = true)
            profile();

        translate([0, 0, - E])
        intersection() {
            translate([thickness / 2, 0, thickness / 2])
            linear_extrude(thickness, center = true) {
                profile();

                translate([- thickness / 4, 0])
                    square([thickness / 2, width], center = true);
            }

            rotate([90, 0, 0])
                cylinder(width, r = thickness, center = true);
        }
    }

    module bend() {
        extent = 50;

        translate([(extent - thickness) / 2, 0, 0])
        rotate([-90, 0, 0]) {
            rotate_extrude(angle = 180)
            translate([extent / 2, 0])
                profile();

            translate([extent / 2, E, 0])
            rotate_extrude(angle = 180)
            intersection() {
                profile();

                translate([- thickness / 4, 0])
                    square([thickness / 2, width], center = true);
            }
        }
    }

    under_table();

    translate([table_edge_hole_offset - E, 0, 0])
        side();

    translate([table_edge_hole_offset + thickness - E * 2, 0, - length])
        bend();
}


rotate([90, 0, 0])
    hook();
