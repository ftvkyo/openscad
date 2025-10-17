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


module key_profile(hole) {
    key_radius = hole ? key_radius + 0.1 : key_radius;

    if (hole) {
        intersection() {
            rotate(45)
            square(key_radius * 2, center = true);

            square([key_radius * sqrt(2), key_radius * 2.2], center = true);
        }
    }

    circle(key_radius);
}

module key_bend(r) {
    translate([key_bend_radius, key_bend_radius])
    rotate([0, 0, 180])
    rotate_extrude(angle = 90)
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
        rotate_extrude()
        if (hole) {
            polygon([
                [0, 0],
                [screw_cap_radius, 0],
                [screw_cap_radius + screw_cap_height, screw_cap_height],
                [0, screw_cap_height],
            ]);
        } else {
            square([screw_cap_radius, screw_cap_height]);
        }
    }

    translate([0, - handle_bar_length / 4, 0]) {
        cylinder(h = screw_length + screw_cap_height, r = screw_radius, center = true);

        cap();

        mirror([0, 0, 1])
        cap();
    }
}


module handle_profile() {
    rotate(30)
    circle(handle_radius - handle_rounding, $fn = 6);
}

module handle_tip() {
    linear_extrude(handle_radius - handle_rounding, scale = 0.8)
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

module handle() {
    difference() {
        minkowski() {
            union() {
                handle_bar();
                handle_stem();

                key_bend()
                handle_profile();

                mirror([0, 1, 0])
                key_bend()
                handle_profile();
            }

            sphere(handle_rounding, $fn = 24);
        }

        key(hole = true);

        screw(hole = true);
    }
}


%key();

%screw();

handle();
