use <../../lib/maths.scad>

// Nozzle diameter
NOZZLE = 0.4;

// Radius of the brooch
brooch_r = 25;

// Padding between the logo and the brooch edge
brooch_p = 3;

// Brooch plate thickness in layers
brooch_plate_tl = 5;

// Logo thickness in layers
logo_tl = 5;

/* [Hidden] */

N = NOZZLE;
L = N / 2; // Layer height
E = 0.01; // Epsilon

$fn = 48;

/* Derived parameters */

brooch_plate_t = brooch_plate_tl * L; // Brooch thickness
logo_r = brooch_r * 2 - brooch_p * 2; // Logo radius
logo_t = logo_tl * L; // Logo thickness
logo_sw = N * 2; // Logo stroke width

/* Modules */

module logo_half() {
    neck = [0, logo_r / 4];
    pelvis = [0, - logo_r / 6];
    foot = [logo_r / 8, - logo_r / 2];
    shoulder = [0, logo_r / 6];
    elbow = [logo_r / 8, 0];
    wrist = [logo_r / 4, logo_r / 6];
    fingertip = [logo_r / 3, logo_r / 6];

    // Center line
    stroke_line(neck, pelvis, N * 2);

    // Leg
    stroke_line(pelvis, foot, N * 2);

    // Wing
    stroke_line(shoulder, elbow, N * 2);
    translate(elbow)
        circle(r = N);
    stroke_line(elbow, wrist, N * 2);
    translate(wrist)
        circle(r = N);
    stroke_line(wrist, fingertip, N * 2);
    translate(fingertip)
        circle(r = N);

    // Feathers: primary
    let (
        step = 0.2,
        angle_from = -75,
        angle_to = -10,
        len_from = 10,
        len_to = 15
    ) {
        for (t = [0 : step : 1]) {
            a = lerp(angle_from, angle_to, t);
            l = lerp(len_from, len_to, t);

            p0 = lerp(wrist, fingertip, t);

            p1 = [
                p0.x + cos(a) * l,
                p0.y + sin(a) * l,
            ];

            stroke_line(p0, p1, N * 2);
        }
    }

    // Feathers: secondary
    let (
        step = 0.21,
        angle_from = -90,
        angle_to = -80,
        len_from = 7,
        len_to = 9
    ) {
        for (t = [0 : step : 1]) {
            a = lerp(angle_from, angle_to, t);
            l = lerp(len_from, len_to, t);

            p0 = lerp(elbow, wrist, t);

            p1 = [
                p0.x + cos(a) * l,
                p0.y + sin(a) * l,
            ];

            stroke_line(p0, p1, N * 2);
        }
    }

    // Head
    translate(neck + [0, N * 8]) {
        difference() {
            union() {
                circle(N * 8);

                // Ear: top
                polygon([
                    [0, 4],
                    [16, 8],
                    [8, 0],
                ] * N);

                // Ear: bottom
                polygon([
                    [0, -2],
                    [14, -6],
                    [8, 0],
                ] * N);
            }

            circle(N * 6);
        }
    }
}

module logo() {
    offset(- N / 2)
    offset(N)
    offset(- N / 2) {
        scale([-1, 1])
            logo_half();
        logo_half();
    }
}

module brooch_plate() {
    difference() {
        offset(brooch_p, $fn = 360)
        offset(- brooch_p * 8)
        offset(brooch_p * 8)
            logo();

        translate([12, 9])
            circle(r = N);
        translate([14, 9])
            circle(r = N);

        translate([-12, 9])
            circle(r = N);
        translate([-14, 9])
            circle(r = N);

        translate([2, 0])
            circle(r = N);
        translate([-2, -2])
            circle(r = N);

        translate([-2, 0])
            circle(r = N);
        translate([2, -2])
            circle(r = N);
    }
}

module brooch() {
    color("yellow")
    translate([0, 0, brooch_plate_t - E])
    linear_extrude(logo_t)
        logo();

    color("grey")
    linear_extrude(brooch_plate_t)
        brooch_plate();
}

brooch();
