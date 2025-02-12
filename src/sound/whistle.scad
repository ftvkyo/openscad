wall = 2;

tube_ir = 20.5 / 2;
tube_or = 26 / 2;
thing_or = tube_or + wall;

cuff = 15;
tip = 20;

E = 0.01;
$fn = 72;


module thing() {
    module positive() {
        module side_profile() {
            polygon([
                [- thing_or, -10],
                [- thing_or, cuff],
                [- thing_or + 5, cuff + 5],
                [- thing_or + 5, cuff + tip],
                [- thing_or + 10, cuff + tip],
                [- thing_or + 10, cuff + 15],
                [thing_or, cuff],
                [thing_or, -10],
            ]);
        }

        intersection() {
            cylinder(cuff + tip, r = thing_or);

            rotate([90, 0, 0])
            linear_extrude(thing_or * 2, center = true)
            side_profile();
        }
    }

    module negative() {
        module side_profile() {
            polygon([
                [- thing_or + 4.5, -10],
                [- thing_or + 4.5, cuff + 15],
                [- thing_or + 10, cuff + 15],
                [thing_or, cuff],
                [thing_or, -10],
            ]);
        }

        cylinder(cuff, r = tube_or);

        off = 8.3;
        w = 10;

        difference() {
            union() {
                translate([-7.5, 0, 0])
                cube([2, w, (cuff + tip) * 3], center = true);

                intersection() {
                    cylinder(cuff + tip + E * 2, r = tube_ir);

                    rotate([90, 0, 0])
                    linear_extrude(thing_or * 2, center = true)
                    offset(- wall)
                    side_profile();
                }
            }

            translate([-10.1, 0, cuff + off])
            rotate([0, 5, 0])
            cube([4, w * 2, 10], center = true);
        }

        translate([-10.75, 0, cuff + off + 1.75])
        rotate([0, 16, 0])
        cube([4, w, 8], center = true);
    }

    difference() {
        positive();

        color("red")
        translate([0, 0, -E])
        negative();
    }
}

thing();

// projection(cut = true)
// rotate([90, 0, 0])
// thing();
