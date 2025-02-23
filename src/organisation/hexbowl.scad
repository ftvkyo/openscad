use <../../lib/ops.scad>
use <../../lib/maths.scad>
use <../../lib/util.scad>

HOLES = true;

r = 50;
h = 20;
rounden = 5;


module holes() {
    hr = 5.25;
    hd = 10;

    translate([0, 0, - 0.01])
    arrange_hex(hd, 5)
    rotate([0, 0, 360 / 12])
    cylinder(h * 2, r = hr, $fn = 6);
}

// module bowl() {
//     difference() {
//         half3("z+")
//         rounden_xyz(rounden, $fn = 72)
//         translate([0, 0, - rounden])
//         cylinder(h - rounden, r = r - rounden, $fn = 6);

//         f = 2;

//         translate([0, 0, r * f + 5])
//         sphere(r * f, $fn = 180);
//     }
// }

module bowl() {
    module cut_profile() {
        STEPS = 24;

        o = 5;

        p0 = [0, o];
        p1 = [20, o];
        p2 = [r - 20, h];
        p3 = [r, h];

        bz = bezier3([p0, p1, p2, p3], STEPS);
        pts = [ for (i = [
            bz,
            [
                [r * 2, h],
                [r * 2, h * 2],
                [-rounden, h * 2],
                [-rounden, o],
            ],
        ]) each i ];

        offset(- rounden)
        polygon(pts);
    }

    module cut() {
        rounden_xyz(rounden)
        rotate_extrude($fn = 6)
        cut_profile();
    }

    module base() {
        half3("z+")
        rounden_xyz(rounden, $fn = 48)
        cylinder(h - rounden, r = r - rounden, $fn = 6);
    }

    difference() {
        base();
        cut();
    }
}


difference() {
    bowl();
    if (HOLES) {
        holes();
    }
}
