INF = 10 ^ 5;
E = 0.01;


module screw(
    screw_l,
    screw_d,
    cap_l,
    cap_d
) {
    translate([0, 0, cap_l + E])
    rotate([180, 0, 0]) {
        cylinder(cap_l + screw_l, r = screw_d / 2);
        cylinder(cap_l, r = cap_d / 2);
    }
}


module screw_M2x4(hole = false, hole_l = 6) {
    screw(
        screw_l = hole ? hole_l : 3.8,
        screw_d = hole ? 2 : 1.75,
        cap_l = hole ? INF : 1.75,
        cap_d = hole ? 4 : 3.5
    );
}


module screw_M2x6(hole = false, hole_l = 6) {
    screw(
        screw_l = hole ? hole_l : 5.5,
        screw_d = hole ? 2 : 1.75,
        cap_l = hole ? INF : 1.75,
        cap_d = hole ? 4 : 3.5
    );
}


module heat_insert(
    insert_l,
    insert_d,
    screw_l,
    screw_d,
) {
    translate([0, 0, E])
    rotate([180, 0, 0]) {
        cylinder(insert_l, r = insert_d / 2);
        if (is_num(screw_d)) {
            cylinder(is_num(screw_l) ? screw_l : INF, r = screw_d / 2);
        }
    }
}


module heat_insert_M2(hole = false, hole_l = 10) {
    depth = 3;

    translate([0, 0, hole ? hole_l - depth : 0])
    heat_insert(
        insert_l = hole ? hole_l : depth,
        insert_d = hole ? 3.2 : 3.5,
        screw_l = undef,
        screw_d = hole ? 2 : undef
    );
}
