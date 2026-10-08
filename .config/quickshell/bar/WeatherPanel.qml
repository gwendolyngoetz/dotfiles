pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import qs

// Replacement for the existing WeatherPanel. The weather module and its
// entries binding stay unchanged. SlidePanel still owns the window, background,
// outer border, anchoring, animation and hover-close behavior.
SlidePanel {
    id: root

    property var entries: []
    property real uiScale: Math.max(1, Config.fontPixelSize / 14)
    property int panelWidth: Math.round(336 * uiScale)
    property int panelPadding: Math.round(16 * uiScale)

    readonly property color textColor: Colors.foreground
    readonly property color mutedColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.7)
    readonly property color lineColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.16)
    readonly property color cardColor: Qt.rgba(textColor.r, textColor.g, textColor.b, 0.025)
    readonly property color meterColor: Colors.foregroundAlt

    // Resolve by label rather than index so separator rows can move freely.
    function entry(label) {
        return (entries ?? []).find(e => e && e.label === label) ?? {};
    }

    readonly property var cityEntry: entry("City")
    readonly property var dateEntry: entry("Date")
    readonly property var weatherEntry: entry("Weather")
    readonly property var tempEntry: entry("Temp")
    readonly property var highEntry: entry("High")
    readonly property var lowEntry: entry("Low")
    readonly property var humidityEntry: entry("Humidity")
    readonly property var sunriseEntry: entry("Sunrise")
    readonly property var sunsetEntry: entry("Sunset")
    readonly property bool hasWeather: (tempEntry.value ?? "") !== ""
    readonly property real humidityFraction: {
        const value = parseFloat(humidityEntry.value ?? "");
        return Number.isFinite(value) ? Math.max(0, Math.min(1, value / 100)) : 0;
    }

    minWidth: panelWidth

    component WeatherText: Text {
        color: root.textColor
        font.family: Config.fontFamily
        font.pixelSize: Config.fontPixelSize
        textFormat: Text.PlainText
        elide: Text.ElideRight
        verticalAlignment: Text.AlignVCenter
    }

    component WeatherGlyph: Icon {
        color: root.textColor
        iconStyle: "solid"
        font.pixelSize: Math.round(18 * root.uiScale)
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    component Divider: Rectangle {
        Layout.fillWidth: true
        implicitHeight: 1
        color: root.lineColor
    }

    component TemperatureCard: Rectangle {
        id: card
        required property var detail
        Layout.fillWidth: true
        Layout.preferredWidth: 1
        implicitHeight: cardContent.implicitHeight + 28 * root.uiScale
        radius: 10 * root.uiScale
        color: root.cardColor
        border.width: 1
        border.color: root.lineColor

        ColumnLayout {
            id: cardContent
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 14 * root.uiScale
            spacing: 8 * root.uiScale

            RowLayout {
                Layout.fillWidth: true
                spacing: 8 * root.uiScale
                WeatherGlyph {
                    text: card.detail.icon ?? "\uf2c9"
                    iconStyle: card.detail.iconStyle ?? "solid"
                    Layout.preferredWidth: 20 * root.uiScale
                }
                WeatherText {
                    Layout.fillWidth: true
                    text: card.detail.label ?? ""
                    font.weight: Font.Medium
                }
            }

            WeatherText {
                Layout.fillWidth: true
                text: card.detail.value ?? "–"
                color: card.detail.valueColor ?? root.textColor
                font.pixelSize: Math.round(34 * root.uiScale)
                font.weight: Font.DemiBold
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    component SolarRow: RowLayout {
        id: solar
        required property var detail
        Layout.fillWidth: true
        spacing: 12 * root.uiScale

        WeatherGlyph {
            text: solar.detail.icon ?? ""
            iconStyle: solar.detail.iconStyle ?? "solid"
            Layout.preferredWidth: 24 * root.uiScale
            color: root.mutedColor
        }
        WeatherText {
            Layout.fillWidth: true
            text: solar.detail.label ?? ""
            color: root.mutedColor
        }
        WeatherText {
            text: solar.detail.value ?? "–"
            font.weight: Font.DemiBold
        }
    }

    // Like the old ColumnLayout, expose implicit dimensions to SlidePanel's
    // content sizing. Do not set window height here: SlidePanel animates it.
    Item {
        anchors.fill: parent
        implicitWidth: root.panelWidth
        implicitHeight: (root.hasWeather ? content.implicitHeight : emptyState.implicitHeight)
            + 2 * root.panelPadding

        WeatherText {
            id: emptyState
            visible: !root.hasWeather
            anchors.centerIn: parent
            text: "No weather data"
            color: root.mutedColor
        }

        ColumnLayout {
            id: content
            visible: root.hasWeather
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: root.panelPadding
            spacing: 14 * root.uiScale

            RowLayout {
                Layout.fillWidth: true
                spacing: 8 * root.uiScale

                WeatherGlyph {
                    text: "\uf3c5" // map-marker-alt, Font Awesome 5
                    font.pixelSize: Math.round(21 * root.uiScale)
                    Layout.preferredWidth: 22 * root.uiScale
                }
                WeatherText {
                    Layout.fillWidth: true
                    text: root.cityEntry.value ?? "Weather"
                    font.pixelSize: Math.round(22 * root.uiScale)
                    font.weight: Font.DemiBold
                }
                WeatherGlyph {
                    text: root.dateEntry.icon ?? "\uf073"
                    color: root.mutedColor
                    font.pixelSize: Math.round(14 * root.uiScale)
                }
                WeatherText {
                    text: root.dateEntry.value ?? "–"
                    color: root.mutedColor
                }
            }

            Divider {}

            RowLayout {
                Layout.fillWidth: true
                Layout.topMargin: 4 * root.uiScale
                Layout.bottomMargin: 4 * root.uiScale
                spacing: 16 * root.uiScale

                WeatherGlyph {
                    Layout.preferredWidth: 100 * root.uiScale
                    Layout.preferredHeight: 92 * root.uiScale
                    text: root.weatherEntry.icon ?? "\uf0c2"
                    iconStyle: root.weatherEntry.iconStyle ?? "solid"
                    font.pixelSize: Math.round(70 * root.uiScale)
                }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0
                    WeatherText {
                        Layout.fillWidth: true
                        text: root.tempEntry.value ?? "–"
                        font.pixelSize: Math.round(50 * root.uiScale)
                        minimumPixelSize: Math.round(30 * root.uiScale)
                        fontSizeMode: Text.HorizontalFit
                        font.weight: Font.DemiBold
                    }
                    WeatherText {
                        Layout.fillWidth: true
                        text: root.weatherEntry.value ?? "–"
                        font.pixelSize: Math.round(19 * root.uiScale)
                        color: root.mutedColor
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10 * root.uiScale
                TemperatureCard { detail: root.highEntry }
                TemperatureCard { detail: root.lowEntry }
            }

            Divider {}

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: humidityContent.implicitHeight + 28 * root.uiScale
                radius: 10 * root.uiScale
                color: root.cardColor
                border.width: 1
                border.color: root.lineColor

                RowLayout {
                    id: humidityContent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 14 * root.uiScale
                    spacing: 12 * root.uiScale

                    WeatherGlyph {
                        text: root.humidityEntry.icon ?? "\uf043"
                        Layout.preferredWidth: 28 * root.uiScale
                        font.pixelSize: Math.round(28 * root.uiScale)
                    }
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10 * root.uiScale
                        RowLayout {
                            Layout.fillWidth: true
                            WeatherText {
                                Layout.fillWidth: true
                                text: "Humidity"
                                font.weight: Font.Medium
                            }
                            WeatherText {
                                text: root.humidityEntry.value ?? "–"
                                font.weight: Font.DemiBold
                            }
                        }
                        Rectangle {
                            id: humidityTrack
                            Layout.fillWidth: true
                            implicitHeight: 7 * root.uiScale
                            radius: height / 2
                            color: root.lineColor
                            Rectangle {
                                width: humidityTrack.width * root.humidityFraction
                                height: humidityTrack.height
                                radius: height / 2
                                color: root.meterColor
                            }
                        }
                    }
                }
            }

            Divider {}

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: solarContent.implicitHeight + 28 * root.uiScale
                radius: 10 * root.uiScale
                color: root.cardColor
                border.width: 1
                border.color: root.lineColor

                ColumnLayout {
                    id: solarContent
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.margins: 14 * root.uiScale
                    spacing: 13 * root.uiScale
                    SolarRow { detail: root.sunriseEntry }
                    Divider {}
                    SolarRow { detail: root.sunsetEntry }
                }
            }
        }
    }
}
