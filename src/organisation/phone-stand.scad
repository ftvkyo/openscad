use <../../lib/util.scad>


phone = [75.7, 8.9, 165];
phone_tilt = 20;
phone_lift = 15;
phone_enrounden = 5;

screen_enrounden = 2;
screen_margin = 4;

base_thickness = 10;
base_enrounding = 5;

enrounden = true;

E = 0.01;


module _enrounden(r, $fn) {
    if (enrounden) {
        minkowski() {
            children();

            sphere(r, $fn = $fn);
        }
    } else {
        children();
    }
}


module _phone() {
    phone_pre_d = phone + [2, 2, 2];
    phone_d = enrounden
        ? phone_pre_d - [phone_enrounden, phone_enrounden, phone_enrounden] * 2
        : phone;

    screen_pre_d
        = phone
        + [0, base_thickness, 0] * 2
        - [screen_margin, 0, screen_margin / 2] * 2;
    screen_d = enrounden
        ? screen_pre_d - [screen_enrounden, screen_enrounden, screen_enrounden] * 2
        : screen_pre_d;

    translate([0, 0, phone_lift])
    rotate([- phone_tilt, 0, 0])
    translate([0, 0, phone.z / 2]) {
        _enrounden(phone_enrounden, $fn = 36)
        cube(phone_d, center = true);

        translate([0, - screen_d.y / 2, 0])
        _enrounden(screen_enrounden, $fn = 36)
        cube(screen_d, center = true);
    }
}


module _prism() {
    width = phone.x + base_thickness * 2 - base_enrounding * 2;
    depth = sin(phone_tilt) * phone.z + base_thickness * 2;
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

            hole_depth = (depth - base_thickness) / 2 + base_thickness * 2;

            translate([0, depth - base_thickness - hole_depth / 2 - base_thickness / 6, height / 2 - E])
            cube([width - base_thickness / 3, hole_depth, height], center = true);
        }
    }

    half3()
    _enrounden(base_enrounding, $fn = 72)
    base_shape();
}


module _base() {
    difference() {
        _prism();
        _phone();
    }
}


_base();
