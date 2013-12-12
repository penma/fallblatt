RA_abstand=84;
RA_staerke=3;

module _rahmenverbinder_base() {
	rotate([90,0,0]) difference() {
		cube(size=[RA_abstand, 20, 6], center=true);
		translate([-35,0,0]) cube(size=[20, 18.5, 4.5], center=true);
		translate([+35,0,0]) cube(size=[20, 18.5, 4.5], center=true);
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
	translate([-RA_abstand/2 + 15/2,0,0])
	cube(size=[15, 17.4, 3.8], center=true);
}

rahmenverbinder();