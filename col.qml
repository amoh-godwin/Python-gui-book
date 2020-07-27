import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

ApplicationWindow {
    visible: true
    width: 400
    height: 400

    ColumnLayout {
        width: 400
        height: 400

        Rectangle {
                    Layout.fillWidth: false
                    Layout.fillHeight: true
                    color: "darkgrey"
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    color: "dodgerblue"
                }

    }

}
