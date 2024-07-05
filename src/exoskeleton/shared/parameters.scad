NOZZLE = 0.4;
LAYER = 0.2;
E = 0.01;


joint_h = 10;
joint_d = 30;

bone_d = 10;

bone_cap_h = 10;
bone_cap_d = bone_d + 4;

bone_box_wall = NOZZLE * 6;
bone_box_bottom = LAYER * 5;

bone_box_l = bone_cap_h + bone_box_wall * 2 + NOZZLE * 2;
bone_box_w = bone_cap_d * 2 + NOZZLE * 3 + bone_box_wall * 2;
bone_box_h = bone_cap_d + bone_box_bottom;

strap_width = 25;
