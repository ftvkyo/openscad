/* ========== *
 * Parameters *
 * ========== */

/* [Output] */

RENDER = "all"; // ["all", "assembly folded", "joint", "joint cut", "leg1", "leg2"]


/* [Parameters] */

// Laptop dimensions
laptop = [200, 300, 15];
// Angle for the laptop
laptop_tilt = 30;
// Raise the laptop off the ground
laptop_lift = 25;

// Half of the angle between legs
leg_angle = 30;
// Thickness of the material used for the legs
leg_thickness = 5;
// Extra offset at the front of the notch
leg_notch_offset = 10;
// Offset from the joint axis to the screw
leg_hole_offset = 15;

// How much to round the corners
rounding = 4;

// Screw radius
hole_r = 3 / 2;
// Screw cap radius
hole_cap_r = 8 / 2;
// Put screws away from each other
hole_spread = 6;

joint_h = 24;
joint_cap_h = 4;

joint_rounding = 2;


/* [Hidden] */

$fn = 24;
NOZ = 0.4;
E = 0.01;

halfjoint_h = (joint_h - NOZ) / 2;

leg_axis_extra_offset = leg_thickness * 2;


/* ============ *
 * Calculations *
 * ============ */

// Projection of the laptop bottom at this tilt
support = [
    cos(laptop_tilt) * laptop.x,
    sin(laptop_tilt) * laptop.x,
];

// Projection of the laptop front at this tilt
notch = [
    cos(90 - laptop_tilt) * laptop.z,
    sin(90 - laptop_tilt) * laptop.z,
];

holes = [
    [leg_hole_offset, laptop_lift],
    [leg_hole_offset, laptop_lift + support.y / 3],
    [leg_hole_offset, laptop_lift + support.y * 2 / 3],
];


/* ======= *
 * Modules *
 * ======= */

module _render(r) {
    if (is_undef(r) && RENDER == "all" || RENDER == r)
        children();
}

// 2D base of the leg, not scaled for the leg angle
module leg_base() {
    // notch_offset = 0;

    p_origin = [0, 0];
    p_front_bottom = [support.x + notch.x + leg_notch_offset, 0];
    p_notch_front_top = [support.x + notch.x + leg_notch_offset, laptop_lift + notch.y * 3/2];
    p_notch_back_top = [support.x + notch.x - leg_notch_offset, laptop_lift + notch.y * 2];
    p_notch_back_middle = [support.x + notch.x, laptop_lift + notch.y];
    p_notch_back_bottom = [support.x, laptop_lift];
    p_back_top = [0, support.y + laptop_lift];

    ps = [
        p_origin,
        p_front_bottom,
        p_notch_front_top,
        p_notch_back_top,
        p_notch_back_middle,
        p_notch_back_bottom,
        p_back_top,
    ];

    polygon(ps);

    // %for (p = ps) {
    //     color("red")
    //     translate(p)
    //         circle(2);
    // }
}

// 2D base of the leg, scaled for the leg angle
module leg_base_angled() {
    front_extent = support.x * tan(leg_angle);
    assert(front_extent * 2 <= laptop.y * 0.8, "The legs open too wide for the laptop");

    scale([1 / cos(leg_angle), 1])
        leg_base();
}

module leg_base_rounded() {
    // Concave corners
    offset(-1)
    offset(1)
    // Convex corners
    offset(rounding)
    offset(-rounding)
        leg_base_angled();
}

module leg_base_holed(hole_offset) {
    assert(is_num(hole_offset));

    difference() {
        leg_base_rounded();

        translate([0, hole_offset])
        for (hole = holes) {
            assert(hole.x > leg_thickness + hole_r, "Hole offset too small");
            translate([hole.x - leg_thickness, hole.y])
                circle(hole_r);
        }

        translate([0, -hole_offset])
        for (hole = holes) {
            assert(hole.x > leg_thickness + hole_r, "Hole offset too small");
            translate([hole.x - leg_thickness, hole.y])
                circle(hole_cap_r);
        }
    }
}


module leg(hole_offset) {
    translate([leg_axis_extra_offset + leg_thickness, 0, 0])
    rotate([90, 0, 0])
    linear_extrude(leg_thickness, center = true)
        leg_base_holed(hole_offset);
}


module leg_pair(angle) {
    rotate([0, 0, angle])
    translate([0, leg_thickness / 2, 0])
        leg(hole_spread);

    rotate([0, 0, -angle])
    translate([0, -leg_thickness / 2, 0])
        leg(-hole_spread);
}


module joint_attachment() {
    joint_extent = leg_axis_extra_offset + leg_hole_offset + halfjoint_h / 2;

    module profile() {
        intersection() {
            union() {
                translate([joint_extent / 2, leg_thickness * 3/2])
                square([joint_extent, leg_thickness], center = true);

                rotate(leg_angle)
                translate([joint_extent / 4 + leg_thickness / 2 + NOZ, 0])
                square([joint_extent / 2, leg_thickness], center = true);
            }

            translate([0, - leg_thickness])
            square([joint_extent, leg_thickness * 3]);

            rotate(leg_angle)
            translate([joint_extent, - leg_thickness * 3/2])
            square([joint_extent * 2, leg_thickness * 4], center = true);
        }
    }

    module attachment(rounding) {
        minkowski() {
            linear_extrude(halfjoint_h - rounding * 2, center = true)
            offset(- rounding)
            profile();

            sphere(rounding);
        }
    }

    difference() {
        attachment(joint_rounding);

        translate([joint_extent - halfjoint_h / 2, leg_thickness * 3/2, 0])
        rotate([90, 0, 0])
            cylinder(leg_thickness + E, r = hole_r, center = true);
    }
}


module joint(angle) {
    assert(is_num(angle));

    color("green")
    difference() {
        cylinder(joint_h, r = leg_thickness, center = true);

        cube([leg_thickness * 2, leg_thickness * 2, NOZ], center = true);
        cylinder(joint_h + E, r = leg_thickness / 2 + NOZ, center = true);
    }

    color("red") {
        pin_h = joint_h + NOZ * 2;

        // Central pin
        cylinder(pin_h + E, r = leg_thickness / 2, center = true);

        // Top cap
        translate([0, 0, (pin_h + joint_cap_h) / 2])
            cylinder(joint_cap_h, r = leg_thickness, center = true);

        // Bottom cap
        translate([0, 0, - (pin_h + joint_cap_h) / 2])
            cylinder(joint_cap_h, r = leg_thickness, center = true);
    }

    // Attachments
    color("green") {

        // Top attachment
        rotate([0, 0, angle])
        translate([0, 0, (halfjoint_h + NOZ) / 2])
            joint_attachment();

        // Bottom attachment
        mirror([0, 1, 0])
        rotate([0, 0, angle])
        translate([0, 0, - (halfjoint_h + NOZ) / 2])
            joint_attachment();
    }
}


module joint_triple(angle) {
    for (hole = holes) {
        translate([0, 0, hole.y])
            joint(angle);
    }
}


/* ======= *
 * Outputs *
 * ======= */


module assembly(angle) {
    leg_pair(angle);
    joint_triple(angle);
}

module print_joint() {
    rotate([0, -90, 0])
        joint(90);
}

module cut_leg_1() {
    leg_base_holed(hole_spread);
}

module cut_leg_2() {
    rotate(180)
    mirror([1, 0])
        leg_base_holed(- hole_spread);
}


_render()
    assembly(180 - leg_angle);

_render("assembly folded")
    assembly(0);

_render("joint")
    print_joint();

_render("joint cut")
    projection(cut = true)
    translate([0, 0, halfjoint_h / 2])
    joint(180 - leg_angle);

_render("leg1")
    cut_leg_1();

_render("leg2")
    cut_leg_2();
