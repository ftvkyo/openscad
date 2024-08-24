use <../../lib/shape.scad>

h = 100;


module shard() {
    a = atan2(sqrt(2) / 2, 1 / 2);
    f = h / sqrt(3);

    scale([f / 2, f / 2, f])
    translate([0, 0, sqrt(3) / 6])
    rotate([0, a, 0])
    rotate([0, 0, 45])
        cube(1, center = true);
}

module slice() {
    scale(3 / 2)
    intersection() {
        for (a = [0 : 45 : 359]) {
            rotate([0, 0, a])
                shard();
        }

        translate([0, 0, h / 6])
        cube([h, h, h / 3], center = true);
    }
}


module bottom() {
    $fn = 120;

    translate([0, 0, h / 2])
    rotate([180, 0, 0])
    linear_extrude(h / 2, scale = 1.5, twist = 45, slices = 64) {
        projection(cut = true)
            slice();
    }
}


module vase() {
    translate([0, 0, h / 2])
        slice();

    bottom();

    mirror([1, 0, 0])
        bottom();
}


vase();
