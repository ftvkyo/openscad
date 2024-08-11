
thickness = 2;
height = 20;

hole_phone = [77.5, 9];
hole_holster = [25, 7.5];
hole_strap = [25, 2.5];

power_button_offset = 7;


module bracket(hole, thickness, height) {
    $fn = 48;
    rounding = thickness * 0.49;

    linear_extrude(height, convexity = 4)
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


difference() {
    bracket(hole_phone, thickness, height);

    translate([0, 0, height / 2 - power_button_offset])
        cube([hole_phone.x + 1, hole_phone.y / 2, height], center = true);
}

translate([
    hole_phone.x / 2 - hole_holster.x / 2,
    (hole_phone.y + hole_holster.y) / 2 + thickness,
    0,
])
bracket(hole_holster, thickness, height);

translate([
    - hole_phone.x / 4 + hole_strap.x / 4,
    (hole_phone.y + hole_strap.y) / 2 + thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);

translate([
    - hole_phone.x / 4 + hole_strap.x / 4,
    - (hole_phone.y + hole_strap.y) / 2 - thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);
