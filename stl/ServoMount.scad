use <ServoRad.scad>

module _mutter() {
	translate([0, 0, -0.1]) rotate([0, 0, 360/6 * 0.5]) cylinder(r=9/2, h=3.5, $fn=6);
	translate([0, 0, 0]) cylinder(r=5/2, h=50, $fn=20);
	translate([0, 0, 3.4]) cylinder(r1=8/2, r2=5/2, h=1, $fn=20);
}

module servomount() {
	translate([-10, -9 - 9.1/2 - 12, 0]) difference() {
		union() {
			translate([0, 2.5, 0]) cube(size=[20, 65, 3]);
			for (y = [9, 61]) {
				hull() for (x = [5, 15]) {
					translate([x, y, 0.5]) cylinder(r=9.1/2, h=25, $fn=50);
				}
			}
		}
		for (y = [9, 61]) {
			for (x = [5, 15]) {
				translate([x, y, 0]) _mutter();
			}
		}
		translate([9, 10, 21]) cube(size=[2, 50, 5]);
	}
}

module servomount_cutout() {
	translate([-10, -9 - 9.1/2 - 12 + 2.5, -1]) cube(size=[20, 65, 5]);
}

module servomount_abstandshalter() {
	translate([-10, -9 - 9.1/2 - 12, 0]) difference() {
		for (y = [9, 61]) {
			hull() for (x = [5, 15]) {
				translate([x, y, 0.5 + 25 + 2]) cylinder(r=9.1/2, h=3.5, $fn=20);
			}
		}
		for (y = [9, 61]) {
			for (x = [5, 15]) {
				translate([x, y, 0.5 + 23 + 2 - 0.1]) cylinder(r=5/2, h=5.7, $fn=20);
				translate([x, y, 0.5 + 23 + 2 + 3]) cylinder(r1=5/2, r2=9/2, h=2.6, $fn=20);
			}
		}
	}
}

servomount();
%servomount_abstandshalter();
%translate([0, 0, 3.5]) servorad();


