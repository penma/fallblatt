/*
 * 0 = Mitte der Drehachse
 *
 * werden sinnigerweise überhaupt nicht gedruckt, weil Dauer und Materialverbrauch
 * die Achse lässt sich nicht fein und dennoch stabil drucken
 * die Lochgröße im Blätterrad ist auf gelaserte (siehe SVG) Platten ausgelegt.
 *
 * die in dieser Datei verwendete Stärke ist druckbar, damit können Prototypen
 * erstellt werden, allerdings sind dann Anpassungen am Blätterrad notwendig
 */

breite = 75;
pinlaenge = 2;
pindurchmesser = 1.75;
pinabstand = 2;
radabstand = 5.25;
hoehe = 60;
dicke = 0.8;

module Plaettchen_alt() {
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

module Plaettchen2D() {
	translate([0, -pinabstand, 0]) for (i = [+1,-1]) {
		scale([i, 1, 1]) polygon([
			[breite/2 - pinlaenge, 0],
			[breite/2 - pinlaenge, pinabstand - pindurchmesser/2],
			[breite/2, pinabstand - pindurchmesser/2],
			[breite/2, pinabstand + pindurchmesser/2],
			[breite/2 - pinlaenge, pinabstand + pindurchmesser/2],
			[breite/2 - pinlaenge, pinabstand + radabstand],
			[breite/2, pinabstand + radabstand],
			[breite/2, hoehe],
			[0, hoehe],
			[0, 0]
		]);
	}
}


module Plaettchen() {
	linear_extrude(height = dicke, center = true) Plaettchen2D();
}

Plaettchen();

translate([0, 0, -1]) mirror([0,1,0]) Plaettchen_alt();
