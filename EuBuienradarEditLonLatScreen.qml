import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0

import BxtClient 1.0
import "buienradar.js" as BuienradarJS

Screen {
	id: lonlatEntryScreen

	property string qrCodeID

	function saveLon(text) {
		//rounding at 2 decimals
		if (text) {
			app.lon = (Math.round(parseFloat(text.replace(",", ".")) * 100) / 100);
			lonLabel.inputText = app.lon;
	   		app.saveSettings();
		}
	}

	function saveLat(text) {
		//rounding at 2 decimals
		if (text) {
			app.lat = (Math.round(parseFloat(text.replace(",", ".")) * 100) / 100);
			latLabel.inputText = app.lat;
	   		app.saveSettings();
		}
	}


	function validateCoordinate(text, isFinalString) {
		return null;
	}

	hasCancelButton: true
	hasSaveButton: false

	screenTitle: "BuienradarEU settings"

	onShown: {
		addCustomTopRightButton("Opslaan");
		cityLabel.inputText = app.locationName; 
		lonLabel.inputText = app.lon;
		latLabel.inputText = app.lat;
	}
	
	onCustomButtonClicked: {
		app.saveSettings();
		app.updateRegenkans();
		hide();
	}

	Text {
		id: title
		text: "Invoeren GPS coordinaten (2 decimalen) voor de exacte regenverwachting in NL en BE."
       		width: isNxt ? 500 : 400
        	wrapMode: Text.WordWrap
		font.pixelSize: isNxt ? 20 : 16
		font.family: qfont.semiBold.name
		color: colors.rbTitle

		anchors {
			left: lonButton.right
			leftMargin: 20
			top: lonButton.top
		}
		visible: (app.countryCode !== "EU")
	}

	EditTextLabel4421 {
		id: lonLabel
		width: isNxt ? 350 : 280
		height: isNxt ? 45 : 35
		leftText: "Lengtegraad:"
		leftTextAvailableWidth: isNxt ?  175 : 140

		anchors {
			left: parent.left
			leftMargin: 40
			top: parent.top
			topMargin: 30
		}

		onClicked: {
			qnumKeyboard.open("Lengtegraad", lonLabel.inputText, app.lon, 1 , saveLon, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}

	IconButton {
		id: lonButton
		width: isNxt ? 50 : 40

		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: lonLabel.right
			leftMargin: 6
			top: lonLabel.top
		}

		bottomClickMargin: 3
		onClicked: {
			qnumKeyboard.open("Lengtegraad", lonLabel.inputText, app.lon, 1 , saveLon, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}

	EditTextLabel4421 {
		id: latLabel
		width: lonLabel.width
		height: isNxt ? 45 : 35
		leftText: "Breedtegraad:"
		leftTextAvailableWidth: isNxt ?  175 : 140

		anchors {
			left: lonLabel.left
			top: lonLabel.bottom
			topMargin: 6
		}

		onClicked: {
			qnumKeyboard.open("Breedtegraad", latLabel.inputText, app.lat, 1 , saveLat, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}

	IconButton {
		id: latButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: latLabel.right
			leftMargin: 6
			top: lonLabel.bottom
			topMargin: 6
		}

		topClickMargin: 3
		onClicked: {
			qnumKeyboard.open("Breedtegraad", latLabel.inputText, app.lat, 1 , saveLat, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}

	EditTextLabel4421 {
		id: cityLabel
		width: lonLabel.width
		height: isNxt ? 45 : 35
		leftText: "Plaats:"
		leftTextAvailableWidth: isNxt ?  125 : 100

		anchors {
			left: lonLabel.left
			top: latLabel.bottom
			topMargin: 6
		}

		onClicked: {
  	              if (app.buienradarCitiesScreen) {
  	                     app.buienradarCitiesScreen.show();
  	              }
		}
	}

	IconButton {
		id: stationButton
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: cityLabel.right
			leftMargin: 6
			top: latLabel.bottom
			topMargin: 6
		}

		topClickMargin: 3
		onClicked: {
  	              if (app.buienradarCitiesScreen) {
  	                     app.buienradarCitiesScreen.show();
  	              }

		}
	}

}
