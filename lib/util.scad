function _assert_vec2(vec) =
    assert(is_list(vec) && len(vec) == 2, "a vec is not a list of 2 elements")
    assert(is_num(vec.x) && is_num(vec.y), "a vec component is not a number")
    true;


function _assert_vec3(vec) =
    assert(is_list(vec) && len(vec) == 3, "a vec is not a list of 3 elements")
    assert(is_num(vec.x) && is_num(vec.y) && is_num(vec.z), "a vec component is not a number")
    true;


function _assert_flat(flat) =
    assert(is_list(flat) && len(flat) > 2, "a flat is not a list of more than 2 points")
    is_list([ for (point = flat)
        assert(is_list(point) && len(point) == 2, "a point in a flat is not a list of 2 elements")
        assert(is_num(point.x) && is_num(point.y), "a component of a point in a flat is not a number")
        true
    ]);


function _assert_slice(slice) =
    assert(is_list(slice) && len(slice) > 2, "a slice is not a list of more than 2 points")
    is_list([ for (point = slice)
        assert(is_list(point) && len(point) == 3, "a point in a slice is not a list of 3 elements")
        assert(is_num(point.x) && is_num(point.y) && is_num(point.z), "a component of a point in a slice is not a number")
        true
    ]);


module _halfplane(axis, dir, INF) {
    assert(is_string(axis) && len(axis) == 1 && len(search(axis, "xy")) == 1);
    assert(is_string(dir) && len(dir) == 1 && len(search(dir, "+-")) == 1);

    module hp0() {
        translate([INF / 2, 0])
            square(INF, center = true);
    }

    module hp1() {
        if (dir == "+") {
            hp0();
        } else {
            rotate(180)
                hp0();
        }
    }

    if (axis == "x") {
        hp1();
    } else {
        rotate(90)
            hp1();
    }
}


module half2(which = "x+", INF = 10 ^ 3) {
    intersection() {
        _halfplane(which[0], which[1], INF);

        children();
    }
}


module _halfspace(axis, dir, INF) {
    assert(is_string(axis) && len(axis) == 1 && len(search(axis, "xyz")) == 1);
    assert(is_string(dir) && len(dir) == 1 && len(search(dir, "+-")) == 1);

    module hp0() {
        translate([0, 0, INF / 2])
            cube(INF, center = true);
    }

    module hp1() {
        if (dir == "+") {
            hp0();
        } else {
            mirror([0, 0, 1])
                hp0();
        }
    }

    if (axis == "z") {
        hp1();
    } else if (axis == "y") {
        rotate([-90, 0, 0])
            hp1();
    } else {
        rotate([0, 90, 0])
            hp1();
    }
}


module half3(which = "z+", INF = 10 ^ 3) {
    intersection() {
        _halfspace(which[0], which[1], INF);

        children();
    }
}
