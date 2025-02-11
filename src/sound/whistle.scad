d = 26;
wall = 2;
R = d / 2 + wall;

cuff_h = 20;
whistle_h = 30;

E = 0.02;


module whistle() {
    module shell() {
        intersection() {
            rotate([90, 0, 0])
            linear_extrude(R * 2, center = true)
            polygon([
                [- R, 0],
                [- R, cuff_h + whistle_h],
                [- R + 10, cuff_h + whistle_h],
                [- R + 10, cuff_h + whistle_h - 15],
                [R, cuff_h],
                [R, 0],
            ]);

            cylinder(cuff_h + whistle_h, r = R);
        }
    }

    module inside() {
        difference() {
            intersection() {
                rotate([90, 0, 0])
                linear_extrude(R * 2, center = true)
                polygon([
                    [- R, - E],
                    [- R, cuff_h + whistle_h],
                    [- R + 8, cuff_h + whistle_h + E],
                    [- R + 8, cuff_h + whistle_h - 15],
                    [R, cuff_h - 4],
                    [R, - E],
                ]);

                translate([0, 0, - E])
                cylinder(cuff_h + whistle_h + E * 2, r = d / 2);
            }

            translate([- d / 2 - wall / 2, 0, cuff_h + whistle_h / 2 + 1])
            rotate([0, 1, 0])
            cube([5, d, whistle_h], center = true);
        }
    }

    module wedge() {
        a = 15;

        cube([10, 10, 2], center = true);

        translate([-1, 0, -8])
        rotate([0, 90 + a, 0])
        cube([16, 10, 5], center = true);
    }

    difference() {
        shell();
        inside();

        translate([-R, 0, cuff_h + whistle_h - 10])
        wedge();
    }
}

whistle();
