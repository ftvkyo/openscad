height = 75;
radius = 30;
widen = 1.5;
twist = 1;
rounding = 6;

$fn = 48;
N = 0.4;
L = N / 2;
slices = height / L;

module triangle(extent) {
    a = 120;
    p0 = [extent, 0];
    p1 = [p0.x * cos(a) - p0.y * sin(a), p0.x * sin(a) + p0.y * cos(a)];
    p2 = [p1.x * cos(a) - p1.y * sin(a), p1.x * sin(a) + p1.y * cos(a)];

    polygon([p0, p1, p2]);
}

linear_extrude(height, scale = widen, twist = twist * 360 / 6, slices = slices)
offset(- rounding)
offset(rounding * 2)
offset(- rounding) {
    triangle(radius);
    rotate([0, 0, 60])
        triangle(radius);
}
