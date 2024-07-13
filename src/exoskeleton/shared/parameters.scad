NOZZLE = 0.4;
LAYER = 0.2;
E = 0.01;


joint_h = 10;
joint_d = 20;

bone_l = 300;
bone_d = 10;
bone_inner_d = 5.5;

bone_box_h = bone_d + NOZZLE * 6;
bone_box_r = bone_d / 2 + NOZZLE * 6;

// How much to raise the bone box over the joint_h
bone_raise =  (bone_box_h - bone_d) / 2 - NOZZLE;

// Offset to the place of the bone attachment
bone_offset = joint_d * (1 + sqrt(2)) / 2 + bone_box_r * sqrt(2);

strap_width = 25;
strap_end_offset = joint_d / 4;

screw_d = 3;
screw_l = 12;
screw_long_l = 20;
screw_nut_d = 6;
screw_nut_l = 4;

bone_box_rod_r = screw_d / 2 + NOZZLE * 3;
