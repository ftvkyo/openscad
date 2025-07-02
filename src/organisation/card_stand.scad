card_dim = [1.5, 86, 55];

card_slot_count = 10;
card_slot_gap = 2;

card_slot_period = card_slot_gap + card_dim.x;

base_rounding = 5;
base_dim = [
    (card_slot_count - 1) * card_slot_period + card_dim.x,
    card_dim.y,
    10,
];


module card() {
    translate([0, 0, card_dim.z / 2])
    cube(card_dim, center = true);
}

module card_slots() {
    translate([- (card_slot_count - 1) * card_slot_period / 2, - card_dim.y / 2, 0])
    rotate([5, 0, 0])
    for(ix = [0 : card_slot_count - 1])
    translate([ix * card_slot_period, card_dim.y / 2, 0])
    card();
}

module base() {
    intersection() {
        base_h = base_dim.z - base_rounding;
        minkowski() {
            translate([0, - base_rounding / 2, base_h / 2])
            cube([base_dim.x, base_dim.y - base_rounding, base_h], center = true);

            sphere(base_rounding, $fn = 36);
        }

        translate([0, 0, base_dim.z / 2])
        cube(base_dim + [base_rounding, base_rounding, 0] * 2, center = true);
    }
}


difference() {
    base();
    translate([0, 0, 1])
    card_slots();
}
