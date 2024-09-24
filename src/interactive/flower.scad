use <../../lib/ops.scad>
use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/fasteners.scad>
use <../../lib/util.scad>


/* ========== *
 * Parameters *
 * ========== */

/* [General] */

// What to render
RENDER = "all"; // ["all", "petal", "housing"]

RESOLUTION = 12; // [12, 24, 36, 48]


/* [Petals] */

petal_length = 100;
petal_thickness = 15;
petal_end_scale = 3/10;
petal_end_displacement = 20;
petal_turns = 2;

// Adjustment to the height so that the spiral is not linear
petal_bezier = [0, 0.1, 0.4, 1];


/* [Housing] */

housing_thickness = 2.5;
housing_petal_count = 12;
housing_petal_cogs = 12; // [12 : 3 : 36]


/* [Hidden] */

$fn = RESOLUTION;
INF = 10 ^ 3;
E = 0.01;

housing_cog_width = petal_thickness * PI / housing_petal_cogs;
housing_cogs_per_petal = ceil(petal_thickness / housing_cog_width);
housing_cogs = housing_cogs_per_petal * housing_petal_count;
housing_diameter = housing_cog_width * housing_cogs / PI;


/* ========= *
 * Utilities *
 * ========= */

module _render(r) {
    if ((is_undef(r) && RENDER == "all") || RENDER == r)
        children();
}


/* ======= *
 * Modules *
 * ======= */

module petal() {
    profile = pts_inflate(pts_circle(1, RESOLUTION));

    slices = [ for(step = [1 : RESOLUTION * 2])
        let (
            f = (step - 1) / (RESOLUTION * 2 - 1),
            h = petal_length * _bezier3(petal_bezier, f),
            s = lerp(petal_thickness, petal_thickness * petal_end_scale, f) / 2,
            t = petal_end_displacement * f
        )
            pts_rotate3(
                pts_translate3(
                    pts_scale3(profile, [s, s, 1]),
                    [t, 0, h]
                ),
                [0, 0, petal_turns * 360 * f]
            )
    ];

    pts_extrude(slices, loop = false);
}

module gear() {
    connection_extent_factor = 1/2;
    connection_extent = housing_diameter / 2 * connection_extent_factor;

    connection_groove_width = 2;
    connection_groove_depth = 3;

    connection_r1 = petal_thickness / 2;
    connection_r2 = petal_thickness / 2 * (1 - connection_extent_factor);

    rotate([180, 0, 0])
    difference() {
        cog_angle_step = 360 / housing_petal_cogs / 3; // Doing 60 degree cogs

        linear_extrude(connection_extent, scale = connection_extent_factor, convexity = 10)
        for(angle = [360 / housing_petal_cogs : 360 / housing_petal_cogs : 360])
        rotate(angle)
            circle(connection_r1, $fn = 3);

        rotate_extrude(convexity = 10, $fn = housing_petal_cogs)
        translate([(connection_r1 + connection_r2) / 2, connection_extent / 2])
        rotate(atan(connection_extent / (connection_r2 - connection_r1)))
        scale([connection_groove_width, connection_groove_depth])
            circle(1, $fn = 4);
    }
}

module housing() {
    translate([0, 0, petal_thickness + housing_thickness] / 2)
        cylinder(housing_thickness, r = housing_diameter / 2, center = true);

    translate([0, 0, - petal_thickness - housing_thickness] / 2)
        cylinder(housing_thickness, r = housing_diameter / 2, center = true);
}

/* ======== *
 * Assembly *
 * ======== */

module assembly() {
    _render() {
        %housing();

        for (angle = [360 / housing_petal_count : 360 / housing_petal_count : 360])
        rotate([0, 0, angle])
        translate([housing_diameter / 2, 0, 0])
        // rotate([$t * 4 * 360, 0, 0])
        rotate([0, 90, 0]) {
            petal();
            gear();
        }
    }

    _render("housing")
        housing();

    _render("petal") {
        petal();
        gear();
    }
}

assembly();
