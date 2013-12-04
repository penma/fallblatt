// Blätterrad
// Lochrad 3mm, Zahnrad 4mm
// 0 = Mitte Zahnrad, Außenseite

use <libgear.scad>
use <Plaettchen.scad>
use <Mittelstift.scad>

module _lochrad() {
	difference() {
		difference() {
			cylinder(h=3, r=10, $fn=50);
			for (a = [0:9]) {
				rotate([0,0,(a+0.5)/10 * 360])
				translate(v=[7.75, 0, -.05])
				cylinder(h=10, r=1.5, $fn=20);
			}
		}
		mittelstift_antistift();
	}
}

module _zahnrad() {
	difference() {
		gear(
			number_of_teeth=20,
			diametral_pitch=0.75,
			hub_thickness=4, rim_thickness=4,
			gear_thickness=0,
			bore_diameter=0,
			hub_diameter=16,
			$fn=30);
		mittelstift_antistift();
	}
}

module blaetterrad_links() {
	translate([0,0,+4]) _lochrad();
	_zahnrad();
}

module blaetterrad_rechts() {
	_lochrad();
}

module blaetterrad_demo() {
	mittelstift();
	translate([0, 0, 0]) blaetterrad_links();
	translate([0, 0, 3+4+0.5+70+0.5]) blaetterrad_rechts();
	translate([0, 7.75, 4+3+0.5+35]) rotate([0, 90, 180]) Plaettchen();
}

blaetterrad_demo();
