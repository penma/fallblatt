use <libgear.scad>

$fn = 50;

module motor_rad() {
	// 3mm Seitenwand + 1mm Abstand zur Wand
	translate([0, 0, 3 + 1]) difference() {
		union() {
			gear(
				number_of_teeth=30,
				diametral_pitch=1,
				hub_thickness=6, rim_thickness=6,
				gear_thickness=6,
				bore_diameter=1,
				hub_diameter=10,
				clearance=0.5, backlash=0.5);
			cylinder(h=12, r=10/2);
		}
		translate([0,0,1]) cylinder(h=15, r=5.25/2);
		translate([0,0,9]) rotate([90,0,0]) cylinder(h=20, r=2.8/2, center=true);
	}
}


module motor_mount() {
	difference() {
		union() {
			for (x = [-13, +13]) {
				for (y = [-13, +13]) {
					translate([x,y,0]) cylinder(h=26, r=6/2);
				}
			}
			translate([-20,-20,0]) cube(size=[40,40,3]);
		}
		for (x = [-13, +13]) {
			for (y = [-13, +13]) {
				translate([x,y, -0.1]) cylinder(h=40, r=3.5/2);
				translate([x,y, -0.1]) cylinder(h=2, r1=6.5/2, r2=3.5/2);
			}
		}
		translate([0,0,3.01]) cylinder(r=(30 + 4) / 2, h=6+2);
	}
}

module motor_mount_cutout() {
	translate([-20,-20,-1]) cube(size=[40,40,5]);
}


%motor_rad();
motor_mount();
