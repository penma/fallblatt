module _rahmenverbinder_base() {
	rotate([90,0,0]) difference() {
		cube(size=[82, 20, 6], center=true);
		translate([-35,0,0]) cube(size=[20, 18.5, 4.5], center=true);
		translate([+35,0,0]) cube(size=[20, 18.5, 4.5], center=true);
	}
}

// Stehend (Löcher nach oben zeigend)
// kein Raft, 0.30mm, 8%, 110/160 mm/s, 14min, 5.2g
difference() {
	_rahmenverbinder_base();
	for (i = [-20,0,+20]) {
		translate([i,0,5]) cylinder(h=10, r1=2.4, r2=2.4, $fn=40);
	}
}