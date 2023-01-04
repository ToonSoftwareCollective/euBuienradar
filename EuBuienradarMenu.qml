import QtQuick 2.1

import qb.components 1.0
import qb.base 1.0

MenuItem {
	property EuBuienradarApp app;
	label: "EU Buienradar"
	image: "qrc:/tsc/buienradar.png"
	weight: 200

	onClicked: {
		if (app) {
			if (app.buienradarDetailsScreen) app.buienradarDetailsScreen.show();
		}
	}
}