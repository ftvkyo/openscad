use <../../lib/debug.scad>

DEBUG = false;

card = [65, 89];

holder_height = 60;
holder_wall = 2;
holder_gap = 1;

holder_cutout_width = 20;
holder_cutout_rounding = 8;


module card_stack() {
    %color("#FFFFFF66")
    translate([0, 0, holder_height / 2])
    cube([card.x, card.y, holder_height], center = true);
}


module card_holder() {
    module card_stack_expanded() {
        h = holder_height * 2;
        expand = [holder_gap, holder_gap, 0];

        translate([0, 0, h / 2 + 0.01])
        cube([card.x, card.y, h] + expand, center = true);
    }

    module base() {
        module rounder() {
            $fn = 24;
            cylinder(h = holder_wall, r = holder_wall, center = true);
        }

        translate([0, 0, holder_height / 2 - holder_wall / 2])
        minkowski() {
            cube([card.x + holder_gap, card.y + holder_gap, holder_height], center = true);
            rounder();
        }
    }

    module rounden_cutout() {
        $fn = 24;
        offset(holder_cutout_rounding)
        offset(- holder_cutout_rounding * 2)
        offset(holder_cutout_rounding)
        children();
    }

    module cutout_on_yz() {
        points1 = [
            [- holder_cutout_width / 2, holder_height - holder_cutout_rounding],
            [- holder_cutout_width / 2, holder_cutout_rounding],
            [holder_cutout_width / 2, holder_cutout_rounding],
            [holder_cutout_width / 2, holder_height - holder_cutout_rounding],
        ];

        p2_mid = card.y / 2 + holder_cutout_width / 2;

        points2 = [
            [- p2_mid / 2 - holder_cutout_width - holder_cutout_rounding * 2, holder_height + holder_cutout_rounding * 2],
            [- p2_mid / 2 - holder_cutout_width - holder_cutout_rounding * 2, holder_height],
            [- p2_mid / 2 - holder_cutout_width / 2, holder_height],
            [- p2_mid / 2 - holder_cutout_width / 2, holder_height - holder_cutout_rounding * 2],
            [- p2_mid / 2 + holder_cutout_width / 2, holder_height - holder_cutout_rounding * 2],
            [- p2_mid / 2 + holder_cutout_width / 2, holder_height],
            [- p2_mid / 2 + holder_cutout_width + holder_cutout_rounding * 2, holder_height],
            [- p2_mid / 2 + holder_cutout_width + holder_cutout_rounding * 2, holder_height + holder_cutout_rounding * 2],
        ];

        module profile() {
            rounden_cutout()
            polygon(points1);

            rounden_cutout()
            polygon(points2);

            mirror([1, 0])
            rounden_cutout()
            polygon(points2);

        }

        rotate([90, 0, 90])
        if (DEBUG) {
            %translate([0, 0, card.x / 2 + holder_wall + holder_gap]) {
                debug_points(points1);
                debug_points(points2, c = "green");
            }
        } else {
            linear_extrude(card.x + holder_wall * 2 + holder_gap + 1, center = true)
            profile();
        }
    }


    module cutout_on_xy() {
        linear_extrude(holder_height, center = true)
        rounden_cutout()
        square(card - [20, 20], center = true);
    }


    difference() {
        base();

        card_stack_expanded();

        cutout_on_yz();
        cutout_on_xy();
    }
}


card_stack();
card_holder();
