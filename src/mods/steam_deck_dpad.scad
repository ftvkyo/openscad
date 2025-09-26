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
button_gap = 2.0;
button_slant = 7.5;

button_rim_width = 0.6;
button_rim_height = 2.0;

button_rounding = 1.0;
button_tolerance = 0.2;

dome_distance = 16.0;
dome_relaxed_height = 2.8;
dome_pressed_height = 1.9;
dome_radius1 = 3.75;
dome_radius2 = 2.5;

pin_height = 1.3;
pin_radius = 2.5;


$fn = $preview ? 24 : 96;


module button_profile() {
    button_x = dpad_diameter / 2 - dpad_rounding - button_gap * sqrt(2);
    button_y = dpad_width - dpad_rounding * 2;

    intersection() {
        translate([dome_distance / 2, 0])
        square([button_x, button_y], center = true);

        circle(dpad_diameter / 2 - dpad_rounding);
    }

    translate([dome_distance / 2 - button_x / 2, 0])
    circle(button_y / 2, $fn = 4);
}


module button_rim_profile() {
    button_x = dpad_diameter / 2 - dpad_rounding - button_gap * sqrt(2) - button_rim_width * 2;
    button_y = dpad_width - dpad_rounding * 2 + button_rim_width * 2;


    offset(button_rounding)
    offset(- button_rounding) {
        intersection() {
            translate([dome_distance / 2, 0])
            square([button_x, button_y], center = true);

            circle(dpad_diameter / 2 - dpad_rounding);
        }

        translate([dome_distance / 2 - button_x / 2, 0])
        circle(button_y / 2, $fn = 4);
    }
}


module buttons(negative = false) {
    module button_base() {
        intersection() {
            linear_extrude(button_height - button_rounding)
            offset(- button_tolerance)
            offset(- button_rounding)
            button_profile();

            translate([dpad_diameter / 2 - dpad_rounding - button_rounding, 0, (button_height - button_rounding) / 2])
            rotate([0, - button_slant, 0])
            cube([dpad_diameter - dpad_rounding * 2, dpad_width, button_height - button_rounding], center = true);
        }
    }

    for(a = [0, 90, 180, 270])
    rotate(a)
    if (!negative) {
        minkowski() {
            button_base();

            half3()
            sphere(button_rounding, $fn = 24);
        }

        linear_extrude(button_rim_height)
        offset(- button_tolerance)
        button_rim_profile();
    } else {
        linear_extrude(100, center = true)
        offset(button_rounding)
        offset(- button_rounding)
        button_profile();

        translate([0, 0, button_rim_height + button_tolerance])
        mirror([0, 0, 1])
        linear_extrude(100)
        button_rim_profile();
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
        translate([dome_distance / 2, 0, - dome_relaxed_height - 0.01])
        cylinder(h = (dome_radius1 - dome_radius2), r1 = dome_radius1, r2 = dome_radius2);
    }
}


module assembly() {
    color("#8888BB")
    render()
    dpad();

    color("#BB6666")
    render()
    buttons();
}


assembly();
