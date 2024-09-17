/* ========== *
 * Parameters *
 * ========== */


// What to display and export
RENDER = "all"; // ["all", "bearing-outer", "bearing-inner-top", "bearing-inner-bottom", "bearing-cage", "handle"]

// Whether to show the model or its cuts
CUT = false;

// Resolution
$fn = 24; // [12, 24, 36, 48, 60]
// Rotational resolution
fn_rotate_extrude = 36; // [36, 72, 180]

/* [Hidden] */

// Faces on debug balls
fn_debug = 12;

// Floating point error correction
E = 0.01;

// Infinity
INF = 10 ^ 3;


/* ======= *
 * Modules *
 * ======= */


module _render(r) {
    if (RENDER == "all" || RENDER == r)
        children();
}


module bearing(
    shell_height,
    shell_outer_diameter,
    shell_inner_diameter,
    shell_inner_joiner_count,
    shell_inner_joiner_height,
    ball_count,
    ball_diameter,
    ball_margin,
    cage_margin,
) {
    // Diameter where the ball is
    diameter = (shell_outer_diameter + shell_inner_diameter) / 2;

    // Full width of both of the bearing walls together, with the gap
    wall_w = (shell_outer_diameter - shell_inner_diameter) / 2;

    // Clearance around the center of the ball
    gap_ball_r = ball_diameter / 2 + ball_margin;
    // Gap connecting the ball grooves together
    gap_inner_w = gap_ball_r;
    // Gap connecting the ball grooves to the outside
    gap_outer_w = gap_ball_r;

    // Radius of the crossection of the torus part of the cage
    cage_r = ball_diameter / 3;
    // Space allocated for a ball in the cage
    cage_ball_r = ball_diameter / 2 + ball_margin;
    // Width of the structural flat ring part of the cage
    cage_w = gap_inner_w - cage_margin * 2;

    module repeat_balls() {
        for (a = [360 / ball_count : 360 / ball_count : 360]) {
            rotate([0, 0, a])
            translate([diameter / 2, 0, 0])
                children();
        }
    }

    module ball() {
        color("grey")
            sphere(ball_diameter / 2, $fn = fn_debug);
    }

    module shell_profile() {
        module base() {
            translate([(shell_inner_diameter + wall_w) / 2, 0])
                square([wall_w, shell_height], center = true);
        }

        module ball_groove() {
            module single() {
                translate([diameter / 2, shell_height / 4])
                intersection() {
                    rotate(45)
                        square([gap_ball_r * 3, gap_ball_r * 2], center = true);
                    square([gap_ball_r * 2, gap_ball_r * 3], center = true);
                }
            }

            single();

            mirror([0, 1])
                single();
        }

        module gap() {
            // Gap connecting the ball grooves
            translate([diameter / 2 - gap_ball_r + gap_inner_w / 2, 0])
                square([gap_inner_w, shell_height / 2], center = true);

            // Gap connecting the top ball groove to the top of the bearing
            translate([diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 2])
                square([gap_outer_w, shell_height / 2], center = true);

            // Gap connecting the bottom ball groove to the bottom of the bearing
            translate([diameter / 2 + gap_ball_r - gap_outer_w / 2, - shell_height / 2])
                square([gap_outer_w, shell_height / 2], center = true);
        }

        difference() {
            base();
            ball_groove();
            gap();
        }
    }

    module repeat_shell_inner_joiners() {
        for (a = [360 / shell_inner_joiners : 360 / shell_inner_joiners : 360]) {
            rotate([0, 0, a])
            translate([shell_inner_diameter / 2, 0, 0])
                children();
        }
    }

    module shell_inner_joiners() {
        r = shell_inner_diameter / 3;
        rounding = r / 4;

        module repeat_at_d(d) {
            for (a = [360 / shell_inner_joiner_count : 360 / shell_inner_joiner_count : 360]) {
                rotate([0, 0, a])
                translate([d / 2, 0, 0])
                    children();
            }
        }

        module profile() {
            intersection() {
                offset(- rounding)
                offset(rounding) {
                    repeat_at_d(shell_inner_diameter)
                        circle(r);

                    difference() {
                        circle(shell_inner_diameter / 2 + r, $fn = fn_rotate_extrude);
                        circle(shell_inner_diameter / 2 + E, $fn = fn_rotate_extrude);
                    }
                }

                circle(diameter / 2 - gap_ball_r - E, $fn = fn_rotate_extrude);
            }
        }

        module base() {
            linear_extrude(shell_inner_joiner_height, convexity = 10)
                profile();
        }

        if ($children > 0)
            difference() {
                base();

                repeat_at_d(shell_inner_diameter - r)
                translate([0, 0, shell_inner_joiner_height])
                    children();
            }
        else
            base();
    }

    module shell_inner_half() {
        rotate_extrude($fn = fn_rotate_extrude)
        intersection() {
            shell_profile();

            polygon([
                [0, 0],
                [diameter / 2 - gap_ball_r + gap_inner_w / 2, 0],
                [diameter / 2 - gap_ball_r + gap_inner_w / 2, shell_height / 4],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 4],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 2],
                [0, shell_height / 2],
            ]);
        }

        translate([0, 0, E])
        shell_inner_joiners()
            children();
    }

    module shell_outer() {
        rotate_extrude($fn = fn_rotate_extrude)
        intersection() {
            shell_profile();

            polygon([
                [diameter / 2 - gap_ball_r + gap_inner_w / 2, 0],
                [diameter / 2 - gap_ball_r + gap_inner_w / 2, - shell_height / 4],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, - shell_height / 4],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, - shell_height / 2],
                [shell_outer_diameter / 2, - shell_height / 2],
                [shell_outer_diameter / 2, shell_height / 2],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 2],
                [diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 4],
                [diameter / 2 - gap_ball_r + gap_inner_w / 2, shell_height / 4],
            ]);
        }
    }

    module cage_ball() {
        sphere(cage_ball_r);
    }

    module cage_profile() {
        offset(- gap_ball_r / 2)
        offset(gap_ball_r / 2) {
            translate([diameter / 2, shell_height / 4])
                circle(cage_r);

            translate([diameter / 2 - gap_ball_r + gap_inner_w / 2, shell_height * 3 / 20])
                square([cage_w, shell_height / 5], center = true);
        }
    }

    module cage() {
        difference() {
            rotate_extrude($fn = fn_rotate_extrude)
                cage_profile();

            translate([0, 0, shell_height / 4])
            repeat_balls()
                cage_ball();
        }
    }

    _render()
    translate([0, 0, shell_height / 4])
    repeat_balls()
        ball();

    _render()
    translate([0, 0, - shell_height / 4])
    repeat_balls()
        ball();

    _render("bearing-outer")
    color("green")
        shell_outer();

    _render("bearing-inner-top")
    color("blue")
    if ($children > 0) {
        shell_inner_half()
            children(0);
    } else {
        shell_inner_half();
    }

    _render("bearing-inner-bottom")
    color("blue")
    mirror([0, 0, 1])
    if ($children > 1) {
        shell_inner_half()
            children(1);
    } else {
        shell_inner_half();
    }

    _render("bearing-cage")
    color("red")
        cage();

    _render()
    color("red")
    mirror([0, 0, 1])
        cage();
}


module handle(
    handle_d,
    handle_h
) {
    indent_top_scale = 1/12;
    indent_side_scale = 1/6;

    bump_count = 12;
    bump_size = handle_d / 12;
    bump_diameter = handle_d * 7/12; // Distribution

    module profile() {
        r = 2;

        intersection() {
            offset(r)
            offset(-r)
            difference() {
                wf = 6;
                hf = 12;

                translate([0, handle_h / 2])
                    square([handle_d, handle_h], center = true);

                translate([handle_d / 2, 0])
                scale([handle_d * indent_side_scale, handle_h / 2])
                translate([0, 1])
                    circle(1);

                translate([0, handle_h])
                scale([handle_d / 2, handle_h * indent_top_scale])
                    circle(1);
            }

            translate([handle_d / 4, handle_h / 2])
                square([handle_d / 2, handle_h], center = true);
        }
    }

    rotate_extrude($fn = fn_rotate_extrude)
        profile();

    bump_shift = handle_h * indent_top_scale * sin(acos(bump_diameter / handle_d));
    // Discovered by Rubber Duck Miwon:
    bump_tilt = acos(indent_top_scale * bump_diameter / handle_d) + 90;

    translate([
        0,
        0,
        handle_h - bump_shift
    ])
    for(a = [360 / bump_count : 360 / bump_count : 360]) {
        rotate([0, 0, a])
        translate([bump_diameter / 2, 0, 0])
        rotate([0, bump_tilt, 0])
        scale([1, 1, 1/2])
            sphere(bump_size / 2);
    }
}


module screw(
    screw_l,
    screw_d,
    cap_l,
    cap_d
) {
    translate([0, 0, cap_l + E])
    rotate([180, 0, 0]) {
        cylinder(cap_l + screw_l, r = screw_d / 2);
        cylinder(cap_l, r = cap_d / 2);
    }
}


module screw_M2x6(hole = false) {
    screw(
        screw_l = hole ? 6 : 5.5,
        screw_d = hole ? 2 : 1.75,
        cap_l = hole ? INF : 1.75,
        cap_d = hole ? 4 : 3.5
    );
}


module heat_insert(
    insert_l,
    insert_d,
    screw_l,
    screw_d,
) {
    translate([0, 0, E])
    rotate([180, 0, 0]) {
        cylinder(insert_l, r = insert_d / 2);
        if (is_num(screw_d)) {
            cylinder(is_num(screw_l) ? screw_l : INF, r = screw_d / 2);
        }
    }
}


module heat_insert_M2(hole = false) {
    heat_insert(
        insert_l = 3,
        insert_d = hole ? 3.2 : 3.5,
        screw_l = undef,
        screw_d = hole ? 2 : undef
    );
}


module magnet(
    magnet_d,
    magnet_h
) {
    cylinder(magnet_h, r = magnet_d / 2);
}


/* ======== *
 * Assembly *
 * ======== */


module assembly() {
    bearing(
        shell_height = 20,
        shell_outer_diameter = 30,
        shell_inner_diameter = 15,
        shell_inner_joiner_count = 3,
        shell_inner_joiner_height = 4,
        ball_diameter = 3.5,
        ball_count = 12,
        ball_margin = 0.15,
        cage_margin = 0.4
    ) {
        translate([0, 0, - 2]) screw_M2x6(hole = true);
        heat_insert_M2(hole = true);
    }

    _render("handle")
    translate([0, 0, 20])
        handle(
            handle_d = 60,
            handle_h = 30
        );
}

module cuts() {
    intersection() {
        union() {
            translate([25, 0, 0])
            rotate([90, 0, 0])
                assembly();

            translate([-25, 0, 0])
            rotate([90, 360 / 24, 0])
                assembly();
        }

        translate([0, 0, - INF / 2])
            cube(INF, center = true);
    }
}

if (CUT)
    cuts();
else
    assembly();
