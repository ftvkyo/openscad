key_radius = 2.25;
key_bend_radius = 7.0;
key_extent_x = 70.0;
key_extent_y = 20.0;

handle_radius = 4.5;
handle_rounding = 1.0;
handle_bar_length = 40.0;
handle_stem_length = 60.0;

screw_radius = 1.0;
screw_length = 6.0;
screw_cap_height = 2.0;
screw_cap_radius = 1.75;

handle_screw_loop_f = 1.75;

screw_position = [0, - handle_bar_length / 4];
screw_loop_position = [handle_stem_length / 2, 0];


module key_profile(hole) {
    key_radius = hole ? key_radius + 0.1 : key_radius;

    if (hole) {
        intersection() {
            rotate(45)
            square(key_radius * 2, center = true);

            square([key_radius * sqrt(2), key_radius * 2.2], center = true);
        }

        intersection() {
            f = 1.515;

            scale([key_radius * f, key_radius * 4])
            rotate(45)
            square(1, center = true);

            square([key_radius * 4, key_radius * f / 2], center = true);
        }
    }

    circle(key_radius);
}

module key_bend(r) {
    translate([key_bend_radius, key_bend_radius])
    rotate([0, 0, 180])
    rotate_extrude(angle = 90, $fn = 96)
    translate([key_bend_radius, 0])
    children();
}

module key(hole = false) {
    $fn = 36;

    key_bend()
    key_profile(hole);

    rotate([-90, 0, -90])
    translate([0, 0, key_bend_radius - 0.01])
    linear_extrude(key_extent_x)
    key_profile(hole);

    rotate([-90, 0, 0])
    translate([0, 0, key_bend_radius - 0.01])
    linear_extrude(key_extent_y)
    key_profile(hole);
}


module screw(hole = false) {
    $fn = 36;

    module cap() {
        translate([0, 0, screw_length / 2])
        if (hole) {
            cylinder(h = screw_cap_height, r1 = screw_cap_radius, r2 = screw_cap_radius + screw_cap_height);
        } else {
            cylinder(h = screw_cap_height, r = screw_cap_radius);
        }
    }

    cylinder(h = screw_length + screw_cap_height, r = screw_radius, center = true);

    cap();

    mirror([0, 0, 1])
    cap();
}


module handle_profile() {
    rotate(30)
    offset(handle_rounding, $fn = 24)
    circle(handle_radius - handle_rounding, $fn = 6);
}

module handle_tip() {
    linear_extrude(handle_radius, scale = 0.8)
    handle_profile();
}

module handle_bar() {
    for (a = [0, 180])
    rotate([90, 0, a]) {
        translate([0, 0, key_bend_radius])
        linear_extrude(handle_bar_length / 2 - handle_radius - key_bend_radius)
        handle_profile();

        translate([0, 0, handle_bar_length / 2 - handle_radius])
        handle_tip();
    }
}

module handle_stem() {
    rotate([90, 0, 90]) {
        translate([0, 0, key_bend_radius])
        linear_extrude(handle_stem_length - handle_radius - key_bend_radius)
        handle_profile();

        translate([0, 0, handle_stem_length - handle_radius])
        handle_tip();
    }
}

module handle_screw_loop() {
    $fn = 96;

    r = handle_radius * handle_screw_loop_f;
    x = r * sqrt(2);
    y = x * tan(22.5);

    module bend() {
        translate([0, - r, 0])
        rotate([0, 0, 90])
        rotate_extrude(angle = 45)
        translate([r, 0])
        handle_profile();

        translate([- x, r - y, 0])
        rotate([0, 0, -90])
        rotate_extrude(angle = 45)
        translate([r, 0])
        handle_profile();
    }

    translate([0, y, 0]) {
        bend();

        mirror([1, 0, 0])
        bend();
    }
}

module handle_screw_loop_hole() {
    r = handle_radius * handle_screw_loop_f;
    x = r * sqrt(2);
    y = x * tan(22.5);

    translate([0, y, 0]) {
        screw(hole = true);

        %screw();
    }
}

module handle() {
    module handle_base() {
        handle_bar();
        handle_stem();

        key_bend()
        handle_profile();

        mirror([0, 1, 0])
        key_bend()
        handle_profile();

        translate(screw_loop_position)
        handle_screw_loop();
    }

    difference() {
        handle_base();

        key(hole = true);

        translate([0, - handle_bar_length / 4, 0])
        screw(hole = true);

        translate(screw_loop_position)
        handle_screw_loop_hole();
    }

    %key();

    translate([0, - handle_bar_length / 4, 0])
    %screw();
}


handle();
