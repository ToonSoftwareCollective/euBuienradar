import QtQuick 2.1
import qb.components 1.0
import "buienradar.js" as BuienradarJS

Screen {
	id: buienradarDetailsScreen

	screenTitle: "Actueel weer plus weersverwachting";

	property bool dimState: screenStateController.dimmedColors;

	onCustomButtonClicked: {
		if (app.buienradarEditLonLatScreen) {
			 app.buienradarEditLonLatScreen.show();
		}
	}

	onShown: {
		addCustomTopRightButton("Locatie");
		showData();
	}

	Component.onCompleted: {   //get signal when cies model is populated
		app.buienradarDataUpdated.connect(showData);
	}


	function showData() {

		fivedayforecastModel.clear();
		for (var i = 0; i < app.fivedayforecast.length; i++) {
			fivedayforecastModel.append(app.fivedayforecast[i]);
		}
		actualWeatherModel.clear();
		for (var i = 0; i < app.actualweather.length; i++) {
			actualWeatherModel.append(app.actualweather[i]);
		}
	}

//selected weatherstation data

	Rectangle {
		id: backgroundRect
		height: isNxt ? 240 : 190
		width: isNxt ? 345 : 275
		anchors {
			baseline: parent.top
			baselineOffset: 5
			left: parent.left
			leftMargin: 5
		}
		color: colors.addDeviceBackgroundRectangle
	}

	Rectangle {
		id: backgroundRect2
		height: isNxt ? 240 : 190
		width:  isNxt ? 1014 : 790
		anchors {
			top: backgroundRect.bottom
			topMargin: isNxt ? 10 : 8
			left: parent.left
			leftMargin: 5
		}
		color: colors.addDeviceBackgroundRectangle
	}

	Rectangle {
		color: "#FFFF00"
		width: backgroundRect.width
		height: isNxt ? 35 : 28
		anchors {
			top: backgroundRect.top
			left: backgroundRect.left
		}
	}
	

//weatherforecast data for selected weather station

	GridView {
		id: grid

		model: actualWeatherModel
		delegate: actualDelegateGrid

		interactive: false
		flow: GridView.TopToBottom
		cellWidth: isNxt ? 175 : 140
		cellHeight: backgroundRect.height
		height: backgroundRect.height
		width: parent.width
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 32 : 24
			left: parent.left
			leftMargin: 10
		}
	}


	ListModel {
		id: actualWeatherModel
	}

	Component {
		id: actualDelegateGrid

		Item {
			width: grid.width / grid.columns
		        height: grid.height
			Rectangle {
				anchors.fill: parent

			 	Text {
					id: txtstation
					text: location
					anchors {
						baseline: parent.top
					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}


				Text {
					id: txttemperature
					text: temperature
					anchors {
						top: txtstation.bottom
						topMargin: isNxt ? 5 : 4
					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}


				Text {
					id: txtfeeltemperature
					text: feeltemperature
					anchors {
						top: txttemperature.bottom
						topMargin: isNxt ? 5 : 4
					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: txtwindsnelheid
					text: wind
					anchors {
						top: txtfeeltemperature.bottom
						topMargin: isNxt ? 5 : 4

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: txtwindrichting
					text: luchtdruk
					anchors {
						top: txtwindsnelheid.bottom
						topMargin: isNxt ? 5 : 4

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: txthumidity
					text: luchtvochtigheid
					anchors {
						top: txtwindrichting.bottom
						topMargin: isNxt ? 5 : 4

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: txtzicht
					text: zicht
					anchors {
						top: txthumidity.bottom
						topMargin: isNxt ? 5 : 4
					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: txtzonop
					text: zonoponder
					anchors {
						top: txtzicht.bottom
						topMargin: isNxt ? 5 : 4

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}
			}
		}
        }

//weatherforecast data per day of week

	GridView {
		id: grid2

		model: fivedayforecastModel
		delegate: delegateGrid

		interactive: false
		flow: GridView.TopToBottom
		cellWidth: isNxt ? 100 : 75
		cellHeight: backgroundRect2.height
		height: backgroundRect2.height
		width: parent.width
		anchors {
			top: backgroundRect2.top
			topMargin: isNxt ? 30 : 24
			left: backgroundRect2.left
			leftMargin : 5
		}
	}

	ListModel {
		id: fivedayforecastModel
	}

	Component {
		id: delegateGrid

		Item {
			width: grid.width / grid.columns
		        height: grid.height
			Rectangle {
				anchors.fill: parent

			 	Text {
					id: forecastdagweek
					text: dagweek
					anchors {
						baseline: parent.top
					}
					font {
						family: qfont.bold.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}
	
				Text {
					id: forecastkanszon
					text: " " //empty row
					anchors {
						top: forecastdagweek.bottom
						topMargin: isNxt ? 5 : 4
						left: forecastdagweek.left

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: forecastkansregen
					text: regen
					anchors {
						top: forecastkanszon.bottom
						topMargin: isNxt ? 5 : 4
						left: forecastdagweek.left

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: forecastmintemp
					text: mintemp
					anchors {
						top: forecastkansregen.bottom
						topMargin: isNxt ? 5 : 4
						left: forecastdagweek.left

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: forecastmaxtenmp
					text: maxtemp
					anchors {
						top: forecastmintemp.bottom
						topMargin: isNxt ? 5 : 4
						left: forecastdagweek.left

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}

				Text {
					id: forecastwind
					text: wind
					anchors {
						top: forecastmaxtenmp.bottom
						topMargin: isNxt ? 5 : 4
						left: forecastdagweek.left

					}
					font {
						family: (index == 0) ? qfont.bold.name : qfont.regular.name
						pixelSize: isNxt ? 18 : 15
					}
					color: colors.clockTileColor
				}
				Image {
					id: forecasticoon
					source: icoon
					anchors {
						top: forecastwind.bottom
						topMargin: isNxt ? 10 : 8
						left: forecastdagweek.left

					}
					cache: false
				}
			}
		}
        }


	Rectangle {
 		id: backgroundRectradar
		height: isNxt ? 240 : 190
		width: isNxt ? 240 : 190
		anchors {
			top: backgroundRect.top
			left: backgroundRect.right
			leftMargin: 10
		}
    		AnimatedImage { id: animation; source: app.radarimagesSmallurl }

		MouseArea {
			anchors.fill: parent
			onClicked: {
				app.radarimagesurl = "http://toon/";  //resetimage
				if (isNxt) {
					app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "?w=600&h=600";
				} else {
					app.radarimagesurl = "https://api.buienradar.nl/image/1.0/radarmap" + app.countryCode + "?w=400&h=400";
				}
				if (app.buienradarActualRadarScreen) {
					app.buienradarActualRadarScreen.setTitle("Actuele Buienradar");
					app.buienradarActualRadarScreen.show();
				}
			}
		}
	}
}
