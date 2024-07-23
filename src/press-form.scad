stock = [270, 165];

hole = [30, 3];
hole_gap = 5;

padding = 5;

ply_t = 3.2;

r = stock.y / 3.141592;


module bendy_hole() {
    offset(-1)
    offset(1)
        square(hole, center = true);
}

module bendy() {
    difference() {

        square(stock + [padding, padding] * 2, center = true);

        for (
            x = [- stock.x : hole_gap + hole.x : stock.x],
            y = [- stock.y - hole_gap : (hole_gap + hole.y) * 2 : stock.y]
        ) {
            translate([x, y])
                bendy_hole();
        }

        for (
            x = [- stock.x + (hole_gap + hole.x) / 2 : hole_gap + hole.x : stock.x],
            y = [- stock.y + hole.y : (hole_gap + hole.y) * 2 : stock.y]
        ) {
            translate([x, y])
                bendy_hole();
        }
    }
}


module support_semicircle() {

    difference() {
        circle(r = r);

        translate([0, - r / 2])
            square([r * 2, r], center = true);

        translate([r / 2, 0])
            square([ply_t, r / 2], center = true);

        translate([- r / 2, 0])
            square([ply_t, r / 2], center = true);
    }
}


module support_leg() {
    h = r / 2;

    difference() {
        translate([0, h / 2])
            square([stock.x, h], center = true);

        translate([0, h])
            square([ply_t, r / 2], center = true);

        translate([stock.x / 3, h])
            square([ply_t, r / 2], center = true);

        translate([- stock.x / 3, h])
            square([ply_t, r / 2], center = true);

    }
}


// translate([0, -150])
    bendy();

// translate([0, 50])
    // support_semicircle();

// support_leg();
