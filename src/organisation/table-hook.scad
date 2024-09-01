table_thickness = 16.2;
table_edge_hole_offset = 10;
screw_hole_d = 5;
screw_cap_d = 8;


E = 0.01;


module hook() {
    $fn = 64;

    width = 25;
    length = 50;
    thickness = 7.5;

    module under_table() {
        height = 1.5;

        translate([0, 0, - thickness / 2])
        difference() {
            cube([table_edge_hole_offset * 2, width, thickness], center = true);

            cylinder(thickness + E, r = screw_hole_d / 2, center = true);

            translate([0, 0, - thickness / 2 - height])
                cylinder(thickness, r = screw_cap_d / 2);
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
        extent = 40;

        translate([extent / 2, 0, 0])
        intersection() {
            translate([0, 0, width / 4])
                cube([extent, width, width / 2], center = true);

            rotate([0, 90, 0])
                cylinder(extent, r = width / 2, center = true);
        }

        translate([extent, 0, 0])
        intersection() {
            translate([0, 0, width / 3])
                cube([thickness, width, width * 2 / 3], center = true);

            rotate([0, 90, 0])
                cylinder(extent, r = width * 2 / 3, center = true);
        }
    }

    under_table();

    translate([table_edge_hole_offset - E, 0, 0])
        side();

    translate([table_edge_hole_offset + thickness - E * 2, 0, - length])
        bend();
}

hook();
