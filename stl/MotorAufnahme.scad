// Aufnahme für Motor.
// 0 = Achse, hinteres Ende vom Motor
// Bodenplatte = -( 16/2 + 2 + 3 )

use <Schnecke.scad>

module _motor_cutout() {
	render() translate([0,0,16]) union() {
		intersection() {
			cylinder(h=32, r=21/2, center=true, $fn=100);
			cube(size=[22.001, 16, 32.001], center=true);
		}
		translate([0,0,16]) cylinder(r=17/2, h=5, $fn = 50);
	}
}

module _motor_mount() {
	difference() {
		// Außenform
		rotate([-90,0,0]) cylinder(r=30/2, h=33, $fn=100);
		// Motor
		rotate([-90,0,0]) _motor_cutout();
		// muss nicht über gesamte Breite gehen
		translate([-50, 1 + 5,-50]) cube(size=[100, 32 - 2*1 - 2*5, 100]);
	}
}

module _motor_inside() {
	rotate([-90,0,0]) {
		_motor_cutout();
		translate([0,0,32.5]) schnecke_sn();
	}
}

module _kugellager_mount() {
	difference() {
		rotate([-90,0,0]) cylinder(r=27/2, h=8, $fn=100);
		rotate([-90,0,0]) cylinder(r=19.3/2, h=6.2, $fn = 100);
	}
}

module motor_aufnahme() {
	// Halterungen
	difference() {
		union() {
			_motor_mount();
			translate([0, 32 + 0.5 + 21 + 0.5, 0]) _kugellager_mount();
		}
		// Nach oben und unten begrenzt
		translate([-100,-100,6]) cube(size=[200,200,200]);
		translate([-100,-100,-10 - 2 - 20 + 0.5]) cube(size=[200,200,20]);
	}

	% _motor_inside();

	// Bodenplatte
	translate([-12, 0, -10 - 3])
	difference() {
		cube(size=[24, 32 + 22 + 8, 3]);

		// Aufnahme zum Seitenteil
		difference() {
			union() {
				translate([24/2, 1 + 5 + 20/2, -0.5 + 2]) cube(size=[16, 20, 4], center=true);
				translate([24/2, 32 + 1 + 21/2, -0.5 + 2]) cube(size=[16, 21, 4], center=true);
			}
			translate([24/2, 32 + 1 + 21/2, -0.5 + 2]) cube(size=[4, 21, 5], center=true);
		}
	}
}

module motor_gegenstueck() {
	translate([-12, 0, -10 - 3])
	difference() {
		// Aufnahme zum Seitenteil
		difference() {
			union() {
				translate([24/2, 1 + 5 + 20/2, -0.5 + 2]) cube(size=[15, 19, 3], center=true);
				translate([24/2, 32 + 1 + 21/2, -0.5 + 2]) cube(size=[15, 20, 3], center=true);
			}
			translate([24/2, 32 + 1 + 21/2, -0.5 + 2]) cube(size=[5, 21, 5], center=true);
		}
	}
}

motor_aufnahme();
* motor_gegenstueck();
