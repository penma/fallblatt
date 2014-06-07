// Blätterrad
// Lochrad 3mm, Zahnrad 4mm
// 0 = Mitte Zahnrad, Außenseite

// 90/160 230 0.2mm 50% raft   (links)    22min
//                  75%        (rechts)   6min

use <libgear.scad>
use <Plaettchen.scad>
use <Mittelstift.scad>

module _lochrad() {
	difference() {
		difference() {
			cylinder(h=3, r=9.5, $fn=50);

			for (a = [0:9]) {
				rotate([0,0,(a+0.5)/10 * 360])
				translate(v=[7.5, 0, -.05])
				cylinder(h=10, r=2.5/2, $fn=20);
			}
		}
		mittelstift_antistift_mb();
	}
}

module _zahnrad() {
	difference() {
		gear(
			number_of_teeth=20,
			diametral_pitch=1,
			hub_thickness=4, rim_thickness=4,
			gear_thickness=0,
			bore_diameter=0,
			hub_diameter=16,
			clearance=0.5, backlash=0.5,
			$fn=30);
		mittelstift_antistift_mb();
	}
}

module blaetterrad_links() {
	difference() {
		union() {
			translate([0,0,+4]) cylinder(h=2, r=9.5, $fn=50);
			translate([0,0,+6]) _lochrad();
			_zahnrad();
		}
		mittelstift_antistift_mb();
	}
}

module blaetterrad_rechts() {
	_lochrad();
}

module blaetterrad_demo() {
	mittelstift();
	translate([0, 0, 0]) blaetterrad_links();
	translate([0, 0, 3+6+0.5+70+0.5]) blaetterrad_rechts();

	for (i = [
		[1, 1.1],
		[2, -0.3],
		[3, 0.4],
		[4, 0.1],
		[5, 0.3],
		[6, 1.25 - 0.008],
		[7, 9],
		[8, 7],
		[9, 5],
		[10, 3]
	]) {
		rotate([0,0,( i[0] +0.5)/10 * 360])
		translate(v=[7.5, 0, -.05])
		rotate([0,0, 360/20 * i[1]])
		translate([0, 0, 3+6+0.5+35]) rotate([0, 90, 180]) Plaettchen();
	}
}

module blaetterrad_pt1() {
	mittelstift();
	translate([0, 0, 3+6+0.5+70+0.5]) {
		blaetterrad_rechts();
		translate([0, 0, 1.5]) difference() {
			cube(size=[9,9,3], center=true);
			cube(size=[7,7,3], center=true);
		}
	}
}

module blaetterrad_pt2() {
	blaetterrad_links();
}

blaetterrad_pt2();
