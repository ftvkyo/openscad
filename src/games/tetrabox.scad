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

board();
