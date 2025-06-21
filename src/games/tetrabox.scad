display = "board"; // ["board", "piece_I", "piece_o", "piece_T", "piece_L", "piece_Z", "DEBUG-arranged"]

atom_radius = 5;
atom_gap = 2;
board_thickness = 4;
stamp_depth = 1;

matrix = 12;

atom_period = atom_radius * 2 + atom_gap;

module atom() {
    sphere(atom_radius, $fn = 36);
}

module stamp(name) {
    translate([0, 0, board_thickness])
    linear_extrude(stamp_depth * 2, center = true)
    text(
        name,
        size = 4,
        font = "JetBrains Mono:bold",
        valign = "center",
        halign = "center"
    );
}

module board() {
    module indents() {
        translate([atom_period / 2, atom_period])
        for (x = [- matrix / 2 : matrix / 2 - 1]) {
            translate([x * atom_period, atom_period * matrix / 2, 0])
            circle(atom_period / 2, $fn = 4);
        }
    }

    module plate() {
        linear_extrude(board_thickness)
        offset(1)
        offset(-1)
        difference() {
            offset(atom_period)
            offset(-atom_period)
            square(atom_period * (matrix + 3/2), center = true);

            for(a = [0, 90, 180, 270])
            rotate(a)
            indents();
        }
    }

    module atom_slots() {
        translate([atom_period / 2, atom_period / 2, atom_radius + 1])
        for (x = [- matrix / 2 : matrix / 2 - 1]) {
            for (y = [- matrix / 2 : matrix / 2 - 1]) {
                translate([x * atom_period, y * atom_period, 0])
                atom();
            }
        }
    }

    module stamps(letter) {
        translate([atom_period / 2, atom_period / 2 - 3])
        for (x = [- matrix / 2 : matrix / 2 - 1]) {
            translate([x * atom_period, atom_period * matrix / 2, 0])
            stamp(str(letter, x + matrix / 2));
        }
    }

    difference() {
        plate();
        atom_slots();

        stamps("N");

        rotate([0, 0, -90])
        stamps("E");

        rotate([0, 0, -180])
        stamps("S");

        rotate([0, 0, -270])
        stamps("W");
    }
}

module piece(balls) {
    for (t = balls)
    translate([atom_period * t.x, atom_period * t.y, 0])
    intersection() {
        atom();

        cube([atom_radius * 2, atom_radius * 2, atom_radius * 1.65], center = true);
    }
}

module piece_bridge(start, to_y = false) {
    rot_z = to_y ? 90 : 0;

    translate([start.x * atom_period, start.y * atom_period])
    rotate([0, 90, rot_z])
    rotate([0, 0, 30])
    cylinder(h = atom_period, r = atom_radius / 3, $fn = 6);
}

module piece_I() {
    piece([
        [0, 0],
        [1, 0],
        [2, 0],
        [3, 0],
    ]);

    piece_bridge([0, 0]);
    piece_bridge([1, 0]);
    piece_bridge([2, 0]);
}

module piece_o() {
    piece([
        [0, 0],
        [0, 1],
        [1, 0],
        [1, 1],
    ]);

    piece_bridge([0, 0]);
    piece_bridge([0, 0], to_y = true);
    piece_bridge([1, 0], to_y = true);
    piece_bridge([0, 1]);
}

module piece_T() {
    piece([
        [0, 0],
        [1, 0],
        [2, 0],
        [1, 1],
    ]);

    piece_bridge([0, 0]);
    piece_bridge([1, 0]);
    piece_bridge([1, 0], to_y = true);
}

module piece_L() {
    piece([
        [0, 0],
        [1, 0],
        [2, 0],
        [0, 1],
    ]);

    piece_bridge([0, 0]);
    piece_bridge([0, 0], to_y = true);
    piece_bridge([1, 0]);
}

module piece_Z() {
    piece([
        [0, 0],
        [1, 0],
        [1, 1],
        [2, 1],
    ]);

    piece_bridge([0, 0]);
    piece_bridge([1, 0], to_y = true);
    piece_bridge([1, 1]);
}

module debug_arranged() {
    translate([0, 0, - atom_radius - 1])
    board();

    translate([0.5, 3.5, 0] * atom_period)
    piece_straight();

    translate([-2.5, 2.5, 0] * atom_period)
    piece_square();

    translate([0.5, 0.5, 0] * atom_period)
    piece_T();

    translate([-3.5, -2.5, 0] * atom_period)
    piece_L();

    translate([1.5, -2.5, 0] * atom_period)
    piece_skew();
}

if (display == "board") board();
if (display == "piece_I") piece_I();
if (display == "piece_o") piece_o();
if (display == "piece_T") piece_T();
if (display == "piece_L") piece_L();
if (display == "piece_Z") piece_Z();
if (display == "DEBUG-arranged") debug_arranged();
