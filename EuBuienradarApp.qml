import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0
import FileIO 1.0
import "buienradar.js" as BuienradarJS

App {
	id: buienradarApp
	objectName: "EuBuienradarApp"

	// These are the URL's for the QML resources from which our widgets will be instantiated.
	// By making them a URL type property they will automatically be converted to full paths,
	// preventing problems when passing them around to code that comes from a different path.

	//Edit these settings:
		// default weerstation after cold boot if no saved location exists	
	property string locationName : "Barcelona";
	property string locationId : "3128760"
	property string weatherStation : "0"
	property string countryCode : "EU"
		// default coordinates voor 2-uurs regenradardata if no saved location exists
	property string lat : "41.38879"
	property string lon : "2.15899"
	property real yaxisScale : 0
	//Stop editing here!	

	property url tileUrl : "EuBuienradarTile.qml"
	property url tileUrlRegen : "EuBuienradarRegenTile.qml"
	property url tileSunrise : "EuBuienradarSunriseTile.qml"
	property url thumbnailIcon: "qrc:/tsc/buienradar.png"
	property EuBuienradarDetailsScreen buienradarDetailsScreen
	property EuBuienradarCitiesScreen buienradarCitiesScreen
	property EuBuienradarActualRadarScreen buienradarActualRadarScreen
	property EuBuienradarEditLonLatScreen buienradarEditLonLatScreen
	property url menuUrl : "EuBuienradarMenu.qml"
	property url trayUrl : "EuBuienradarTray.qml";
	property string timeStr

	property variant regenVerwachting : []
	property string regenVerwachtingVanaf
	property string regenVerwachtingMidden
	property string regenVerwachtingTot
	property real regenMaxValue
	property bool showRain : false
	property variant cities : {}

	property string temperatuurGC
	property string windsnelheidBF
	property string windsnelheidMS
	property string gevoelsTemperatuur
	property string windrichting
	property string icoonlink
	property string icoonid
	property string icoonimageDim
	property string icoonimageNoDim
	property string luchtvochtigheid
	property string luchtdruk
	property string zichtmeters
	property string datumupdate
	property string radarimagesurl
	property string radarimagesSmallurl
	property string zonopkomst
	property string zononder

	property variant fivedayforecast: []
	property variant actualweather: []

	property bool autoAdjustDimBrightness: true
	property int autoDimlevelSunUp: 30
	property int autoDimlevelSunDown: 10

	// user settings from config file
	property variant buienradarSettingsJson : {
		'locationName' : "",
		'locationId' : "",
		'countryCode' : "",
		'weatherStation' : "",
		'selectedLongitude': "",
		'selectedLatitude': "",
		'autoAdjustDimBrightness': "Yes",
		'autoDimlevelSunUp': 30,
		'autoDimlevelSunDown': 10
	}

	FileIO {
		id: buienradarSettingsFile
		source: "file:///mnt/data/tsc/EuBuienradar.userSettings.json"
 	}

    	signal buienradarCitiesUpdated()
    	signal buienradarDataUpdated()

	QtObject {
		id: p

		property url buienradarDetailsScreenUrl : "EuBuienradarDetailsScreen.qml"
		property url buienradarCitiesScreenUrl : "EuBuienradarCitiesScreen.qml"
		property url buienradarActualRadarScreenUrl : "EuBuienradarActualRadarScreen.qml"
		property url buienradarEditLonLatScreenUrl : "EuBuienradarEditLonLatScreen.qml"
		property url buienradarFullWeatherForecastScreenUrl : "EuBuienradarFullWeatherForecastScreen.qml"
		property url buienradarMenuUrl   : "EuBuienradarMenu.qml"
		property url buienradarTrayUrl: "EuBuienradarTray.qml"
	}

	
	function init() {
		registry.registerWidget("tile", tileUrl, this, null, {thumbLabel: qsTr("BuienradarEU"), thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("tile", tileUrlRegen, this, null, {thumbLabel: "Regenverw.", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("tile", tileSunrise, this, null, {thumbLabel: "Zon op/onder", thumbIcon: thumbnailIcon, thumbCategory: "general", thumbWeight: 30, baseTileWeight: 10, thumbIconVAlignment: "center"});
		registry.registerWidget("screen", p.buienradarDetailsScreenUrl, this, "buienradarDetailsScreen");
		registry.registerWidget("screen", p.buienradarCitiesScreenUrl, this, "buienradarCitiesScreen");
		registry.registerWidget("screen", p.buienradarActualRadarScreenUrl, this, "buienradarActualRadarScreen");
		registry.registerWidget("screen", p.buienradarEditLonLatScreenUrl, this, "buienradarEditLonLatScreen");
		registry.registerWidget("menuItem", p.buienradarMenuUrl, this, "buienradarMenu", {weight: 110});
		registry.registerWidget("systrayIcon", p.buienradarTrayUrl, buienradarApp);
	}

	Component.onCompleted: {

		//read user settings

		try {
			buienradarSettingsJson = JSON.parse(buienradarSettingsFile.read());
			if (buienradarSettingsJson['locationName']) locationName = buienradarSettingsJson['locationName'];		
			if (buienradarSettingsJson['locationId']) locationId = buienradarSettingsJson['locationId'];		
			if (buienradarSettingsJson['countryCode']) countryCode = buienradarSettingsJson['countryCode'];		
			if (buienradarSettingsJson['weatherStation']) weatherStation = buienradarSettingsJson['weatherStation'];		
			if (buienradarSettingsJson['selectedLongitude']) lon = buienradarSettingsJson['selectedLongitude'];		
			if (buienradarSettingsJson['selectedLatitude']) lat = buienradarSettingsJson['selectedLatitude'];		
			if (buienradarSettingsJson['autoDimlevelSunUp']) autoDimlevelSunUp = buienradarSettingsJson['autoDimlevelSunUp'];		
			if (buienradarSettingsJson['autoDimlevelSunDown']) autoDimlevelSunDown = buienradarSettingsJson['autoDimlevelSunDown'];		
			if (buienradarSettingsJson['autoAdjustDimBrightness']) {
				 if (buienradarSettingsJson['autoAdjustDimBrightness'] == "Yes") {
					autoAdjustDimBrightness = true;
				} else {
					autoAdjustDimBrightness = false;
				}		
			}
		} catch(e) {
		}
	}

	function saveSettings() {
		
		// save user settings
 		var tmpUserSettingsJson = {
			"locationName": locationName,
			"locationId": locationId,
			"countryCode": countryCode,
			"weatherStation": weatherStation,
			"selectedLongitude": lon,
			"selectedLatitude": lat,
			"autoAdjustDimBrightness": autoAdjustDimBrightness ? "Yes" : "No",
			"autoDimlevelSunUp": autoDimlevelSunUp,
			"autoDimlevelSunDown": autoDimlevelSunDown
		}

  		var doc3 = new XMLHttpRequest();
   		doc3.open("PUT", "file:///mnt/data/tsc/EuBuienradar.userSettings.json");
   		doc3.send(JSON.stringify(tmpUserSettingsJson ));
	}

	function updateBuienradar() {
		
  		var weekday = new Array(7);
  		weekday[0] = "Zo";
  		weekday[1] = "Ma";
 		weekday[2] = "Di";
  		weekday[3] = "Wo";
 		weekday[4] = "Do";
  		weekday[5] = "Vr";
  		weekday[6] = "Za";

		var now = new Date().getTime();
		timeStr = i18n.dateTime(now, i18n.time_yes);

			// get 5 days forecast

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {

			if (xmlhttp.readyState == 4) {
				if (xmlhttp.status == 200) {
					var brJson = JSON.parse(xmlhttp.responseText);
				
					zonopkomst = brJson['days']['0']['sunrise']
					zononder = brJson['days']['0']['sunset']

						// auto adjust brightness if configured (on Toon 1 only)

					if (autoAdjustDimBrightness) {
	                 			if (BuienradarJS.determineNight (timeStr, zonopkomst, zononder)) 
        	             				screenStateController.backLightValueScreenDimmed = autoDimlevelSunDown;
                	  			else
                     					screenStateController.backLightValueScreenDimmed = autoDimlevelSunUp;
                  				screenStateController.notifyChangeOfSettings();
					}
					
						// read 5-days weather forecast

					var tmpForecast = [];	
					tmpForecast.push({'regen': 'regen mm',
							  'mintemp': 'min',
							  'maxtemp': 'max',
							  'icoon' : " ",
							  'dagweek' : " ",
							  'wind': 'wind'});

						// load next 5 days forecast

					for (var i = 0; i < 9; i++) {
						var tmpNewDate = new Date(brJson['days'][i]['date']);
						var tmpdagweek = weekday[tmpNewDate.getDay()];
						var dpicoon = "qrc:/tsc/" + brJson['days'][i]['iconcode'] + ".png";
						tmpForecast.push({'dagweek': tmpdagweek,
							  'regen': brJson['days'][i]['precipitationmm'].toString(),
							  'mintemp': i18n.number( Number(brJson['days'][i]['mintemp']), 0).toString(),
							  'maxtemp': i18n.number( Number(brJson['days'][i]['maxtemp']), 0).toString(),
							  'wind': brJson['days'][i]['winddirection'].toUpperCase() + " " + brJson['days'][i]['beaufort'].toString(),
							  'icoon': dpicoon});
					}
					fivedayforecast = tmpForecast;

						// get actual weather data if near a weatherstation

					if (weatherStation.length > 2) {

						var xmlhttp2 = new XMLHttpRequest();
						xmlhttp2.onreadystatechange=function() {

							if (xmlhttp2.readyState == 4) {
								if (xmlhttp2.status == 200) {
									var brJson2 = JSON.parse(xmlhttp2.responseText);
	
										// save actual temp for use in TemperatureLogger app

				   					var doc2 = new XMLHttpRequest();	
									doc2.open("PUT", "file:///var/volatile/tmp/actualBuienradarTemp.txt");
   									doc2.send(brJson['temperature'] + ":" + brJson2['timestamp']);
	
									if (brJson2['windspeed']) windsnelheidMS = brJson2['windspeed'];
									if (brJson2['windspeedBft']) windsnelheidBF = brJson2['windspeedBft'];
									if (brJson2['winddirection']) windrichting = brJson2['winddirection'].toUpperCase();
									if (brJson2['visibility']) zichtmeters = brJson2['visibility'];
									if (brJson2['temperature']) temperatuurGC = brJson2['temperature'];
									if (brJson2['feeltemperature']) gevoelsTemperatuur = brJson2['feeltemperature'];
									if (brJson2['humidity']) luchtvochtigheid = brJson2['humidity'];
	
									icoonlink = "qrc:/tsc/" + brJson2['iconcode'] + ".png";	
		
										// fill model for grid of weather station data on detail screen
	
									var tmpActual = [];	
									tmpActual.push({'location': locationName,
										  'temperature': 'Temperatuur:',
										  'feeltemperature': 'Gevoelstemp:',
										  'wind': 'Wind:',
										  'luchtdruk': 'Luchtdruk:',
										  'luchtvochtigheid': 'Luchtvochtigheid:',
										  'zicht': 'Zicht:',
										  'zonoponder': 'Zon op\/onder'});
									tmpActual.push({'location': BuienradarJS.dateFormat(brJson2['timestamp']),
										  'temperature': i18n.number( Number(temperatuurGC ), 1 ) + "°",
										  'feeltemperature': i18n.number( Number(gevoelsTemperatuur), 1 ) + "°",
										  'wind': windsnelheidBF + " Bft, " + windrichting,
										  'luchtdruk': "--",
										  'luchtvochtigheid': luchtvochtigheid + " %" ,
										  'zicht': zichtmeters + "m",
										  'zonoponder': BuienradarJS.lineZonOpOnder(brJson['days']['0']['sunrise'], brJson['days']['0']['sunset'])});
									actualweather = tmpActual;

				
									zonopkomst = brJson['days']['0']['sunrise']
									zononder = brJson['days']['0']['sunset']

										// auto adjust brightness if configured (on Toon 1 only)

									if (autoAdjustDimBrightness) {
	                				 			if (BuienradarJS.determineNight (timeStr, zonopkomst, zononder)) 
        	             								screenStateController.backLightValueScreenDimmed = autoDimlevelSunDown;
    			            	  				else
                     									screenStateController.backLightValueScreenDimmed = autoDimlevelSunUp;
                  								screenStateController.notifyChangeOfSettings();
									}

									icoonimageDim = BuienradarJS.parseWeatherIdAndText(true, "qrc:/tsc/Dim", brJson2['iconcode'], zonopkomst, zononder, timeStr);
									icoonimageNoDim = BuienradarJS.parseWeatherIdAndText(true, "qrc:/tsc/Home", brJson2['iconcode'], zonopkomst, zononder, timeStr);
									buienradarDataUpdated();
								}
							}
						}
						xmlhttp2.open("GET", "https://observations.buienradar.nl/1.0/actual/weatherstation/" + weatherStation, true);
						xmlhttp2.send();

					} else {  // try to get some data from openweathermap.org

						var xmlhttp2 = new XMLHttpRequest();
						xmlhttp2.onreadystatechange=function() {
							if (xmlhttp2.readyState == 4) {
								if (xmlhttp2.status == 200) {
									var brJson2 = JSON.parse(xmlhttp2.responseText);
	
										// save actual temp for use in TemperatureLogger app

				
				   					var doc2 = new XMLHttpRequest();	
									doc2.open("PUT", "file:///var/volatile/tmp/actualBuienradarTemp.txt");
   									doc2.send(i18n.number( Number(brJson2['main']['temp']), 1 ) + ":" + BuienradarJS.convertEpoch(parseInt(brJson2['dt'])));

									windsnelheidMS = brJson2['wind']['speed'];
									windsnelheidBF = BuienradarJS.calculateWindBFT(parseFloat(brJson2['wind']['speed']));
									windrichting = BuienradarJS.translateWinddirection(brJson2['wind']['deg']);
									zichtmeters = brJson2['visibility'];
									temperatuurGC = brJson2['main']['temp'];
									luchtdruk = brJson2['main']['pressure'];
									gevoelsTemperatuur = brJson2['main']['feels_like'];
									luchtvochtigheid = brJson2['main']['humidity'];
	
									icoonlink = " ";	
		
										// fill model for grid of weather station data on detail screen


									var tmpActual = [];	
									tmpActual.push({'location': locationName,
										  'temperature': 'Temperatuur:',
										  'feeltemperature': 'Gevoelstemp:',
										  'wind': 'Windsnelheid:',
										  'luchtdruk': 'Luchtdruk:',
										  'luchtvochtigheid': 'Luchtvochtigheid:',
										  'zicht': 'Zicht:',
										  'zonoponder': 'Zon Op/Onder: '});
									tmpActual.push({'location': BuienradarJS.convertEpoch(brJson2['dt']).substring(0,10) + " " + BuienradarJS.convertEpoch(brJson2['dt']).substring(11,16),
										  'temperature': i18n.number( Number(temperatuurGC ), 1 ) + "°",
										  'feeltemperature': i18n.number( Number(gevoelsTemperatuur), 1 ) + "°",
										  'wind': windsnelheidBF + " Bft, " + windrichting,
										  'luchtdruk': luchtdruk,
										  'luchtvochtigheid': luchtvochtigheid + " %" ,
										  'zicht': zichtmeters + " m",
										  'zonoponder': BuienradarJS.lineZonOpOnder(BuienradarJS.convertEpoch(brJson2['sys']['sunrise']), BuienradarJS.convertEpoch(brJson2['sys']['sunset']))
										});
									actualweather = tmpActual;
				
									zonopkomst = BuienradarJS.convertEpoch(brJson2['sys']['sunrise']);
									zononder = BuienradarJS.convertEpoch(brJson2['sys']['sunset'])

										// auto adjust brightness if configured (on Toon 1 only)

									if (autoAdjustDimBrightness) {
	                				 			if (BuienradarJS.determineNight (timeStr, zonopkomst, zononder)) 
        	             								screenStateController.backLightValueScreenDimmed = autoDimlevelSunDown;
    			            	  				else
                     									screenStateController.backLightValueScreenDimmed = autoDimlevelSunUp;
                  								screenStateController.notifyChangeOfSettings();
									}

									icoonimageDim = BuienradarJS.parseWeatherIdAndText(true, "qrc:/tsc/Dim", brJson2['weather'][0]['icon'], zonopkomst, zononder, timeStr);
									icoonimageNoDim = BuienradarJS.parseWeatherIdAndText(true, "qrc:/tsc/Home", brJson2['weather'][0]['icon'], zonopkomst, zononder, timeStr);
									buienradarDataUpdated();
								}
							}
						}
						xmlhttp2.open("GET", "http://api.openweathermap.org/data/2.5/weather?lat=" + lat + "&lon=" + lon + "&appid=6eff1de86a36ae47f2919ead408132b5&units=metric", true);
						xmlhttp2.send();
					}
				}
			}
		}
		xmlhttp.open("GET", "https://forecast.buienradar.nl/2.0/forecast/" + locationId, true);
		xmlhttp.send();

	}

	function updateRegenkans() {
	
		if (countryCode !== "EU") {  //only for NL and BE
			var xmlhttp = new XMLHttpRequest();
			var newArray = [];
			var mmRegen = 0;
			var maxValue = 0;
			regenMaxValue = 2;
			showRain = false;

			xmlhttp.onreadystatechange=function() {
				if (xmlhttp.readyState == 4) {
					if (xmlhttp.status == 200) {
						var response = xmlhttp.responseText;
			        	        if (response.length > 0) {
                        				var res = response.replace(/\r/g, "").split(/\n/);

				                        regenVerwachtingVanaf = res[0].split("|")[1];
        	                			regenVerwachtingMidden = BuienradarJS.addMinutes(regenVerwachtingVanaf, 60);
                	        			regenVerwachtingTot = BuienradarJS.addMinutes(regenVerwachtingVanaf, 120);

							for (var i = 0; i < res.length -1 ; i++) {
								mmRegen =  Math.round(Math.pow(10,((Number(res[i].split(/[,.|]/)[0])-109)/32))*10)/10;
								newArray.push(mmRegen);
								if (maxValue < mmRegen) {
									maxValue = mmRegen;
								}
							}
							regenVerwachting = newArray;
							
							if (maxValue > regenMaxValue) {
								regenMaxValue = Math.round(maxValue + 0.5);
							}
							
							if (maxValue > 0) {
								showRain = true;
							}
						}	
					}
				}
			}
			xmlhttp.open("GET", "https://gadgets.buienradar.nl/data/raintext?lat="+lat+"&lon="+lon, true);
			xmlhttp.send();
		}
	}

	function searchCities(searchStr) {

		var xmlhttp = new XMLHttpRequest();
		xmlhttp.onreadystatechange=function() {
			if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
				cities = JSON.parse(xmlhttp.responseText);
				buienradarCitiesUpdated();
			}
		}
		xmlhttp.open("GET", "https://location.buienradar.nl/1.1/location/search?query=" + searchStr, true);
		xmlhttp.send();

	}

	
	Timer {
		id: datetimeTimer
		interval: 1200000
		triggeredOnStart: true
		running: true
		repeat: true
		onTriggered: updateBuienradar()
	}


	Timer {
		id: datetimeTimer2
		interval: 300000
		triggeredOnStart: true
		running: true
		repeat: true
		onTriggered: updateRegenkans()
	}
}
