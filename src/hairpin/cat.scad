use <../../lib/ops.scad>


diameter = 60;
thickness = 5;

ear_factor = 4/5;
ear_angle = 75;

whisker_factor = 3/5;
whisker_angles = [15, -15];

/* [Hidden] */

fn_extrude = 120;
fn_profile = 36;

$fn = fn_extrude;


module profile() {
    circle(thickness / 2, $fn = fn_profile);
}

module head() {
    rotate_extrude()
    translate([diameter / 2, 0])
        profile();
}

module ear() {
    r = diameter / 2 * ear_factor;
    a = 60;

    module side() {
        translate([-r, 0, 0])
        rotate_extrude(angle = a)
        translate([r, 0])
            profile();
    }

    ear_width = r * cos(a) * 2;
    ear_height = r * sin(a);
    ear_lift = sin(acos(ear_width / diameter)) * diameter / 2;

    translate([0, ear_lift, 0]) {
        // Right side
        translate([ear_width / 2, 0, 0]) {
            side();
            sphere(thickness / 2, $fn = fn_profile);
        }

        // Left side
        translate([- ear_width / 2, 0, 0]) {
            mirror([1, 0, 0]) side();
            sphere(thickness / 2, $fn = fn_profile);
        }

        // Tip
        translate([0, ear_height, 0])
            sphere(thickness / 2, $fn = fn_profile);
    }
}

module whisker() {
    l = diameter / 2 * whisker_factor;

    translate([diameter / 2, 0, 0])
    rotate([0, 90, 0]) {
        cylinder(l, r = thickness / 2, $fn = fn_profile);
        translate([0, 0, l])
            sphere(thickness / 2, $fn = fn_profile);
    }
}


module pin(t) {
    l = diameter * (1 + whisker_factor);

    module all() {
        rotate([0, 90, 0]) {
            cylinder(l, r = t / 2, center = true, $fn = fn_profile);
            translate([0, 0, l / 2]) sphere(t / 2, $fn = fn_profile);
            translate([0, 0, - l / 2]) sphere(t / 2, $fn = fn_profile);
        }
    }

    flatten(thickness * 4/5)
        all();
}


module shape() {
    module whiskers_side() {
        for (a = whisker_angles) {
            rotate([0, 0, a])
                whisker();
        }
    }

    module all() {
        head();

        rotate([0, 0, ear_angle / 2])
            ear();

        rotate([0, 0, - ear_angle / 2])
            ear();

        whiskers_side();

        rotate([0, 0, 180])
            whiskers_side();
    }

    difference() {
        flatten(thickness * 4/5)
            all();

        translate([0, 0, thickness * 5/8])
            // Widen the gap slighlty
            pin(thickness + 1/2);
    }
}


shape();

translate([0, - diameter / 2 - thickness * 2, 0])
    pin(thickness);
