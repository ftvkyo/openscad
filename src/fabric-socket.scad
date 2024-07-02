NOZZLE = 0.4;
LAYER = NOZZLE / 2;

side_x = 25;
side_y = 50;
hole = 5;
rounding = 5;

side_max = max(side_x, side_y);
line = NOZZLE * 2;
gap = NOZZLE * 4;
border = NOZZLE * 2;
thickness = LAYER * 5;


module socket_halfgrid() {
    for (xy = [-side_max / 2 : line + gap : side_max / 2]) {
        translate([xy, xy])
        rotate(45)
            square([line, side_max / cos(45)], center=true);
    }
}

module socket_grid() {
    translate([0, NOZZLE]) {
        socket_halfgrid();
        rotate(90)
            socket_halfgrid();
    }
}


module socket_footprint() {
    offset(rounding)
    offset(-rounding)
        square([side_x, side_y], center=true);
}

module socket_border() {
    difference() {
        socket_footprint();
        offset(-border)
            socket_footprint();
    }
}

module socket_hole_footprint() {
    square(hole, center=true);
}

module socket_hole_border() {
    difference() {
        offset(+border)
            socket_hole_footprint();
        socket_hole_footprint();
    }
}

module socket_holes() {

}


module socket() {
    difference() {
        intersection() {
            socket_grid();
            socket_footprint();
        }
        translate([0, side_y / 4])
            socket_hole_footprint();
        translate([0, - side_y / 4])
            socket_hole_footprint();
    }
    socket_border();
    translate([0, side_y / 4])
        socket_hole_border();
    translate([0, - side_y / 4])
        socket_hole_border();
}


module socket_3d() {
    linear_extrude(thickness)
        socket();
}


socket_3d();
