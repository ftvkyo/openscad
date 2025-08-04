aspect = 3/5;

x = 100;
y = x * aspect;

z1 = 0.6;
z2 = 1.2;
z3 = 1.8;
z4 = 2.4;

rim = 1;

module rim() {
    $fn = 24;

    difference() {
        offset(rim * 2)
        offset(-rim * 2)
        square([x, y], center = true);

        offset(rim)
        offset(-rim)
        square([x - rim * 2, y - rim * 2], center = true);
    }
}

module flag() {
    color("#5BCEFA")
    linear_extrude(z1)
    square([x - rim * 2, y - rim * 2], center = true);

    color("#F5A9B8")
    linear_extrude(z2)
    square([x - rim * 2, (y - rim * 2) * 3/5], center = true);

    color("#FFFFFF")
    linear_extrude(z3)
    square([x - rim * 2, (y - rim * 2) / 5], center = true);

    color("#444444")
    linear_extrude(z4)
    rim();
}

flag();
