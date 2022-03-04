import QtQuick 2.1
import qb.components 1.0

Screen {
	id: buienradarActualRadarScreen

	screenTitle: "Actuele Buienradar";

	onCustomButtonClicked: {
		if (app.buienradarEditLonLatScreen) {
			app.buienradarEditLonLatScreen.show();
		}
	}

	onShown: {
		addCustomTopRightButton("Locatie");
		stillRadarImage.visible = false;
		bigRadarImage.visible = true;
	}


	Rectangle {
		id:bigRadarImage
		anchors {
			baseline: parent.top
			left: parent.left
			leftMargin: 50
		}
		visible: true
   		AnimatedImage { id: animation; source: app.radarimagesurl }
	}

	Image {
		id: stillRadarImage
		source: app.stillimagesurl
		anchors {
			baseline: parent.top
			left: parent.left
			leftMargin: 50
		}
		visible: false
	}

	StandardButton {
		id: btnBuienradar
		width: isNxt ? 350 : 305
		text: "Buienradar +1 uur"
		anchors {
			baseline: parent.top
			left: parent.left
			leftMargin: isNxt ? 660 : 475
		}
		onClicked: {
			stillRadarImage.visible = false;
			bigRadarImage.visible = true;
			if (isNxt) {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=500&h=500";
			} else {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=400&h=400";
			}
			setTitle("Actuele Buienradar");
		}
	}

	StandardButton {
		id: btnBuienradar3
		width: isNxt ? 350 : 305
		text: "Buienradar +3 uur"
		anchors {
			left: btnBuienradar.left
			top: btnBuienradar.bottom
			topMargin: 10
		}
		onClicked: {
			stillRadarImage.visible = false;
			bigRadarImage.visible = true;
			if (isNxt) {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "/?nt=0&hist=-1&forc=37&step=2&h=500&w=500";
			} else {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "/?nt=0&hist=-1&forc=37&step=2&h=400&w=400";
			}
			setTitle("Actuele Buienradar 3 uur vooruit");
		}
	}

	StandardButton {
		id: btnBuienradar2
		width: isNxt ? 350 : 305
		text: "Buienradar +8 uur"
		anchors {
			left: btnBuienradar.left
			top: btnBuienradar3.bottom
			topMargin: 10
		}
		onClicked: {
			stillRadarImage.visible = false;
			bigRadarImage.visible = true;
			if (isNxt) {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "/?nt=0&hist=-1&forc=97&step=7&h=500&w=500";
			} else {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "/?nt=0&hist=-1&forc=97&step=7&w=400&h=400";
			}
			setTitle("Actuele Buienradar 8 uur vooruit");
		}
	}

	StandardButton {
		id: btnBuienradar4
		width: isNxt ? 350 : 305
		text: "Buienradar +24 uur"
		anchors {
			left: btnBuienradar.left
			top: btnBuienradar2.bottom
			topMargin: 10
		}
		onClicked: {
			stillRadarImage.visible = false;
			bigRadarImage.visible = true;
			if (isNxt) {
				app.radarimagesurl = "https://image.buienradar.nl/2.0/image/Animation/RadarMapRain24HourForecastWebmercator" + app.countryCode + "?extension=gif&width=500&height=500&renderText=True&renderBranding=False&renderBackground=True&history=0&forecast=24&skip=0";
			} else {
				app.radarimagesurl = "https://image.buienradar.nl/2.0/image/Animation/RadarMapRain24HourForecastWebmercator" + app.countryCode + "?extension=gif&width=400&height=400&renderText=True&renderBranding=False&renderBackground=True&history=0&forecast=24&skip=0";
			}
			setTitle("Actuele Buienradar 24 uur vooruit");
		}
	}

	StandardButton {
		id: btnEUBuienradar
		width: isNxt ? 350 : 305
		text: "Buienradar Europa"
		anchors {
			left: btnBuienradar.left
			top: btnBuienradar4.bottom
			topMargin: 10
		}
		onClicked: {
			stillRadarImage.visible = false;
			bigRadarImage.visible = true;
			if (isNxt) {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmapeu/?nt=0&hist=-1&forc=37&step=1&w=500&h=500";
			} else {
				app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmapeu/?nt=0&hist=-1&forc=37&step=1&w=400&h=400";
			}
			setTitle("Actuele Buienradar Europa");
		}
	}


	StandardButton {
		id: btnPollenradar
		width: isNxt ? 350 : 305
		text: "Pollenradar (NL / BE)"
		anchors {
			left: btnBuienradar.left
			top: btnEUBuienradar.bottom
			topMargin: 10
		}
		onClicked: {
			stillRadarImage.visible = true;
			bigRadarImage.visible = false;
			app.stillimagesurl = "http://toon/";  //resetimage
			if (isNxt) {
				app.stillimagesurl = "https://api.buienradar.nl/image/1.0/pollenradar" + app.countryCode + "/gif/?h=500";
			} else {
				app.stillimagesurl = "https://api.buienradar.nl/image/1.0/pollenradar" + app.countryCode + "/gif/?h=400";
			}
			setTitle("Pollenradar");
		}
		visible: ((app.countryCode == "NL") || (app.countryCode == "BE"))
	}
}
