// Nupsi, nimmt das große Zahnrad auf.
// Passt in das, was der Orcabot produziert, wenn man ihn ein 8.5mm Loch drucken lässt.
// Der Nupsi selbst wird (aus Genauigkeitsgründen) mit dem Makerbot gedruckt,
// 30% Infill, 0.2mm Layer, 60/110 mm/s, mit Raft
// sinnigerweise druckt man einige davon auf einmal.

module radnupsi() {
	difference() {
		union() {
			translate([0,0,0]) cylinder(r=7.8/2, h=3, $fn=60);
			translate([0,0,3]) cylinder(r=4.3/2  , h=4, $fn=40);
			translate([0,0,7]) cylinder(r1=4.5/2, r2=6/2, h=0.5, $fn=40);
			translate([0,0,7.5]) cylinder(r1=6/2, r2=5/2, h=1, $fn=40);
		}
		translate([-0.6, -5, 3]) cube(size=[1.2,10,7.6]);
	}
}

module radnupsi_anti() {
	cylinder(h=10, r=8.5/2, center=true, $fn=40);
}

radnupsi();
