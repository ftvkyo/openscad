// Parameters

case_tilt = 30;

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

        oy = 9;
        oz = 7.5;
        dz = 15;

        #translate([mount_thickness, - oy, oz])
            slot();

        #translate([mount_thickness, - oy, oz + dz])
            slot();
    }
}

module assembly() {
    %printer();

    translate([- dim_case.x / 2, 0, 0])
        %case();

    frame_mount();
}

assembly();
