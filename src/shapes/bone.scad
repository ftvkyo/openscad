use <../../lib/util.scad>


t = 5;
l = 60;
r = 10;

$fn = 48;


module profile() {
    intersection() {
        circle(t / 2);

        square([t, t * 4/5], center = true);
    }
}


module connection() {
    rotate_extrude()
    half2()
    profile();
}


module corner() {
    rotate_extrude(angle = 225)
    translate([r, 0])
    profile();
}


module stick(l) {
    rotate([90, 0, 90])
    linear_extrude(l, center = true)
    profile();
}



module pin() {
    sl = l - r * 2;

    module c() {
        translate([- r - sl / 2, 0, 0])
        corner();
    }

    module h() {
        translate([0, r / sqrt(2), 0]) {
            stick(sl);

            translate([sl / 2, 0, 0])
            connection();

            translate([- sl / 2, 0, 0])
            connection();

            c();

            mirror([1, 0, 0])
            c();
        }
    }

    h();

    mirror([0, 1, 0])
    h();

    translate([sl / 2 + r + r / sqrt(2), 0, 0])
    connection();

    translate([- sl / 2 - r - r / sqrt(2), 0, 0])
    connection();
}


pin();
