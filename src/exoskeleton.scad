E = 0.001;

// Parameters

bone_thickness = 3;
bone_width = 25;

joint_plug_r = 15;
joint_ring_width = 10;
joint_height = 10;
joint_gap = 0.3;

// Bones and their parts

module bone_manus() {
    length = 100;
    cube([
        length,
        bone_width,
        bone_thickness,
    ]);
}

module bone_ulna() {
    length = 270;
    cube([
        length,
        bone_width,
        bone_thickness,
    ]);
}

module bone_humerus() {
    length = 350;
    cube([
        length,
        bone_width,
        bone_thickness,
    ]);
}

module bones() {
    translate([0, 100, 0])
        bone_manus();

    translate([0, 50, 0])
        bone_ulna();

    bone_humerus();
};

// Joints and their parts

module joint_2d_slice_half() {
    translate([0, joint_height / 2])
    intersection() {
        scale([1, 0.5])
            circle(joint_ring_width);
        square([joint_ring_width, joint_height]);
    }

    polygon([
        [0, 0],
        [0, -joint_height / 2],
        [joint_plug_r / 2 + joint_gap + joint_ring_width, - joint_height / 2],
        [joint_plug_r / 2 + joint_gap + joint_ring_width, - joint_gap / 2],
        [joint_plug_r / 2, - joint_gap / 2],
        [joint_plug_r / 2, joint_height / 2 + joint_gap],
        [0, joint_height / 2 + joint_gap],
    ]);

    polygon([
        [joint_plug_r / 2 + joint_gap, joint_gap / 2],
        [joint_plug_r / 2 + joint_gap + joint_ring_width, joint_gap / 2],
        [joint_plug_r / 2 + joint_gap + joint_ring_width, joint_height / 2 - joint_gap],
        [joint_plug_r / 2 + joint_gap, joint_height / 2 - joint_gap],
    ]);
}

module joint_joiners() {
    extent = 30;
    wall_width = 5;
    hole_r = 3;

    width = bone_width + wall_width;

    // Top joiner

    difference() {

        union() {
            translate([joint_plug_r * 0.6, - width / 2, joint_gap / 2])
                cube([extent, width, joint_height / 2 - joint_gap * 2]);

            translate([
                joint_plug_r * 0.6 + joint_ring_width + joint_gap * 2,
                - width / 2,
                - joint_height / 2,
            ])
                cube([extent - joint_ring_width - joint_gap * 2, width, joint_height - joint_gap]);
        }

        // Cutout
        translate([
            joint_plug_r * 0.6 + extent * 0.5,
            - bone_width / 2,
            - bone_thickness - joint_gap / 2,
        ])
            #cube([
                extent,
                bone_width,
                joint_height,
            ]);

        // Unsharpen edges
        translate([0, 0, joint_height * 1.5])
        scale([1, 2, 1])
        rotate([0, 15, 0])
        translate([
            joint_plug_r * 0.6 + extent * 0.5,
            - bone_width / 2,
            - bone_thickness - joint_gap / 2,
        ])
            cube([
                extent,
                bone_width,
                joint_height,
            ]);

        // Mounting holes

        translate([
            joint_plug_r * 0.6 + extent * 0.5 + hole_r * 2,
            hole_r * 2,
            - bone_thickness - joint_gap / 2,
        ])
        #cylinder(joint_height, r = hole_r, center = true);

        translate([
            joint_plug_r * 0.6 + extent * 0.5 + hole_r * 2,
            - hole_r * 2,
            - bone_thickness - joint_gap / 2,
        ])
        #cylinder(joint_height, r = hole_r, center = true);
    }

    // Bottom joiner

    difference() {

        translate([- joint_plug_r * 0.6 - extent, - width / 2, - joint_height / 2])
            cube([extent, width, joint_height / 2 - joint_gap / 2]);

        // Cutout
        translate([
            - joint_plug_r * 0.6 - extent * 1.5,
            - bone_width / 2,
            - bone_thickness - joint_gap / 2,
        ])
            #cube([
                extent,
                bone_width,
                joint_height,
            ]);

        // Mounting holes

        translate([
            - joint_plug_r * 0.6 - extent * 0.5 - hole_r * 2,
            hole_r * 2,
            - bone_thickness - joint_gap / 2,
        ])
        #cylinder(joint_height, r = hole_r, center = true);

        translate([
            - joint_plug_r * 0.6 - extent * 0.5 - hole_r * 2,
            - hole_r * 2,
            - bone_thickness - joint_gap / 2,
        ])
        #cylinder(joint_height, r = hole_r, center = true);

    }
}

module joint_wrist() {
    rotate_extrude()
        joint_2d_slice_half();
    joint_joiners();
}

module joint_elbow() {
    rotate_extrude()
        joint_2d_slice_half();
    joint_joiners();

}

module joint_shoulder() {
    rotate_extrude()
        joint_2d_slice_half();
    joint_joiners();

}

module joints() {
    translate([-100, 100, 0])
        joint_wrist();
    translate([-100, 50, 0])
        joint_elbow();
    translate([-100, 0, 0])
        joint_shoulder();
}

// joint_2d_slice_half();

// bones();
// joints();

joint_shoulder();
