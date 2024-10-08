use <../../lib/maths.scad>

// Height
h = 120;

// Sides of the base polygon
f = 6;
// Radius of the base polygon
r = 35;

// Slices
s = 36;
// Determines twist based on the slice
function t(sn) = _bezier3([0, 120, -180, 30], sn / (s - 1)) / s;
// Determines scale based on the slice
function e(sn) = _bezier3([1, 2, 0.5, 1.2], sn / s);


module __hidden__() {}

$fn = 12;
E = 0.01;


module rounden(r) {
    offset(- r)
    offset(r * 2)
    offset(- r)
    children();
}

module profile() {
    circle(r, $fn = f);

    module corners(r) {
        for (a = [1 : f])
        rotate(360 * a/f)
        translate([r, 0]) {
            circle(r / 3, $fn = f);

            children();
        }
    }

    corners(r)
    corners(r / 3);
}

module vase() {
    module slice(sn) {
        twist = t(sn);

        scale_start = e(sn);
        scale_end = e(sn + 1) / scale_start;

        scale([scale_start, scale_start, 1])
        linear_extrude(h / s + E, slices = 4, twist = twist, scale = scale_end)
        rounden(3)
        profile();

        rotate([0, 0, - twist])
        translate([0, 0, h / s])
        children();
    }

    module reslice(recur = 0) {
        if (recur < s) {
            slice(recur)
            reslice(recur + 1)
            children();
        }
    }

    reslice();
}

vase();
