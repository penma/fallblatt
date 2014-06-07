use <libgear.scad>
use <Blaetterrad.scad>
use <RahmenVerbinder.scad>

use <steppermount.scad>

RA_staerke = 3;
RA_abstand = 84;
RA_hoehe=147.5;

Lside = 0;
Rside = 1;
Cside = 2;

Grossrad_teeth = 80;

module _grossrad() {
	import("cache/_grossrad.stl"); *
	rotate([0,90,0]) difference() {
		union() {
			gear(
				number_of_teeth=Grossrad_teeth,
				diametral_pitch=1,
				hub_thickness=4, rim_thickness=4,
				gear_thickness=4,
				bore_diameter=0,
				hub_diameter=10,
				clearance=0.5, backlash=0.5,
				$fn=30);
			mirror([0,0,1]) cylinder(h=2, r=7);
		}
		// 6 Löcher
		for (i = [0:5]) {
			rotate([0, 0, 360/6 * i]) translate([20,0,0]) cylinder(h=10, r=9, center=true, $fn=100);
		}
		// Kugellager versenkt
		translate([0, 0, -4]) difference() {
			cylinder(h=6.5, r=20/2, $fn=100);
			cylinder(h=8, r=6.05/2, $fn=30);
		}

		// Orientierungsschlitze
		for (i = [0:3]) {
			rotate([0, 0, 360/4 * i + 180/Grossrad_teeth]) translate([Grossrad_teeth/2 + 0.75 - 4/2 - 5, 0, 0]) cube([4,1,20], true);
		}
	}
}

module m3_cutout(len) {
	translate([0,0, -0.1]) cylinder(h=len, r=3.5/2, $fn=20);
	translate([0,0, -0.1]) cylinder(h=1.5, r1=5.75/2, r2=3.5/2, $fn=20);
}

module m3_grundloch(h) {
	translate([0,0,-0.1]) {
		cylinder(h = h+0.1, r=2.9/2, $fn=30);
		rotate([0,0,45]) cube([2.9 / 2, 2.9 / 2, h+0.1]);
	}
}

module _rahmen_frame(side) {
	intersection() {
		translate([0,-10, 0]) cube(size=[RA_staerke, 130, RA_hoehe]);
		translate([-1, 0, 0]) scale([RA_staerke + 2, 1, 1]) union() {
			translate([0,125,85]) rotate([-27.5,0,0]) mirror([0,1,0]) cube(size=[1, 200, 7.5]);
			// oben
			translate([0,-10,RA_hoehe - 7.5]) cube(size=[1, 30, 7.5]);
			// vorn
			translate([0,-10,0]) cube(size=[1, 10, RA_hoehe - 2.5]);
			// unten
			translate([0,-10,0]) cube(size=[1, 130, 7.5]);
			// hinten
			translate([0,110,0]) cube(size=[1, 10, 95]);

			// Achse
			translate([0,-7.5,75 - 7.5]) cube(size=[1, 15, 15]);
			// Hinterer Verbinder
			translate([0,100,90]) cube(size=[1, 10, 10]);

			if (side == Lside) {
				/* Waagerechte */
				translate([0, 0, 75 - 4]) cube([1, 111, 8]);

				/* Grossrad + Senkrechte */
				translate(Grossrad_pos) rotate([0,90,0]) cylinder(h=3, r=28/2, $fn=30);
				translate(Grossrad_pos - [0,28/2,0]) cube([3, 28, 28/2]);
				translate(Grossrad_pos - [0,7.5/2,Grossrad_pos[2]]) cube([3, 7.5, Grossrad_pos[2]]);

				// Flachbandkabel vor großem Rad schützen
				translate(Grossrad_pos) rotate([0,90,0]) difference() {
					cylinder(h=1, r=40 + 1.5, $fn = 100);
					cylinder(h=3, r=40 - 1.5, $fn = 100, center=true);
					translate([-50,-50,-1]) cube([50,100,50]);
					translate([-1,-50,-2]) cube([51,51,50]);
				}

				// Lichtschranke Verschraubung
				translate(Lichtschranke_pos) rotate([0,90,0]) cylinder(h=3, r=8/2, $fn=30);
				// zwischen Motor und hinterer Verbinder oben
				translate([0,100,80]) cube(size=[1, 10, 10]);
			}
		}
	}
}

function rotateX(v, a) = v * [
	[1, 0, 0],
	[0, cos(a), -sin(a)],
	[0, sin(a),  cos(a)]
];

Blaetterrad_pos = [0,3, 75];
Grossrad_a = 12;
Grossrad_pos = Blaetterrad_pos + rotateX([0, 20/2 + Grossrad_teeth/2, 0], Grossrad_a);
Stepper_a = 0;
Stepper_pos = Grossrad_pos + rotateX([0, Grossrad_teeth/2 + 10/2, 0], Stepper_a);

Lichtschranke_d = 15;
Lichtschranke_a = -90 + 27.5;
Lichtschranke_pos = Grossrad_pos + rotateX([0, Grossrad_teeth/2 + Lichtschranke_d, 0], Lichtschranke_a);

module rv_cut() {
	rotate([0,90,0]) {
		for (x = [-5, +5]) {
			translate([0, x, 0]) m3_cutout(20);
		}
	}
}

module _rahmen_seitenwand(side) {
	difference() {
		_rahmen_frame(side);
		// Achse
		translate(Blaetterrad_pos) rotate([0,90,0]) cylinder(h=RA_staerke*3, r=4.5/2, center=true, $fn=40);
		translate(Blaetterrad_pos) rotate([0,90,0]) m3_cutout(10);
		// Lager
		translate(Grossrad_pos) rotate([0,90,0]) cylinder(h=RA_staerke*3, r=19.1/2, center=true, $fn=40);
		// Servo
		if (side == Lside) translate(Stepper_pos) rotate([-Stepper_a, 0, 0]) rotate([0, 90, 0]) motor_mount_cutout();

		translate([0,0,6/2]) rv_cut();
		translate([0,0,RA_hoehe - 6/2]) rv_cut();
		translate([0,110,6/2]) rv_cut();
		translate([0,110,93]) rv_cut();

		if (side == Lside) translate(Lichtschranke_pos) rotate([0,90,0]) m3_cutout(10);
	}

}

module verbinder_unten() {
	rahmenverbinder();

	translate([0,110,0]) difference() {
		rahmenverbinder();
		for (i = [-1,0,+1]) {
			translate([i * RA_abstand/2 * 3/4, 0, 0]) {
				translate([0,0,-3.1]) cylinder(h=6.2, r=3.5/2, $fn=20);
				translate([0,0,1]) cylinder(h=2.1, r1=3.5/2, r2=7/2, $fn=20);
			}
		}
	}

	// Lol, Platine
	% translate([0, 70, +1.5]) {
		cube(size=[RA_abstand, 59, 2.5], center=true);
		translate([-RA_abstand/2, -30 + 15, 1.25]) cube([10,25,17.5]);
	}
	
	for (i = [-1,+1]) {
		scale([i,1,1]) translate([RA_abstand/2 - 5,10,-3]) {
			cube([5, 90, 3]);
			translate([0,30 - 3,0]) cube(size=[5, 3, 6]);
		}
	}
}

module verbinder_vorne() {
	rahmenverbinder();
	translate([0,-10 + 0.5/2, -5.5 -3/2]) cube(size=[RA_abstand, 0.5, 8], center=true);
}

module rahmen(side) {
	// Seitenwand
	if (side == Lside) translate([-RA_staerke, 0, 0]) _rahmen_seitenwand(side);
	if (side == Rside) translate([RA_abstand + RA_staerke, 0, 0]) mirror([1,0,0]) _rahmen_seitenwand(side);

	if (side == Cside) {
		// Blätterrad
		for (i = [360/20 * 1.008]) {
			translate(Blaetterrad_pos + [0.5, 0, 0]) rotate([i,0,0]) rotate([0,90,0]) blaetterrad_demo();
			*#translate(Blaetterrad_pos + [0.5 + 4 + 0.5 + 1, 0, 0]) rotate([i,0,0]) rotate([0,90,0]) difference() {
				cylinder(h=4, r=67, $fn=100);
				cylinder(h=30, r=65, $fn=100, center=true);
			}
		}

		// Rahmenverbinder vorne oben
		translate([RA_abstand/2,0, RA_hoehe - 6/2]) verbinder_vorne();

		// Rahmenverbinder unten (vorne wie hinten, eine Einheit)
		translate([RA_abstand/2,0, 6/2]) verbinder_unten();
		
		// Rahmenverbinder hinten oben
		translate([RA_abstand/2,110, 93]) rahmenverbinder();
	}

	// Motor
	translate(Stepper_pos - [RA_staerke, 0, 0]) rotate([-Stepper_a, 0, 0]) rotate([0, 90, 0]) union() {
		if (side == Lside) motor_mount();
		if (side == Cside) motor_rad();
		if (side == Cside) translate([0,0,3 + 22]) motor_platte();
	}


	if (side == Cside) translate(Grossrad_pos + [0.5, 0, 0]) rotate([180/65 + 3.75,0,0]) _grossrad();
	if (side == Cside) translate(Lichtschranke_pos + [0.5, 0, 0]) rotate([90 - Lichtschranke_a,0,0]) translate([-4/2, -11/2, 0]) cube([4, 11, 22.5]);
	if (side == Cside) translate(Lichtschranke_pos + [0.5, 0, 0]) rotate([90 - Lichtschranke_a,0,0]) translate([19, -11/2, -2]) rotate([0,0,90]) import("lichtschranke-bla.stl");
}

rahmen(Rside);
%rahmen(Cside);
rahmen(Lside);

