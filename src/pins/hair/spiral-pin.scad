use <../../../lib/shape.scad>

module pin() {
    rotate([90, 0, 0])
        spiral(100, 3, 4/5, 4.5, 0.5, center = true);

    translate([0.8, 50, 0])
        sphere(5, $fn = 36);
}


pin();
