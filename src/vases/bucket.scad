side = 150;
height = 150;
expand = 1.2;

rounding = 20;

$fn = 120;

module base() {
    linear_extrude(height, scale = expand)
    offset(rounding)
    offset(-rounding)
        square(side, center = true);
}

base();
