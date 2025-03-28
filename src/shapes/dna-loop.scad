use <../../lib/shape.scad>


/* Parameters */

radius_ring = 25;
radius_twist = 2;
gap = 4;
twists = 6;
bridges = 72;

thickness_helix = 3;
thickness_bridge = 1;

DEBUG = false;


/* Render */

double_helix(
    radius_ring = radius_ring,
    radius_twist = radius_twist,
    thickness = thickness_helix,
    gap = gap,
    twists = twists,
    fn_loop = 360
);

double_helix_bridges(
    radius_ring = radius_ring,
    radius_twist = radius_twist,
    thickness = thickness_bridge,
    gap = gap + thickness_helix / 2,
    twists = twists,
    steps = bridges
);


if (DEBUG) {
    %color("#AAAAAA")
    rotate_extrude($fn = 72)
    translate([radius_ring, 0])
    circle(thickness / 2, $fn = 24);
}
