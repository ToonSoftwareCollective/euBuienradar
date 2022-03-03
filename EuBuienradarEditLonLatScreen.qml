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

	function saveDimSunDown(text) {
		if (text) {
			app.autoDimlevelSunDown = parseInt(text);
			dimSunDownLabel.inputText = app.autoDimlevelSunDown;
	   		app.saveSettings();
		}
	}

	function saveDimSunUp(text) {
		if (text) {
			app.autoDimlevelSunUp = parseInt(text);
			dimSunUpLabel.inputText = app.autoDimlevelSunUp;
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
		dimSunDownLabel.inputText = app.autoDimlevelSunDown;
		dimSunUpLabel.inputText = app.autoDimlevelSunUp;
		yaxisLabel.inputText = app.yaxisScale;
		autoDimToggle.isSwitchedOn = app.autoAdjustDimBrightness ;
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

	EditTextLabel4421 {
		id: autoDimLabel
		width: cityLabel.width
		height: isNxt ? 44 : 35
		leftText: "Automatische helderheid dim"
		leftTextAvailableWidth: cityLabel.width
		anchors {
			left: cityLabel.left
			top: cityLabel.bottom
			topMargin: 6
		}
	}

	OnOffToggle {
		id: autoDimToggle
		height: isNxt ? 45 : 36
		anchors.left: autoDimLabel.right
		anchors.leftMargin: 10
		anchors.top: autoDimLabel.top
		anchors.topMargin: 5
		leftIsSwitchedOn: false
		onSelectedChangedByUser: {
			if (isSwitchedOn) {
				app.autoAdjustDimBrightness = true
			} else {
				app.autoAdjustDimBrightness = false
			}
		}
	}

	EditTextLabel4421 {
		id: dimSunDownLabel
		width: isNxt ? 200 : 170
		height: isNxt ? 45 : 35
		leftText: "Zon Onder:"
		leftTextAvailableWidth: isNxt ?  150 : 110

		anchors {
			left: autoDimToggle.right
			leftMargin: 10
			top: autoDimLabel.top
		}

		onClicked: {
			qnumKeyboard.open("Helderheid scherm na zonsondergang", dimSunDownLabel.inputText, app.autoDimlevelSunDown, 1 , saveDimSunDown, validateCoordinate);
		}
	}

	EditTextLabel4421 {
		id: dimSunUpLabel
		width: isNxt ? 200 : 170
		height: isNxt ? 45 : 35
		leftText: "Zon Op:"
		leftTextAvailableWidth: isNxt ?  150 : 110

		anchors {
			left: dimSunDownLabel.right
			leftMargin: 10
			top: autoDimLabel.top
		}

		onClicked: {
			qnumKeyboard.open("Helderheid scherm na zonsopgang", dimSunUpLabel.inputText, app.autoDimlevelSunUp, 1 , saveDimSunUp, validateCoordinate);
		}
	}

	EditTextLabel4421 {
		id: yaxisLabel
		width: lonLabel.width
		height: isNxt ? 45 : 35
		leftText: "Schaal grafiek:"
		leftTextAvailableWidth: isNxt ? 175 : 140

		anchors {
			left: lonLabel.left
			top: autoDimLabel.bottom
			topMargin: 50
		}

		onClicked: {
			qnumKeyboard.open("Y-as schaal", yaxisLabel.inputText, app.yaxisScale, 1 , saveYaxis, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}

	IconButton {
		id: yaxisButton;
		width: isNxt ? 50 : 40
		iconSource: "qrc:/tsc/edit.png"

		anchors {
			left: yaxisLabel.right
			leftMargin: 6
			top: cityLabel.bottom
			topMargin: 50
		}

		topClickMargin: 3
		onClicked: {
			qnumKeyboard.open("Schaal regengrafiek", yaxisLabel.inputText, app.yaxisScale, 1 , saveYaxis, validateCoordinate);
		}
		visible: (app.countryCode !== "EU")
	}


	Text {
		id: uitlegLabel
		text: "Schaal regengrafiek: voor flexibele schaling op basis\nvan de opgehaalde gegevens voer waarde 0 in."
       		width: isNxt ? 500 : 400
        	wrapMode: Text.WordWrap
		anchors {
			left: yaxisButton.right
			leftMargin: 20
			top: yaxisLabel.top
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 20 : 16
		}
		color: colors.rbTitle
	}
}
