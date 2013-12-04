// Mittelstift
// 81mm =
// 4mm Zahnrad
// 3mm Lochrad
// 0.5mm Abstand
// 70mm Plättchen
// 0.5mm Abstand
// 3mm Lochrad

module mittelstift() {
	difference() {
		translate([-7.8/2, -7.8/2, 0]) cube(size=[7.8, 7.8, 81]);
		translate([0,0,-1]) cylinder(h=90, r1=3, r2=3, $fn=20);
	}
}

module mittelstift_antistift() {
	// Nennmaß: 8mm
	cube(size=[8.5, 8.5, 100], center=true);
}

use <Blaetterrad.scad>
use <Plaettchen.scad>

mittelstift();