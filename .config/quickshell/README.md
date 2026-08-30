# quickshell

Quickshell (0.3.1) bars and app launcher for i3. `launch.sh` restarts it (`qs kill`, then
`qs --daemonize`); `qs log` reads the daemon's log.

## Layout

| file | role |
| --- | --- |
| `shell.qml` | one `Bar` per screen, a `TrayBar` on the primary screen (`MONITOR`, else `xrandr` / `swaymsg`, else the first screen), the `Launcher` |
| `Config.qml` | geometry, fonts, spacing |
| `Colors.qml` | palette; the base16 Dracula scheme as constants, with the bar and launcher colors derived from it |
| `bar/Bar.qml` | top bar: workspaces and spotify left, date and time centered, system modules right |
| `bar/TrayBar.qml` | bottom bar holding the system tray |
| `bar/Module.qml` | one bar module: margins and padding (in spaces of the bar font), prefix icon, background, underline, click / scroll signals; hidden when `active` is false |
| `bar/OtpPanel.qml` | slide-down panel over the password store: generates, shows and copies OTP codes |
| `bar/ShutdownPanel.qml` | slide-down panel with the session actions: logout, sleep, reboot, shutdown |
| `bar/WeatherPanel.qml` | slide-down info panel: read-only icon / label / value detail rows |
| `bar/modules/*.qml` | the modules |
| `launcher/` | the app launcher |

## Modules

- **Workspaces** – `Quickshell.I3`, this output's workspaces sorted by number, click to focus. The
  binding-mode label comes from `i3-msg -t subscribe`, resubscribed when i3 restarts.
- **Spotify** – `Quickshell.Services.Mpris`; `title - artist` cut to 30 characters, click jumps to
  workspace 10.
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
  `pass otp <name>`, pipes the code into `xclip` and shows it beside the entry with a bar draining
  over the 30s TOTP period; the code is regenerated when the period rolls over. 45s after a copy
  the clipboard is cleared if it still holds the code. Right click copies the default account
  (`work`) without opening the panel and reports through `notify-send`. Needs `pass-otp` and
  `xclip`.
- **ShutdownMenu** – left click slides `ShutdownPanel` down from the bar: logout / sleep / reboot /
  poweroff; picking one runs its command.
- **Tray** – `Quickshell.Services.SystemTray` at 16px with 2px padding; left click activates,
  right click opens the item menu, middle click is secondary activate.

## Launcher

`qs ipc call launcher toggle` shows/hides it (`show` and `hide` also exist). It is a normal
window titled `launcher`, which i3 floats and strips the border from via a `for_window` rule.
Every whitespace-separated token of the query must match the name, generic name, exec, comment,
categories or keywords of an entry; entries are sorted by name. Enter / Escape / Up / Down /
Tab / Ctrl-n / Ctrl-p / PgUp / PgDn navigate; it also closes when it loses focus.

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
- Transparency: `Colors.launcherBg` has alpha. Without a compositor it renders black, so drop
  the `CC` prefix in that case.
- Weather needs `OPENWEATHERMAP_*` and AirQuality `AIRNOW_API_*` in the environment (both
  come from `~/.private-env` via `.profile`).
- Otp needs `pass-otp`, `xclip` and a `notify-send` provider.
