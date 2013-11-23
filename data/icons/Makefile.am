icon16dir=$(datadir)/icons/hicolor/16x16/apps
icon22dir=$(datadir)/icons/hicolor/22x22/apps
icon24dir=$(datadir)/icons/hicolor/24x24/apps
icon32dir=$(datadir)/icons/hicolor/32x32/apps
icon48dir=$(datadir)/icons/hicolor/48x48/apps
icon256dir=$(datadir)/icons/hicolor/256x256/apps
iconscalabledir=$(datadir)/icons/hicolor/scalable/apps
iconscalablestatusdir=$(pkgdatadir)/icons/hicolor/scalable/status

icon16_DATA = 16x16/gnome-chess.png
icon22_DATA = 22x22/gnome-chess.png
icon24_DATA = 24x24/gnome-chess.png
icon32_DATA = 32x32/gnome-chess.png
icon48_DATA = 48x48/gnome-chess.png
icon256_DATA = 256x256/gnome-chess.png
iconscalable_DATA = scalable/gnome-chess.svg
iconscalablestatus_DATA = \
	scalable/user-available.svg \
	scalable/user-away.svg \
	scalable/user-busy.svg \
	scalable/user-idle.svg \
	scalable/user-offline.svg \
	scalable/goa.svg \
	scalable/user.svg

gtk_update_icon_cache = gtk-update-icon-cache -f -t $(pkgdatadir)/icons/hicolor

install-data-hook: update-icon-cache
uninstall-hook: update-icon-cache

update-icon-cache:
	@-if test -z "$(DESTDIR)"; then \
			echo "Updating Gtk icon cache."; \
			$(gtk_update_icon_cache); \
	else \
			echo "*** Icon cache not updated.  After (un)install, run this:"; \
			echo "***   $(gtk_update_icon_cache)"; \
	fi

EXTRA_DIST = $(icon16_DATA) $(icon22_DATA) $(icon24_DATA) $(icon32_DATA) $(icon48_DATA) $(icon256_DATA) $(iconscalable_DATA) $(iconscalablestatus_DATA)

-include $(top_srcdir)/git.mk
