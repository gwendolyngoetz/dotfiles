# quickshell

Quickshell (0.3.1) bars and app launcher for i3. `launch.sh` restarts it (`qs kill`, then
`qs --daemonize`); `qs log` reads the daemon's log.

## Layout

| file | role |
| --- | --- |
| `shell.qml` | one `Bar` per screen, a `TrayBar` on the primary screen, the `Launcher` |
| `Config.qml` | geometry, fonts, spacing; reads `xrdb -query` once |
| `Colors.qml` | palette; bar colors come from xrdb `color*` where set, launcher colors are fixed |
| `Env.qml` | `ETHERNET_INT`, `WIFI_INT`, `TEMPERATURE_PATH`, `MONITOR` from the environment, detected when unset |
| `bar/Bar.qml` | top bar: workspaces and spotify left, date and time centered, system modules right |
| `bar/TrayBar.qml` | bottom bar holding the system tray |
| `bar/Module.qml` | one bar module: margins and padding (in spaces of the bar font), prefix icon, background, underline, click / scroll signals; hidden when `active` is false |
| `bar/ScriptModule.qml` | runs a shell command on an interval and shows its output; hidden when empty |
| `bar/Menu.qml` | popup menu / info panel anchored to a module |
| `bar/modules/*.qml` | the modules |
| `launcher/` | the app launcher |
| `scripts/` | shell scripts used by modules |

## Modules

- **Workspaces** – `Quickshell.I3`, this output's workspaces sorted by number, click to focus. The
  binding-mode label comes from `i3-msg -t subscribe`, resubscribed when i3 restarts.
- **Spotify** – `Quickshell.Services.Mpris`; `title - artist` cut to 30 characters, click jumps to
  workspace 10.
- **DateModule / TimeModule** – `SystemClock` ticking on the minute boundary.
- **Cpu / Memory / Temperature** – `FileView` on `/proc/stat`, `/proc/meminfo` and the hwmon
  file, reloaded every 2s without forking. Temperature reads `TEMPERATURE_PATH` (k10temp
  `temp1_input`, found by `Env.qml` when unset) and hides when the sensor is missing.
- **Filesystem / Eth** – shell out to `df` and `ip` on their intervals.
- **Weather** – `scripts/weather.sh` fetches the OpenWeatherMap one-call response into
  `scripts/.weather.json` every 15 min (written through a temp file so a failed fetch keeps the
  last response; needs `OPENWEATHERMAP_*` from `~/.private-env`). The label, condition icon and
  the left-click popup — city, conditions, temp / high / low over the next 12h, humidity, date,
  sunrise, sunset — are built from that file.
- **AirQuality** – `scripts/air-quality.sh` every 15 min (needs `AIRNOW_API_*`).
- **Volume** – `Quickshell.Services.Pipewire` default sink. Icon only; click toggles mute, scroll
  changes volume by 5%, right click opens `pavucontrol -t 4`.
- **Otp** – lists `~/.password-store` in a popup and runs `scripts/otp-copy.sh <name>`; right
  click copies the default account (`work`).
- **ShutdownMenu** – logout / sleep / reboot / poweroff.
- **Tray** – `Quickshell.Services.SystemTray` at 16px with 2px padding; left click activates,
  right click opens the item menu, middle click is secondary activate.

## Launcher

`qs ipc call launcher toggle` shows/hides it (`show` and `hide` also exist). It is a normal
window titled `launcher`, which i3 floats and strips the border from via a `for_window` rule.
Every whitespace-separated token of the query must match the name, generic name, exec, comment,
categories or keywords of an entry; entries are sorted by name. Enter / Escape / Up / Down /
Tab / Ctrl-n / Ctrl-p / PgUp / PgDn navigate; it also closes when it loses focus.

## Conventions

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
- The weather and air-quality scripts need `~/.private-env` and `AIRNOW_API_*` in the
  environment.
