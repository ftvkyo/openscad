use <../../lib/util.scad>

finger_length = 50;
finger_radius = 10;

arm_radius = 12;
arm_length = 80;

module diamond(r) {
    rotate_extrude($fn = 4)
    half2()
    circle(r, $fn = 4);
}

module arm() {
    translate([- finger_radius * 5/2, 0, 0])
    rotate([0, -90, 0])
    linear_extrude(arm_length)
    circle(arm_radius, $fn = 4);
}

module palm() {
    r = 5;

    minkowski() {
        cube([finger_radius * 6, finger_radius * 3, finger_radius * 6] - [r, r, r] * 2, center = true);

        diamond(r);
    }
}

module finger_thumb() {
    translate([- finger_radius, 0, finger_radius * 3]) {
        linear_extrude(finger_length * 2/3)
        circle(finger_radius, $fn = 4);

        translate([0, 0, finger_length * 2/3])
        diamond(finger_radius);

        diamond(finger_radius);
    }
}

module finger_index() {
    l = finger_length;

    translate([finger_radius * 5/2, 0, finger_radius * 1.5])
    rotate([0, 90, 0]) {
        linear_extrude(l)
        circle(finger_radius, $fn = 4);

        translate([0, 0, l])
        diamond(finger_radius);

        diamond(finger_radius);
    }
}

module finger_middle() {
    l = finger_length * 4/5;

    translate([finger_radius * 5/2, finger_radius, 0])
    rotate([0, -90, 0]) {
        linear_extrude(l)
        circle(finger_radius, $fn = 4);

        translate([0, 0, l])
        diamond(finger_radius);

        diamond(finger_radius);
    }
}

module finger_little() {
    l = finger_length * 3/5;

    translate([finger_radius * 5/2, finger_radius, - finger_radius * 1.5])
    rotate([0, -90, 0]) {
        linear_extrude(l)
        circle(finger_radius, $fn = 4);

        translate([0, 0, l])
        diamond(finger_radius);

        diamond(finger_radius);
    }
}

module pointer() {
    arm();
    palm();
    finger_thumb();
    finger_index();
    finger_middle();
    finger_little();
}


module repoint() {
    translate([130, 0, finger_radius * 3/2])
    scale(1/2)
    children();
}

module repointer() {
    pointer();

    repoint()
    pointer();

    repoint()
    repoint()
    pointer();
}



if ($preview) {
    repointer();
} else {
    half3() {
        rotate([90, 0, 0])
        translate([0, 0, 40])
        repointer();

        rotate([-90, 0, 0])
        translate([0, 0, 40])
        repointer();
    }
}
