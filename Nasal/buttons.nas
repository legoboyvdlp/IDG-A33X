# A3XX Buttons
# Joshua Davidson (it0uchpods)

# Copyright (c) 2019 Joshua Davidson (it0uchpods)

# Resets buttons to the default values
var variousReset = func {
	setprop("/modes/cpt-du-xfr", 0);
	setprop("/modes/fo-du-xfr", 0);
	setprop("/controls/fadec/n1mode1", 0);
	setprop("/controls/fadec/n1mode2", 0);
	setprop("/instrumentation/mk-viii/serviceable", 1);
	setprop("/instrumentation/mk-viii/inputs/discretes/terr-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/gpws-inhibit", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/glideslope-cancel", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap-all-override", 0);
	setprop("/instrumentation/mk-viii/inputs/discretes/momentary-flap-3-override", 0);
	setprop("/controls/switches/cabinCall", 0);
	setprop("/controls/switches/mechCall", 0);
	setprop("/controls/switches/emer-lights", 0.5);
	# cockpit voice recorder stuff
	setprop("/controls/CVR/power", 0);
	setprop("/controls/CVR/test", 0);
	setprop("/controls/CVR/tone", 0);
	setprop("/controls/CVR/gndctl", 0);
	setprop("/controls/CVR/erase", 0);
	setprop("/controls/switches/cabinfan", 1);
	setprop("/controls/oxygen/crewOxyPB", 1); # 0 = OFF 1 = AUTO
	setprop("/controls/switches/emerCallLtO", 0); # ON light, flashes white for 10s
	setprop("/controls/switches/emerCallLtC", 0); # CALL light, flashes amber for 10s
	setprop("/controls/switches/emerCall", 0);
	setprop("/controls/switches/LrainRpt", 0);
	setprop("/controls/switches/RrainRpt", 0);
	setprop("/controls/switches/wiperLspd", 0); # -1 = INTM 0 = OFF 1 = LO 2 = HI
	setprop("/controls/switches/wiperRspd", 0); # -1 = INTM 0 = OFF 1 = LO 2 = HI
	setprop("/controls/lighting/strobe", 0);
	setprop("/controls/lighting/beacon", 0);
	setprop("/controls/lighting/wing-lights", 0);
	setprop("/controls/lighting/nav-lights-switch", 0);
	setprop("/controls/lighting/landing-lights[1]", 0);
	setprop("/controls/lighting/taxi-light-switch", 0);
	setprop("/controls/lighting/DU/du1", 1);
	setprop("/controls/lighting/DU/du2", 1);
	setprop("/controls/lighting/DU/du3", 1);
	setprop("/controls/lighting/DU/du4", 1);
	setprop("/controls/lighting/DU/du5", 1);
	setprop("/controls/lighting/DU/du6", 1);
	setprop("/controls/lighting/DU/mcdu1", 1);
	setprop("/controls/lighting/DU/mcdu2", 1);
	setprop("/modes/fcu/hdg-time", 0);
	setprop("/controls/switching/ATTHDG", 0);
	setprop("/controls/switching/AIRDATA", 0);
	setprop("/controls/switches/no-smoking-sign", 1);
	setprop("/controls/switches/seatbelt-sign", 1);
}

var BUTTONS = {
	init: func() {
		var stateL = getprop("/engines/engine[0]/state");
		var stateR = getprop("/engines/engine[1]/state");
		var Lrain = getprop("/controls/switches/LrainRpt");
		var Rrain = getprop("/controls/switches/RrainRpt");
		var OnLt = getprop("/controls/switches/emerCallLtO");
		var CallLt = getprop("/controls/switches/emerCallLtC");
		var EmerCall = getprop("/controls/switches/emerCall");
		var wow = getprop("/gear/gear[1]/wow");
		var wowr = getprop("/gear/gear[2]/wow");
		var gndCtl = getprop("/systems/CVR/gndctl");
		var acPwr = getprop("/systems/electrical/bus/ac-ess");
	},
	update: func() {
		rainRepel();
		CVR_master();
		if (getprop("/controls/switches/emerCall")) {
			EmerCallOnLight();
			EmerCallLight();
		}
	},
};

var rainRepel = func() {
	Lrain = getprop("/controls/switches/LrainRpt");
	Rrain = getprop("/controls/switches/RrainRpt");
	wow = getprop("/gear/gear[1]/wow");
	stateL = getprop("/engines/engine[0]/state");
	stateR = getprop("/engines/engine[1]/state");
	if (Lrain and (stateL != 3 and stateR != 3 and wow)) {	
		setprop("/controls/switches/LrainRpt", 0);
	}
	if (Rrain and (stateL != 3 and stateR != 3 and wow)) { 
		setprop("/controls/switches/RrainRpt", 0);
	}
}

var EmerCallOnLight = func() {
	OnLt = getprop("/controls/switches/emerCallLtO");
	EmerCall = getprop("/controls/switches/emerCall");
	if ((OnLt and EmerCall) or !EmerCall) { 
		setprop("/controls/switches/emerCallLtO", 0);
	} else if (!OnLt and EmerCall) { 
		setprop("/controls/switches/emerCallLtO", 1);
	}
}

var EmerCallLight = func() {
	CallLt = getprop("/controls/switches/emerCallLtC");
	EmerCall = getprop("/controls/switches/emerCall");
	if ((CallLt and EmerCall) or !EmerCall) { 
		setprop("/controls/switches/emerCallLtC", 0);
	} else if (!CallLt and EmerCall) { 
		setprop("/controls/switches/emerCallLtC", 1);
	}
}

var CVR_master = func() {
	stateL = getprop("/engines/engine[0]/state");
	stateR = getprop("/engines/engine[1]/state");
	wow = getprop("/gear/gear[1]/wow");
	wowr = getprop("/gear/gear[2]/wow");
	gndCtl = getprop("/systems/CVR/gndctl");
	acPwr = getprop("/systems/electrical/bus/ac-ess");
	if (acPwr > 0 and wow and wowr and (gndCtl or (stateL == 3 or stateR == 3))) {
		setprop("/controls/CVR/power", 1);
	} else if (!wow and !wowr and acPwr > 0) {
		setprop("/controls/CVR/power", 1);
	} else {
		setprop("/controls/CVR/power", 0);
	}
}

var EmerCall = func {
	setprop("/controls/switches/emerCall", 1);
	settimer(func() {
		setprop("/controls/switches/emerCall", 0);
	}, 10);
}

var CabinCall = func {
	setprop("/controls/switches/cabinCall", 0);
	settimer(func() {
		setprop("/controls/switches/cabinCall", 0);
	}, 15);
}
		
var MechCall = func {
	setprop("/controls/switches/mechCall", 1);
	settimer(func() {
		setprop("/controls/switches/mechCall", 0);
	}, 15);
}

var CVR_test = func {
	var parkBrake = getprop("/controls/gear/brake-parking");
	if (parkBrake) {
		setprop("controls/CVR/tone", 1);
		settimer(func() {
			setprop("controls/CVR/tone", 0);
		}, 15);
	}
}

var mcpSPDKnbPull = func {
	setprop("/it-autoflight/input/spd-managed", 0);
	fmgc.ManagedSPD.stop();
	var ias = getprop("/instrumentation/airspeed-indicator/indicated-speed-kt");
	var mach = getprop("/instrumentation/airspeed-indicator/indicated-mach");
	if (getprop("/it-autoflight/input/kts-mach") == 0) {
		if (ias >= 100 and ias <= 360) {
			setprop("/it-autoflight/input/spd-kts", math.round(ias, 1));
		} else if (ias < 100) {
			setprop("/it-autoflight/input/spd-kts", 100);
		} else if (ias > 360) {
			setprop("/it-autoflight/input/spd-kts", 360);
		}
	} else if (getprop("/it-autoflight/input/kts-mach") == 1) {
		if (mach >= 0.50 and mach <= 0.95) {
			setprop("/it-autoflight/input/spd-mach", math.round(mach, 0.001));
		} else if (mach < 0.50) {
			setprop("/it-autoflight/input/spd-mach", 0.50);
		} else if (mach > 0.95) {
			setprop("/it-autoflight/input/spd-mach", 0.95);
		}
	}
}

var mcpSPDKnbPush = func {
	if (getprop("/FMGC/internal/cruise-lvl-set") == 1 and getprop("/FMGC/internal/cost-index-set") == 1) {
		setprop("/it-autoflight/input/spd-managed", 1);
		fmgc.ManagedSPD.start();
	}
}

var mcpHDGKnbPull = func {
	if (getprop("/it-autoflight/output/fd1") == 1 or getprop("/it-autoflight/output/fd2") == 1 or getprop("/it-autoflight/output/ap1") == 1 or getprop("/it-autoflight/output/ap2") == 1) {
		var latmode = getprop("/it-autoflight/output/lat");
		var showhdg = getprop("/it-autoflight/custom/show-hdg");
		if (latmode == 0 or showhdg == 0) {
			setprop("/it-autoflight/input/lat", 3);
			setprop("/it-autoflight/custom/show-hdg", 1);
		} else {
			setprop("/it-autoflight/input/lat", 0);
			setprop("/it-autoflight/custom/show-hdg", 1);
		}
	}
}

var hdgInput = func {
	var latmode = getprop("/it-autoflight/output/lat");
	if (latmode != 0) {
		setprop("/it-autoflight/custom/show-hdg", 1);
		var hdgnow = getprop("/it-autoflight/input/hdg");
		setprop("/modes/fcu/hdg-time", getprop("/sim/time/elapsed-sec"));
	}
}

var mcpHDGKnbPush = func {
	if (getprop("/it-autoflight/output/fd1") == 1 or getprop("/it-autoflight/output/fd2") == 1 or getprop("/it-autoflight/output/ap1") == 1 or getprop("/it-autoflight/output/ap2") == 1) {
		setprop("/it-autoflight/input/lat", 1);
	}
}

var toggleSTD = func {
	var Std = getprop("/modes/altimeter/std");
	if (Std == 1) {
		var oldqnh = getprop("/modes/altimeter/oldqnh");
		setprop("/instrumentation/altimeter/setting-inhg", oldqnh);
		setprop("/modes/altimeter/std", 0);
	} else if (Std == 0) {
		var qnh = getprop("/instrumentation/altimeter/setting-inhg");
		setprop("/modes/altimeter/oldqnh", qnh);
		setprop("/instrumentation/altimeter/setting-inhg", 29.92);
		setprop("/modes/altimeter/std", 1);
	}
}

var increaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs + 0.001);
	}
}

var decreaseManVS = func {
	var manvs = getprop("/systems/pressurization/outflowpos-man");
	var auto = getprop("/systems/pressurization/auto");
	if (manvs <= 1 and manvs >= 0 and !auto) {
		setprop("/systems/pressurization/outflowpos-man", manvs - 0.001);
	}
}

var apOff = func(type, side) {
	if (side == 0) {
		setprop("/it-autoflight/input/ap1", 0);
		setprop("/it-autoflight/input/ap2", 0);
	} elsif (side == 1) {
		setprop("/it-autoflight/input/ap1", 0);
	} elsif (side == 2) {
		setprop("/it-autoflight/input/ap2", 0);
	}
	apWarn(type);
}

var apWarn = func(type) {
	if (type == "none") {
		return;
	} elsif (type == "soft") {
		setprop("/ECAM/ap-off-time", getprop("/sim/time/elapsed-sec"));
		setprop("/it-autoflight/output/ap-warning", 1);
		setprop("/ECAM/warnings/master-warning-light", 1);
	} else {
		setprop("/it-autoflight/output/ap-warning", 2);
		# master warning handled by warning system in this case
		libraries.LowerECAM.clrLight();
	}
}

var athrOff = func(type) {
	if (type == "hard") {
		lockThr();
	}
	
	setprop("/it-autoflight/input/athr", 0);
	
	athrWarn(type);
}

var athrWarn = func(type) {
	if (type == "none") { 
		return; 
	} elsif (type == "soft") {
		setprop("/ECAM/athr-off-time", getprop("/sim/time/elapsed-sec"));
		setprop("/it-autoflight/output/athr-warning", 1);
	} else {
		libraries.LowerECAM.clrLight();
		setprop("/it-autoflight/output/athr-warning", 2);
	}
	setprop("/ECAM/warnings/master-caution-light", 1);
}

var lockThr = func() {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	if ((state1 == "CL" and state2 == "CL" and getprop("/systems/thrust/eng-out") == 0) or (state1 == "MCT" and state2 == "MCT" and getprop("/systems/thrust/eng-out") == 1)) {
		setprop("/systems/thrust/thr-locked", 1);
	}
	
	lockTimer.start();
}

var checkLockThr = func() {
	state1 = getprop("/systems/thrust/state1");
	state2 = getprop("/systems/thrust/state2");
	if ((state1 != "CL" and state2 != "CL" and getprop("/systems/thrust/eng-out") == 0) or (state1 != "MCT" and state2 != "MCT" and getprop("/systems/thrust/eng-out") == 1)) {
		setprop("/systems/thrust/thr-locked", 0);
		lockTimer.stop();
	}
}


var lockTimer = maketimer(0.02, checkLockThr);