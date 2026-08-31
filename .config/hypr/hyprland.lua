-- Hyprland 0.56.2 Lua config, ported from ~/.config/i3/config.
-- Section order and comments mirror the i3 file; i3-isms that have no
-- Wayland/Hyprland equivalent are noted inline.

local home = os.getenv("HOME")
local mod = "SUPER" -- i3: set $mod Mod4

-- i3 used X11 output names (DisplayPort-0/1). Hyprland uses DRM names;
-- check `hyprctl monitors` and adjust if these don't match.
local mon_primary = "DP-1"   -- was DisplayPort-0
local mon_secondary = "DP-2" -- was DisplayPort-1

------------------------------------------------------------
-- Colors
------------------------------------------------------------

-- i3 pulled these from ~/.Xresources via set_from_resource; the values
-- below are copied from there (Dracula-based theme). Keep in sync by
-- hand if the theme changes.
local magenta = "#5a4799" -- color13 = base0E; i3 $magenta (focused child-border)
local border = "#282936"  -- color0 = base00; i3 $border (unfocused border)
local black = "#000000"   -- solid black desktop background (i3: feh + black.jpg)

------------------------------------------------------------
-- Monitors
------------------------------------------------------------

hl.monitor({
    output = "Virtual-1",
    mode = "1920x1080@60",
    position = "0x0",
    scale = 1,
})
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

------------------------------------------------------------
-- General options
------------------------------------------------------------

hl.config({
  general = {
    layout = "dwindle",

    -- i3: for_window [class="^.*"] border pixel 3
    border_size = 3,

    -- i3-gaps: inner 8, outer 0, left -8, right -8, bottom -6.
    -- In i3 the edge gap is inner+outer, so the effective edge gaps were
    -- top 8, left 0, right 0, bottom 2; Hyprland's gaps_out sets the edge
    -- gap directly.
    gaps_in = 8,
    gaps_out = { top = 8, left = 0, right = 0, bottom = 2 },

    -- i3: client.focused child-border $magenta, client.unfocused $border
    col = {
      active_border = magenta,
      inactive_border = border,
    },
  },

  -- i3: $mod+v split toggle (togglesplit needs preserve_split)
  dwindle = {
    preserve_split = true,
  },

  input = {
    -- i3: focus_follows_mouse no
    follow_mouse = 0,
  },

  misc = {
    -- i3: font pango:monospace 8
    font_family = "monospace",

    -- solid black background, no wallpaper daemon needed
    disable_hyprland_logo = true,
    force_default_wallpaper = 0,
    background_color = black,
  },
})

------------------------------------------------------------
-- Keybinds
------------------------------------------------------------

-- Use Mouse+$mod to drag floating windows (i3: floating_modifier $mod;
-- left button moves, right button resizes)
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- start a terminal
hl.bind(mod .. " + Return", hl.dsp.exec_cmd("alacritty"))

-- kill focused window
hl.bind(mod .. " + SHIFT + Q", hl.dsp.window.close())
-- i3: "bindsym button2 kill" acted on the titlebar; Hyprland has no
-- titlebars, and a bare middle-click bind would swallow clicks in apps,
-- so it is intentionally not ported.

-- start the launcher
-- quickshell launcher; swap back to rofi by uncommenting the next line and removing the qs one
--hl.bind(mod .. " + D", hl.dsp.exec_cmd("rofi -modi drun -show drun -sidebar-mode -show-icons"))
hl.bind(mod .. " + D", hl.dsp.exec_cmd("qs ipc call launcher toggle"))

-- play/pause spotify (scripts are WM-agnostic, reused from the i3 dir)
-- hl.bind(mod .. " + slash", hl.dsp.exec_cmd(home .. "/.config/i3/scripts/playpause.sh"))
-- hl.bind(mod .. " + comma", hl.dsp.exec_cmd(home .. "/.config/i3/scripts/prev.sh"))
-- hl.bind(mod .. " + period", hl.dsp.exec_cmd(home .. "/.config/i3/scripts/next.sh"))

-- change focus
hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

-- move focused window
hl.bind(mod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- split orientation
hl.bind(mod .. " + V", hl.dsp.layout("togglesplit"))

-- enter fullscreen mode for the focused container
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- toggle tiling / floating
hl.bind(mod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

-- change focus between tiling / floating windows
hl.bind(mod .. " + space", function()
  local w = hl.get_active_window()
  if w ~= nil and w.floating then
    hl.dispatch(hl.dsp.window.cycle_next({ tiled = true }))
  else
    hl.dispatch(hl.dsp.window.cycle_next({ floating = true }))
  end
end)

-- i3: $mod+a focus parent; Hyprland's dwindle tree has no
-- parent-container focus, so this bind has no equivalent.

-- switch to workspace / move focused window to workspace
-- (i3: $ws1 "1:1" .. $ws10 "10:"; the label rendering is the bar's job,
-- ws10's name is set by a workspace rule below)
for i = 1, 10 do
  local key = tostring(i % 10)
  local ws = tostring(i)

  hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
  hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

-- reload the configuration file
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))

-- i3: $mod+Shift+r restart-in-place; Hyprland cannot restart in place,
-- a reload is the closest equivalent
hl.bind(mod .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

-- exit (i3 used i3-nagbar with Log Out / Shutdown / Reboot;
-- hyprshutdown from hyprland-guiutils provides the same dialog)
hl.bind(mod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprshutdown"))

-- resize (i3 used "10 px or 10 ppt")
hl.bind(mod .. " + Y", hl.dsp.window.resize({ x = -10, y = 0, relative = true }))
hl.bind(mod .. " + U", hl.dsp.window.resize({ x = 0, y = 10, relative = true }))
hl.bind(mod .. " + I", hl.dsp.window.resize({ x = 0, y = -10, relative = true }))
hl.bind(mod .. " + O", hl.dsp.window.resize({ x = 10, y = 0, relative = true }))

-- apps
hl.bind(mod .. " + minus", hl.dsp.exec_cmd("alacritty"))
hl.bind(mod .. " + backslash", hl.dsp.exec_cmd("firefox"))
-- flameshot is X11-specific (unreliable on wlroots); use hyprshot or
-- grim+slurp instead
--hl.bind(mod .. " + S", hl.dsp.exec_cmd("flameshot gui"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd("thunar"))
hl.bind(mod .. " + C", hl.dsp.exec_cmd("calendarwidget"))

-- navigate workspaces next / previous
--hl.bind(mod .. " + CTRL + K", hl.dsp.focus({ workspace = "e+1" }))
--hl.bind(mod .. " + CTRL + J", hl.dsp.focus({ workspace = "e-1" }))

-- lock screen
-- add bind here (e.g. hl.dsp.exec_cmd("hyprlock"))

------------------------------------------------------------
-- Workspace rules
------------------------------------------------------------

-- i3: smart_gaps on, smart_borders on, hide_edge_borders smart:
-- drop gaps and border when a workspace has a single tiled window,
-- or a fullscreen one
hl.workspace_rule({ workspace = "w[tv1]", gaps_in = 0, gaps_out = 0, no_border = true })
hl.workspace_rule({ workspace = "f[1]", gaps_in = 0, gaps_out = 0, no_border = true })

-- i3: workspace $ws10 output DisplayPort-1; name "10:"
hl.workspace_rule({ workspace = "10", monitor = mon_secondary, default_name = "" })

-- i3: scripts/load-workspaces.sh put workspace 1 on DisplayPort-0 and
-- workspace 6 on DisplayPort-1 via i3-companion (its saved JSON layouts
-- have no Hyprland equivalent)
hl.workspace_rule({ workspace = "1", monitor = mon_primary, default = true })
hl.workspace_rule({ workspace = "6", monitor = mon_secondary, default = true })

------------------------------------------------------------
-- Window rules
------------------------------------------------------------

-- i3 floated dialogs per-app via window_type="dialog" / window_role;
-- Hyprland can't match X11 roles, but matching modal windows covers the
-- dialog cases (Code, firefox, Gimp, Inkscape, jetbrains-idea, nextcloud,
-- obs, soffice, VirtualBox, thunderbird, dolphin "Copying", ...)
hl.window_rule({ match = { modal = true }, float = true })

-- open specific applications in floating mode
-- (i3 "sticky enable" -> pin; pinning only applies to floating windows)
hl.window_rule({ match = { class = "Conky" }, float = true })
hl.window_rule({ match = { class = "etcher" }, float = true, pin = true })
hl.window_rule({ match = { class = "Galculator" }, float = true, pin = true })
hl.window_rule({ match = { class = "kcalc" }, float = true, pin = true })
hl.window_rule({ match = { class = "Lxappearance" }, float = true, pin = true })
hl.window_rule({ match = { class = "Pavucontrol" }, float = true, pin = true })
hl.window_rule({ match = { class = "Qtconfig-qt4" }, float = true, pin = true })
hl.window_rule({ match = { class = "qt5ct" }, float = true, pin = true })
hl.window_rule({ match = { class = "qt6ct" }, float = true, pin = true })
hl.window_rule({ match = { class = "Solaar" }, float = true, pin = true })
hl.window_rule({ match = { title = "Steam Settings" }, float = true, pin = true })
hl.window_rule({ match = { class = "Streamdeck UI" }, float = true })
hl.window_rule({ match = { class = "weather-widget" }, float = true })
hl.window_rule({ match = { class = "(?i)origin.exe" }, float = true })
hl.window_rule({ match = { class = "(?i)xencelabs" }, float = true })
hl.window_rule({ match = { class = "calendarwidget" }, float = true, pin = true, border_size = 0 })
hl.window_rule({ match = { class = "calculatorwidget" }, float = true, pin = true, border_size = 0 })

-- quickshell launcher (rofi replacement) is a plain window; float it
-- without decoration
hl.window_rule({
  match = { class = "(?i)quickshell", title = "^launcher$" },
  float = true,
  pin = true,
  border_size = 0,
})

-- default workspace assignments
hl.window_rule({ match = { class = "Spotify" }, workspace = "10 silent" })

------------------------------------------------------------
-- Autostart
------------------------------------------------------------

hl.on("hyprland.start", function()
  -- quickshell bar; swap back to polybar by uncommenting the next line
  -- and removing the quickshell one
  --hl.exec_cmd(home .. "/.config/polybar/launch.sh")
  hl.exec_cmd(home .. "/.config/quickshell/launch.sh")

  -- i3: xset s off / xset dpms 0 0 3600 are X11-only; use hypridle with
  -- a 3600s dpms-off listener for the same behavior
  -- hl.exec_cmd("hypridle")

  -- i3 used feh + wallpaper/black.jpg; misc.background_color covers a
  -- solid color natively, so no wallpaper tool is needed

  -- hl.exec_cmd(home .. "/.config/i3/scripts/start-dunst.sh")
  -- streamdeck-ui's key emulation (pynput) is X11-only
  --hl.exec_cmd(home .. "/src/github/system-repos/streamdeck-ui/start.sh")
  hl.exec_cmd("solaar --window hide")
  hl.exec_cmd("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
  hl.exec_cmd("nextcloud --background")
end)
