% union() {
// Seitenwand links
translate([-2, 0, 0]) cube(size=[4, 20, 90+80], center=true);
// Nupsi links
translate([-2.5 + 4,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, center=true, $fn=40);
// Führung Links unten
translate([41,0,-82]) difference() {
	cube(size=[82, 20, 6], center=true);
	cube(size=[90, 18.5, 4.5], center=true);
}
// Führung links oben
translate([11,0,82]) cube(size=[22, 17.8, 3.8], center=true);


// Oberkante
translate([8,-12,60]) cube(size=[24, 6.5, 3], center=true);
// Stab
translate([-2,-12.5,60]) cube(size=[4, 5, 10], center=true);

}



union() {


// Seitenwand rechts
translate([84, 0, 0]) cube(size=[4, 20, 90+80], center=true);
// Nupsi rechts
translate([80,0,0]) rotate([0,90,0]) cylinder(h=5, r1=2.4, r2=2.4, center=true, $fn=40);
// Führung rechts unten
translate([71,0,-82]) cube(size=[22, 17.8, 3.8], center=true);

// Führung rechts oben
translate([41,0,82]) difference() {
	cube(size=[82, 20, 6], center=true);
	cube(size=[90, 18.5, 4.5], center=true);
}

// Oberkante Dummy
% translate([70,0,60]) cube(size=[30, 17.8, 3.8], center=true);





% translate([41,0,-82]) difference() {
	cube(size=[82, 20, 6], center=true);
	cube(size=[90, 18.5, 4.5], center=true);
}
}

