use <../../lib/shape.scad>

INF = 10 ^ 4;

tl = 30; // Length of top
ta = 30; // Angle of top
bl = 40; // Length of bottom
t = 5; // Thickness
gap = 10;

module antibody() {
    LO = [(gap + t) / 2, 0, 0];

    LTB = [
        LO.x + (gap + t) / 2 * cos(90 - ta),
        LO.y + (gap + t) / 2 * sin(90 - ta),
        0
    ];
    LTT = [
        LTB.x + tl * cos(90 - ta),
        LTB.y + tl * sin(90 - ta),
        0
    ];

    LBT = [
        LO.x,
        - (gap + t) / 2,
        0
    ];
    LBB = [
        LO.x,
        LBT.y - bl,
        0
    ];

    ST = [
        LTT.x + sin(90 - ta) * (gap + t),
        LTT.y - cos(90 - ta) * (gap + t),
        0
    ];
    SB = [
        LTB.x + sin(90 - ta) * (gap + t),
        LTB.y - cos(90 - ta) * (gap + t),
        0
    ];

    module LT() {
        capsule([
            LTB,
            LTT,
        ], t);
    }

    module LB() {
        capsule([
            LBT,
            LBB,
        ], t);
    }

    module S() {
        capsule([
            ST,
            SB,
        ], t);
    }

    module LT_LB() {
        capsule([
            LTB,
            LO,
        ], t / 2);

        capsule([
            LO,
            LBT,
        ], t / 2);
    }

    module LT_S() {
        capsule([
            LTB,
            SB,
        ], t / 2);
    }

    module middle() {
        capsule([
            LO,
            [- LO.x, LO.y, LO.z],
        ], t / 2);
    }

    module half() {
        LT();
        LB();
        LT_LB();

        S();
        LT_S();
    }

    middle();

    half();

    mirror([1, 0, 0])
        half();
}


intersection() {
    antibody();

    translate([0, 0, t / 4])
        cube([INF, INF, t], center = true);
}
