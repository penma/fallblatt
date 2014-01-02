use <libgear.scad>
use <Mittelstift.scad>

RA_abstand = 84;

module lichtschranke_rad() {
	gear(
		number_of_teeth=20,
		diametral_pitch=1,
		hub_thickness=4, rim_thickness=4,
		gear_thickness=0,
		bore_diameter=0,
		hub_diameter=0,
		$fn=30);

	mittelstift();
}

module lichtschranke_schlitze(n=10) {
	translate([0, 0, RA_abstand - 1 - 12.5]) {
		difference() {
			union() {
				cylinder(r=18, h=4, $fn=30);
				translate([-11/2, -11/2, 0]) cube(size=[11,11,10]);
			}
			mittelstift_antistift();
			for (i = [1:n]) {
				rotate([0, 0, 360/10 * i]) translate([0, 13.75, 0]) cube(size=[2, 5, 10], center=true);
			}
		}
	}
}

*lichtschranke_rad();
lichtschranke_schlitze(1);
