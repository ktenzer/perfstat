function statusLevel3InitialToggle(serviceName) {
	var prefix = serviceName.substring(0, serviceName.indexOf("."));
	if (prefix.length != 0) {
		var off = prefix + "-off";
		var on = prefix + "-on";
		toggle(off, on);
	}
}