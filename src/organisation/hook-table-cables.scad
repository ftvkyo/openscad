table_thickness = 16.2;
table_edge_hole_offset = 10.1;
screw_hole_d = 5;
screw_cap_d = 8.5;

cable_thickness = 5;
cable_cutouts = 5;


E = 0.01;


module hook() {
    $fn = 128;

    thickness = 7.5;

    width_attachment = 25;
    width_holder = 75;
    extent_holder = 20;

    // How thick is the place that is squished against the table by the screw
    bearing = 2.5;

    module attachment() {
        translate([0, 0, - thickness / 2])
        difference() {
            linear_extrude(thickness, center = true)
            translate([thickness / 4, 0])
                square([table_edge_hole_offset * 2 + thickness / 2, width_attachment], center = true);

            cylinder(thickness + E, r = screw_hole_d / 2, center = true);

            translate([0, 0, - thickness / 2 - bearing])
            scale([0.86, 1.25, 1])
            rotate([0, 0, 45])
            translate([0, 0, thickness / 2])
                cube([screw_cap_d, screw_cap_d, thickness], center = true);
        }
    }

    module profile() {
        translate([(extent_holder - thickness) / 2, 0]) {
            offset(1)
            offset(-1)
                square([extent_holder, width_holder], center = true);

            translate([- extent_holder / 4, 0])
                square([extent_holder / 2, width_holder], center = true);
        }
    }

    module side() {
        translate([thickness / 2 - E, 0, - thickness / 2])
        linear_extrude(thickness, center = true)
            profile();

        translate([0, 0, - E])
        intersection() {
            translate([thickness / 2, 0, thickness / 2])
            linear_extrude(thickness, center = true) {
                profile();

                translate([- thickness / 4, 0])
                    square([thickness / 2, width_attachment], center = true);
            }

            rotate([90, 0, 0])
                cylinder(width_holder, r = thickness, center = true);
        }
    }

    module cutouts() {
        l = extent_holder * 2/3 + E;
        h = thickness + E * 2;
        w = cable_thickness;

        module cutout() {
            translate([l, 0, 0]) {
                mirror([0, 0, 1])
                linear_extrude(h, convexity = 10)
                offset(-1)
                offset(1) {
                    circle(w / 2);
                    translate([l / 4, 0])
                        square([l / 2, w], center = true);
                    translate([l, 0])
                        square([l, w * 2], center = true);
                }

                translate([0, 0, - w])
                    cylinder(w, r1 = 0, r2 = w);
            }

        }

        cutout_step = width_holder / cable_cutouts;

        translate([0, 0, E])
        for (i = [1 : cable_cutouts])
        translate([0, - width_holder / 2 + (i - 1/2) * cutout_step])
            cutout();
    }

    attachment();

    translate([table_edge_hole_offset - E, 0, 0])
    difference() {
        side();
        cutouts();
    }
}


hook();
