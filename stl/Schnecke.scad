use <libthread.scad>
use <libgear.scad>

use <MotorRitzel.scad>
use <Mittelstift.scad>

SN_numberTeeth=10;
SN_pitchRadius=10;
SN_thickness=5;

SN_length=30;
SN_radius=8;
SN_pitch=2 * 3.1415926 * SN_pitchRadius/SN_numberTeeth;

SN_angle=-360*$t;
SN_offset=9;

SN_distance=SN_radius + SN_pitchRadius + 0.0*SN_pitch;

// Schnecke, mit der Kugellager-Aufnahme unten
// Drucken: Negativritzel nach unten, Raft, 95/160, 30%, 0.25mm
module schnecke_sn() {
	difference() {
		* trapezoidThread( 
			length=SN_length,          // axial length of the threaded rod
			pitch=SN_pitch,            // axial distance from crest to crest
			pitchRadius=SN_radius,     // radial distance from center to mid-profile
			threadHeightToPitch=0.5,
			profileRatio=0.5,
			threadAngle=28,
			RH=true,                // thread winds clockwise
			clearance=0.2,          // radial clearance, normalized to thread height
			backlash=0.06,          // axial clearance, normalized to pitch
			stepsPerTurn=40         // number of slices to create per turn
		);
		import("Schnecke_bare.stl");
		translate([0,0,SN_length - 4]) render(convexity=2) motor_ritzel();
	}
	// Kugellager Aufnahme
	translate([0,0,0]) cylinder(r=6/2, h=10, center=true, $fn=20);
}

module schnecke_rad() {
	difference() {
		gear(
			number_of_teeth=SN_numberTeeth,
			circular_pitch=360 * SN_pitchRadius/SN_numberTeeth,
			pressure_angle=28,
			clearance = 0,
			gear_thickness=SN_thickness,
			rim_thickness=SN_thickness,
			rim_width=5,
			hub_thickness=SN_thickness,
			hub_diameter=10,
			bore_diameter=6,
			twist=-SN_pitchRadius/SN_radius,
			$fn=30
		);
		mittelstift_antistift();
	}
}

translate([0, +SN_distance, -SN_length/2])
rotate([0,0,180+SN_angle])
schnecke_sn();

%translate([-SN_thickness/2,0,0])
rotate([0, 90, 0])
rotate([0, 0, SN_offset - SN_angle/SN_numberTeeth])
schnecke_rad();
