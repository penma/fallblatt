// Blätterrad
// Lochrad 3mm, Zahnrad 4mm
// 0 = Mitte Zahnrad, Außenseite

use <libgear.scad>

module _antistift() {
	// Nennmaß: 8mm
	cube(size=[8.5, 8.5, 100], center=true);
}

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
		_antistift();
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
		% translate(v=[0,40.5, 0]) rotate([0,0,1/80 * 360]) gear(
				number_of_teeth=40,
				diametral_pitch=0.75,
				hub_thickness=4, rim_thickness=4,
				gear_thickness=2,
				bore_diameter=0,
				hub_diameter=10,
			circles=6,
				$fn=30);
		_antistift();
	}
}

module blaetterrad_links() {
	translate([0,0,+4]) _lochrad();
	_zahnrad();
}

module blaetterrad_rechts() {
	_lochrad();
}

blaetterrad_links();
