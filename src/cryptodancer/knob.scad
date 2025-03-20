ec11_base = [11.6, 12.1, 4.5];
ec11_base_cyl_r = 3.8;
ec11_base_cyl_h = 7;

ec11_spin_h = 12.5;
ec11_spin_r = 3.25;
ec11_spin_cut_h = 10;
ec11_spin_cut_o = 1.5;

knob_r = 8;
knob_h = 25;
knob_chamfer = 1;

E = 0.01;


module ec11() {
    translate([0, 0, -0.5]) {
        translate([0, 0, - ec11_base.z / 2 + E])
        cube(ec11_base, center = true);

        cylinder(h = ec11_base_cyl_h, r = ec11_base_cyl_r);

        difference() {
            cylinder(h = ec11_base_cyl_h + ec11_spin_h, r = ec11_spin_r);

            translate([ec11_spin_r / 2 + ec11_spin_cut_o, 0, ec11_base_cyl_h + ec11_spin_h - ec11_spin_cut_h / 2 + E])
            cube([ec11_spin_r, ec11_spin_r * 2, ec11_spin_cut_h], center = true);
        }
    }
}


module knob() {
    module chamfer() {
        rotate_extrude()
        polygon([
            [0, knob_chamfer],
            [knob_chamfer, 0],
            [0, -knob_chamfer],
        ]);
    }

    module profile() {
        offset(- knob_chamfer)
        offset(knob_chamfer)
        for (a = [0, 30, 60, 90]) {
            rotate([0, 0, a])
            circle(knob_r, $fn = 3);
        }
    }

    translate([0, 0, knob_chamfer])
    minkowski() {
        linear_extrude(knob_h - knob_chamfer * 2)
        offset(- knob_chamfer / 2)
        profile();

        chamfer();
    }

    translate([0, 0, 2])
    cylinder(h = 1, r1 = knob_r + 1, r2 = knob_r + E, $fn = 48);
    cylinder(h = 2, r = knob_r + 1, $fn = 48);
}


difference() {
    knob($fn = 24);

    #ec11($fn = 48);
}
