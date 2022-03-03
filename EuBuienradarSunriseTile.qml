import QtQuick 2.1
import qb.components 1.0
import "buienradar.js" as BuienradarJS

Tile {
	id: buienradarTile

	property bool dimState: screenStateController.dimmedColors

	onClicked: {
		app.radarimagesSmallurl ="http://toon/";  //resetimage
		if (isNxt) {
			app.radarimagesSmallurl ="https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=240&h=240";
		} else {
			app.radarimagesSmallurl ="https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=190&h=190";
		}
		if (app.buienradarDetailsScreen)
			app.buienradarDetailsScreen.show();
	}


	Text {
		id: weatherSunrise
		text: app.zonopkomst.substr(11,5)
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 70 : 55
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 65 : 50
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
 	}

	Text {
		id: weatherSunsetText
		text: "Zon op / onder"
		anchors {
			left: weatherSunrise.left
			leftMargin: isNxt ? 16 : 12
			top: weatherSunrise.bottom
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 20 : 16
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
 	}

	Text {
		id: weatherSunset
		text: app.zononder.substr(11,5)
		anchors {
			left: weatherSunrise.left
			topMargin: isNxt ? 20 : 16
			top: weatherSunrise.bottom
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 65 : 50
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.waTileTextColor : colors.waTileTextColor
 	}
}
