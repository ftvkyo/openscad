width = 35;
hole = 10;

thickness = 5;
flatten = 4;

ring = width / 2;

module profile() {
    intersection() {
        circle(thickness / 2, $fn = 48);
        square([thickness, flatten], center = true);
    }
}

module corner() {
    intersection() {
        sphere(thickness / 2, $fn = 48);
        cube([thickness, thickness, flatten], center = true);
    }
}

module bar(l) {
    rotate([90, 0, 0])
    linear_extrude(l, center = true)
    profile();

    translate([0, l / 2, 0])
    corner();

    translate([0, - l / 2, 0])
    corner();
}

module arc(r) {
    rotate_extrude(angle = 90, $fn = 90)
    translate([r, 0])
    profile();
}

module ring(r) {
    rotate_extrude($fn = 90)
    translate([r, 0])
    profile();
}

module side() {
    arc_r = hole + thickness;

    translate([(width + thickness) / 2, 0, 0]) {
        translate([hole + thickness, 0, 0])
        bar(width + thickness);

        translate([hole + thickness, arc_r + thickness / 2 + width / 2, 0])
        rotate([0, 0, 180])
        arc(arc_r);
    }

    bar_l = (sqrt(2) - 1) * arc_r + sqrt(2) * width / 2 + thickness / 2 - ring;

    rotate([0, 0, 45])
    translate([0, bar_l / 2 + ring, 0])
    bar(bar_l);
}

module all() {
    for (a = [0, 90, 180, 270])
    rotate([0, 0, a])
    side();

    ring(ring);
}

all();
