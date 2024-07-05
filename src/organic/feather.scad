E_NOZZLE = 0.4; // Extrusion width
E_LAYER = E_NOZZLE / 2; // Layer thickness


// Generate a box
// - Along +X
// - Contained in +Z, touches XY
// - Split in half (along) by XZ
module box(l, w, h) {
    translate([
        0,
        - w / 2,
        0,
    ])
        cube([
            l,
            w,
            h,
        ]);
}


// Factor for length of a barb where l = [0, 1]
// determines where the barb is along the vane
function barb_factor(l) = sin(l * 180);


// Generate a whole feather starting at 0, 0, 0 along +X
module feather() {

    // Length of a feather shaft
    shaft_l = 150;
    // Width of a feather shaft
    shaft_w = E_NOZZLE * 6;
    // Height of a feather shaft
    shaft_h = E_LAYER * 3;

    // Base length of a barb
    barb_l = 40;
    // Width of a barb
    barb_w = E_NOZZLE * 2;
    // Height of a barb
    barb_h = E_LAYER;
    
    // Angle for the barbs
    barb_a = 30;
    // Gap between the barbs
    barb_g = E_NOZZLE * 2;
    // How close together to put the barbs along +X
    barb_gx = (barb_g + barb_w) / sin(barb_a);

    // Vane as a fraction of shaft length
    vane_f = 0.8;
    // Vane length
    vane_l = vane_f * shaft_l;
    // Vane start offset
    vane_o = shaft_l - vane_l;
    
    shear = (shaft_w / shaft_l) / 3;
    m1 = [
        [1, 0, 0, 0],
        [shear, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
    ];
    m2 = [
        [1, 0, 0, 0],
        [-shear, 1, 0, 0],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
    ];

    intersection() {
        multmatrix(m1)
            box(shaft_l, shaft_w, shaft_h);
        multmatrix(m2)
            box(shaft_l, shaft_w, shaft_h);
    }
    
    color("green") {
        for (x = [vane_o : barb_gx : shaft_l - barb_gx]) {
            translate([x, 0, (shaft_h - barb_h) / 2]) {
                let (l = (x - vane_o) / vane_l, f = barb_factor(l)) {
                    rotate([0, 0, barb_a])
                        box(barb_l * f, barb_w, barb_h);
                    rotate([0, 0, -barb_a])
                        box(barb_l * f, barb_w, barb_h);
                }
            }
        }
    }

    translate([10, -25, 0])
        cube([shaft_w, 50, shaft_h]);
}


feather();
