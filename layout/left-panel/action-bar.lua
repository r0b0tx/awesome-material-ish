local awful = require('awful')
local beautiful = require('beautiful')
local wibox = require('wibox')
local gears = require('gears')
local dpi = beautiful.xresources.apply_dpi
local icons = require('theme.icons')
local tag_list = require('widget.tag-list')
local clickable_container = require('widget.clickable-container')
local apps = require('configuration.apps')

return function(s, panel, action_bar_width)

	local menu_icon = wibox.widget {
		{
			id = 'menu_btn',
			image = icons.main_menu,
			resize = true,
			widget = wibox.widget.imagebox
		},
		margins = dpi(10),
		widget = wibox.container.margin
	}

	local open_dashboard_button = wibox.widget {
		{
			menu_icon,
			widget = clickable_container
		},
		bg = '#3f51b5',
		widget = wibox.container.background
	}

	open_dashboard_button:buttons(
		gears.table.join(
			awful.button(
				{},
				1,
				nil,
				function()
					panel:toggle()
				end
			)
		)
	)


	panel:connect_signal(
		'opened',
		function()
			menu_icon.menu_btn:set_image(gears.surface(icons.close_small))
		end
	)

	panel:connect_signal(
		'closed',
		function()
			menu_icon.menu_btn:set_image(gears.surface(icons.main_menu))
		end
	)

	return wibox.widget {
		id = 'action_bar',
		layout = wibox.layout.align.vertical,
		forced_width = action_bar_width,
		{
			open_dashboard_button,
			tag_list(s),
			require("widget.xdg-folders")(),
			require('widget.global-search')(),
	    require('widget.info-center-toggle')(),
			layout = wibox.layout.fixed.vertical,
		},
		nil,
		{
		layout = wibox.layout.fixed.vertical,
		wibox.container.margin(systray, dpi(10), dpi(10)),
		require('widget.package-updater')(s),
		require('widget.bluetooth')(s),
		require('widget.network')(s),
		require('widget.battery')(s),
		require('widget.layoutbox')(s)
		}
	}
end
