
module lichtschranke_halterung(h=0) {
	translate([-(2 + 1 + 2.5 + 4 + 4), -2 - 3, -14 - 5]) difference() {
		union() {
			difference() {
				translate([0, 1, -2 - h]) cube([30, 13, 6 + h]);
				translate([2, 0, -3 - h]) cube([30 - 2*2, 15, h]);
			}
			
			translate([0, 1, -1]) cube([5, 13, 6]);
			translate([2 + 1 + 2.5 + 3.75 + 3.5 + 12.5, 1, -1]) cube([4.75, 13, 6]);
			
			translate([5, 1, -1]) cube([20, 1, 7]);
		}

		translate([2 - 0.5, 0, 0]) cube([3.5, 15, 3.25]);
		translate([2 + 1, 0, 0]) cube([2.5, 15, 7]);

		translate([2 + 1 + 2.5 + 3.5, 0, 2.25]) cube([4, 15, 4]);

		translate([2 + 1 + 2.5 + 3.75 + 3.5 + 12.5 - 4, 0, 0]) cube([4, 15, 7]);
		translate([2 + 1 + 2.5 + 3.75 + 3.5 + 12.5, 0, 0]) cube([2.5, 15, 3.25]);
	}
	% translate([2.5, -3, 0]) cube([5, 7, 4.2]);
	% translate([-2.5 - 5, -3, 0]) cube([5, 7, 4.2]);
	% translate([2.5, -3, -14]) cube([5, 7, 13.8]);
	% translate([-2.5 - 5, -3, -14]) cube([5, 7, 13.8]);
}

lichtschranke_halterung();
