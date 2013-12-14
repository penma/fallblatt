// Nupsi, passt in ein "8.5" Loch

module radnupsi() {
	difference() {
		union() {
			translate([0,0,0]) cylinder(r=8/2, h=3.5, $fn=60);
			translate([0,0,2.5]) cylinder(r=4.3/2  , h=6, $fn=40);
			translate([0,0,8]) cylinder(r1=4.5/2, r2=6.5/2, h=0.5, $fn=40);
			translate([0,0,8.5]) cylinder(r1=6.5/2, r2=5/2, h=1, $fn=40);
		}
		translate([-0.6, -5, 4.25]) cube(size=[1.2,10,7.6]);
	}
}

module radnupsi_anti() {
	cylinder(h=10, r=8.5/2, center=true, $fn=40);
}

radnupsi();