use <../../lib/util.scad>

// Real parameters:
// dpad_width = 7.5;
// dpad_diameter = 22.0;
// dpad_thickness = 5.5;
// dpad_rim_width = 1.5;
// dpad_rim_left_reduction = 3.4;

dpad_width = 8.0;
dpad_diameter = 23.0;
dpad_thickness = 4.0;

dpad_rim_width = 1.2;
dpad_rim_thickness = 0.8;
dpad_rim_left_reduction = 4.0;

dpad_rounding = 1.0;

button_height = 6.5;
button_distance = 16.0;
button_radius = 3.0;
button_reduction = 0.5;

button_rim_width = 0.4;
button_rim_height = 2.0;

button_rounding = 1.0;
button_tolerance = 0.2;

dome_relaxed_height = 2.8;
dome_pressed_height = 1.9;
dome_radius1 = 3.75;
dome_radius2 = 2.5;

pin_height = 1.3;
pin_radius = 2.5;


$fn = $preview ? 24 : 96;


module buttons(negative = false) {
    button_radius = negative ? button_radius + button_tolerance : button_radius;
    button_rim_radius = button_radius + button_rim_width;

    module button() {
        if (negative) {
            intersection() {
                cylinder(h = button_height, r = button_radius);

                translate([- button_reduction, 0, 0])
                cube([button_radius * 2, button_radius * 2, 100], center = true);
            }
        } else {
            minkowski() {
                intersection() {
                    cylinder(h = button_height - button_rounding, r = button_radius - button_rounding);

                    translate([- button_reduction, 0, 0])
                    cube([(button_radius - button_rounding) * 2, (button_radius - button_rounding) * 2, 100], center = true);
                }

                half3()
                sphere(button_rounding, $fn = 24);
            }
        }
    }

    module button_rim() {
        intersection() {
            union() {
                cylinder(h = button_rim_height, r = button_rim_radius);

                translate([0, 0, button_rim_height])
                cylinder(h = button_rim_width, r1 = button_rim_radius, r2 = button_radius);
            }

            translate([- button_reduction - button_rim_width, 0, 0])
            cube([button_rim_radius * 2, button_rim_radius * 2, 100], center = true);
        }
    }

    for (a = [0, 90, 180, 270])
    rotate([0, 0, a])
    translate([button_distance / 2, 0, -0.01]) {
        button();
        button_rim();
    }
}


module dpad_body_profile() {
    intersection() {
        union() {
            square([dpad_width, dpad_diameter], center = true);
            square([dpad_diameter, dpad_width], center = true);
        }

        circle(dpad_diameter / 2);
    }
}


module dpad_body() {
    minkowski() {
        linear_extrude(dpad_thickness - dpad_rounding)
        offset(- dpad_rounding)
        dpad_body_profile();

        half3()
        sphere(dpad_rounding, $fn = 24);
    }
}


module dpad_rim_profile() {
    intersection() {
        offset(dpad_rim_width)
        dpad_body_profile();

        dr = dpad_diameter / 2;
        drw = dpad_rim_width;

        polygon([
            [- dr + dpad_rim_left_reduction, dr + drw],
            [dr + drw, dr + drw],
            [dr + drw, - dr - drw],
            [- dr + dpad_rim_left_reduction, - dr - drw],
        ]);
    }
}


module dpad_rim() {
    linear_extrude(dpad_rim_thickness)
    dpad_rim_profile();
}


module dpad_support() {
    mirror([0, 0, 1])
    linear_extrude(dome_relaxed_height)
    difference() {
        dpad_rim_profile();

        projection()
        buttons(negative = true);
    }
}


module dpad() {
    difference() {
        union() {
            dpad_body();
            dpad_rim();
            dpad_support();
        }

        translate([0, 0, - 0.01])
        buttons(negative = true);

        translate([0, 0, - dome_relaxed_height - 0.01])
        cylinder(h = pin_height, r = pin_radius);

        for (a = [0, 90, 180, 270])
        rotate([0, 0, a])
        translate([button_distance / 2, 0, - dome_relaxed_height - 0.01])
        cylinder(h = (dome_radius1 - dome_radius2), r1 = dome_radius1, r2 = dome_radius2);
    }
}


module assembly() {
    color("#8888BB")
    dpad();

    color("#BB6666")
    buttons();
}


assembly();
