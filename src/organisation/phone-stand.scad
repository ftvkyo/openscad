use <../../lib/util.scad>


phone = [75.7, 8.9, 165];
phone_tilt = 15;
phone_lift = 10;

base_thickness = 10;

E = 0.01;


module _phone() {
    translate([0, 0, phone_lift])
    rotate([- phone_tilt, 0, 0])
    translate([0, 0, phone.z / 2])
    cube(phone, center = true);
}


module _prism() {
    rounding = base_thickness / 2;

    width = phone.x + base_thickness * 2 - rounding * 2;
    depth = sin(phone_tilt) * phone.z + base_thickness;
    height = phone_lift + base_thickness;

    module profile() {
        difference() {
            intersection() {
                translate([- depth / 2 + base_thickness, height / 2])
                square([depth, height], center = true);

                rotate(phone_tilt)
                square([depth, height] * 2, center = true);
            }

            rotate(phone_tilt)
            translate([base_thickness * 5/4, - height / 2])
            square([base_thickness, height * 2]);
        }
    }

    module base_shape() {
        difference() {
            rotate([90, 0, -90])
            linear_extrude(width, center = true)
            profile();

            hole_depth = (depth - base_thickness) / 2 + base_thickness;

            translate([0, depth - base_thickness - hole_depth / 2 - base_thickness / 6, height / 2 - E])
            cube([width - base_thickness / 3, hole_depth, height], center = true);
        }
    }

    half3()
    minkowski() {
        base_shape();
        sphere(rounding, $fn = 72);
    }
}


module _base() {
    difference() {
        _prism();

        minkowski() {
            _phone();

            sphere(1, $fn = 36);
        }
    }
}


_base();

// %_phone();
