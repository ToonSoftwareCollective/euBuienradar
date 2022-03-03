import QtQuick 2.1
import qb.components 1.0
import BasicUIControls 1.0;
import "buienradar.js" as BuienradarJS

Tile {
	id: root
	property string displayScale: BuienradarJS.formatScale(app.regenMaxValue, app.yaxisScale)

	onClicked: {
		app.radarimagesurl ="http://toon/";  //resetimage
		if (isNxt) {
			app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMapNL?w=600&h=600";
		} else {
			app.radarimagesurl = "https://api.buienradar.nl/image/1.0/RadarMapNL?w=400&h=400";
		}

		if (app.buienradarActualRadarScreen) {
			app.buienradarActualRadarScreen.setTitle("Actuele Buienradar");
			app.buienradarActualRadarScreen.show();
		}
	}

	Text {
		id: buienradarRegenTileTitleText
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 38 : 30
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 20 : 16
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: "Regenverwachting"
		visible: app.showRain
	}

	Text {
		id: buienradarRegenTileTitleText2
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 110 : 90
			horizontalCenter: parent.horizontalCenter
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 20 : 16
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: (app.countryCode == "EU") ? "Tile only available for NL and BE" : "Geen neerslag verwacht"
		visible: !app.showRain
	}

	Item {
		id: brgraphItem

		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 50 : 41
			horizontalCenter: parent.horizontalCenter
		}
		height: isNxt ? 90 : 72
		width: isNxt ? 200 : 160

		AreaGraphControl {
			id: areaGraph

			width: parent.width
			height: parent.height
			color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.graphTileRect
			yScale: app.yaxisScale ? (height / app.yaxisScale) : (height / app.regenMaxValue)
			showNaN: false
			values: app.regenVerwachting
		}
		visible: app.showRain
		
	}

	Text {
		id: buienradarYaxis
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 55 : 45
			left: parent.left
			leftMargin: isNxt ? 5 : 4
		}
		font {
			family: qfont.bold.name
			pixelSize: isNxt ? 30 : 24
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: app.yaxisScale ? app.yaxisScale : app.regenMaxValue
		visible: app.showRain
	}

	Text {
		id: buienradarYaxismm
		anchors {
			baseline: parent.top
			baselineOffset: isNxt ? 75 : 60
			left: parent.left
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 20 : 16
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: "mm"
		visible: app.showRain
	}


	Rectangle {
		id: lineYaxis
		color: colors.graphTileRect
		height: isNxt ? 90 : 72
		width: 1
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 52 : 42
			left: brgraphItem.left
		}
		visible: app.showRain
	}

	Rectangle {
		id: lineYaxisTopMarker1
		color: colors.graphTileRect
		height: 1
		width: 6
		anchors {
			bottom: parent.bottom
			bottomMargin: isNxt ? 143 : 113
			left: lineYaxis.left
		}
		visible: app.showRain
	}

	Text {
		id: leftTimeText
		anchors {
			horizontalCenter: brgraphItem.left
			baseline: brgraphItem.bottom
			baselineOffset: isNxt ? 31 : 25
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: app.regenVerwachtingVanaf
		visible: app.showRain
	}

	Text {
		id: midTimeText
		anchors {
			horizontalCenter: brgraphItem.horizontalCenter
			baseline: brgraphItem.bottom
			baselineOffset: isNxt ? 31 : 25
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: app.regenVerwachtingMidden
		visible: app.showRain
	}
	Text {
		id: rightTimeText
		anchors {
			horizontalCenter: brgraphItem.right
			baseline: brgraphItem.bottom
			baselineOffset: isNxt ? 31 : 25
		}
		font {
			family: qfont.regular.name
			pixelSize: isNxt ? 25 : 20
		}
		color: (typeof dimmableColors !== 'undefined') ? dimmableColors.tileTextColor : colors.tileTextColor
		text: app.regenVerwachtingTot
		visible: app.showRain
	}

	/// horizontal Repeater representing 10 minutes markers

	Row {
		id: xLegendRow
		anchors.top: brgraphItem.bottom
		anchors.left: brgraphItem.left
		width: brgraphItem.width

		Repeater {
			id: xLegendRepeater
			model: 13
			Item {
				height: isNxt ? 10 : 8
				width: brgraphItem.width / 12

				Rectangle {
					id: linexaxisMarker
					color: colors.graphTileRect
					height: (index === 6) || (index === 0) || (index ===12) ? 6 : 3
					width: 1

					anchors {
						baseline: parent.top
						left: parent.left
					}
					visible: app.showRain
				}
			}
		}
	}
}
