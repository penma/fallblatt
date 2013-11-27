difference() {
	union() {
		translate([0,0,0]) cylinder(r=19/2, h=4, $fn=60);
		translate([0,0,4]) cylinder(r=8/2, h=0.5, $fn=60);
		translate([0,0,3.5]) cylinder(r=4.3/2  , h=6, $fn=40);
		translate([0,0,9]) cylinder(r1=4.5/2, r2=6.5/2, h=0.5, $fn=40);
		translate([0,0,9.5]) cylinder(r1=6.5/2, r2=5/2, h=1, $fn=40);
	}
	translate([-0.6, -5, 4.25]) cube(size=[1.2,10,7.6]);
}