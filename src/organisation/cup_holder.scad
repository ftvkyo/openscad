use <../../lib/ops.scad>
use <../../lib/debug.scad>


DEBUG = false;
TOLERANCE = 0.4;

table_thickness = 16.1;

bracket_offset = 40.4;
bracket_width = 26;
bracket_height = 32;
bracket_thickness = 3;
bracket_table_gap = 2;

cup_d1 = 66;
cup_d2 = 88;
cup_height = 136;
cup_bottom_sides = 9;
cup_bottom_height = 80;

holder_thickness = 15;
holder_leg_thickness = 10;
holder_rounding = 5;


module __hidden__() {}


// Middle diameter
cup_dm = cup_d1 + (cup_d2 - cup_d1) * (cup_height - cup_bottom_height) / cup_height;
cup_position = [bracket_offset + cup_d2 / 2 + holder_thickness, 0, - cup_bottom_height + table_thickness + holder_thickness + 15 ];

holder_leg_profile_height = table_thickness + bracket_height + holder_thickness;

holder_leg_profile_points = [
    /*  0 */ [bracket_offset, table_thickness + holder_thickness / 2],
    /*  1 */ [bracket_offset, 0],
    /*  2 */ [0, 0],
    /*  3 */ [- bracket_thickness, - bracket_thickness - bracket_table_gap],
    /*  4 */ [- bracket_width, - bracket_thickness - bracket_table_gap],
    /*  5 */ [- bracket_thickness - holder_thickness, - bracket_height - holder_thickness],
    /*  6 */ [cup_position.x - holder_leg_profile_height, - bracket_height - holder_thickness],
    /*  7 */ [cup_position.x, table_thickness],
    /*  8 */ [cup_position.x, table_thickness + holder_thickness / 2],
];

holder_leg_profile_points_negative = [
    /*  0 */ [bracket_offset, table_thickness + holder_thickness],
    /*  1 */ [bracket_offset, 0],
    /*  2 */ [0, 0],
    /*  3 */ [0, - bracket_height],
    /*  4 */ [- bracket_thickness, - bracket_height],
    /*  5 */ [- bracket_thickness, - bracket_thickness - bracket_table_gap],
    /*  6 */ [- bracket_width, - bracket_thickness - bracket_table_gap],
    /*  7 */ [- bracket_width, table_thickness + holder_thickness],
];


module table() {
    extent = 100;

    module top() {
        translate([extent / 2 - bracket_offset, 0, table_thickness / 2])
        cube([extent, extent, table_thickness], center = true);
    }

    module bracket() {
        translate([bracket_thickness / 2, 0, - bracket_height / 2])
        cube([bracket_thickness, extent, bracket_height], center = true);

        translate([bracket_width / 2, 0, - bracket_thickness / 2 - bracket_table_gap])
        cube([bracket_width, extent, bracket_thickness], center = true);
    }

    color("#FFFFFF88")
    mirror([1, 0, 0]) {
        top();
        bracket();
    }
}


module cup() {
    color("#0000FF88") {
        cylinder(h = cup_bottom_height + 0.1, r1 = cup_d1 / 2, r2 = cup_dm / 2, $fn = cup_bottom_sides);

        translate([0, 0, cup_bottom_height])
        cylinder(h = cup_height - cup_bottom_height, r1 = cup_dm / 2, r2 = cup_d2 / 2, $fn = 72);
    }
}

module cups() {
    translate(cup_position)
    cup();

    translate([0, 0, table_thickness - 0.01])
    scale(1.025)
    rotate([0, 0, 180])
    cup();
}


module holder() {
    module top(reduce) {
        // Ring around the cup
        translate([cup_position.x, 0, table_thickness + reduce])
        cylinder(h = holder_thickness - reduce * 2, r = cup_d2 / 2 - reduce);

        // Circle holding onto the table
        translate([0, 0, table_thickness + reduce])
        cylinder(h = holder_thickness - reduce * 2, r = cup_d2 / 2 - reduce);

        // Connection between the ring and the circle
        translate([cup_position.x / 2, 0, holder_thickness / 2 +  table_thickness])
        cube([cup_position.x, cup_d2 - reduce * 2, holder_thickness - reduce * 2], center = true);
    }

    module leg() {
        rotate([90, 0, 0])
        linear_extrude(holder_leg_thickness, center = true) {
            difference() {
                offset(- holder_rounding)
                offset(holder_rounding * 2)
                offset(- holder_rounding)
                polygon(holder_leg_profile_points);

                offset(TOLERANCE)
                polygon(holder_leg_profile_points_negative);
            }
        }
    }

    module bottom() {
        translate([0, cup_d2 / 2 - holder_leg_thickness / 2, 0])
        leg();

        translate([0, - cup_d2 / 2 + holder_leg_thickness / 2, 0])
        leg();
    }

    if (!DEBUG) {
        difference() {
            color("#AA6688FF") {
                rounden_xyz(holder_rounding, $fn = 72)
                top(holder_rounding);

                bottom();
            }

            cups();
        }
    } else {
        debug_points(holder_leg_profile_points, trans = function (p) [p.x, 0, p.y], rot = [90, 0, 180], c = "green");
        debug_points(holder_leg_profile_points_negative, trans = function (p) [p.x, 0, p.y], rot = [90, 0, 180], c = "red");
    }
}


module assembly() {
    %table();

    %cups();

    holder();
}


assembly();
