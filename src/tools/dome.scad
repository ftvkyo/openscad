height = 50;
radius = 25;
shape = "cubic"; // [cubic, elliptic, quadratic]

enable_base = true;

$fn = $preview ? 48 : 96;

point_cubic = function(t)
    let (x = radius * t)
    let (y = height * (1 - t * t * t))
    [x, y];

point_elliptic = function(t)
    let (a = 90 * t)
    let (x = radius * cos(a))
    let (y = height * sin(a))
    [x, y];

point_quadratic = function(t)
    let (x = radius * t)
    let (y = height * (1 - t * t))
    [x, y];

point =
    shape == "cubic" ? point_cubic :
    shape == "elliptic" ? point_elliptic :
    shape == "quadratic" ? point_quadratic :
    undef;

assert(!is_undef(point));

module dome() {
    $fn = $fn ? $fn : 24;

    base_height = 3;
    base_padding = 6;

    module dome() {
        polygon([ for (p = [
            [[0, 0]],
            [ for (t = [0 : 1 / $fn : 1]) point(t) ],
        ]) each p ]);
    }

    module base() {
        translate([0, - base_height])
        intersection() {
            union() {
                offset(- base_height * 1/5)
                offset(base_height * 2/5)
                offset(- base_height * 1/5) {
                    square([radius + base_padding, base_height * 4/5]);

                    square([radius, base_height * 2]);
                }

                // Unrounden outer bottom corner
                square([radius + base_padding, base_height * 1/5]);

                // Unrounden center top & bottom
                square([radius / 2, base_height * 2]);
            }

            square([radius + base_padding, base_height]);
        }
    }

    difference() {
        rotate_extrude() {
            dome();

            if (enable_base) {
                base();
            }
        }

        for (a = [0, 60, 120, 180, 240, 300])
        rotate([0, 0, a])
        translate([radius + base_padding / 2, 0, 0])
        cylinder(h = base_height * 3, r = 1.5, center = true);
    }
}

dome();
