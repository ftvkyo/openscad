E = 0.001;
INF = 10 ^ 5;

thickness = 1.6;
height = 20;

hole_phone = [77.5, 9];
hole_holster = [25, 7.5];
hole_strap = [25, 2.5];

power_button_offset = 7;


module bracket(hole, thickness, height) {
    $fn = 48;
    rounding = thickness * 0.49;

    linear_extrude(height, convexity = 10)
    offset(rounding)
    offset(- rounding)
    difference() {
        square([
            hole.x + thickness * 2,
            hole.y + thickness * 2,
        ], center = true);

        square(hole, center = true);
    }
}


module brrrracket(hole, thickness, height) {
    $fn = 48;
    rounding = thickness * 0.49;

    r_in = hole.y / 2 + thickness;
    r_out = hole.y / 2;

    linear_extrude(height, convexity = 10)
    difference() {
        union() {
            square([
                hole.x - r_out * 2,
                hole.y + thickness * 2,
            ], center = true);

            translate([hole.x / 2 - r_out, 0])
                circle(r = r_in);

            translate([- hole.x / 2 + r_out, 0])
                circle(r = r_in);
        }

        union() {
            square([
                hole.x - r_out * 2,
                hole.y,
            ], center = true);

            translate([hole.x / 2 - r_out, 0])
                circle(r = r_out);

            translate([- hole.x / 2 + r_out, 0])
                circle(r = r_out);
        }
    }
}


module brracket(hole, thickness, height) {
    translate([0, - hole.y / 2, 0])
    intersection() {
        brrrracket([hole.x, hole.y * 2], thickness, height);

        translate([0, INF / 2, height / 2])
            cube([INF, INF, height + 1], center = true);
    }

    translate([0, E, 0])
    intersection() {
        bracket(hole, thickness, height);

        translate([0, - (hole.y + thickness) / 2, height / 2])
            cube([INF, thickness, height + 1], center = true);
    }
}


difference() {
    bracket(hole_phone, thickness, height);

    translate([0, 0, height / 2 + power_button_offset])
        cube([hole_phone.x + 1, hole_phone.y / 2, height], center = true);
}

translate([
    hole_phone.x / 2 - hole_holster.x / 2,
    - (hole_phone.y + hole_holster.y) / 2 - thickness,
    0,
])
rotate([0, 0, 180])
brracket(hole_holster, thickness, height * 2);

translate([
    (- hole_phone.x + hole_strap.x) / 4,
    (hole_phone.y + hole_strap.y) / 2 + thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);

translate([
    (- hole_phone.x + hole_strap.x) / 4,
    - (hole_phone.y + hole_strap.y) / 2 - thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);
