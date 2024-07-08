NOZZLE = 0.4;
LAYER = 0.2;
E = 0.01;


joint_h = 10;
joint_d = 32.25;

bone_l = 300;
bone_d = 10;
bone_inner_d = 6;

bone_cap_h = 10;
bone_cap_d = bone_d + 4;

bone_box_wall = NOZZLE * 4;

bone_box_l = bone_cap_h + bone_box_wall * 2 + NOZZLE * 2;
bone_box_w = bone_cap_d * 2 + NOZZLE * 3 + bone_box_wall * 2;
bone_box_h = bone_cap_d + NOZZLE * 2;

bone_box_offset = joint_d * (1 + sqrt(2)) / 2;

strap_width = 25;
strap_offset = bone_box_l;
