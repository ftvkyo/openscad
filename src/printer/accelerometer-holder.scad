use <../../lib/fasteners.scad>

bed_length = 235;
bed_thickness = 5;

accel_holes_dx = 32;

$fn = 48;


module holder() {
    t = 5;

    module profile() {
        offset(1)
        offset(-1)
        polygon([
            [  bed_length / 2 + t, 0],
            [  bed_length / 2 + t, - t - bed_thickness - t],
            [  bed_length / 2 - t, - t - bed_thickness - t],
            // [  bed_length / 2 - t, - t - bed_thickness],
            [  bed_length / 2,     - t - bed_thickness],
            [  bed_length / 2,     - t],
            [- bed_length / 2,     - t],
            [- bed_length / 2,     - t - bed_thickness],
            // [- bed_length / 2 + t, - t - bed_thickness],
            [- bed_length / 2 + t, - t - bed_thickness - t],
            [- bed_length / 2 - t, - t - bed_thickness - t],
            [- bed_length / 2 - t, 0],
        ], convexity = 10);
    }

    difference() {
        rotate([-90, 0, 90])
        linear_extrude(accel_holes_dx + t * 2, center = true)
        profile();

        for (x = [- accel_holes_dx / 2, accel_holes_dx / 2])
        translate([x, 0, 0])
        rotate([180, 0, 0])
        heat_insert_M2(true);

        cube([accel_holes_dx - t * 2, bed_length - t * 2, t * 3], center = true);
    }
}

holder();
