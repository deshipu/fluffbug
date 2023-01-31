use <fluffbug.scad>;

$explode = 5;

module leg() {
    translate([0, 0, -$explode]) {
        translate([0, 0, $explode]) SG90_single_horn(0);
        translate([-0.5, -0.25, 1.5]) Femur();
        translate([10, 0, 1 + $explode * 2]) leg_screw();
        translate([6, 0, 1 + $explode * 2]) leg_screw();
        translate([35, 0, 2 - $explode * 2]) rotate([0, 180, 0]) leg_screw();
        translate([31, 0, 2 - $explode * 2]) rotate([0, 180, 0]) leg_screw();
    }
    translate([41, 0, 3]) rotate([180, 0, 0]) {
        translate([0, 0, $explode * 2]) SG90_single_horn(180);
    }
}


leg();
