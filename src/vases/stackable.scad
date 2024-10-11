height = 50;
radius = 30;
twist = 60;
expand = 1.5;

$fn = 120;

module profile() {
    offset(- 2)
    offset(2)
    for (a = [0 : 60 : 359])
    rotate([0, 0, a])
    translate([radius * 2/3, 0])
    circle(radius / 3);

    circle(radius / 2);
}

linear_extrude(height, slices = 20, twist = - twist, scale = expand)
profile();
