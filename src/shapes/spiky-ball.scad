module spike() {
    rotate_extrude($fn = 6)
    polygon([
        [0, 0],
        [10, 0],
        [0, 50],
    ]);
}

sphere(25, $fn = 12);

for (a = [0 : 30 : 359])
rotate([90, 0, a])
spike();

for (a = [0 : 45 : 359]) {
    rotate([60, 0, a])
    spike();

    rotate([120, 0, a])
    spike();
}

for (a = [0 : 60 : 359]) {
    rotate([30, 0, a])
    spike();

    rotate([150, 0, a])
    spike();
}

spike();

mirror([0, 0, 1])
spike();
