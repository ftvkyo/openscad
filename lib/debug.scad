module debug_point(p, c = "black") {
    %color(c)
        translate(p)
        circle(0.5);
}

module debug_points(pts, trans, rot = [0, 0, 0], c = "red") {
    r = 1.5;

    color(c)
    for (i = [0 : 1 : len(pts) - 1]) {
        p = pts[i];

        if (len(p) == 2) {
            translate(trans(p)) {
                sphere(r);

                rotate(rot)
                translate([r, r])
                text(str(i));
            }
        }
    }
}
