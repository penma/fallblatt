difference() {
	cube(size=[35, 30, 5], center=true);
	intersection() {
		cylinder(h=10, r=21/2, center=true, $fn=100);
		cube(size=[30, 16, 15], center=true);
	}
}