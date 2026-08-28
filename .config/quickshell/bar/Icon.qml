import QtQuick
import qs

// A Font Awesome 5 glyph. polybar listed Regular (font-2) before Solid (font-3), so glyphs that
// exist in both styles rendered Regular; pick the style per icon to match.
Text {
    property string iconStyle: "regular"   // regular | solid | brands

    font.family: iconStyle === "brands" ? Config.brandsFontFamily : Config.iconFontFamily
    font.styleName: iconStyle === "solid" ? "Solid" : "Regular"
    font.pixelSize: iconStyle === "brands" ? Config.brandsPixelSize : Config.iconPixelSize
    color: Colors.foregroundAlt
    verticalAlignment: Text.AlignVCenter
}
