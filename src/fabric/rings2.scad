use <../../lib/shape.scad>


module triangle(side, thickness) {
    flatten(thickness * 2 / 3)
        multiring(3, side, thickness);
}


module diamond(side, thickness) {
    shift = - (side + thickness) / 4 / cos(30);

    translate([shift, 0])
        triangle(side, thickness);

    rotate([0, 0, 180])
    translate([shift, 0])
        triangle(side, thickness);
}


// triangle(40, 6);
diamond(40, 6);
