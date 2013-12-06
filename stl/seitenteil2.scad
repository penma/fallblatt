use <Schnecke.scad>
use <MotorAufnahme.scad>
use <Blaetterrad.scad>
use <Mittelstift.scad>
use <RahmenVerbinder.scad>

rahmen_dicke_links = 4;
rahmen_dicke_rechts = 4;

// Test Print: 10% 0.4mm 100mm/s ~ 40min
// Oberes Ende kann 1,25 cm runter


union() {
	// Seitenwand links
	*translate([-rahmen_dicke_links/2, 0, 0]) cube(size=[rahmen_dicke_links, 20, 90+80], center=true);
	*difference() {
		translate([-rahmen_dicke_links/2, 70, -35]) cube(size=[rahmen_dicke_links, 125, 100], center=true);
		translate([-rahmen_dicke_links/2, 150, -20]) rotate([-45,0,0]) cube(size=[rahmen_dicke_links*2, 200, 100], center=true);
	
translate([0, 35, -40]) rotate([0, 90, 0]) cylinder(h=15, r=30, center=true);	
	}

	// Seitenwand rechts?
	
	difference() {
	union() {translate([82 + rahmen_dicke_links/2, 0, 0]) cube(size=[rahmen_dicke_links, 20, 90+80], center=true);
	translate([82 + rahmen_dicke_links/2, 70, -35]) cube(size=[rahmen_dicke_links, 125, 100], center=true);
}
		translate([82 + rahmen_dicke_links/2, 150, -20]) rotate([-45,0,0]) cube(size=[rahmen_dicke_links*2, 200, 100], center=true);
	
translate([82, 35, -40]) rotate([0, 90, 0]) cylinder(h=15, r=35, center=true, $fn=15);
	}
	translate([82 - 5,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, $fn=40);


	// Nupsi links
	*rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, $fn=40);

	*translate([41,0,-82]) % rotate([-90,0,0]) rahmenverbinder();
	for (x = [/* 0, */ 82-15]) { for (z = [82 - 3.8/2, -82 - 3.8/2]) {
		translate([x,-17.4/2,z]) cube(size=[15, 17.4, 3.8]); // fixme: passt länge 15?
	} }
// translate([0,120 -17.4/2,-82 - 3.8/2]) cube(size=[15, 17.4, 3.8]); // fixme: passt länge 15?
translate([82 - 15,120 -17.4/2,-82 - 3.8/2]) cube(size=[15, 17.4, 3.8]); // fixme: passt länge 15?

	// Oberkante
	*translate([8,-12,60]) cube(size=[24, 6.5, 3], center=true);
	// Stab
	*translate([-2,-12.5,60]) cube(size=[4, 5, 10], center=true);
}



* union() {
	// Seitenwand rechts
	translate([84, 0, 0]) cube(size=[4, 20, 90+80], center=true);
	// Nupsi rechts
	translate([80,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, center=true, $fn=40);

	// Führung rechts oben
	translate([41,0,82]) % rotate([-90,0,0]) rahmenverbinder();
}

% translate([0.5,0,0]) rotate([-55,0,0]) rotate([0,90,0]) blaetterrad_demo();

translate([20, 40, -80 + 8 + 3 + 3]) {
	% motor_aufnahme();
	% translate([-2.5, 43, 18]) rotate([0,90,0])  schnecke_rad();
	translate([-20, 43, 18]) union() {
		% translate([0.5, 0, 0]) rotate([0,90,0]) mittelstift();
		// Nupsis links und rechts
		//translate([-2.5 + 4,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, center=true, $fn=40);
		translate([80,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, center=true, $fn=40);
	}
		
	* motor_gegenstueck();
}
