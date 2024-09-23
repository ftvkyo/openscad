use <../../lib/ops.scad>


L = 0.1;
E = 0.01;


module washer(height, mark) {
    fn = is_undef(mark) ? 36 : mark;

    d_inner = 3.75;
    d_outer = 8;

    difference() {
        cylinder(height, r = d_outer / 2, $fn = fn);

        translate([0, 0, - E / 2])
        cylinder(height + E, r = d_inner / 2, $fn = 36);
    }
}


module set_washers() {
    arrange_row([10, 0, 0]) {
        washer(L * 5, 5);
        washer(L * 6, 6);
        washer(L * 7, 7);
        washer(L * 8, 8);
        washer(L * 9, 9);
        washer(L * 10, 10);
    }
}


repeat_row([0, 10, 0], 4)
    set_washers();
