use <Schnecke.scad>
use <MotorAufnahme.scad>
use <Blaetterrad.scad>
use <Mittelstift.scad>
use <RahmenVerbinder.scad>

RA_staerke = 3;
RA_abstand = 82;
RA_hoehe=150;

Lside = 0;
Rside = 1;
Cside = 2;

// Test Print: 10% 0.4mm 100mm/s ~ 40min
// Oberes Ende kann 1,25 cm runter

// Test 2: 15% 0.4mm 100mm/s (linke Seite) 51m 29.2g (4mm Wandstaerke)
// Test 3: 25% 0.4mm 100mm/s (rechte Seite) fail?
// Test 3.5:  20% 0.4mm 93/150  rechts 80min Raft 49.4g (4mm Wandstaerke)
// Test 4 20% 0.3mm 90/170 234 rechts kein Raft (3mm Wandstaerke, größere Cutouts) 46min 18.2g - 47min mit helperdisks

module _rahmen_seitenwand() {
	difference() {
		translate([0,-10, 0]) cube(size=[RA_staerke, 115, RA_hoehe]);
		translate([-RA_staerke,105,60]) rotate([-55,0,0]) mirror([0,1,0]) cube(size=[3*RA_staerke, 200, 100]);

		// Druckoptimierer
translate([-RA_staerke,60,70]) rotate([-55,0,0]) mirror([0,1,0]) cube(size=[3*RA_staerke, 77, 20]);
		translate([-RA_staerke,10,10]) cube(size=[3*RA_staerke, 55, 85]);
		translate([-RA_staerke,10,90]) cube(size=[3*RA_staerke, 40, 25]);
		translate([-RA_staerke,10,110]) cube(size=[3*RA_staerke, 22, 35]);

		translate([-RA_staerke,40,25]) cube(size=[3*RA_staerke, 50, 25]);
		translate([-RA_staerke,50,10]) cube(size=[3*RA_staerke, 20, 80]);

		translate([-RA_staerke,0,10]) cube(size=[3*RA_staerke, 20, 57]);
		translate([-RA_staerke,0,82]) cube(size=[3*RA_staerke, 20, 57]);
	}
}

module rahmen(side) {
	// Seitenwand
	if (side == Lside) translate([-RA_staerke, 0, -RA_hoehe/2]) _rahmen_seitenwand();
	if (side == Rside) translate([RA_abstand, 0, -RA_hoehe/2]) _rahmen_seitenwand();

	// Blätterrad
	if (side == Cside) for (i = [2,9,-4,22]) {
		translate([0.5,0,0]) rotate([-62 + 7 * i,0,0]) rotate([0,90,0]) blaetterrad_demo();
	}

	// Nupsi Blätterrad
	if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
	if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();

	// Rahmenverbinder oben und unten
	for (z = [-RA_hoehe/2 + 6/2, RA_hoehe/2 - 6/2]) {
		translate([RA_abstand/2,0,z]) {
			if (side == Cside) rahmenverbinder();
			if (side == Lside) rahmenverbinder_nupsi();
			if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
		}
	}

	// Rahmenverbinder hinten
	translate([RA_abstand/2,95,-RA_hoehe/2 + 6/2]) {
		if (side == Cside) rahmenverbinder();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}


	// Rahmen Stabilisierung hinten
	translate([0,80,20]) rotate([-55,0,0]) {
		if (side == Cside) translate([0.5, 0, 0]) rotate([0,90,0]) mittelstift();
		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
	}

	// Motor
	translate([RA_abstand - 10 - 3, 79, 5]) rotate([-90,0,90]) union() {
		if (side == Cside) motor_aufnahme();
		if (side == Rside) motor_gegenstueck();
	}

	// Schnecke
	translate([0, 97, 5 -32.5 - 30/2]) {
		if (side == Cside) translate([RA_abstand - 10 - 3 - 5/2, 0, 0])
			rotate([0,90,0]) rotate([0,0, 360/20]) schnecke_rad();

		if (side == Cside) translate([0.5, 0, 0]) rotate([0,90,0]) mittelstift();
		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
}


}

rahmen(Rside);
*rahmen(Lside);
*rahmen(Cside);