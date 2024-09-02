table_thickness = 16.2;
table_edge_hole_offset = 10;
screw_hole_d = 5;
screw_cap_d = 8.5;


E = 0.01;


module hook() {
    $fn = 64;

    width = 25;
    length = 50;
    thickness = 7.5;

    module under_table() {
        // How thick is the place that is squished against the table by the screw
        bearing = 2;

        translate([0, 0, - thickness / 2])
        difference() {
            cube([table_edge_hole_offset * 2, width, thickness], center = true);

            cylinder(thickness + E, r = screw_hole_d / 2, center = true);

            translate([0, 0, - thickness / 2 - bearing])
            scale([0.86, 1.25, 1])
            rotate([0, 0, 45])
            translate([0, 0, thickness / 2])
                cube([screw_cap_d, screw_cap_d, thickness], center = true);
        }
    }

    module side() {
        translate([thickness / 2 - E, 0, - length / 2])
            cube([thickness, width, length], center = true);

        translate([0, 0, - E])
        intersection() {
            translate([thickness / 2, 0, thickness / 2])
                cube([thickness, width, thickness], center = true);

            rotate([90, 0, 0])
                cylinder(width, r = thickness, center = true);
        }
    }

    module bend() {
        extent = 50;

        translate([extent / 2, 0, 0])
        intersection() {
            union() {
                scale([1, 1.25, 1])
                rotate([0, 90, 0])
                    cylinder(extent, r = width / 2, center = true);

                translate([(extent + thickness) / 2 - E, 0, 0])
                rotate([0, 90, 0])
                    cylinder(thickness, r = width * 3 / 4, center = true);
            }

            translate([thickness / 2, 0, width / 2])
                cube([extent + thickness, width, width], center = true);
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
