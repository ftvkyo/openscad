use <../../lib/util.scad>


bearing_outer_r = 11.0;
bearing_inner_r = 4.05;
bearing_h = 7.0;

roller_r = 20.0;
roller_h = 40.0;
roller_corner = 1.0;

handle_l = 100.0;

$fn = $preview ? 48 : 96;


module bearing() {
    linear_extrude(bearing_h, center = true)
    difference() {
        circle(bearing_outer_r);
        circle(bearing_inner_r);
    }
}


module roller() {
    c = 2.0;

    rotate_extrude()
    polygon([
        [bearing_outer_r, roller_h / 2 - bearing_h - c * 2],
        [bearing_outer_r - c, roller_h / 2 - bearing_h - c],
        [bearing_outer_r, roller_h / 2 - bearing_h],
        [bearing_outer_r, roller_h / 2 - roller_corner],
        [bearing_outer_r + roller_corner, roller_h / 2],
        [roller_r - roller_corner, roller_h / 2],
        [roller_r, roller_h / 2 - roller_corner],
        [roller_r, - roller_h / 2 + roller_corner],
        [roller_r - roller_corner, - roller_h / 2],
        [bearing_outer_r + roller_corner, - roller_h / 2],
        [bearing_outer_r, - roller_h / 2 + roller_corner],
        [bearing_outer_r, - roller_h / 2 + bearing_h],
        [bearing_outer_r - c, - roller_h / 2 + bearing_h + c],
        [bearing_outer_r, - roller_h / 2 + bearing_h + c * 2],
    ]);
}


module handle() {
    c = 2.0;

    intersection() {
        rotate_extrude()
        half2() {
            translate([0, handle_l / 2 + roller_h / 2])
            circle(bearing_inner_r);

            translate([0, - handle_l / 2 - roller_h / 2])
            circle(bearing_inner_r);

            square([bearing_inner_r * 2, handle_l + roller_h], center = true);

            polygon([
                [bearing_inner_r, roller_h / 2 - bearing_h],
                [bearing_inner_r + c, roller_h / 2 - bearing_h - c],
                [bearing_inner_r, roller_h / 2 - bearing_h - c * 2],
            ]);

            polygon([
                [bearing_inner_r, - roller_h / 2 + bearing_h + c * 2],
                [bearing_inner_r + c, - roller_h / 2 + bearing_h + c],
                [bearing_inner_r, - roller_h / 2 + bearing_h],
            ]);
        }

        cube([bearing_inner_r * 4, bearing_inner_r * 8/5, handle_l + roller_h + bearing_inner_r * 2], center = true);
    }
}


%translate([0, 0, roller_h / 2 - bearing_h / 2])
bearing();

%translate([0, 0, - roller_h / 2 + bearing_h / 2])
bearing();

roller();

handle();
