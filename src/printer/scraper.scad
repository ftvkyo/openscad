scraper_length = 60;
scraper_angle = 20;

handle_length = 100;
handle_angle = 30;

finger_diameter = 20;
thumb_diameter = 30;

$fn = 48;
E = 0.01;

rounding = scraper_length * sin(scraper_angle) / 5;
handle_thickness = scraper_length * sin(scraper_angle);


module sharp() {
    polygon([
        [0, 0],
        [scraper_length, scraper_length * tan(scraper_angle)],
        [scraper_length, 0]
    ]);
}

module handle() {

    offset(rounding)
    offset(- rounding * 2)
    offset(rounding)
    difference() {
        union() {
            sharp();

            translate([scraper_length, 0])
            rotate(handle_angle) {
                difference() {
                    square([handle_length, handle_thickness]);

                    translate([handle_length - finger_diameter / 2, 0])
                    for (finger = [0 : 3]) {
                        translate([- finger_diameter * finger, - finger_diameter / 4])
                            circle(finger_diameter / 2);
                    }
                }
            }
        }

        translate([scraper_length, 0])
        rotate(handle_angle)
        translate([0, handle_thickness + thumb_diameter / 3])
            circle(thumb_diameter / 2);
    }
}

module scraper() {
    scale(1/2)
        sharp();

    handle();
}

module info() {
    translate([scraper_length, 0])
    rotate(handle_angle)
    translate([handle_length / 2, handle_thickness * 2/3]) {
        text(
            "Scraper",
            size = handle_thickness / 4,
            font = "JetBrains Mono",
            halign = "center",
            valign = "center"
        );
    }
}

difference() {
    scraper();
    info();
}
