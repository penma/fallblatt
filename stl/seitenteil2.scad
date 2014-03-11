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
RA_hoehe=147.5;

Lside = 0;
Rside = 1;
Cside = 2;

module _grossrad() {
	import("cache/grossrad.stl"); *
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

module _rahmen_frame(side) {
	intersection() {
		translate([0,-10, 0]) cube(size=[RA_staerke, 125, RA_hoehe]);
		translate([-1, 0, 0]) scale([RA_staerke + 2, 1, 1]) union() {
			translate([0,120,85]) rotate([-27.5,0,0]) mirror([0,1,0]) cube(size=[1, 200, 7.5]);
			// oben
			translate([0,-10,RA_hoehe - 7.5]) cube(size=[1, 25, 7.5]);
			// vorn
			translate([0,-10,0]) cube(size=[1, 10, RA_hoehe - 2.5]);
			// unten
			translate([0,-10,0]) cube(size=[1, 125, 7.5]);
			// hinten
			translate([0,105,0]) cube(size=[1, 10, 95]);

			// Achse
			translate([0,-7.5,75 - 7.5]) cube(size=[1, 15, 15]);
			// Hinterer Verbinder
			translate([0,95,90]) cube(size=[1, 10, 10]);
			// Lichtschrankenrad
			translate([0, 101.5 - 7.5, 75 - 20 - 7.5]) cube(size=[1, 15, 15]);

			if (side == Lside) {
				// Nupsi für großes Rad
				difference() {
					union() {
						translate([0, 38 - 7.5, 55 - 15/2]) cube([1, 15, 15]);
						translate([0, 0, 55 - 8/2]) cube([1, 100, 8]);
					}
					translate([0, 38, 55]) rotate([0,90,0]) radnupsi_anti();
				}
				translate([0, 0, 75 - 4]) cube([1, 91, 8]);
				translate([0, 81 - 20/2, 0]) cube([1, 20, 20]);
				translate([0, 101.5 - 15, 55 - 7.5]) cube(size=[1, 20, 15]);
			}
		}
	}

}

module _rahmen_seitenwand(side) {
	difference() {
		_rahmen_frame(side);
		// Achse
		translate([0,0.25,75]) rotate([0,90,0]) cylinder(h=RA_staerke*3, r=4.75/2, center=true, $fn=40);
		// Servo
		translate([0, 81, 55]) rotate([90, 180, 90]) servo_halterung_ausschnitt();
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
	if (side == Lside) translate([-RA_staerke, 0, 0]) _rahmen_seitenwand(side);
	if (side == Rside) translate([RA_abstand + RA_staerke, 0, 0]) mirror([1,0,0]) _rahmen_seitenwand(side);

	// Blätterrad
	if (side == Cside) for (i = [15]) {
		% translate([0.5,0.25, 75]) rotate([i,0,0]) rotate([0,90,0]) blaetterrad_demo();
	}

	// Rahmenverbinder oben und unten
	translate([RA_abstand/2,0, 6/2]) {
		if (side == Cside) rahmenverbinder();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}
	translate([RA_abstand/2,0, RA_hoehe - 6/2]) {
		if (side == Cside) verbinder_vorne();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}

	// Rahmenverbinder hinten
	translate([RA_abstand/2,105, 6/2]) {
		if (side == Cside) verbinder_unten();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}
	translate([RA_abstand/2,105, 93]) {
		if (side == Cside) verbinder_oben();
		if (side == Lside) rahmenverbinder_nupsi();
		if (side == Rside) rotate([0,0,180]) rahmenverbinder_nupsi();
	}

	// Motor
	translate([-RA_staerke, 81, 55]) rotate([90, 180, 90]) union() {
		if (side == Lside) servo_halterung();
		if (side == Cside) rotate([0, 0, -1]) translate([0, 0, 3.5]) servorad();
	}

	// Das Lichtschrankenrad
	translate([0, 101.5, 55]) {
		if (side == Cside) translate([0.5,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_rad();
		if (side == Cside) translate([0.5 - 3.5,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_schlitze();
		if (side == Cside) translate([0.5 - 3.5 - 13,0,0]) rotate([10, 0, 0]) rotate([0, 90, 0]) lichtschranke_schlitze();

		if (side == Lside) rotate([0,90,0]) mittelstift_nupsi();
		if (side == Rside) translate([RA_abstand,0,0]) rotate([0,-90,0]) mittelstift_nupsi();
	}

	if (side == Cside) translate([0.5,38,55]) rotate([-1.1,0,0]) _grossrad();
}

*rahmen(Rside);
rahmen(Lside);
*rahmen(Cside);

