$explode = cos(180 + $t * 360) * 10 + 10;


module SG90_horn_screw() {
    color("DarkGray") union() {
        translate([0, 0, 3.4]) difference() {
            union() {
                cylinder(r=1.3, h=0.9, $fn=8);
                translate([0, 0, -4.4]) cylinder(r1=0.25, r2=0.8, h=5, $fn=8);
            }
            translate([-0.25, -1, 0.4]) cube([0.5, 2, 1]);
            translate([1, -0.25, 0.4]) rotate(90) cube([0.5, 2, 1]);
        }
    }
}

module SG90_mount_screw() {
    color("DarkGray") union() {
        translate([0, 0, 3.4]) difference() {
            union() {
                cylinder(r=1.4, h=0.9, $fn=8);
                translate([0, 0, -7.4]) cylinder(r1=0.25, r2=0.8, h=8, $fn=8);
                cylinder(r=1.8, h=0.2, $fn=8);
            }
            translate([-0.25, -1, 0.4]) cube([0.5, 2, 1]);
            translate([1, -0.25, 0.4]) rotate(90) cube([0.5, 2, 1]);
        }
    }
}

module leg_screw() {
    color("black") union() {
        translate([0, 0, 3.4]) difference() {
            union() {
                cylinder(r=1, h=0.5, $fn=6);
                translate([0, 0, -3.5]) cylinder(r1=0.2, r2=0.6, h=3.5, $fn=4);
            }
        }
    }
}

module SG90() {
    servo_height = 22.6;
    servo_width = 12.2;
    servo_depth = 22.8;
    servo_ear_depth = 4.8;
    servo_big_tip_r = 6.05;

    translate([-6.0, -16.9, -servo_height - 5.8 - 1]) union() {
        color("darkslateblue", 0.75) union () {
            cube([servo_width, servo_depth, servo_height]);
            translate([0, -4.8, 17.6]) {
                difference () {
                    cube([12.0, 32.3, 2.4]);
                    translate([6.0, 1.5, -0.1]) cylinder(r=2, h=2.6, $fn=10);
                    translate([6.0, 30.8, -0.1]) cylinder(r=2, h=2.6, $fn=10);
                }
            }
            translate([6.0, 16.9, servo_height]) {
                cylinder(r=servo_big_tip_r, h=5.8, $fn=20);
            }
            translate([6.0, 16.9 - servo_big_tip_r, servo_height]) {
                cylinder(r=2.75, h=5.8, $fn=10);
            }
        }
        color("Snow") translate([6.0, 16.9, servo_height + 5.8]) difference() {
            cylinder(r=2.275, h=3.9, $fn=6);
            cylinder(r=0.8, h=5, $fn=10);
        }
    }
    translate([1, -10, -25]) rotate([0, 90, 90]) {
        color("Orange") translate([1.27, 0, 12]) cylinder(r1=0.75, r2=0, h=20);
        color("Red") translate([1.27, 1, 12]) cylinder(r1=0.75, r2=0, h=20);
        color("Brown") translate([1.27, 2, 12]) cylinder(r1=0.75, r2=0, h=20);
    }
}

module _SG90_horn_arm() {
    difference() {
        translate([13.8, 0, 3.1]) {
            cylinder(r=1.85, h=1.3, $fn=10);
            translate([0,-2,0]) rotate([0,0,94]) {
                cube([4, 13.8, 1.3]);
            }
            translate([0,-2,0]) rotate([0,0,86]) {
                cube([4, 13.8, 1.3]);
            }
        }
        for(i=[0:5]) {
            translate([13.8 - i * 2,0,0]) {
                cylinder(r=0.6, h=8, $fn=8);
            }
        }
    }
}

module SG90_single_horn(angle) {
    rotate(angle) color("dimgray") {
        difference() {
            union() {
                cylinder(r=3.3, h=4.4, $fn=20);
                _SG90_horn_arm();
            }
            translate([0,0,-1]) {
                cylinder(r=2.275, h=3.2, $fn=6);
                cylinder(r=1, h=8, $fn=10);
                translate([0, 0, 4.4]) cylinder(r=2.35, h=2, $fn=10);
            }
        }
    }
}

module S2Mini() {
    translate([0, -16.365, -11.12]) {
        rotate([90, 0, 90]) color("darkmagenta") {
            linear_extrude(height=0.6, center=true, convexity=10)
            import("s2mini.svg");
        }
        color("black") {
            translate([-3.3, 5.16, 0.8]) cube([3, 20.32, 5.08]);
            translate([-3.3, 5.16, 18.6]) cube([3, 20.32, 5.08]);
        }
        color("silver") hull() {
            translate([1.75, 25, 15]) rotate([0, 90, 90]) cylinder(r=1.5, h=7.5, $fn=12);
            translate([1.75, 25, 9]) rotate([0, 90, 90]) cylinder(r=1.5, h=7.5, $fn=12);
        }
        color("black") translate([0, 10, 10]) cube([0.5, 7, 7]);
        for (i=[0:1])
        translate([-5.7, 6.43, 19.87 - 2.54 * i * 7]) for(x=[0:7]) for(y=[0:1]) {
            translate([0, x * 2.54, y * 2.54]) {
                color("gold") cube([12.7, 0.5, 0.5]);
                color("silver") translate([5.3, 0.25, 0.25]) rotate([0, 90, 0]) cylinder(r=1.27, h=0.8, $fn=8);
            }
        }
    }
}

module Femur() {
    color("silver", 0.5) {
        translate([-5.41, -5.67])
        linear_extrude(height=3, center=true, convexity=10)
        import("femur.svg");
    }
}

module Tibia() {
    color("silver", 0.5) {
        translate([-8.948, -52.5])
        linear_extrude(height=3, center=true, convexity=10)
        import("tibia.svg");
    }
}
module Coxa() {
    color("silver", 0.5) {
        translate([-5.88, -2.65])
        linear_extrude(height=3, center=true, convexity=10)
        import("coxa.svg");
    }
}

module Servo(angle) {
    translate([0, 0, $explode * 3]) SG90_horn_screw();
    translate([0, 0, $explode * 2]) SG90_single_horn(angle);
    SG90();
}

module Leg(hip=0, knee=0) {
    translate([-41, 0, 0]) {
        translate([41, 0, 3 - $explode]) rotate(-hip) translate([-41, 0, -3]) {
            translate([0, 0, -$explode]) rotate(-knee) Servo(knee);
            translate([-0.5, -0.25, 1.5]) Femur();
            translate([10, 0, 1 + $explode * 2]) leg_screw();
            translate([6, 0, 1 + $explode * 2]) leg_screw();
            translate([35, 0, 2 - $explode * 2]) rotate([0, 180, 0]) leg_screw();
            translate([31, 0, 2 - $explode * 2]) rotate([0, 180, 0]) leg_screw();
            rotate(-knee) {
                translate([0, 0, -7.9]) Tibia();
                translate([0, 0, -$explode * 2]) {
                    translate([0, 8.3, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
                    translate([0, -19.1, -8.5]) rotate([180, 0, 0]) SG90_mount_screw();
                }
            }
        }
        translate([41, 0, 3]) rotate([180, 0, 0]) {
            Servo(180 + hip);
            translate([0, 0, $explode]) {
                translate([0, 8.3, -12.6]) SG90_mount_screw();
                translate([0, -19.1, -12.6]) SG90_mount_screw();
            }
        }
    }
}

module BatteryHolder() {
    translate([-21.465, -9.145, 0]) color("dimgray") {
        cube([4.13, 18.29, 15.24]);
        translate([4.13, 0, 0]) cube([34.67, 18.29, 8]);
        translate([42.93 - 4.13, 0, 0]) cube([4.13, 18.29, 15.24]);
    }
}

module Battery() {
    color("mediumpurple") {
        translate([-16.5, 0, 10]) rotate([0, 90, 0]) cylinder(r=8.5, h=33, $fn=20);
    }
}

module IDCPlug2x6() {
    color("black") translate([-12, 0, 0]) cube([12, 15.24, 5.08]);
}

module Body() {
    translate([0, -25.4, -10.5]) rotate([90, 0, 90]) color("purple") {
        linear_extrude(height=1.6, center=true, convexity=10)
        import("body.svg");
    }
    translate([-0.8, 0, 43]) rotate([90, 0, -90]) BatteryHolder();
    translate([0.8, -10.16, 43.5]) color("dimgray") cube([3, 20.32, 5.08]);
    translate([0.8, -10.16, 25.72]) color("dimgray") cube([3, 20.32, 5.08]);
    translate([-2.8, -10.16-15.24, 25.72]) color("dimgray") cube([2, 15.24, 5.08]);
    translate([-2.8, -10.16+15.24+5.08, 25.72]) color("dimgray") cube([2, 15.24, 5.08]);
}


module Robot() {
    rotate([90, 0, 0]) {
        translate([0, 0, -22.6-5.8-4]) {
            translate([-6.9, 0, -$explode]) Leg();
            translate([6.9, 0, -$explode]) mirror([1, 0, 0]) Leg();
        }
        translate([0, 0, 22.6+5.8+4]) mirror([0, 0, 1]) {
            translate([-6.9, 0, -$explode]) Leg();
            translate([6.9, 0, -$explode]) mirror([1, 0, 0]) Leg();
        }
        translate([-6.72, -8.7 - $explode, -16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72, -8.7 - $explode, 16]) rotate([180, 0, 0]) Coxa();
        translate([-6.72 + $explode, 19.7, -16]) Coxa();
        translate([-6.72 + $explode, 19.7, 16]) Coxa();
    }
    Body();
    translate([-0.8 - $explode, 0, 43]) rotate([90, 0, -90]) Battery();
    translate([-2.8 - $explode, -10.16+15.24+5.08, 25.72]) IDCPlug2x6();
    translate([-2.8 - $explode, -10.16-15.24, 25.72]) IDCPlug2x6();
    translate([7 + $explode, 1, 36]) S2Mini();
}

Robot();

