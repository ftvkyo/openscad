/* ========== *
 * Parameters *
 * ========== */

/* [Table] */

screw_hole_d = 5;
screw_cap_d = 8.5;
table_thickness = 16.2;
table_edge_hole_offset = 10.1;

/* [General] */

// Base thickness of things
thickness = 7.5;
// How wide is the part under the table
attachment_width = 25;
// How far the screw cap will be from the bottom table surface when fully in
attachment_bearing_thickness = 2.5;

/* [Holder] */

// Extent of the holder
holder_extent = 25;
// Width of the holder
holder_width = 75;

// Thickness of the cable to be held
holder_cable_thickness = 5;
// How many cables should be able to fit
holder_cable_cutouts = 5;

/* [Hidden] */

E = 0.01;
rounding = 2;
holder_extent_total = thickness + holder_extent;


/* ======= *
 * Modules *
 * ======= */


module hook() {
    $fn = 128;


    module attachment() {
        translate([0, 0, - thickness / 2])
        difference() {
            linear_extrude(thickness, center = true)
            translate([thickness / 4, 0])
                square([table_edge_hole_offset * 2 + thickness / 2, attachment_width], center = true);

            cylinder(thickness + E, r = screw_hole_d / 2, center = true);

            translate([0, 0, - thickness / 2 - attachment_bearing_thickness])
            scale([0.86, 1.25, 1])
            rotate([0, 0, 45])
            translate([0, 0, thickness / 2])
                cube([screw_cap_d, screw_cap_d, thickness], center = true);
        }
    }

    module profile() {
        translate([(holder_extent_total - thickness) / 2, 0]) {
            offset(rounding)
            offset(-rounding)
                square([holder_extent_total, holder_width], center = true);

            translate([- holder_extent_total / 4, 0])
                square([holder_extent_total / 2, holder_width], center = true);
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
                    square([thickness / 2, attachment_width], center = true);
            }

            rotate([90, 0, 0])
                cylinder(holder_width, r = thickness, center = true);
        }
    }

    module cutouts() {
        width = holder_cable_thickness;
        length = holder_extent - holder_cable_thickness - width;
        height = thickness + E * 2;

        dimple_radius = width * 1.4;
        dimple_gap = width * 3/2 - dimple_radius;

        module cutout() {
            translate([thickness + holder_cable_thickness + width / 2, 0, 0]) {
                mirror([0, 0, 1])
                linear_extrude(height, convexity = 10)
                offset(-rounding)
                offset(rounding) {
                    circle(width / 2);
                    translate([length / 2 + width / 4, 0])
                        square([length + width / 2, width], center = true);
                    translate([length + width / 2 + rounding * 3/2, 0])
                        square([rounding * 3, width * 2], center = true);
                }

                translate([0, 0, - thickness])
                    cylinder(thickness, r1 = 0, r2 = dimple_radius);
            }
        }

        cutout_step = holder_width / holder_cable_cutouts - dimple_gap / 2;

        translate([0, 0, E])
        for (i = [1 : holder_cable_cutouts])
        translate([0, - holder_width / 2 + dimple_gap + (i - 1/2) * cutout_step])
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
