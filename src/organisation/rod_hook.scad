use <../../lib/util.scad>

rod_r = 25.4 / 2 + 0.5;

hook_t = 10;
hook_w = 20;
hook_r = 25.4;
hook_l = 25.4 * 3;

module profile() {
    $fn = 6;
    f = 0.7;
    intersection() {
        scale([hook_t, hook_w / f] / 2)
        rotate(180 / $fn)
        circle();

        square([hook_t, hook_w], center = true);
    }
}

module profile_half() {
    half2("x+")
    profile();
}

module end() {
    $fn = 36;
    rotate_extrude()
    profile_half();
}

module hook() {
    $fn = 120;
    a = 195;

    linear_extrude(hook_l)
    profile();

    top = [- rod_r - hook_t / 2, 0, hook_l];
    bottom = [hook_r + hook_t / 2, 0, 0];

    for (t = [top, bottom]) {
        translate(t)
        rotate([270, 0, 180])
        rotate_extrude(angle = a)
        translate(t)
        profile();

        translate([t.x, 0, t.z])
        rotate([0, 180 - a, 0])
        translate([t.x, 0, 0])
        rotate([270, 0, 0])
        end();
    }

}

hook();
