// Parameters

case_tilt = 15;

hole_r_1 = 4;
hole_r_2 = 2;

// Dimensions

T = 0.5; // Tolerance offset
N = 0.4; // Nozzle diameter
L = N / 2; // Layer height
E = 0.01;
NEAR = 50;
FAR = 300;

dim_case = [61, 90, 22];

dim_printer_base = [FAR, FAR, NEAR];
dim_printer_frame = [40, 3, FAR];
dim_printer_bracket = [40, NEAR, 13];

offset_printer_frame = 3;
offset_printer_bracket = 40;

mount_thickness = N * 4;

poke_y_offset = 9;
poke_z_offset = 7.5;
poke_z_distance = 15;

// Modules

module case() {
    color("#aaaaff55")
    rotate([case_tilt, 0, 0])
        cube(dim_case, center = true);
}

module printer() {
    module base() {
        cube(dim_printer_base);
    }

    module frame() {
        cube(dim_printer_frame);
    }

    module bracket() {
        cube(dim_printer_bracket);
    }

    color("#aaaaaacc") {
        translate([0, - dim_printer_base.y / 2, - dim_printer_base.z])
            base();

        translate([offset_printer_frame, 0, 0])
            frame();

        translate([offset_printer_frame, dim_printer_frame.y, offset_printer_bracket])
            bracket();
    }
}

module frame_mount() {
    $fn = 48;

    snap_width = dim_printer_frame.x + mount_thickness * 2 + T;
    snap_depth = dim_printer_frame.y + mount_thickness * 2 + T;
    snap_grip = 1;

    module snap_section() {
        offset(mount_thickness * 0.49)
        offset(- mount_thickness * 0.49) {
            difference() {
                square([snap_width, snap_depth], center = true);
                square([dim_printer_frame.x, dim_printer_frame.y] + [T, T] / 2, center = true);
                translate([0, mount_thickness])
                    square([dim_printer_frame.x + T / 2 - snap_grip * 2, dim_printer_frame.y + T / 2 + mount_thickness], center = true);
            }

            triangle_angle = 20;
            triangle_extent = snap_width * tan(triangle_angle);
            triangle_diagonal = snap_width / cos(triangle_angle);

            translate([(mount_thickness - snap_width) / 2, - (triangle_extent + snap_depth) / 2 + E])
                square([mount_thickness, triangle_extent], center = true);

            intersection() {
                translate([0, - (triangle_extent + snap_depth) / 2])
                rotate(90 + triangle_angle)
                    square([mount_thickness, triangle_diagonal], center = true);

                // Cut off the bits that stick out
                square([snap_width, 10 ^ 3], center = true);
            }
        }
    }

    module snap() {
        translate([
            offset_printer_frame + dim_printer_frame.x / 2,
            dim_printer_frame.y / 2,
            0,
        ])
        linear_extrude(offset_printer_bracket - 1, convexity = 4)
            snap_section();
    }

    module slot_section() {
        circle(hole_r_2);

        translate([0, hole_r_2 * 3])
            circle(hole_r_1);

        translate([0, hole_r_2 * 1.5])
            square([hole_r_2 * 2, hole_r_2 * 3], center = true);
    }

    module slot() {
        rotate([90, 0, 90])
        linear_extrude(mount_thickness * 2, center = true, convexity = 4)
            slot_section();
    }

    difference() {
        snap();

        #translate([mount_thickness, - poke_y_offset, poke_z_offset])
            slot();

        #translate([mount_thickness, - poke_y_offset, poke_z_offset + poke_z_distance])
            slot();
    }
}

module pi_holder() {
    $fn = 48;

    module poke() {
        translate([0, 0, offset_printer_frame + T])
            cylinder(mount_thickness, r = hole_r_1 - T / 2);

        translate([0, 0, offset_printer_frame - mount_thickness])
            cylinder(mount_thickness + T, r = hole_r_2);

        cylinder(offset_printer_frame - mount_thickness, r = hole_r_1);
    }

    module pokers() {
        translate([- 0.5, - poke_y_offset, poke_z_offset]) {
            rotate([0, 90, 0])
                poke();

            translate([0, 0, poke_z_distance])
            rotate([0, 90, 0])
                poke();
        }
    }

    module base() {
        difference() {
            cube([
                dim_case.x + mount_thickness * 2,
                dim_case.y + mount_thickness * 2,
                mount_thickness * 4,
            ], center = true);

            translate([0, 0, mount_thickness / 2 + E])
            cube([
                dim_case.x,
                dim_case.y,
                mount_thickness * 3,
            ], center = true);
        }
    }

    module connector() {
        difference() {
            union() {
                translate([- mount_thickness, -9, 12])
                    cube([mount_thickness * 2, 14, 32], center = true);

                translate([- mount_thickness, -9, 6])
                rotate([0, -90, 0])
                linear_extrude(mount_thickness)
                scale([1, 1.5])
                    circle(20,  $fn = 3);
            }

            translate([0, 1.8, - dim_case.z / 2])
            rotate([case_tilt, 0, 0])
                cube(dim_case, center = true);
        }
    }

    pokers();

    connector();

    translate([- (dim_case.x + mount_thickness) / 2 - mount_thickness * 1.5, -12, 0])
    rotate([case_tilt, 0, 0])
        base();
}

module assembly() {
    %printer();

    // translate([- dim_case.x / 2, 0, 0])
    //     %case();

    frame_mount();

    pi_holder();
}

assembly();
