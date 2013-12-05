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
		translate([-7.8/2, -7.8/2, 0]) cube(size=[7.8, 7.8, 81]);
		translate([0,0,10]) mirror([0,0,1]) cylinder(h=20, r1=3, r2=3, $fn=20);
		translate([0,0,81-10])              cylinder(h=20, r1=3, r2=3, $fn=20);
	}
}

module mittelstift_antistift() {
	// Nennmaß: 8mm
	cube(size=[8.5, 8.5, 100], center=true);
}

use <Blaetterrad.scad>
use <Plaettchen.scad>

mittelstift();