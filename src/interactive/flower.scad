use <../../lib/ops.scad>
use <../../lib/parts.scad>
use <../../lib/maths.scad>
use <../../lib/points.scad>
use <../../lib/fasteners.scad>
use <../../lib/util.scad>


/* ========== *
 * Parameters *
 * ========== */

/* [General] */

// What to render
RENDER = "all"; // ["all", "petal", "housing-top", "housing-bottom", "interface", "interface-shell", "interface-cage", "interface-top", "interface-bottom"]

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

connection_extent_factor = 1/2;
connection_extent = housing_diameter / 2 * connection_extent_factor;
connection_groove_width = 2;
connection_groove_depth = 3;
connection_r1 = petal_thickness / 2;
connection_r2 = petal_thickness / 2 * (1 - connection_extent_factor);

interface_joiner_height = 4;


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
    module connection() {
        rotate_extrude(convexity = 10, $fn = housing_petal_cogs)
        translate([(connection_r1 + connection_r2) / 2, connection_extent / 2])
        rotate(atan(connection_extent / (connection_r2 - connection_r1)))
        scale([connection_groove_width, connection_groove_depth])
            circle(1, $fn = 4);
    }

    rotate([180, 0, 0])
    difference() {
        cog_angle_step = 360 / housing_petal_cogs / 3; // Doing 60 degree cogs

        linear_extrude(connection_extent, scale = connection_extent_factor, convexity = 10)
        for(angle = [360 / housing_petal_cogs : 360 / housing_petal_cogs : 360])
        rotate(angle)
            circle(connection_r1, $fn = 3);

        connection();
    }
}

module housing() {
    module profile() {
        polygon([
            [housing_diameter * 7/32, petal_thickness / 2],
            [housing_diameter * 7/32, petal_thickness / 2 + housing_thickness],
            [housing_diameter / 2, petal_thickness / 2 + housing_thickness],
            [housing_diameter / 2, petal_thickness / 2],
            [housing_diameter / 4, petal_thickness / 4],
            [housing_diameter / 4, petal_thickness / 2],
        ]);

        translate([
            housing_diameter * 3/8,
            petal_thickness * 3/8,
        ])
        rotate(atan((connection_r1 - connection_r2) / connection_extent))
        scale([connection_groove_width, connection_groove_depth])
            circle(1, $fn = 4);
    }

    module cog() {
        difference() {
            angle = atan(housing_diameter / petal_thickness);
            length = housing_diameter / 2 / sin(angle);

            rotate([180, angle, 0])
            translate([0, 0, - length])
            linear_extrude(length, scale = 0)
                circle(housing_cog_width / 2, $fn = 3);

            cylinder(petal_thickness, r = housing_diameter / 4, center = true);
        }
    }

    module cogs() {
        for (a = [360 / housing_cogs : 360 / housing_cogs : 360])
        rotate([0, 0, 360 / housing_cogs / 2 + a])
            cog();
    }

    cogs();
    rotate_extrude()
        profile();
}

module housing_top() {
    difference() {
        housing();
        cylinder(petal_thickness * 33/32, r = housing_diameter * 9/32, center = true);
    }

    translate([0, 0, interface_joiner_height])
    difference() {
        h = petal_thickness / 2 + housing_thickness - interface_joiner_height;

        union() {
            cylinder(h, r = housing_diameter / 8);

            for (a = [0, 60, 120, 180, 240, 300]) {
                h = housing_thickness - petal_thickness / 32;

                rotate([90, 0, a])
                translate([0, petal_thickness / 2 - housing_thickness, housing_diameter / 12 + housing_diameter / 8])
                    cube([h, h, housing_diameter / 4], center = true);
            }
        }

        translate([0, 0, - E])
            cylinder(h + E * 2, r = housing_diameter / 12);
    }
}

module housing_bottom() {
    mirror([0, 0, 1])
        housing();
}

module interface(part) {
    bearing(
        shell_height = petal_thickness,
        shell_outer_diameter = housing_diameter / 2,
        shell_inner_diameter = housing_diameter / 4,
        shell_inner_joiner_count = 3,
        shell_inner_joiner_height = interface_joiner_height,
        shell_inner_gap = 0,
        ball_diameter = 3.5,
        ball_count = 12,
        ball_margin = 0.2,
        cage_margin = 0.5,
        // solid = true,
        PART = part
    ) {
        translate([0, 0, - 2]) screw_M2x6(hole = true);
        heat_insert_M2(hole = true);
    }
}

/* ======== *
 * Assembly *
 * ======== */

module assembly() {
    module all() {
        color("#FF000044") {
            housing_top();
            housing_bottom();
        }

        interface("all");

        for (angle = [360 / housing_petal_count : 360 / housing_petal_count : 360])
        rotate([0, 0, angle])
        translate([housing_diameter / 2, 0, 0])
        rotate([0, 90, 0]) {
            petal();
            gear();
        }
    }

    _render() {
        all();
    }

    _render("housing-top")
        housing_top();

    _render("housing-bottom")
        housing_bottom();

    _render("petal") {
        petal();
        gear();
    }

    _render("interface")
        interface("all");

    _render("interface-shell")
        interface("bearing-outer");

    _render("interface-cage")
        interface("bearing-cage");

    _render("interface-top")
        interface("bearing-inner-top");

    _render("interface-bottom")
        interface("bearing-inner-bottom");
}

assembly();
