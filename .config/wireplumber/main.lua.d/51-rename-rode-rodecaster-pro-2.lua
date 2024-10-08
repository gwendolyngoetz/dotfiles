-- Renames the outputs and inputs of the RODE RODECaster Pro II.
--
-- Place this file inside ~/.config/wireplumber/main.lua.d/
--
-- Tips on using the RODE RODECaster Pro II on Linux:
--   - Use PipeWire together with WirePlumber. I'm using the following packages on
--     Arch Linux: pipewire pipewire-alsa pipewire-pulse pipewire-jack wireplumber.
--     Optional packages: qpwgraph
--   - Configure the RODE RODECaster Pro II to use the 'Pro Audio' profile
--   - Your node names might differ. Run `pactl list sinks` and `pactl list sources` to check assigned names.

-- Outputs (Sinks)
rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
	  { "node.name", "equals", "alsa_output.usb-R__DE_RODECaster_Pro_II_GV0047597-00.pro-output-1" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Main)",
  },
})

rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
	  { "node.name", "equals", "alsa_output.usb-R__DE_RODECaster_Pro_II_GV0047597-00.pro-output-0" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Chat)",
  },
})

rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
      { "node.name", "equals", "alsa_output.usb-R__DE_R__DECaster_Pro_II_GV0047597-00.pro-output-0" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Secondary)",
  },
})

-- Inputs (Sources)
rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
	  { "node.name", "equals", "alsa_input.usb-R__DE_RODECaster_Pro_II_GV0047597-00.pro-input-1" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Main)",
  },
})

rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
	  { "node.name", "equals", "alsa_input.usb-R__DE_RODECaster_Pro_II_GV0047597-00.pro-input-0" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Chat)",
  },
})

rule = table.insert(alsa_monitor.rules, {
  matches = {
    {
	  { "node.name", "equals", "alsa_input.usb-R__DE_R__DECaster_Pro_II_GV0047597-00.pro-input-0" },
    },
  },
  apply_properties = {
    ["node.description"] = "RODECaster Pro II (Secondary)",
  },
})
