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
output and rendering `%{F#...}` / `%{B#...}` tags from script output.

## Module notes

- **i3** – `Quickshell.I3`. pin-workspaces, index-sort, strip-wsnumbers, click to focus. The
  binding-mode label comes from `i3-msg -t subscribe`.
- **spotify** – `Quickshell.Services.Mpris` instead of polling `dbus-send` once a second. Same
  `title - artist` cut to 30 characters, same underline and click to workspace 10.
- **date / time** – computed in QML with the same formats as `date.sh` / `time.sh`.
- **cpu / memory / filesystem / temperature / eth** – read from `/proc`, `df`, hwmon and `ip`
  on the same intervals. `%percentage:2%` on cpu is left-padded like polybar.
- **weather / airquality** – still shell out to the scripts (`scripts/weather.sh` uses the venv
  under `~/.config/polybar/scripts/weather/.venv` unless one exists under `scripts/weather/`).
- **pulseaudio** – `Quickshell.Services.Pipewire` default sink. Icon only, muted icon, scroll
  changes volume by 5%, right click opens `pavucontrol -t 4`.
- **otp / shutdown-menu** – static icons with the same xmenu click handlers.
- **tray** – `Quickshell.Services.SystemTray` at 16px with 2px padding; left click activates,
  right click opens the item menu, middle click is secondary activate.

## Launcher

`qs ipc call launcher toggle` shows/hides it (`show` and `hide` also exist). It is a normal
window titled `launcher`, which i3 floats and strips the border from via the `for_window` rule.
Matching follows rofi's default "normal" mode (every token must match name, generic name, exec,
comment, categories or keywords). Entries are sorted by name; rofi orders by launch history
first, which is the one intentional difference. Enter/Escape/Up/Down/Tab/Ctrl-n/Ctrl-p/PgUp/PgDn
work as in rofi; it also closes when it loses focus.

## Things to check on first run

- Quickshell logs: `qs log` (or run `qs` in a terminal).
- Font: `Config.fontFamily` defaults to `fixed` to match `font-0`. If Qt 6 refuses the bitmap
  face, change it to `monospace`.
- Transparency: `Colors.rofiBg` keeps rofi's `CC` alpha. Without a compositor it renders black,
  so drop the alpha in that case.
- The weather and air-quality scripts need the same environment as before (`~/.private-env`,
  `AIRNOW_API_*`).
