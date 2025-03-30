enable_chamfer = true;

ec11_base = [11.6, 12.1, 4.5];
ec11_base_cyl_r = 3.8;
ec11_base_cyl_h = 7;

ec11_spin_h = 12.5;
ec11_spin_r = 3.25;
ec11_spin_cut_h = 10;
ec11_spin_cut_o = 1.5;

knob_r = 10;
knob_h = 20;
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

    module base() {
        height_reduction = enable_chamfer ? knob_chamfer : 0;
        offset_reduction = enable_chamfer ? knob_chamfer / 2 : 0;

        linear_extrude(knob_h - knob_chamfer - height_reduction, convexity = 10)
        offset(- offset_reduction)
        profile();
    }

    translate([0, 0, knob_chamfer])
    if (enable_chamfer) {
        minkowski() {
            base();
            chamfer();
        }
    } else {
        base();
    }

    translate([0, 0, 2])
    cylinder(h = 1, r1 = knob_r + 1, r2 = knob_r + E, $fn = 48);
    cylinder(h = 2, r = knob_r + 1, $fn = 48);
}


module hexagon() {
    t = 5;
    r = 1;
    o = r / 2;

    for (a = [0, 60, 120, 180, 240, 300])
    rotate([0, 0, a])
    translate([0, t * sqrt(3) / 2, knob_h + o])
    rotate([0, 90, 0]) {
        cylinder(t, r = r, center = true);

        translate([0, 0, t / 2])
        sphere(r);
    }
}



difference() {
    knob($fn = 24);

    hexagon($fn = 24);

    #ec11($fn = 48);
}
