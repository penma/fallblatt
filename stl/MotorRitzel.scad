// Zahnrad für den hier:
// http://www.pollin.de/shop/dt/Mzc0OTg2OTk-/Motoren/Gleichstrommotoren/Gleichstrommotor_MABUCHI_FF_180PH.html
// 0 = Boden Zahnrad

use <libgear.scad>

module motor_ritzel() {
	numberTeeth=15;
	pitchRadius=4;
	thickness=20;

	length=20;
	radius=8;
	pitch=2*3.1415926*pitchRadius/numberTeeth;

	angle=-360*$t;
	offset=9;

	distance=radius+pitchRadius+0.0*pitch;

	gear( 
		number_of_teeth=numberTeeth,
		circular_pitch=360*pitchRadius/numberTeeth,
		pressure_angle=0,
		clearance = 0,
		gear_thickness=thickness,
		rim_thickness=thickness,
		rim_width=5,
		hub_thickness=thickness,
		hub_diameter=10,
		bore_diameter=0,
		$fn=30
	);
}

motor_ritzel();
