$fn=30;

difference() {
	translate([0,5,-1]) cube([11, 14.5, 9]);

	for (y = [-0.1, 9.5]) {
		translate([y, 18 - 1 + 0.5, 6]) cube([1.6, 2.6, 2.1]);
		translate([y, -0.1 + 0.5, 5]) cube([1.6, 7.1, 3.1]);
	}

	translate([11/2, 19.6, 2]) rotate([90, 0, 0]) cylinder(h=8, r=2.9/2);
}
translate([11/2, 15, 8]) cylinder(h=2.5, r1=5/2, r2=7/2);