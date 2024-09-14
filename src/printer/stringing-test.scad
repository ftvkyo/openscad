use <../../lib/shape.scad>


$fn = 48;


N = 0.4;
L = N / 2;

r = 5;


linear_extrude(N * 4, center = true)
offset(- 4)
offset(4)
{
    translate([r, 0, 0])
        circle(r);

    translate([- r, 0, 0])
        circle(r);
}

capsule([
    [r, 0, 0],
    [- r, 0, r * 3],
], N * 2);

capsule([
    [- r, 0, 0],
    [r, 0, r * 3],
], N * 2);
