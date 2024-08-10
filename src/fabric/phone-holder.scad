
thickness = 2;
height = 15;

hole_phone = [77.5, 9];
hole_holster = [25, 7.5];
hole_strap = [25, 2.5];


module bracket(hole, thickness, height) {
    $fn = 48;
    rounding = thickness * 0.49;

    linear_extrude(height)
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

    translate([1 / 4, 0, height / 4])
        cube([hole_phone.x + 0.5, hole_phone.y / 2, height / 2 + 1], center = true);
}

translate([
    hole_phone.x / 2 - hole_holster.x / 2,
    (hole_phone.y + hole_holster.y) / 2 + thickness,
    0,
])
bracket(hole_holster, thickness, height);

translate([
    - hole_phone.x / 3 + hole_strap.x / 3,
    (hole_phone.y + hole_strap.y) / 2 + thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);

translate([
    - hole_phone.x / 3 + hole_strap.x / 3,
    - (hole_phone.y + hole_strap.y) / 2 - thickness,
    0,
])
bracket(hole_strap, thickness, height / 2);
