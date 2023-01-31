use <fluffbug.scad>;

$explode = 5;

module leg() {
rotate([180, 0, 0]) {
    translate([0, 0, -$explode]) SG90();
    translate([0, 0, -7.9]) Tibia();
    translate([0, 0, -$explode * 2]) {
        translate([0, 8.3, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
        translate([0, -19.1, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
    }
}}


leg();
