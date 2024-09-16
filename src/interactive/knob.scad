$fn = 24;
fn_ball = 12;
fn_bearing = 36;


module bearing(
    shell_outer_diameter,
    shell_inner_diameter,
    shell_height,
    ball_count,
    ball_diameter,
    ball_margin,
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
    gap_outer_w = gap_ball_r / 2;

    // Radius of the crossection of the torus part of the cage
    cage_r = ball_diameter / 3;
    // Space allocated for a ball in the cage
    cage_ball_r = ball_diameter / 2 + ball_margin;
    // Width of the structural flat ring part of the cage
    cage_w = gap_inner_w - ball_margin;

    module repeat_balls() {
        for (a = [360 / ball_count : 360 / ball_count : 360]) {
            rotate([0, 0, a])
            translate([diameter / 2, 0, 0])
                children();
        }
    }

    module ball() {
        color("grey")
            sphere(ball_diameter / 2, $fn = fn_ball);
    }

    module shell() {
        module profile() {
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
                translate([diameter / 2 - gap_ball_r + gap_inner_w / 2, 0])
                    square([gap_inner_w, shell_height / 2], center = true);

                translate([diameter / 2 + gap_ball_r - gap_outer_w / 2, shell_height / 2])
                    square([gap_outer_w, shell_height / 2], center = true);

                translate([diameter / 2 + gap_ball_r - gap_outer_w / 2, - shell_height / 2])
                    square([gap_outer_w, shell_height / 2], center = true);
            }

            difference() {
                base();
                ball_groove();
                gap();
            }
        }

        rotate_extrude($fn = fn_bearing)
            profile();
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
            rotate_extrude($fn = fn_bearing)
                cage_profile();

            translate([0, 0, shell_height / 4])
            repeat_balls()
                cage_ball();
        }
    }

    translate([0, 0, shell_height / 4])
    repeat_balls()
        ball();

    translate([0, 0, - shell_height / 4])
    repeat_balls()
        ball();

    color("#00FF00")
        shell();

    color("#FF0000")
        cage();

    color("#FF0000")
    mirror([0, 0, 1])
        cage();
}


module assembly() {
    bearing(
        shell_outer_diameter = 30,
        shell_inner_diameter = 15,
        shell_height = 20,
        ball_diameter = 3.5,
        ball_count = 12,
        ball_margin = 0.3
    );
}

module projections() {
    projection(cut = true)
    rotate([90, 0, 0])
        assembly();

    translate([0, - 20 - 1])
    projection(cut = true)
    rotate([90, 360 / 24, 0])
        assembly();
}

// assembly();
projections();
