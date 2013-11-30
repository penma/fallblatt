
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
		intersection() {
			rotate([-90,0,0]) cylinder(r=30/2, h=33, $fn=100);
			translate([-50,1,-10]) cube(size=[100,50,16 + 2*2]);
		}
		// Motor
		rotate([-90,0,0]) _motor_cutout();
		// muss nicht über gesamte Breite gehen
		translate([-50, 1 + 5,-50]) cube(size=[100, 32 - 2*1 - 2*5, 100]);
	}
	% rotate([-90,0,0]) {
		_motor_cutout();
		translate([0,0,32.5]) import("Schnecke_bare.stl");
	}
}

module _kugellager_mount() {
	intersection() {
		difference() {
			                       rotate([-90,0,0]) cylinder(r=27/2, h=8, $fn=100);
			translate([0,-0.01,0]) rotate([-90,0,0]) cylinder(r=19.3/2, h=6.2, $fn = 100);
		}
		translate([-50,-1,-10]) cube(size=[100,50,16 + 2*2]);
	}
}

difference() {
	union() {
		_motor_mount();
		translate([0, 32 + 0.5 + 21 + 0.5, 0]) _kugellager_mount();
	}
	translate([-100,-100,6]) cube(size=[200,200,200]);
}

// Bodenplatte
translate([-12, 0, -10 - 2])
difference() {
	cube(size=[24, 32 + 22 + 8 ,2]);
	translate([3, 1 + 5, -0.5]) cube(size=[18, 20, 3]);
	translate([3, 1 + 5 + 21 + 5 + 1 + 1, -0.5]) cube(size=[18, 20, 3]);
}


* difference() {
	union() {
		// 2x Motor Aufnahme
		translate([0,  0 + 1 + 4/2, 0]) cube(size=[25, 4, 20], center=true);
		translate([0, 32 - 1 - 4/2, 0]) cube(size=[25, 4, 20], center=true);
		// Kugellager Aufnahme
		translate([0, 32 + 21 + 4/2, 0]) cube(size=[25, 4, 20], center=true);
		translate([0, 32 + 21 + 4 + 4/2, -5]) cube(size=[25, 4, 10], center=true);
		// Bodenplatte
		translate([-15, 1, -11]) cube(size=[30, 32 - 1 + 21 + 4 + 4, 2.5]);
	}
	translate([0,16,0]) rotate([90,0,0]) _motor_cutout();
	translate([0, 32 + 21 - 0.01, 0]) rotate([-90,0,0]) cylinder(r=19.1/2, h=6, $fn=100);
	translate([-10, 31, -12]) cube(size=[20, 22, 4]);
	translate([-10, 1+4, -12]) cube(size=[20, 32 - 2 - 2*4, 4]);

	translate([-20, 0, 5]) cube(size=[40,60, 20]);
}
