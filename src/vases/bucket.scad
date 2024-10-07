radius = 75;
height = 150;
expand = 1.2;

rounding = 25;

$fn = 120;

module base() {
    linear_extrude(height, scale = expand, twist = 30, slices = 90)
    offset(- rounding)
    offset(rounding * 2)
    offset(- rounding) {
        circle(radius, $fn = 6);

        rotate(30)
        circle(radius, $fn = 6);
    }
}

base();
