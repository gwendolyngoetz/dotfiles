pragma Singleton
import QtQuick
import Quickshell

// Converts polybar formatting tags in script output (%{F#555}...%{F-}) into Qt rich text so
// scripts like weatherwidget.py render the same as they did under polybar.
Singleton {
    function escapeHtml(s) {
        return s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
    }

    // polybar accepts #RGB, #ARGB, #RRGGBB, #AARRGGBB; Qt rich text wants #RRGGBB
    function normalizeColor(c) {
        if (c.length === 4) return "#" + c[1] + c[1] + c[2] + c[2] + c[3] + c[3];
        if (c.length === 5) return "#" + c[2] + c[2] + c[3] + c[3] + c[4] + c[4];
        if (c.length === 9) return "#" + c.slice(3);
        return c;
    }

    function hasTags(s) {
        return s.indexOf("%{") >= 0;
    }

    function toRichText(s) {
        let out = "";
        let openFg = 0;
        let openBg = 0;
        let i = 0;

        while (i < s.length) {
            const start = s.indexOf("%{", i);
            if (start < 0) {
                out += escapeHtml(s.slice(i));
                break;
            }

            out += escapeHtml(s.slice(i, start));
            const end = s.indexOf("}", start);
            if (end < 0) {
                out += escapeHtml(s.slice(start));
                break;
            }

            const tag = s.slice(start + 2, end).trim();
            const kind = tag[0];
            const arg = tag.slice(1);

            if (kind === "F") {
                if (arg === "-") { if (openFg > 0) { out += "</font>"; openFg--; } }
                else { out += `<font color="${normalizeColor(arg)}">`; openFg++; }
            } else if (kind === "B") {
                if (arg === "-") { if (openBg > 0) { out += "</span>"; openBg--; } }
                else { out += `<span style="background-color:${normalizeColor(arg)}">`; openBg++; }
            }
            // %{T..}, %{u..}, %{A..}, %{O..}, %{R} and friends are dropped

            i = end + 1;
        }

        while (openFg-- > 0) out += "</font>";
        while (openBg-- > 0) out += "</span>";

        return out;
    }
}
