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

use <Blaetterrad.scad>
use <Plaettchen.scad>

mittelstift();
% union() {
	translate([0, 0, 0]) blaetterrad_links();
	translate([0, 0, 3+4+0.5+70+0.5]) blaetterrad_rechts();
	
	translate([0, 7.75, 4+3+0.5+35]) rotate([0, 90, 180]) Plaettchen();
}