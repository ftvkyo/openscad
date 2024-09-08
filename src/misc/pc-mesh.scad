E = 0.01;

width = 160;
height = 175;
thickness = 1;

tab_width = 12;
tab_height = 2;
tab_gap = 52;

module shape_tab() {
    square([tab_width, tab_height], center = true);
}

module shape() {
    square([width, height], center = true);

    translate([0, tab_height / 2 + height / 2 - E]) {
        shape_tab();

        translate([tab_width / 2 + tab_gap, 0])
            shape_tab();

        translate([- tab_width / 2 - tab_gap, 0])
            shape_tab();
    }

    translate([0, - tab_height / 2 - height / 2 + E]) {
        shape_tab();

        translate([tab_width / 2 + tab_gap, 0])
            shape_tab();

        translate([- tab_width / 2 - tab_gap, 0])
            shape_tab();
    }
}

$fn = 36;

linear_extrude(thickness)
offset(1)
offset(-1)
    shape();
