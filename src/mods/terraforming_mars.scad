// Player resources organiser (tray)


/* [Tray properties] */

padding = 5;
height = 5;
thickness = 2;
section_y = 30;

/* [Counter properties] */

counter_side = 8.5;
counter_gap = 1;


module __hidden__() {}

$fn = 36;


// Section in the middle with the counters
counter_cols = 6;
counter_rows = 5;
counter_area_x = (counter_side + counter_gap) * counter_cols - counter_gap;
counter_area_y = (counter_side + counter_gap) * counter_rows + counter_gap;

// How many a single vertical section repeats
tray_cols = 3;

// Total tray size
tray_x = padding + (counter_area_x + padding) * tray_cols;
tray_y = padding + (counter_area_y + padding) + (section_y + padding) * 2;


/* ======= *
 * Generic *
 * ======= */

module area(x, y) {
    offset(padding)
    offset(- padding)
    square([x, y]);
}

module slot(col, row) {
    translate([col * (counter_side + counter_gap), row * (counter_side + counter_gap)])
    offset(1/2)
    offset(-1/2)
    square(counter_side);
}

module counter_large() {
    for (col = [0 : 5], row = [0 : 2])
    slot(col, row);
}

module counter_small() {
    for (col = [0 : 5], row = [0 : 1])
    slot(col, row);
}

/* ===== *
 * Parts *
 * ===== */

module base(x, y) {
    translate([- padding, - padding])
    offset(padding * 2)
    offset(- padding * 2)
    square([x, y]);
}

module profile() {
    difference() {
        base(tray_x, tray_y);

        // All areas

        for (col = [0 : tray_cols - 1])
        translate([(counter_area_x + padding) * col, 0]) {
            area(counter_area_x, section_y);

            translate([0, counter_area_y + section_y + padding * 2])
            area(counter_area_x, section_y);
        }

        // Top counters

        for (col = [1 : tray_cols - 1])
        translate([(counter_area_x + padding) * col, counter_area_y + section_y + padding])
        mirror([0, 1])
        counter_small();

        translate([0, counter_area_y + section_y + padding])
        mirror([0, 1])
        counter_large();

        // Bottom counters

        for (col = [0 : tray_cols - 1])
        translate([(counter_area_x + padding) * col, section_y + padding])
        counter_small();
    }
}

color("grey")
linear_extrude(thickness)
base(tray_x, tray_y);

linear_extrude(height)
profile();
