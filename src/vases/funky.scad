use <../../lib/maths.scad>

// Height
h = 150;

// Sides of the base polygon
f = 6;
// Radius of the base polygon
r = 50;

// Slices
s = 24;
// Determines twist based on the slice
function t(sn) = _bezier3([5, -20, 5, -5], sn / (s - 1));


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
        t = t(sn);

        linear_extrude(h / s + E, slices = 4, twist = t)
        rounden(3)
        profile();

        rotate(- t)
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
