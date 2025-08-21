which = "left"; // [left, right]


crescent_outer_radius = 25.5 / 2;
crescent_inner_radius = 18.2 / 2;
crescent_inner_offset = -5;
crescent_line_width = 1.5;

star_radius = 5;
star_hole_radius = 1.25;

ring_thickness = 1;
ring_radius = 1.5;


module rounder(r, t) {
    $fn = 12;

    rotate_extrude()
    polygon([
        [0, 0],
        [r, 0],
        [0, t],
    ]);
}


module ring() {
    $fn = $preview ? 12 : 48;

    rotate_extrude()
    translate([ring_radius, 0]) {
        translate([0, ring_thickness / 2])
        circle(ring_thickness / 2);

        translate([0, ring_thickness / 4])
        square([ring_thickness, ring_thickness / 2], center = true);
    }
}


module crescent(rounding, thickness) {
    $fn = $preview ? 12 : 96;

    module profile() {
        difference() {
            circle(crescent_outer_radius - rounding);

            translate([crescent_inner_offset, 0])
            circle(crescent_inner_radius + rounding);
        }
    }

    minkowski() {
        linear_extrude(1)
        difference() {
            profile();

            offset(-crescent_line_width)
            profile();
        }

        rounder(rounding, thickness - 1);
    }
}


module star(rounding, thickness) {
    $fn = $preview ? 8 : 24;

    star_radius = star_radius - rounding;

    minkowski() {
        linear_extrude(1)
        difference() {
            for (a = [0, 90, 180, 270]) {
                rotate(a)
                polygon([
                    [- star_radius / 3, 0],
                    [0, star_radius],
                    [star_radius / 3, 0],
                ]);

                rotate(a + 45)
                polygon([
                    [- star_radius / 3, 0],
                    [0, star_radius * 3/4],
                    [star_radius / 3, 0],
                ]);
            }

            circle(star_hole_radius);
        }

        rounder(rounding, thickness - 1);
    }
}


module assembly() {
    crescent(2/3, 2);

    translate([0, crescent_outer_radius, 0])
    ring();

    translate([crescent_inner_offset, crescent_inner_radius, 0])
    ring();

    translate([crescent_inner_offset, 0, 0])
    star(1/3, 1.5);

    translate([crescent_inner_offset, star_radius, 0])
    ring();
}


if (which == "left") {
    assembly();
} else {
    mirror([1, 0, 0])
    assembly();
}
