laptop_dim = [300, 200, 15]; // Laptop dimensions
laptop_angle = 20; // Angle of the laptop stand
leg_angle = 30; // Angle between the legs
leg_distance = 100; // Distance between the legs (somewhere)
raise = 25; // How much to raise the laptop
push = 10; // How much to push the laptop away
thickness = 10; // Thickness of the legs

stand_leg_depth = cos(laptop_angle) * laptop_dim.y / cos(leg_angle);
stand_leg_height = sin(laptop_angle) * laptop_dim.y + raise;


module laptop() {
    // color("grey")
    translate([-laptop_dim.x / 2, 0, 0])
        cube(laptop_dim);
}

module laptop_free_space() {
    free_space = [
        laptop_dim.x,
        laptop_dim.y * 2,
        100,
    ];

    union() {
        translate([-laptop_dim.x / 2, 0, 0])
            cube(free_space);

        translate([-laptop_dim.x / 2, -laptop_dim.z, laptop_dim.z])
            cube(free_space);
    }
}

module stand_leg() {
    translate([-thickness / 2, 0, 0])
        cube([thickness, stand_leg_depth, stand_leg_height]);
}

module stand_plank() {
    translate([- leg_distance / 2, 0, 0])
        cube([leg_distance, thickness, stand_leg_height]);
}

module stand() {
    difference() {
        union() {
            translate([leg_distance, 0, 0])
            rotate([0, 0, leg_angle])
                stand_leg();

            translate([-leg_distance, 0, 0])
            rotate([0, 0, -leg_angle])
                stand_leg();

            translate([0, cos(laptop_angle) * laptop_dim.y / 2, 0])
                stand_plank();
        }

        translate([0, push, raise])
        rotate([laptop_angle, 0, 0])
            laptop_free_space();
    }
}

module assembly() {
    translate([0, push, raise])
    rotate([laptop_angle, 0, 0])
        %laptop();

    stand();
}

assembly();
