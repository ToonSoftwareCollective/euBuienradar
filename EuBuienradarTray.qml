import QtQuick 2.1
import qb.components 1.0
import qb.base 1.0

SystrayIcon {
	id: buienradarSystrayIcon
	visible: true
	posIndex: 9000
        property string objectName: "buienradarSystrayIcon"

	onClicked: {
		app.radarimagesurl ="http://toon/";  //resetimage
		if (isNxt) {
			app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=600&h=600";
		} else {
			app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMap" + app.countryCode + "?w=400&h=400";
		}
		if (app.buienradarActualRadarScreen) {
			app.buienradarActualRadarScreen.setTitle("Actuele Buienradar");
			app.buienradarActualRadarScreen.show();
		}
	}

	Image {
		id: imgNewMessage
		anchors.centerIn: parent
		source: "qrc:/tsc/buienradarTray.png"
	}
}
