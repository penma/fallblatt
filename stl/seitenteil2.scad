use <libgear.scad>
use <LichtschrankeRad.scad>
use <LichtschrankeHalterung.scad>
use <ServoRad.scad>
use <ServoHalterung.scad>
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
Nside = 3;

// 10% 0.3mm 90/160 , 51min 16g
module _grossrad() {
	rotate([0,90,0]) difference() {
		gear(
			number_of_teeth=65,
			diametral_pitch=1,
			hub_thickness=4, rim_thickness=4,
			gear_thickness=4,
			bore_diameter=6,
			hub_diameter=10,
			$fn=30);
		for (i = [0:5]) {
			rotate([0, 0, 360/6 * i]) translate([19,0,0]) cylinder(h=10, r=8, center=true);
		}
	}
}

// Test 4 20% 0.3mm 90/170 234 rechts kein Raft (3mm Wandstaerke, größere Cutouts) 46min 18.2g - 47min mit helperdisks
// Test 5: wie 4, 231 90/160     22.6g 56m
module _rahmen_frame(side) {
	intersection() {
		translate([0,-10, 0]) cube(size=[RA_staerke, 125, RA_hoehe - 2.5]);
		union() {
			translate([-RA_staerke,120,RA_hoehe/2 + 10]) rotate([-27.5,0,0]) mirror([0,1,0]) cube(size=[3*RA_staerke, 200, 7.5]);
			// oben
			translate([-RA_staerke,-10,RA_hoehe - 2.5 - 7.5]) cube(size=[3*RA_staerke, 25, 7.5]);
			// vorn
			translate([-RA_staerke,-10,0]) cube(size=[3*RA_staerke, 10, RA_hoehe - 2.5]);
			// unten
			translate([-RA_staerke,-10,0]) cube(size=[3*RA_staerke, 125, 7.5]);
			// hinten
			translate([-RA_staerke,105,0]) cube(size=[3*RA_staerke, 10, 95]);

			// Achse
			translate([-RA_staerke,-7.5,RA_hoehe/2 - 7.5]) cube(size=[3*RA_staerke, 15, 15]);
			// Hinterer Verbinder
			translate([-RA_staerke,95,90]) cube(size=[3*RA_staerke, 10, 10]);
			// Lichtschrankenrad
			translate([-RA_staerke, 101.5 - 7.5, RA_hoehe/2 - 20 - 7.5]) cube(size=[3*RA_staerke, 15, 15]);

			if (side == Lside) {
				// Nupsi für großes Rad
				difference() {
					union() {
						translate([-RA_staerke, 38 - 7.5, RA_hoehe/2 - 20 - 7.5]) cube([3*RA_staerke, 15, 15]);
						translate([-RA_staerke, 0, RA_hoehe/2 - 20 - 4]) cube([3*RA_staerke, 100, 8]);
					}
					translate([0, 38, RA_hoehe/2 - 20]) rotate([0,90,0]) radnupsi_anti();
				}
				translate([-RA_staerke, 0, RA_hoehe/2 - 0 - 4]) cube([3*RA_staerke, 91, 8]);
				translate([-RA_staerke, 81 - 20/2, 0]) cube([3*RA_staerke, 20, 20]);
				translate([-RA_staerke, 101.5 - 15, RA_hoehe/2 - 20 - 7.5]) cube(size=[3*RA_staerke, 20, 15]);
			}
		}
	}

}

module _rahmen_seitenwand(side) {
	difference() {
		_rahmen_frame(side);
		// Achse
		translate([0,0.25,RA_hoehe/2]) rotate([0,90,0]) cylinder(h=RA_staerke*3, r=4.85/2, center=true, $fn=40);
		// Servo
		translate([0, 81, RA_hoehe/2 -20]) rotate([90, 180, 90]) servo_halterung_ausschnitt();
	}

}

module verbinder_unten() {
	// 0mm unten
	rahmenverbinder();
	translate([RA_abstand/2 - 12.5 - 3 + 4/2, -6, 39]) rotate([0, 0, 180]) mirror([0,1,0]) lichtschranke_halterung(15);
}
module verbinder_oben() {
	// 11mm oben
	rahmenverbinder();
	translate([RA_abstand/2 - 12.5 - 3 - 11 + 4/2, -6, -25]) rotate([0, 0, 180]) mirror([0,0,1]) mirror([0,1,0]) lichtschranke_halterung(1);
}
module verbinder_vorne() {
	difference() {
		rahmenverbinder();
		translate([0, -9, 0]) cube(size=[3, 1.5, 10], center=true);
	}
	translate([0,-10 + 0.5/2, -3 - 3/2]) cube(size=[RA_abstand, 0.5, 3], center=true);
}

module rahmen(side) {
	// Seitenwand
	if (side == Lside) translate([-RA_staerke, 0, -RA_hoehe/2]) _rahmen_seitenwand(side);
	if (side == Rside) translate([RA_abstand + RA_staerke, 0, -RA_hoehe/2]) mirror([1,0,0]) _rahmen_seitenwand(side);

	// Blätterrad
	if (side == Cside) for (i = [15]) {
		% translate([0.5,0,0]) rotate([i,0,0]) rotate([0,90,0]) blaetterrad_demo();
	}

	// Rahmenverbinder oben und unten
	translate([RA_abstand/2,0, -RA_hoehe/2 + 6/2]) {
		if (side == Cside) rahmenverbinder();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}
	translate([RA_abstand/2,0, RA_hoehe/2 - 2.5 - 6/2]) {
		if (side == Cside) verbinder_vorne();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}

	// Rahmenverbinder hinten
	translate([RA_abstand/2,105, -RA_hoehe/2 + 6/2]) {
		if (side == Cside) verbinder_unten();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}
	translate([RA_abstand/2,105, 18]) {
		if (side == Cside) verbinder_oben();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}

	// Motor
	translate([-RA_staerke, 81, -20]) rotate([90, 180, 90]) union() {
		if (side == Lside) servo_halterung();
		if (side == Cside) rotate([0, 0, -1]) translate([0, 0, 3.5]) servorad();
	}

	// Das Lichtschrankenrad
	translate([0, 101.5, -20]) {
		if (side == Cside) translate([0.5,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_rad();
		if (side == Cside) translate([0.5 - 3.5,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_schlitze();
		if (side == Cside) translate([0.5 - 3.5 - 13,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_schlitze();

		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
	}

	if (side == Cside) translate([0.5,38,-20]) rotate([-1.1,0,0]) _grossrad();
}


*rahmen(Rside);
rahmen(Lside);
%rahmen(Cside);


