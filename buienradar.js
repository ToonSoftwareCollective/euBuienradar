function addStationName(inputarray, index, name) {
		inputarray[index] = name;
		return inputarray;
}

function convertEpoch(epochsec) {
	var d = new Date(0); // The 0 there is the key, which sets the date to the epoch
	d.setUTCSeconds(epochsec);
	const offset = d.getTimezoneOffset();
	var e = new Date(d.getTime() - (offset*60*1000));
	return e.toISOString().substr(0, 16)
}

function calculateWindBFT(windms) {
	
	var windBft = "0";

    	switch (true) {
  	  	case (windms < 0.3): windBft = "0"; break;
 		case (windms < 1.6): windBft = "1"; break;
 		case (windms < 3.4): windBft = "2"; break;
 		case (windms < 5.5): windBft = "3"; break;
		case (windms < 8.0): windBft = "4"; break;
		case (windms < 10.8): windBft = "5"; break;
		case (windms < 13.9): windBft = "6"; break;
		case (windms < 17.2): windBft = "7"; break;
 		case (windms < 20.8): windBft = "8"; break;
		case (windms < 24.5): windBft = "9"; break;
		case (windms < 28.5): windBft = "10"; break;
		case (windms < 32.7): windBft = "11"; break;
		default:
			windBft = "12";
	}
	return windBft;

}

function translateWinddirection(degrees) {

	var direction = " ";

    	switch (true) {
  	  	case (degrees < 11.25): direction = "N"; break;
 		case (degrees < 33.75): direction = "NNO"; break;
 		case (degrees < 56.25): direction = "NO"; break;
 		case (degrees < 78.75): direction = "ONO"; break;
		case (degrees < 101.25): direction = "O"; break;
		case (degrees < 123.75): direction = "OZO"; break;
		case (degrees < 146.25): direction = "ZO"; break;
		case (degrees < 168.75): direction = "ZZO"; break;
 		case (degrees < 191.25): direction = "Z"; break;
		case (degrees < 213.75): direction = "ZZW"; break;
		case (degrees < 236.25): direction = "ZW"; break;
		case (degrees < 258.75): direction = "WZW"; break;
		case (degrees < 281.25): direction = "W"; break;
		case (degrees < 303.75): direction = "WNW"; break;
		case (degrees < 326.25): direction = "NW"; break;
		case (degrees < 348.75): direction = "NNW"; break;
		default:
			direction = "N";
	}
	return direction;
}


function addMinutes(time/*"hh:mm"*/, minsToAdd/*"N"*/) {
  function z(n){
    return (n<10? '0':'') + n;
  }
  var bits = time.split(':');
  var mins = bits[0]*60 + (+bits[1]) + (+minsToAdd);

  return z(mins%(24*60)/60 | 0) + ':' + z(mins%60);  
}

function formatScale(maxRegen, yScale) {
    if (yScale = 0) {
	return 72 / maxRegen;
    } else {
	return 72 / yScale;
    }
}

function formatTemp(tempValue, locationName) {
//adapted to reflect locale settings
	if (locationName) return locationName + ": " + i18n.number( Number( tempValue ), 1 ) + " °C";
	return "Even geduld..."
}


function dateFormat( dateStr ) {
    return  dateStr.substring(0, 10) + " " + dateStr.substring(11,16);
}


function formatDimTemp( tempValue ) {
//adapted to reflect locale settings

	return i18n.number( Number( tempValue ), 1 )  + " °C";
}


function formatWind(richting, bf) {
	return "wind: " + bf + " BFT, " + richting;
}


function formatWind2(richting, bf) {
	return bf + " " + richting;
}


function determineNight (tijdnu, zonop, zononder) {
	var zonoptimestr = zonop.substring(11,16);
	var zonondertimestr = zononder.substring(11,16);
	if (tijdnu.length == 4)
		tijdnu = "0" + tijdnu;
	var isTodayDay = ((tijdnu <= zonondertimestr) && (tijdnu >= zonoptimestr));
	return !isTodayDay;
}


function formatGevoelstemp( temperature, windSpeed, humidity ) {
   
   return "gevoelstemp: " + i18n.number(Number(temperature), 1) + " °C";

}

	
function formatLuchtdruk(humidity) {
	return "Luchtvochtigheid: " + humidity + " %";
}


function lineTemp(tempValue) {
	return i18n.number( Number( tempValue ), 1 ) + " °C";
}


function lineZonOpOnder(zonop, zononder) {
	return zonop.substr(11,5) + " / " + zononder.substr(11,5);
}


function lineWindsnelheid(bf) {
	return bf + " BFT";
}


function lineLuchtvochtigheid(lv) {
	return lv + " %";
}


function lineLuchtdruk(ld) {
	return i18n.number(ld, 0, i18n.general_rounding, 1) + " hPa";
}


function lineZichtmeters(zm) {
	return zm + " m";
}


function lineWindstotenMS(ws) {
	return "Windstoten:       " + ws + " m/s";
}


/**
* @brief Calculate a filename to choose weather icons, distinquishing day and night icons. If later than 16:00 local time a night icon will be chosen.
* @param forceDay : Boolean
*	 If set to true, choice of day icon is forced.
* @param sourceFileName : String
*	 This is the first part of the filename including the path.
* @param weatherId : String
*	 A string that holds an Id coming from buienradar.nl. This is the basis of the decision what icon to pick.
* @param weatherText : String
*	 If weatherId is "0", the icon is chosen on the basis of this string.
* @return relative path to weather icon as string
*/

function parseWeatherIdAndText(forceDay, sourceFileName, weatherId, zonop, zononder, tijdnu) {
    
	var isTodayNight = determineNight (tijdnu, zonop, zononder);

    switch (weatherId) {
    case '01d':
    case 'a': isTodayNight ? sourceFileName += "ClearNight" : sourceFileName += "Sunny";
	break;
    case 'b':
    case 'o':
	sourceFileName += isTodayNight ? "CloudedNight" : "SunnyIntervals";
	break;
    case 'f':
    case '10d':
	sourceFileName += isTodayNight ? "LightRainNight" : "LightRainDay";
	break;
    case 'k':
	sourceFileName += isTodayNight ? "RainNight" : "RainDay";
	break;
    case 'h':
    case 'i':
	sourceFileName += isTodayNight ? "RainHailNight" : "RainHailDay";
	break;
    case 'g':
    case '11d':
	sourceFileName += isTodayNight ? "Thunder Night" : "ThunderDay";
	break;
    case 'u':
	sourceFileName += isTodayNight ? "LightSnowNight" : "LightSnowDay";
	break;
    case 'd':
	sourceFileName += isTodayNight ? "FogNight" : "FogDay";
	break;
	//symbols with moon
    case 'aa':
	sourceFileName += "ClearNight";
	break;
    case 'bb':
    case 'oo':
	sourceFileName += "CloudedNight";
	break;
    case 'ff':
	sourceFileName += "LightRainNight";
	break;
    case 'kk':
	sourceFileName += "RainNight";
	break;
    case 'hh':
    case 'ii':
	sourceFileName += "RainHailNight";
	break;
    case 'gg':
	sourceFileName += "ThunderNight";
	break;
    case 'uu':
	sourceFileName += "LightSnowNight";
	break;
    case 'dd':
	sourceFileName += "FogNight";
	break;
	//just clouds
    case 'c':
    case 'p':
   case 'cc':
    case 'pp':
    case '03d':
	sourceFileName += "Clouded";
	break;
    case 'm':
    case 'mm':
	sourceFileName += "LightRain";
	break;
    case 'l':
    case 'll':
    case 'q':
    case 'qq':
    case '09d':
	sourceFileName += "Rain";
	break;
    case 'w':
    case 'ww':
	sourceFileName += "Sleet";
	break;
    case 's':
    case 'ss':
	sourceFileName += "Thunder";
	break;
    case 'v':
    case 'vv':
    case 'y':
    case 'yy':
	sourceFileName += "LightSnow";
	break;
    case '1':
    case '11':
    case 't':
    case 'tt':
    case 'x':
    case 'xx':
    case 'z':
    case 'zz':
    case '13d':
	sourceFileName += "Snow";
	break;
    case 'e':
    case 'ee':
    case '50d':
	sourceFileName += "Fog";
	break;
    case 'n':
    case 'nn':
	sourceFileName += "SlipRisk";
	break;
    case '0':

	break;
    default:
	sourceFileName += "Cross";
    }
    
    return sourceFileName += ".png"
}

