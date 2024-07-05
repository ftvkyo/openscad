LAPTOP = [300, 200, 15]; // Laptop dimensions
ANGLE = 30; // Angle of the laptop stand
LIFT = 25; // How much to lift the laptop off of the table
PLY = 9; // Plywood thickness
ROUND = 3;


insert_move = [0, cos(ANGLE) * LAPTOP.y / 4, sin(ANGLE) * LAPTOP.y / 4];
insert_offset = [0, 0, LIFT / 3];


// Rotation of the legs actually changes the angle a bit, but it's ok
module laptop() {
    translate([-LAPTOP.x / 2, LIFT / 2, LIFT])
        rotate([ANGLE, 0, 0])
        cube(LAPTOP);
}


module stand_leg_shape(thickness) {
    length = cos(ANGLE) * LAPTOP.y;
    height = sin(ANGLE) * LAPTOP.y + LIFT;

    rotate([90, 0, 90])
        linear_extrude(thickness, center=true)
        offset(ROUND)
        offset(-ROUND)
        difference() {
            square([length, height]);

            translate([LIFT / 2, LIFT])
                rotate(ANGLE)
                square([length, height] * 2);
        };
}

module stand_insert_shape(thickness) {
    length = LAPTOP.x / 2;
    height = LIFT;

    translate([-length / 2, PLY, 0])
        rotate([90, 0, 0])
        linear_extrude(thickness)
        offset(ROUND)
        offset(-ROUND)
        square([length, height]);
}

module stand(angle_legs) {
    translate([LAPTOP.x / 4, 0, 0])
    rotate([0, 0, angle_legs / 2])
        stand_leg_shape(PLY);

    translate([-LAPTOP.x / 4, 0, 0])
    rotate([0, 0, -angle_legs / 2])
        stand_leg_shape(PLY);

    translate(insert_move + insert_offset)
        stand_insert_shape(PLY);

    translate(insert_move * 3 + insert_offset)
        stand_insert_shape(PLY);
}

module assembly(angle) {
    %laptop();
    stand(angle);
}


// PROJECTIONS

module project_leg(angle_legs) {

    projection(cut = true)
    rotate([0, 90, 0])
    rotate([0, 0, angle_legs / 2])
    translate([LAPTOP.x / 4, 0, 0])
    difference()
    {
        translate([-LAPTOP.x / 4, 0, 0])
        rotate([0, 0, -angle_legs / 2])
            stand_leg_shape(PLY);

        translate(insert_move + insert_offset)
            stand_insert_shape(PLY + 1);

        translate(insert_move * 3 + insert_offset)
            stand_insert_shape(PLY + 1);
    }
}

module project_insert_bottom(angle_legs) {

    projection(cut = true)
    translate([0, 0, -insert_move.y - PLY / 2])
    rotate([90, 0, 0])
    difference()
    {
        translate(insert_move + insert_offset)
            stand_insert_shape(PLY);

        translate([LAPTOP.x / 4, 0, 0])
        rotate([0, 0, angle_legs / 2])
            stand_leg_shape(PLY + 1);

        translate([-LAPTOP.x / 4, 0, 0])
        rotate([0, 0, -angle_legs / 2])
            stand_leg_shape(PLY + 1);
    }
}


module project_insert_top(angle_legs) {

    projection(cut = true)
    translate([0, 0, -insert_move.y * 3 - PLY / 2])
    rotate([90, 0, 0])
    difference()
    {
        translate(insert_move * 3 + insert_offset)
            stand_insert_shape(PLY);

        translate([LAPTOP.x / 4, 0, 0])
        rotate([0, 0, angle_legs / 2])
            stand_leg_shape(PLY + 1);

        translate([-LAPTOP.x / 4, 0, 0])
        rotate([0, 0, -angle_legs / 2])
            stand_leg_shape(PLY + 1);
    }
}


// RENDERING

// translate([500, 0, 0])
// assembly(30);

project_leg(30);

translate([170, cos(ANGLE) * LAPTOP.y, 0])
rotate(180)
project_leg(30);

translate([90, 300, 0])
project_insert_bottom(30);

translate([90, 300, 0])
project_insert_top(30);
