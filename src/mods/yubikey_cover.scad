T = 0.01;

module yubikey_5c() {
    $fn = 24;

    module connector() {
        dim = [8.3, 2.4, 6.7];

        r = min(dim.x, dim.y);

        color("#888")
        linear_extrude(dim.z)
        offset(r * 0.4)
        offset(- r * 0.4)
        square([dim.x, dim.y], center = true);
    }
    
    module body_plastic() {
        r = 1;

        color("#444")
        mirror([0, 0, 1]) {
            dim = [12.2, 5, 10];
            
            ring_t = 3;

            difference() {
                linear_extrude(dim.z + dim.x / 2)
                offset(r)
                offset(-r)
                square([dim.x, dim.y], center = true);
                
                translate([0, 0, dim.z + dim.x / 2])
                rotate([90, 0, 0])
                cylinder(h = dim.y + T, r = dim.x / 2 - ring_t / 2, center = true);
            }

            translate([0, 0, dim.z + dim.x / 2])
            rotate([90, 0, 0])
            rotate_extrude()
            translate([dim.x / 2 - ring_t / 2, 0])
            offset(r)
            offset(-r)
            square([ring_t, dim.y], center = true);
        }
    }
    
    module body_metal() {
        offset_z = 9.4;
        
        dim = [13.0, 0.8, 4.5];
        
        color("#884")
        mirror([0, 0, 1])
        translate([0, 0, offset_z + dim.z / 2])
        difference() {
            cube(dim, center = true);
            
            cube([dim.x - 2, dim.y + T, dim.z + T], center = true);
        }
    }
    
    connector();
    body_plastic();
    body_metal();
}

yubikey_5c();
