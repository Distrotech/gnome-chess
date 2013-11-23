class GnomeChess
{
    static bool show_version;
    public static const OptionEntry[] options =
    {
        { "version", 'v', 0, OptionArg.NONE, ref show_version,
          /* Help string for command line --version flag */
          N_("Show release version"), null},
        { null }
    };

    public static int main (string[] args)
    {
        Intl.setlocale (LocaleCategory.ALL, "");
        Intl.bindtextdomain (Config.GETTEXT_PACKAGE, Config.LOCALEDIR);
        Intl.bind_textdomain_codeset (Config.GETTEXT_PACKAGE, "UTF-8");
        Intl.textdomain (Config.GETTEXT_PACKAGE);

        /* This can probably be removed if the desktop file is renamed to gnome-chess.desktop */
        Environment.set_prgname ("glchess");

        Gtk.init (ref args);

        var c = new OptionContext (/* Arguments and description for --help text */
                                   _("[FILE] - Play Chess"));
        c.add_main_entries (options, Config.GETTEXT_PACKAGE);
        c.add_group (Gtk.get_option_group (true));
        try
        {
            c.parse (ref args);
        }
        catch (Error e)
        {
            stderr.printf ("%s\n", e.message);
            stderr.printf (/* Text printed out when an unknown command-line argument provided */
                           _("Run '%s --help' to see a full list of available command line options."), args[0]);
            stderr.printf ("\n");
            return Posix.EXIT_FAILURE;
        }
        if (show_version)
        {
            /* Note, not translated so can be easily parsed */
            stderr.printf ("gnome-chess %s\n", Config.VERSION);
            return Posix.EXIT_SUCCESS;
        }

        File? game_file = null;
        if (args.length > 1)
            game_file = File.new_for_path (args[1]);

        var app = new Application (game_file);
        return app.run ();
    }
}
