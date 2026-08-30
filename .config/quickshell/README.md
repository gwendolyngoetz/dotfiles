# quickshell

Quickshell (0.3.1) port of the polybar bars and the rofi drun launcher. The polybar and rofi
configs are untouched; to swap back, flip the three marked lines in `~/.config/i3/config`.

## Layout

| polybar / rofi | quickshell |
| --- | --- |
| `bars.ini` `[bar/base]`, `config.ini` `[variables]` | `Config.qml` (also reads `xrdb -query` for `color*`, `polybar.height`) |
| `config.ini` `[colors]`, rofi `*` colors | `Colors.qml` |
| `launch.sh` env exports (`ETHERNET_INT`, `TEMPERATURE_PATH`, primary output) | `Env.qml` |
| `[bar/main]` | `bar/Bar.qml`, one per screen |
| `[bar/secondary]` (bottom tray bar) | `bar/TrayBar.qml`, primary screen only |
| `[module/*]` | `bar/modules/*.qml` |
| `rofi/config.rasi` | `launcher/Launcher.qml`, `launcher/LauncherView.qml` |
| `polybar/scripts/*.sh` still used | `scripts/` (copies with paths rewritten) |

`bar/Module.qml` reproduces polybar's format model: `module-margin-left/right`, `format-padding`
(both in spaces of font-0), `format-prefix`, `format-background`, `format-underline`, and the
click / scroll actions. `bar/ScriptModule.qml` is `custom/script`, including hiding on empty
output; polybar `%{...}` tags are not interpreted, modules draw their own icons via `prefix`.

## Module notes

- **i3** – `Quickshell.I3`. pin-workspaces, index-sort, strip-wsnumbers, click to focus. The
  binding-mode label comes from `i3-msg -t subscribe`.
- **spotify** – `Quickshell.Services.Mpris` instead of polling `dbus-send` once a second. Same
  `title - artist` cut to 30 characters, same underline and click to workspace 10.
- **date / time** – `SystemClock` with the same formats as `date.sh` / `time.sh`; it ticks on
  the minute boundary instead of polling.
- **cpu / memory / temperature** – `FileView` on `/proc/stat`, `/proc/meminfo` and the hwmon
  file, reloaded every 2s without forking. `%percentage:2%` on cpu is left-padded like polybar.
- **filesystem / eth** – still shell out to `df` and `ip` on the same intervals.
- **weather** – `scripts/weather.sh` is now only the `curl` into `scripts/.weather.json`
  (written via a temp file so a failed fetch keeps the last response); the bar label, condition
  icon and popup are all built in `Weather.qml` from that file. Left click opens a native popup
  (`bar/Menu.qml` with `interactive: false`) — city, conditions, temp / high / low over the next
  12h, humidity, date, sunrise and sunset. The Python widget, its venv and the customtkinter
  popup are gone.
- **airquality** – still shells out to `scripts/air-quality.sh` via `ScriptModule`.
- **pulseaudio** – `Quickshell.Services.Pipewire` default sink. Icon only, muted icon, scroll
  changes volume by 5%, right click opens `pavucontrol -t 4`.
- **otp / shutdown-menu** – native popup menus (`bar/Menu.qml`) instead of xmenu. The otp
  menu lists `~/.password-store` and runs `scripts/otp-copy.sh <name>`; right click copies the
  default account (`work`). The shutdown menu offers logout / sleep / reboot / poweroff.
- **tray** – `Quickshell.Services.SystemTray` at 16px with 2px padding; left click activates,
  right click opens the item menu, middle click is secondary activate.

## Launcher

`qs ipc call launcher toggle` shows/hides it (`show` and `hide` also exist). It is a normal
window titled `launcher`, which i3 floats and strips the border from via the `for_window` rule.
Matching follows rofi's default "normal" mode (every token must match name, generic name, exec,
comment, categories or keywords). Entries are sorted by name; rofi orders by launch history
first, which is the one intentional difference. Enter/Escape/Up/Down/Tab/Ctrl-n/Ctrl-p/PgUp/PgDn
work as in rofi; it also closes when it loses focus.

## Conventions

- Files with delegates set `pragma ComponentBehavior: Bound` and give `modelData` its real type
  (`ShellScreen`, `I3Workspace`, `SystemTrayItem`, `DesktopEntry`).
- JS-array models go through `ScriptModel`, so delegates are diffed rather than rebuilt.
- Components size themselves with `implicitWidth` / `implicitHeight`; parents may override.
- `launch.sh` uses `qs kill` / `qs --daemonize`; `qs log` reads the daemon's log.

## Things to check on first run

- Quickshell logs: `qs log` (or run `qs` in a terminal).
- Font: `Config.fontFamily` is `Noto Sans`; icons are Font Awesome 5 Free / Brands.
- Transparency: `Colors.rofiBg` keeps rofi's `CC` alpha. Without a compositor it renders black,
  so drop the alpha in that case.
- The weather and air-quality scripts need the same environment as before (`~/.private-env`,
  `AIRNOW_API_*`).
