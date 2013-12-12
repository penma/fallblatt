// Mittelstift
// 81mm =
// 4mm Zahnrad
// 3mm Lochrad
// 0.5mm Abstand
// 70mm Plättchen
// 0.5mm Abstand
// 3mm Lochrad

// liegend / 0.25mm / 15% / 100mm/s / kein Raft / 10m / 3.5g

module mittelstift() {
	difference() {
		translate([-7.8/2, -7.8/2, 0]) cube(size=[7.8, 7.8, 83]);
		translate([0,0,-0.5]) cylinder(h=100, r1=3, r2=3, $fn=40);
	}
}

module mittelstift_antistift() {
	// Nennmaß: 8mm
	cube(size=[8.5, 8.5, 100], center=true);
}

module mittelstift_nupsi() {
	cylinder(h=7, r1=2.4, r2=2.4, $fn=40);
}

use <Blaetterrad.scad>
use <Plaettchen.scad>

mittelstift();