use <libgear.scad>

module servorad() {
	difference() {
		gear(
			number_of_teeth=20,
			diametral_pitch=1,
			hub_thickness=6, rim_thickness=6,
			gear_thickness=0,
			bore_diameter=0,
			hub_diameter=2,
			$fn=30);
		cylinder(h=20, r=11/2, $fn=30, center=true);
	}

	// sechs Stifte zur Verbindung mit dem Servokreuz
	for (i = [1:6]) {
		rotate([0, 0, i * 360/6]) translate([16/2, 0, 6]) cylinder(h=3, r=1, $fn=20);
	}
}

servorad();
