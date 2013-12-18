use <libgear.scad>
use <Schnecke.scad>
use <MotorAufnahme.scad>
use <Blaetterrad.scad>
use <Mittelstift.scad>
use <RahmenVerbinder.scad>
use <RadLager.scad>

RA_staerke = 3;
RA_abstand = 84;
RA_hoehe=150;

Lside = 0;
Rside = 1;
Cside = 2;

// 10% 0.3mm 90/160 , 51min 16g
module _grossrad() {
	rotate([0,90,0]) difference() {
		gear(
			number_of_teeth=95,
			diametral_pitch=1,
			hub_thickness=4, rim_thickness=4,
			gear_thickness=4,
			bore_diameter=6,
			hub_diameter=10,
			$fn=30);
		for (i = [0:5]) {
			rotate([0, 0, 360/6 * i]) translate([29,0,0]) cylinder(h=10, r=11.25, center=true);
		}
	}
}

// Antriebswelle -> Großes Rad
// Mit Raft und viel Infill (>= 40%)
module _rad2() {
	rotate([0,90,0]) difference() {
		gear(
			number_of_teeth=20,
			diametral_pitch=1,
			hub_thickness=4, rim_thickness=4,
			gear_thickness=4,
			bore_diameter=0,
			hub_diameter=16,
			$fn=30);
		mittelstift_antistift();
	}
}

// Test 4 20% 0.3mm 90/170 234 rechts kein Raft (3mm Wandstaerke, größere Cutouts) 46min 18.2g - 47min mit helperdisks
// Test 5: wie 4, 231 90/160     22.6g 56m

module _rahmen_seitenwand() {
	difference() {
		translate([0,-10, 0]) cube(size=[RA_staerke, 135, RA_hoehe]);
		translate([-RA_staerke,125,60]) rotate([-50,0,0]) mirror([0,1,0]) cube(size=[3*RA_staerke, 200, 100]);

		// Durchgehende Achse
		translate([0,0,RA_hoehe/2]) rotate([0,90,0]) cylinder(h=RA_staerke*3, r=3, center=true, $fn=40);

		// Nups Nups
		translate([0, 54.2, RA_hoehe/2 - 20]) rotate([0,90,0]) radnupsi_anti();
		// Druckoptimierer
translate([-RA_staerke,70,65]) rotate([-50,0,0]) mirror([0,1,0]) cube(size=[3*RA_staerke, 81, 28]);
		translate([-RA_staerke,10,10]) cube(size=[3*RA_staerke, 55, 85]);
		translate([-RA_staerke,10,90]) cube(size=[3*RA_staerke, 40, 25]);
		translate([-RA_staerke,10,110]) cube(size=[3*RA_staerke, 29, 35]);

		translate([-RA_staerke,40,25]) cube(size=[3*RA_staerke, 65, 25]);
		translate([-RA_staerke,50,10]) cube(size=[3*RA_staerke, 20, 80]);

		translate([-RA_staerke,0,10]) cube(size=[3*RA_staerke, 20, 57]);
		translate([-RA_staerke,0,82]) cube(size=[3*RA_staerke, 20, 57]);

		*translate([-RA_staerke,95,10]) cube(size=[3*RA_staerke, 10,50]);
	}

	difference() {
		union() {
			translate([0,0,50]) cube(size=[RA_staerke, 80, 8]);
			translate([0,45,48.5]) cube(size=[RA_staerke, 20, 13]);
		}
		translate([0, 54.2, RA_hoehe/2 - 20]) rotate([0,90,0]) radnupsi_anti();
	}
}

module rahmen(side) {
	// Seitenwand
	if (side == Lside) translate([-RA_staerke, 0, -RA_hoehe/2]) _rahmen_seitenwand();
	if (side == Rside) translate([RA_abstand + RA_staerke, 0, -RA_hoehe/2]) mirror([1,0,0]) _rahmen_seitenwand();

	// Blätterrad
	if (side == Cside) for (i = [15]) {
		translate([0.5,0,0]) rotate([i,0,0]) rotate([0,90,0]) blaetterrad_demo();
	}

	// Rahmenverbinder oben und unten
	for (z = [-RA_hoehe/2 + 6/2, RA_hoehe/2 - 6/2]) {
		translate([RA_abstand/2,0,z]) {
			if (side == Cside) rahmenverbinder();
			if (side == Lside) rahmenverbinder_nupsi();
			if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
		}
	}

	// Rahmenverbinder hinten
	translate([RA_abstand/2,115,-RA_hoehe/2 + 6/2]) {
		if (side == Cside) rahmenverbinder();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}


	// Rahmen Stabilisierung hinten
	translate([0,90,20]) rotate([-55,0,0]) {
		if (side == Cside) translate([0.5, 0, 0]) rotate([0,90,0]) mittelstift();
		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
	}

	// Motor
	translate([RA_abstand - 10 - 3, 84, 5]) rotate([-90,0,90]) union() {
*		if (side == Cside) motor_aufnahme();
		if (side == Rside) motor_gegenstueck();
	}

	// Schnecke und restliche Dinge auf der Achse
	translate([0, 84 + 23, 5 -32.5 - 30/2 - 1]) {
		if (side == Cside) translate([0.5,0,0]) rotate([2,0,0]) _rad2();

		if (side == Cside) translate([0.5, 0, 0]) rotate([0,90,0]) mittelstift();
		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
	}

	if (side == Cside) translate([0.5,54.2,-20]) rotate([1.8,0,0]) _grossrad();

}

rahmen(Rside);
*rahmen(Lside);
*rahmen(Cside);

