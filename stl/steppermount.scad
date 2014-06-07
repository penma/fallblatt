use <libgear.scad>

$fn = 50;

module m3_cutout(len) {
	translate([0,0, -0.1]) cylinder(h=len, r=3.5/2, $fn=20);
	translate([0,0, -0.1]) cylinder(h=1.5, r1=5.75/2, r2=3.5/2, $fn=20);
}

module motor_rad() {
	// 3mm Seitenwand + 1mm Abstand zur Wand
	translate([0, 0, 3 + 1]) difference() {
		union() {
			gear(
				number_of_teeth=10,
				diametral_pitch=1,
				hub_thickness=6, rim_thickness=6,
				gear_thickness=6,
				bore_diameter=0,
				hub_diameter=10,
				clearance=0.5, backlash=0.5); // kann man hier bestimmt auch reduzieren, weils andere rad ja schon spiel hat.
				// alternativ bei beiden raedern auf 0.25/0.25 runtergehen... oder so
			translate([0,0,6]) cylinder(h=11, r=10/2);
		}
		translate([0,0,3.5]) cylinder(h=15, r=5.25/2);
	}
}


module motor_platte() {
	/* Montagepunkte am Rahmen */
	p = [ [-20, -5], [+20, -5], [0, +20] ];
	/* Stepper Schraubenlöcher */
	plusminus = [ [-1,-1], [-1,+1], [+1,-1], [+1,+1] ];
	n = plusminus * 26/2; /* NEMA 14 */
	//n = plusminus * 31/2; /* NEMA 17 */

	difference() {
		union() {
			/* Abstandshalter zum Rahmen hin */
			for (pp = p) {
				translate([pp[0], pp[1], -22]) cylinder(h=24, r=6/2);
			}

			/* eigentliche Platte */
			intersection() {
			//	translate([-25,-17.5,0]) cube(size=[50,40,2]);
			//	cylinder(h=10, center=true, r=25, $fn = 200);
				translate([-25,-20,0]) cube(size=[50,43,2]);
				cylinder(h=10, center=true, r=27, $fn = 200);
			}
		}
		/* für M3 Schraube im Rahmen
		 * ggf von 10 auf 20mm Tiefe vergrößern, mehr Stabilität durch
		 * die Schraube?
		 */
		for (pp = p) {
			translate([pp[0], pp[1], -22.1]) cylinder(h=10, r=3/2);
		}

		/* Für die Gummistopfen */
		for (pp = n) {
			translate([pp[0], pp[1], -0.1]) cylinder(h=4, r=6/2);
		}

		/* Für Achse und so */
		cylinder(h=10, center=true, r=12.5, $fn = 150);
	}

	/* Motor Dummy */
	translate([-35/2, -35/2, 3]) cube([35, 35, 22]);
}

module motor_mount() {
	p = [ [-20, -5], [+20, -5], [0, +20] ];
	difference() {
		union() {
			for (pp = p) {
				//translate([pp[0], pp[1], 0]) cylinder(h=26, r=6/2);
			}
			intersection() {
				translate([-25,-25,-1]) cube(size=[50,48,5]);
				cylinder(h=3, r=50/2, $fn=100);
			}
		}
		for (pp = p) {
			//translate([pp[0], pp[1], -0.1]) cylinder(h=40, r=3.5/2);
			//translate([pp[0], pp[1], -0.1]) cylinder(h=2, r1=6.5/2, r2=3.5/2);
			translate([pp[0], pp[1], 0]) m3_cutout(10);
		}
		translate([0,0,0]) cylinder(h=10, center=true, r=12.5);
	}
}



module motor_mount_cutout() {
	*translate([-25,-15,-1]) cube(size=[50,38,5]);
	translate([0,0,-1]) cylinder(h=5, r=50/2, $fn=100);
}


motor_rad();
*%motor_mount();
*translate([0,0,3 + 22]) motor_platte();

