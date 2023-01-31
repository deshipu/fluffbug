use <fluffbug.scad>;

$explode = 5;

module leg() {
    translate([-41, 0, 0]) {
        translate([41, 0, 3]) rotate([180, 0, 0]) {
            SG90();
            translate([0, 0, $explode]) {
                translate([0, 8.3, -12.6]) SG90_mount_screw();
                translate([0, -19.1, -12.6]) SG90_mount_screw();
            }
        }
    }
}

module body() {
    translate([0, -25.4, -10.5]) rotate([90, 0, 90]) color("purple") {
        linear_extrude(height=1.6, center=true, convexity=10)
        import("body.svg");
    }
    translate([-0.8, 0, 43]) rotate([90, 0, -90]) BatteryHolder();
    translate([0.8, -10.16, 43.5]) color("dimgray") cube([3, 20.32, 5.08]);
    translate([0.8, -10.16, 25.72]) color("dimgray") cube([3, 20.32, 5.08]);
    translate([-2.8, -10.16-15.24, 25.72]) color("dimgray") cube([2, 15.24, 5.08]);
    translate([-2.8, -10.16+15.24+5.08, 25.72]) color("dimgray") cube([2, 15.24, 5.08]);
    rotate([90, 0, 0]) {
        translate([0, 0, -22.6-5.8-4]) {
            translate([-6.9, 0, -$explode]) leg();
            translate([6.9, 0, -$explode]) mirror([1, 0, 0]) leg();
        }
        translate([0, 0, 22.6+5.8+4]) mirror([0, 0, 1]) {
            translate([-6.9, 0, -$explode]) leg();
            translate([6.9, 0, -$explode]) mirror([1, 0, 0]) leg();
        }
        translate([-6.72, -8.7, -16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72, -8.7, 16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72, 19.7, -16]) Coxa();
        translate([-6.72, 19.7, 16]) Coxa();
    }
}

body();
