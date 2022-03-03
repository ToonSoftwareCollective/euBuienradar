import QtQuick 2.1
import BasicUIControls 1.0
import qb.components 1.0

Item {
	id: textItem
	width: isNxt ? 475 : 380
	property string locationName
	property string locationId 
	property string weatherStation 
	property string countryCode 
	property string lon
	property string lat 

	height: isNxt ? 35 : 28

	StandardButton {
		id: halteButton

		width: isNxt ? 475 : 360
		height: isNxt ? 30 : 24
		radius: 5
		text: locationName + "(" + countryCode + ")"
		fontPixelSize: isNxt ? 18 : 15
		color: colors.background

		anchors {
			top: parent.top
			topMargin: isNxt ? 5 : 4
			left: parent.left
			leftMargin: isNxt ? 5 : 4
		}

		onClicked: {
			app.locationName= locationName;
			app.locationId = locationId ;
			app.showRain = ((countryCode == "NL") || (countryCode == "BE"));
			app.countryCode = ((countryCode == "NL") || (countryCode == "BE")) ? countryCode : "EU";
			app.lon = lon ;
			app.lat = lat ;
			app.weatherStation = weatherStation ;
			app.saveSettings();
			app.updateBuienradar();
			app.radarimagesSmallurl ="http://toon/";  //resetimage
			if (isNxt){ 
				app.radarimagesSmallurl ="https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=240&h=240";
			} else {
				app.radarimagesSmallurl ="https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=190&h=190";
			}
			hide();
		}
	}
}
