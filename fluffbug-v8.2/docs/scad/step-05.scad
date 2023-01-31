use <fluffbug.scad>;

$explode = 5;

module servo(angle) {
    translate([0, 0, $explode * 2]) SG90_horn_screw();
    translate([0, 0, $explode * 1]) SG90_single_horn(angle);
    SG90();
}

module leg() {
    translate([-41, 0, 0]) {
        translate([0, 0, -0]) {
            translate([0, 0, -$explode * 2]) servo(0);
            translate([-0.5, -0.25, 1.5 - $explode]) Femur();
            translate([10, 0, 1 - $explode]) leg_screw();
            translate([6, 0, 1 - $explode]) leg_screw();
            translate([35, 0, 2 - $explode]) rotate([0, 180, 0]) leg_screw();
            translate([31, 0, 2 - $explode]) rotate([0, 180, 0]) leg_screw();
            translate([0, 0, -7.9 -$explode * 2]) Tibia();
            translate([0, 0, -$explode * 2]) {
                translate([0, 8.3, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
                translate([0, -19.1, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
            }
        }
        translate([41, 0, 3]) rotate([180, 0, 0]) {
            servo(180);
            translate([0, 0, 0]) {
                translate([0, 8.3, -12.6]) SG90_mount_screw();
                translate([0, -19.1, -12.6]) SG90_mount_screw();
            }
        }
    }
}

module body() {
    rotate([90, 0, 0]) {
        translate([0, 0, -22.6-5.8-4]) {
            translate([-6.9, 0, 0]) leg();
            translate([6.9, 0, 0]) mirror([1, 0, 0]) leg();
        }
        translate([0, 0, 22.6+5.8+4]) mirror([0, 0, 1]) {
            translate([-6.9, 0, 0]) leg();
            translate([6.9, 0, 0]) mirror([1, 0, 0]) leg();
        }
        translate([-6.72, -8.7, -16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72, -8.7, 16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72, 19.7, -16]) Coxa();
        translate([-6.72, 19.7, 16]) Coxa();
    }
    Body();
}

body();
