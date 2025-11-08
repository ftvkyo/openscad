$fn = 48;

side = 18.1;
height = 9.39;

shell_t = 2;
shell_r = 0.75;
shell_shear = 0.7;

stem_h = 7.5;
stem_d = 5.54;
stem_hole_w = 1.35;
stem_hole_d = 4.1;
stem_hole_r = 0.3;

rib_h = 1.5;
rib_w = 2;


module stem() {
    linear_extrude(stem_h)
    difference() {
        scale([1.1, 1])
        circle(stem_d / 2);

        offset(-stem_hole_r)
        offset(stem_hole_r) {
            square([stem_hole_w, stem_hole_d], center = true);
            square([stem_hole_d, stem_hole_w], center = true);
        }
    }

    translate([0, side * (1 - shell_shear) * 0.75 / 2, height - rib_h * 2])
    linear_extrude(rib_h) {
        square([rib_w, side * shell_shear], center = true);
    }

    translate([0, 0, height - rib_h * 2])
    linear_extrude(rib_h) {
        square([side * shell_shear, rib_w], center = true);
    }
}


module shell() {
    m = [
        [1, 0, 0, 0],
        [0, 1, (1 - shell_shear) * 0.75, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
    ];

    multmatrix(m)
    linear_extrude(height, scale = shell_shear, convexity = 4)
    offset(shell_r)
    offset(- shell_r)
    difference() {
        square([side, side], center = true);
        square([side - shell_t * 2, side - shell_t * 2], center = true);
    }

    translate([0, side * (1 - shell_shear) * 0.75 / 2, height - shell_t / 2])
    linear_extrude(shell_t, center = true)
    offset(shell_r)
    offset(- shell_r - shell_t / 2)
        square([side, side] * shell_shear, center = true);
}


module assembly() {
    difference() {
        union() {
            stem();
            shell();
        }

        top_side = side * shell_shear * 1.2;

        translate([0, side * (1 - shell_shear) * 0.75 / 2, height + 0.5])
        scale([1, 1, 0.15])
        rotate([90, 0, 0])
            cylinder(top_side, r = top_side / 2, center = true);
    }
}


assembly();
