RA_abstand=84;
RA_staerke=3;

module m3_grundloch(h) {
	translate([0,0,-0.1]) {
		cylinder(h = h+0.1, r=2.9/2, $fn=30);
		rotate([0,0,45]) cube([2.9 / 2, 2.9 / 2, h+0.1]);
	}
}

module _rahmenverbinder_base() {
	rotate([90,0,0]) difference() {
		cube(size=[RA_abstand, 20, 6], center=true);
		for (x = [-1, +1]) {
			for (y = [-1, +1]) {
				translate([x*(RA_abstand/2 - 8), y*5, 0]) rotate([0, x*90, 0]) {
					rotate([0,0,90*x]) m3_grundloch(10);
				}
			}
		}
	}
}

// Stehend
// kein Raft, 0.30mm, 8%, 110/160 mm/s, 14min, 5.2g
// neu mit Löchern: kein Raft, 0.30mm, 8%, 110/170 mm/s,  14min, 5.0g

// Origin: Mitte
module rahmenverbinder() {
	rotate([-90,0,0]) _rahmenverbinder_base();
}

module rahmenverbinder_nupsi() {
*	translate([-RA_abstand/2 + 15/2,0,0])
	cube(size=[15, 16.8, 3.8], center=true);
}

rahmenverbinder();
