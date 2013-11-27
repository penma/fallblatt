// 0 = Mitte der Drehachse

module Plaettchen() {
	translate([0,-28.125,0]) difference() {
		cube(size=[75, 60, 0.75], center=true);

		// Ausgeschnitten: 29.00 - 30.00 und 22.75 - 27.25
		// Drehachse: 28.125
		translate([36.75, 25, 0]) cube(size=[3.5, 4.5, 2], center=true);
		translate([-36.75, 25, 0]) cube(size=[3.5, 4.5, 2], center=true);
		translate([36.75, 29.75, 0]) cube(size=[3.5, 1.5, 2], center=true);
		translate([-36.75, 29.75, 0]) cube(size=[3.5, 1.5, 2], center=true);
	}
}

Plaettchen();

