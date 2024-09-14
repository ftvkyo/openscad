skadis_hole = [5, 5, 15]; // width, thickness, height
skadis_hole_d = skadis_hole.x;
skadis_hole_gap = [15, undef, 25];
skadis_hole_chamfer_d = 3;

skadis_rounding_r = 10;
skadis_margin = [17.5, 12.5];


module hook_part_small_bend() {
    rotate_extrude(angle = 90)
        translate([(skadis_hole.y + skadis_hole_chamfer_d) / 2, 0])
        circle(r = skadis_hole_d / 2);
}

module hook_base() {
    $fn = 48;

    hook_part_small_bend();
}
