-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")

-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end


-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.gap_single_client = true
beautiful.useless_gap = 5

terminal = "alacritty"
editor = os.getenv("EDITOR") or "nano"
editor_cmd = terminal .. " -e " .. editor

rofi_launch = "rofi -show Menu -modi Menu:~/.dotfiles/scripts/rofi.py"
rofi_power = "rofi -show Power -lines 3 -modi Power:~/.dotfiles/scripts/rofi-power.sh"
rofi_notes = "rofi -show Notes -lines 10 -modi Notes:~/.dotfiles/scripts/rofi-notes.sh"
screenshot = "take-screenshot"

modkey = "Mod4"

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max.fullscreen,
}

local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
screen.connect_signal("property::geometry", set_wallpaper)

gears.wallpaper.set("#24283b")

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
end)

-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))

-- Key bindings
globalkeys = gears.table.join(
    -- Awesome
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),

    -- Tag
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    -- Client
    awful.key({ modkey,           }, "j", function () awful.client.focus.byidx( 1) end,
              {description = "focus next by index", group = "client"}),
    awful.key({ modkey,           }, "k", function () awful.client.focus.byidx(-1) end,
              {description = "focus previous by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

    -- Launcher
    awful.key({ modkey,           }, "space", function () awful.spawn(rofi_launch) end,
              {description = "launcher", group = "launcher"}),
    awful.key({ modkey, "Shift"   }, "q", function () awful.spawn(rofi_power) end,
              {description = "power", group = "launcher"}),
    awful.key({ modkey            }, "n", function () awful.spawn(rofi_notes) end,
              {description = "notes", group = "launcher"}),

    -- Screenshot
    awful.key({ modkey, "Shift"   }, "s", function () awful.spawn(screenshot) end,
              {description = "take a screenshot", group = "screen"}),

    -- Terminal
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "terminal"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn("wm-spawn-terminal-in-cwd") end,
              {description = "open a terminal with previous CWD", group = "terminal"}),

    -- Awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- Layout
    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Media
    awful.key({ }, "XF86AudioMute",        function () os.execute("pactl set-sink-mute @DEFAULT_SINK@ toggle") end),
    awful.key({ }, "XF86AudioRaiseVolume", function () os.execute("pactl set-sink-volume @DEFAULT_SINK@ +5%") end),
    awful.key({ }, "XF86AudioLowerVolume", function () os.execute("pactl set-sink-volume @DEFAULT_SINK@ -5%") end),
    awful.key({ }, "XF86AudioPlay",        function () os.execute("playerctl play-pause") end),
    awful.key({ }, "XF86AudioPrev",        function () os.execute("playerctl previous") end),
    awful.key({ }, "XF86AudioNext",        function () os.execute("playerctl next") end),
    awful.key({ }, "XF86AudioStop",        function () os.execute("playerctl stop") end),

    -- Display
    awful.key({ }, "XF86MonBrightnessUp",  function () os.execute("brightnessctl set 5+") end),
    awful.key({ }, "XF86MonBrightnessDown",function () os.execute("brightnessctl set 5-") end)
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "w",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

root.keys(globalkeys)

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "pinentry",
        },
        class = { },
        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
        },
        role = {
          -- "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    { rule = { name = "AlacrittyPopup" },
      properties = { floating = true, placement = awful.placement.centered } },

    { rule = { class = "Enpass" },
      except = { name = "Enpass Assistant" },
      properties = { tag = "8" } },
    { rule = { name = "Enpass Assistant" },
      properties = { floating = true, placement = awful.placement.centered } },

    { rule = { instance = "microsoft teams - preview" },
      except = { name = "Microsoft Teams Notification" },
      properties = { tag = "5" } },
    { rule = { name = "Microsoft Teams Notification" },
      properties = { floating = true, placement = awful.placement.bottom_right } },

    { rule = { instance = "slack" },
      properties = { tag = "5" } },

    { rule = { class = "Conky" },
      properties = { border_width = 0 } },

    {
       rule_any = {role = {"GtkFileChooserDialog"}},
       properties = {
         floating = true,
         placement = awful.placement.centered,
         width = awful.screen.focused().geometry.width * 0.55,
         height = awful.screen.focused().geometry.height * 0.65,
         x = (awful.screen.focused().geometry.width / 2) - (awful.screen.focused().geometry.width * 0.55) / 2,
         y = (awful.screen.focused().geometry.height/ 2) - (awful.screen.focused().geometry.height * 0.65) / 2,
       }
    }
}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

awful.spawn.with_shell("~/.config/awesome/autostart.sh")
awful.spawn.once("enpass")

client.connect_signal("property::urgent", function(c)
  if c.class == "Google-chrome" then
    awful.client.urgent.jumpto(false)
  end
end)
