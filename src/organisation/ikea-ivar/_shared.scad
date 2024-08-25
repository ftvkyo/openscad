var_ivar_leg = [70, 15];

var_ivar_leg_holes = [35.5, 0, 127.5];
var_ivar_leg_hole_r = 7 / 2;


module ivar_leg(h = 100) {
    cube([var_ivar_leg.x, var_ivar_leg.y, h], center = true);
}
