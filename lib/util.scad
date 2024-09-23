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
