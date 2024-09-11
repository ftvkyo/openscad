_pic = [142, 0.8, 191];
_p = 4; // Padding
_m = 4; // Margin
_t = 5; // Thickness

module pic() {
    color("#aaaaaa")
        cube(_pic, center = true);
}

module frame() {
    module window() {
        cube([_pic.x - _p * 2, _t * 2, _pic.z - _p * 2], center = true);
    }

    module frame() {
        cube([_pic.x + _m * 2, _t, _pic.z + _m * 2], center = true);
    }

    difference() {
        frame();

        window();

        // Slot
        pic();
        // Cutout on top
        translate([0, 0, _m * 2])
            pic();
    }
}

module base() {
    module frame() {
        cube([_pic.x + _m * 2, _t + 0.1, _pic.z + _m * 2], center = true);
    }

    difference() {
        rotate([90, 0, 90])
        linear_extrude(_pic.x + _m * 2 - 0.025, center = true)
            polygon([
                [- _m, - _m] * 2,
                [0, _p],
                [_m, - _m] * 2,
            ]);

        translate([0, 0, _pic.z / 2])
            frame();
    }
}


module export1() {
    intersection() {
        rotate([90, 0, 90])
            frame();

        translate([0, 0, -500])
            cube(1000, center = true);
    }
}

module export2() {
    base();
}


export1();
export2();
