E_LAYER = 0.2; // Extrusion (layer) height
E_WIDTH = 0.4; // Extrusion width
E = 0.001; // Tolerance (to join touching objects)


plate_angle = 30;
plate_thickness = 2;
plate_side = 25;

plate_shear = tan(plate_angle);
plate_m = [
    [ 1, 0, 0, 0 ],
    [ 0, 1, -plate_shear, 0 ],
    [ 0, 0, 1, 0 ],
    [ 0, 0, 0, 1 ],
];


support_base_x = 10;
support_base_y = plate_shear * plate_side;
support_base_z = E_LAYER * 2;
support_base_gap = 1;

support_thickness = 1;
support_length = 3;


fur_x = E_WIDTH * 2;
fur_y = 30 + plate_thickness;
fur_z = E_LAYER;

fur_gap_x = 2;
fur_gap_z = 2;


// Supports
color("grey") {
    // Base support
    translate([(plate_side - support_base_x) / 2, -support_base_y, 0])
        cube([support_base_x, support_base_y - support_base_gap, support_base_z]);

    // Support stands
    for (y = [- support_base_gap : - support_length : - support_base_y]) {
        z = 1 / tan(plate_angle) * -y;

        translate([
            (plate_side - support_thickness) / 2,
            y - support_length,
            0,
        ])
            cube([support_thickness, support_length, z + E]);
    }
}


// Plate to put the strands on
multmatrix(plate_m)
    cube([plate_side, plate_thickness, plate_side]);


// FUR STRANDS

for (x = [0 : fur_gap_x : plate_side - fur_x]) {
    for (z = [1 : fur_gap_z : plate_side]) {
        y = tan(plate_angle) * -z;
        
        translate([
            x,
            y,
            z,
        ])
            cube([fur_x, fur_y, fur_z]);
    }
}

