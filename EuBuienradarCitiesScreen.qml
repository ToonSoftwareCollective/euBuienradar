import QtQuick 2.1
import qb.components 1.0

Screen {
	id: selectLocationScreen

	screenTitle: "Selekteer Plaats"

	anchors {
		top: parent.top
		topMargin: 5
		left: parent.left
		leftMargin: 32
	}


	function updatecityLabel(text) {
		cityLabel.inputText = text;
		app.cities = {};
		app.searchCities(text);

	}

	Component.onCompleted: {   //get signal when cies model is populated
		app.buienradarCitiesUpdated.connect(updateLabel);
	}

	function updateLabel() {
		brText.text = "Selekteer een plaats:"
	}

	
	EditTextLabel4421 {
		id: cityLabel
		width: isNxt ? 800 : 500
		height: isNxt ? 45 : 36
		leftText: "Zoek Plaats:"
		leftTextAvailableWidth: isNxt ? 250 : 200
		anchors {
			left: parent.left
			top: parent.top                       
			topMargin: 30
		}
		onClicked: {
			brText.text = "Ophalen plaatsen, ogenblikje......"
			qkeyboard.open("(gedeelte van) Plaatsnaam", cityLabel.inputText, updatecityLabel);
		}
	}

	Text {
		id: brText
		text: "Ophalen plaatsen, ogenblikje......"
		anchors {
			left: cityLabel.left
			top: cityLabel.bottom                       
			topMargin: isNxt ? 15 : 12
		}
		font {
			family: qfont.semiBold.name
			pixelSize: isNxt ? 25 : 20
		}

	}

	Grid {
		spacing:10
		columns: 2
		rows: 16
		anchors {
			top: brText.bottom
			topMargin: isNxt ? 25 : 20
			left: brText.left
		}

		Repeater {
			id: cityRepeater
			model: app.cities
		   	EuBuienradarCitiesDelegate { 
				visible: (app.cities[index]['continent'] == "EU")  ? true : false
				locationName: app.cities[index]['name'];
				locationId: app.cities[index]['id'];
				countryCode: app.cities[index]['countrycode']
				weatherStation: app.cities[index]['weatherstationid']
				lon: app.cities[index]['location']['lon']
				lat: app.cities[index]['location']['lat']
			} 
		}
	}
}
