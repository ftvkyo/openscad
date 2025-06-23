stem = 4.4;
r = 5;

$fn = 72;

linear_extrude(3)
offset(0.2)
offset(-0.2)
difference() {
    circle(r);

    circle(stem / 2);

    translate([r, 0])
    square([r * 2, stem - 0.6], center = true);
}
