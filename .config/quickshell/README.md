# quickshell

Quickshell (0.3.1) bars, app launcher and notification daemon for sway. `launch.sh` restarts it (`qs kill`, then
`qs --daemonize`); `qs log` reads the daemon's log.

## Layout

| file | role |
| --- | --- |
| `shell.qml` | one `Bar` per screen, a `TrayBar` on the primary screen (`MONITOR`, else the output `swaymsg` reports focused at startup, else the first screen), the `Launcher`, the `Notifications` daemon |
| `Config.qml` | geometry, fonts, spacing |
| `Colors.qml` | palette; the base16 Dracula scheme as constants, with the bar and launcher colors derived from it |
| `bar/Bar.qml` | top bar: workspaces and spotify left, date and time centered, system modules right |
| `bar/TrayBar.qml` | bottom bar holding the system tray |
| `bar/Module.qml` | one bar module: margins and padding (in spaces of the bar font), prefix icon, background, underline, click / scroll signals; hidden when `active` is false |
| `bar/OtpPanel.qml` | slide-down panel over the password store: generates, shows and copies OTP codes |
| `bar/ShutdownPanel.qml` | slide-down panel with the session actions: logout, sleep, reboot, shutdown |
| `bar/WeatherPanel.qml` | slide-down info panel: read-only icon / label / value detail rows |
| `bar/SpotifyPanel.qml` | slide-down player panel: album art, track info, progress bar, prev / play-pause / next |
| `bar/modules/*.qml` | the modules |
| `launcher/` | the app launcher |
| `notifications/Notifications.qml` | the notification daemon: `NotificationServer` and the open stack |
| `notifications/NotificationConfig.qml` | the dunst look: geometry, frame, font, format, icon size, progress bar, urgency colors and timeouts, per-app rules |
| `notifications/NotificationCard.qml` | one notification: frame / separator, icon, formatted text, progress bar, timeout, clicks |

## Modules

- **Workspaces** – `Quickshell.I3` (which speaks sway's i3-compatible IPC), this output's
  workspaces sorted by number, click to focus. The binding-mode label comes from
  `swaymsg -t subscribe`, resubscribed when sway restarts.
- **Spotify** – `Quickshell.Services.Mpris`; `title - artist` cut to 30 characters. Left click
  slides `SpotifyPanel` down from the bar: album art spanning
  the panel height (the spotify glyph until it loads),
  title / artist / album, elapsed / total around a read-only progress bar, and
  prev / play-pause / next buttons, disabled when the player refuses the action. Right click jumps to workspace 10.
- **DateModule / TimeModule** – `SystemClock` ticking on the minute boundary.
- **Cpu / Memory / Temperature** – `FileView` on `/proc/stat`, `/proc/meminfo` and the hwmon
  file, reloaded every 2s without forking. Temperature reads `TEMPERATURE_PATH`; when unset it
  scans `/sys/class/hwmon/*/temp*_label` once for `Tdie` / `Package id` (falling back to `Tctl`)
  and hides when nothing is found.
- **Filesystem / Eth** – shell out to `df` and `ip` on their intervals. Eth uses `ETHERNET_INT`,
  else the first `e*` interface that is up.
- **Weather** – fetches the OpenWeatherMap one-call response with `curl` every 15 min, straight
  into memory; a failed fetch keeps the last response, and the last good one is cached in
  `$XDG_CACHE_HOME/quickshell-weather.json` so a restart starts from it (needs
  `OPENWEATHERMAP_*` in the environment, otherwise the module hides). The label shows the
  condition icon and temp; left click slides `WeatherPanel` down from the bar: city, conditions,
  temp / high / low over the next 12h, humidity, date, sunrise, sunset.
- **AirQuality** – PM2.5 AQI with the category initial ("42-G") from the AirNow API with `curl`
  every 15 min (needs `AIRNOW_API_*` in the environment, otherwise the module hides).
- **Volume** – `Quickshell.Services.Pipewire` default sink. Icon only; click toggles mute, scroll
  changes volume by 5%, right click opens `pavucontrol -t 4`.
- **Otp** – left click slides `OtpPanel` down from the bar: the `*.gpg` entries of
  `PASSWORD_STORE_DIR` (else `~/.password-store`) via `find`, grouped into tabs by pass's
  folder layout (`work/github` is `github` on the `work` tab; top-level entries go on the
  `other` tab). Picking one runs
  `pass otp <name>`, pipes the code into `wl-copy` and shows it beside the entry with a bar draining
  over the 30s TOTP period; the code is regenerated when the period rolls over. 45s after a copy
  the clipboard is cleared if it still holds the code. Right click copies the default account
  (`tools/github`) without opening the panel and reports through `notify-send`. Needs `pass-otp` and
  `wl-clipboard`.
- **ShutdownMenu** – left click slides `ShutdownPanel` down from the bar: logout (`swaymsg exit`) /
  sleep / reboot / poweroff; picking one runs its command.
- **Tray** – `Quickshell.Services.SystemTray` at 16px with 2px padding; left click activates,
  right click opens the item menu, middle click is secondary activate. Menu-only items open
  their menu on left click too. Native tray menus require `//@ pragma UseQApplication` in
  `shell.qml`; adding or changing this startup pragma requires a full restart with `launch.sh`,
  not just a QML reload.

## Launcher

`qs ipc call launcher toggle` shows/hides it (`show` and `hide` also exist). It is a normal
window titled `launcher`, which sway floats and strips the border from via a `for_window` rule
matching `app_id="quickshell"` (native Wayland windows have no `class`; check the actual value
with `swaymsg -t get_tree` if the rule does not match).
Every whitespace-separated token of the query must match the name, generic name, exec, comment,
categories or keywords of an entry; entries are sorted by name. Enter / Escape / Up / Down /
Tab / Ctrl-n / Ctrl-p / PgUp / PgDn navigate; it also closes when it loses focus.

## Notifications

A dunst replacement that keeps dunst's look; `NotificationConfig.qml` carries the values from the
old `dunstrc` under their dunst names, including the `[urgency_*]` sections and the per-app rules
(`Solaar` hidden, `Chromium` styled as Teams with its own icon and format, `CiviForm Staging
Deploy` by urgency, `Slack` purple). Only one process can own `org.freedesktop.Notifications`,
so dunst must not be started alongside it (sway's `start-dunst.sh`).

- **Placement** – a layer-shell overlay on `DP-1` (first screen when absent), top-right at offset
  `10x50` from the screen corner, ignoring the bar's exclusive zone like dunst does. Constant
  width 300, one notification at most 300 high, frame 3 with a 2px separator in the frame color
  between notifications, critical ones on top.
- **Content** – `Monospace 11`, format `%a
<b>%s</b>
%b` rendered as StyledText; icon from a
  rule's `new_icon`, else the notification image, else the icon theme, scaled down to 64 (48 for
  Teams) and never up; the `value` hint draws dunst's progress bar (10 high, 1px frame, 150–300
  wide, highlight `#7f7fff`). Qt elides wrapped text at the end, not in the middle.
- **Behaviour** – low / normal time out after 10s, critical never, a client's own timeout wins.
  Left click dismisses, middle click fires the `default` action (or the only one) and dismisses,
  right click dismisses all. No history, duplicate stacking or age display.

## Conventions

- Detected values (`ETHERNET_INT`, `TEMPERATURE_PATH`, `MONITOR`) live in the file that uses them:
  the environment variable wins, otherwise a one-shot `Process` detects it, otherwise the
  module hides / falls back.

- Files with delegates set `pragma ComponentBehavior: Bound` and give `modelData` its real type
  (`ShellScreen`, `I3Workspace`, `SystemTrayItem`, `DesktopEntry`).
- JS-array models go through `ScriptModel`, so delegates are diffed rather than rebuilt.
- Icons are Font Awesome 5 Free / Brands glyphs written as `\uXXXX` escapes; a prefix ends with
  a space to separate it from the text.
- Components size themselves with `implicitWidth` / `implicitHeight`; parents may override.

## Things to check on first run

- Quickshell logs: `qs log` (or run `qs` in a terminal).
- Fonts: `Config.fontFamily` is `Noto Sans`; icons need Font Awesome 5 Free and Brands.
- Weather needs `OPENWEATHERMAP_*` and AirQuality `AIRNOW_API_*` in the environment (both
  come from `~/.private-env` via `.profile`).
- Otp needs `pass-otp` and `wl-clipboard`; its `notify-send` calls land in the notification daemon here.
- Notifications: stop dunst first (`start-dunst.sh` in the sway config), or the server cannot
  claim the D-Bus name; `qs log` shows the failure.
