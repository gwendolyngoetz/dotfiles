import QtQuick
import qs

// A Font Awesome 5 glyph; pick the style per icon.
Text {
    property string iconStyle: "regular"   // regular | solid | brands

    font.family: iconStyle === "brands" ? Config.brandsFontFamily : Config.iconFontFamily
    font.styleName: iconStyle === "solid" ? "Solid" : "Regular"
    font.pixelSize: iconStyle === "brands" ? Config.brandsPixelSize : Config.iconPixelSize
    color: Colors.foregroundAlt
    verticalAlignment: Text.AlignVCenter
}
