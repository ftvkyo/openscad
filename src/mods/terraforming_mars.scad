// Player card organiser

thickness = 1;

counter_side = 8.5;
counter_gap = 1;
counter_area = counter_side + counter_gap;

$fn = 36;

/* Generic */

module area(w, h, x, y) {
    translate([x, y])
    square([w, h]);
}

module slot(x, y) {
    translate([x, y])
    offset(1/2)
    offset(-1/2)
    square(counter_side);
}

module counter_large(x, y) {
    module slot_i(i) {
        if (i < 0) {
            slot(x + counter_area * (i + 6), y + counter_side * 2 + counter_gap);
        } else if (i < 6) {
            slot(x + counter_area * i, y + counter_side);
        } else {
            slot(x + counter_area * (i - 5), y - counter_gap);
        }
    }

    for (i = [-5 : 10])
    slot_i(i);
}

module counter_small(x, y) {
    module slot_i(i) {
        if (i < 6) {
            slot(x + counter_area * i, y + counter_side + counter_gap / 2);
        } else {
            slot(x + counter_area * (i - 5), y - counter_gap / 2);
        }
    }

    for (i = [0 : 10])
    slot_i(i);
}

/* Parts */

module insert() {
    square([221, 161]);
}

module area_credits() {
    area(w = 84, h = 46, x = 8, y = 107);
}

module area_steel() {
    area(w = 58, h = 46, x = 94, y = 107);
}

module area_titanium() {
    area(w = 58, h = 46, x = 154, y = 107);
}

module area_plants() {
    area(w = 71, h = 38, x = 8, y = 9);
}

module area_energy() {
    area(w = 61, h = 38, x = 81, y = 9);
}

module area_heat() {
    area(w = 68, h = 38, x = 144, y = 9);
}

module counter_credits() {
    counter_large(x = 29, y = 77);
}

module counter_steel() {
    counter_small(x = 95, y = 85);
}

module counter_titanium() {
    counter_small(x = 155, y = 85);
}

module counter_plants() {
    counter_small(x = 16, y = 51);
}

module counter_energy() {
    counter_small(x = 84, y = 51);
}

module counter_heat() {
    counter_small(x = 149, y = 51);
}

/* Assembly */

module profile() {
    difference() {
        offset(-5)
        offset(5)
        difference() {
            offset(10)
            offset(-10)
            insert();

            area_credits();
            area_steel();
            area_titanium();
            area_plants();
            area_energy();
            area_heat();
        }

        counter_credits();
        counter_steel();
        counter_titanium();
        counter_plants();
        counter_energy();
        counter_heat();
    }
}

linear_extrude(thickness)
profile();
