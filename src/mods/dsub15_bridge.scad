dsub_length = 16.0;
dsub_width = 31.0;

hole_radius = 1.5;
hole_offset = 5.0;
hole_distance = 25.0;

pin_hole_width = 14.0;
pin_hole_length = 8.0;
pin_hole_offset = 5.0;

module single() {
    difference() {
        translate([0, dsub_length / 2])
        square([dsub_width, dsub_length], center = true);

        translate([- hole_distance / 2, hole_offset])
        circle(hole_radius, $fn = 12);

        translate([hole_distance / 2, hole_offset])
        circle(hole_radius, $fn = 12);

        translate([0, pin_hole_offset])
        square([pin_hole_width, pin_hole_length], center = true);
    }
}

single();

rotate([0, 0, 180])
single();
