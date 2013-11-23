/*
 * Copyright (C) 2010-2013 Robert Ancell
 *
 * This program is free software: you can redistribute it and/or modify it under
 * the terms of the GNU General Public License as published by the Free Software
 * Foundation, either version 2 of the License, or (at your option) any later
 * version. See http://www.gnu.org/copyleft/gpl.html the full text of the
 * license.
 */

/* Workaround for https://bugzilla.gnome.org/show_bug.cgi?id=647122 */
extern void gtk_file_filter_set_name (Gtk.FileFilter filter, string name);

public class Application : Gtk.Application
{
<<<<<<< HEAD
    protected Settings settings;
    protected Settings settings_common;
    private Gtk.Builder builder;
    protected Gtk.Builder preferences_builder;
    protected ChessLauncher? launcher = null;
    private Gtk.Window? window = null;

    /* Chess game screen widgets */
    protected Gtk.Widget game_vbox;
    protected Gtk.InfoBar info_bar;
    protected Gtk.Label info_title_label;
    protected Gtk.Label info_label;
    protected Gtk.Container view_container;
    protected ChessScene scene;
    protected ChessView view;
    protected Gtk.Widget save_button;
    protected Gtk.Widget undo_button;
    protected Gtk.Widget pause_button;
    protected Gtk.Widget claim_draw_button;
    protected Gtk.Widget resign_button;
    protected Gtk.Widget fullscreen_button;
    protected Gtk.Widget first_move_button;
    protected Gtk.Widget prev_move_button;
    protected Gtk.Widget next_move_button;
    protected Gtk.Widget last_move_button;
    protected Gtk.ComboBox history_combo;
    protected Gtk.Widget white_time_label;
    protected Gtk.Widget black_time_label;

    protected Gtk.Dialog? preferences_dialog = null;

    private uint save_duration_timeout = 0;

    private Gtk.FileChooserDialog? open_dialog = null;
    private Gtk.InfoBar? open_dialog_info_bar = null;
    private Gtk.Label? open_dialog_error_label = null;
    private Gtk.FileChooserDialog? save_dialog = null;
    private Gtk.InfoBar? save_dialog_info_bar = null;
    private Gtk.Label? save_dialog_error_label = null;
    private Gtk.AboutDialog? about_dialog = null;

    private PGNGame pgn_game;
    private ChessGame game;
    private bool in_history;
    private string autosave_filename;
    private File game_file;
    private bool game_needs_saving;
    private string engines_file;
    private string? saved_filename = null;
    private List<AIProfile> ai_profiles;
    private ChessPlayer? opponent = null;
    private ChessPlayer? human_player = null;
    private ChessEngine? opponent_engine = null;
    private bool is_fullscreen = false;
    private bool widget_sensitivity[8];

    private enum SensitivityIndex
    {
        UNDO,
        CLAIM_DRAW,
        RESIGN,
        FIRST_MOVE,
        PREV_MOVE,
        NEXT_MOVE,
        LAST_MOVE,
        HISTORY
    }

    private const ActionEntry[] app_entries =
    {
        { "preferences", preferences_cb },
        { "help", help_cb },
        { "about", about_cb },
        { "quit", quit_cb },
    };

    public Application (File? game_file)
    {
        Object (application_id: "org.gnome.gnome-chess", flags: ApplicationFlags.FLAGS_NONE);
        this.game_file = game_file;
    }

<<<<<<< HEAD
=======
    public bool on_window_focus_out (Gdk.EventFocus focus)
    {
        if (((Gtk.ToolButton) pause_button).stock_id == "gtk-media-pause" )
            game.pause ();

        return false;
    }

    public bool on_window_focus_in (Gdk.EventFocus focus)
    {
        if (((Gtk.ToolButton) pause_button).stock_id == "gtk-media-pause" )
            game.unpause ();

        return false;
    }

>>>>>>> gnome-chess-application-rename
    public override void startup ()
    {
        base.startup ();

<<<<<<< HEAD
        if (this is HandlerApplication)
            return;

        settings = new Settings ("org.gnome.gnome-chess");
        settings_common = new Settings ("org.gnome.gnome-chess.games-common");
=======
        settings = new Settings ("org.gnome.gnome-chess");
>>>>>>> gnome-chess-application-rename

        var data_dir = File.new_for_path (Path.build_filename (Environment.get_user_data_dir (), "gnome-chess", null));
        DirUtils.create_with_parents (data_dir.get_path (), 0755);

<<<<<<< HEAD
        history = new History (data_dir);

        builder = new Gtk.Builder ();
        try
        {
            builder.add_from_file (Path.build_filename (Config.PKGDATADIR, "gnome-chess-game-window.ui", null));
        }
        catch (Error e)
        {
            warning ("Could not load UI: %s", e.message);
        }

        settings.changed.connect (settings_changed_cb);

        string engines_file = Path.build_filename (Config.PKGDATADIR, "engines.conf", null);
        ai_profiles = load_ai_profiles (engines_file);

        foreach (var profile in ai_profiles)
            message ("Detected AI profile %s in %s", profile.name, profile.path);

        chess_networking_init ();

        if (game_file == null)
        {
            launcher = create_launcher (engines_file, ai_profiles, history);
            add_window (launcher);

            var unfinished = history.get_unfinished ();
            if (unfinished != null)
                launcher.show_game_selector ();
            else
                launcher.show_opponent_selector ();

            /* Show top-level */
            launcher.show ();
        }
        else
        {
            try
            {
                load_game (game_file, false);
            }
            catch (Error e)
            {
                stderr.printf ("Failed to load %s: %s\n", game_file.get_path (), e.message);
                quit ();
            }
        }

        settings_common.changed.connect (settings_changed_cb);
    }

    public void chess_networking_init ()
    {
      TelepathyGLib.SimpleClientFactory factory;
      TelepathyGLib.AccountManager am;

      if (Config.ENABLE_NETWORKING)
      {
        /* Prepare account-manager from TpAutomaticClientFactory if networking
         * is enabled. Set it as default so that folks uses it.  */

         factory = new TelepathyGLib.AutomaticClientFactory (null);

         /* Features are prepared by folks so we don't need to prepare them */
         am = new TelepathyGLib.AccountManager.with_factory (factory);
         am.set_default ();
      }
    }

    private ChessLauncher create_launcher (string engines_file,
        List<AIProfile>? ai_profiles,
        History history)
    {
        var launcher = new ChessLauncher (engines_file, ai_profiles, history);
        launcher.application = this;

        launcher.start_game.connect (start_new_game);
        launcher.load_game.connect (this.load_game_handler);
        launcher.destroy.connect (launcher_destroy_cb);

        return launcher;
    }

    private void create_game_window ()
    {
        window = (Gtk.Window) builder.get_object ("window_game_screen");

        game_vbox = (Gtk.Widget) builder.get_object ("game_vbox");
        save_menu = (Gtk.Widget) builder.get_object ("menu_save_item");
        save_as_menu = (Gtk.Widget) builder.get_object ("menu_save_as_item");
        fullscreen_menu = (Gtk.MenuItem) builder.get_object ("fullscreen_item");
        undo_menu = (Gtk.Widget) builder.get_object ("undo_move_item");
        undo_button = (Gtk.Widget) builder.get_object ("undo_move_button");
        resign_menu = (Gtk.Widget) builder.get_object ("resign_item");
        resign_button = (Gtk.Widget) builder.get_object ("resign_button");
=======
        add_action_entries (app_entries, this);

        builder = new Gtk.Builder ();

        try
        {
            builder.add_from_file (Path.build_filename (PKGDATADIR, "menu.ui", null));
        }
        catch (Error e)
        {
            error ("Error loading menu UI: %s", e.message);
        }

        var menu = builder.get_object ("appmenu") as MenuModel;
        set_app_menu (menu);

        try
        {
            builder.add_from_file (Path.build_filename (PKGDATADIR, "gnome-chess.ui", null));
        }
        catch (Error e)
        {
            warning ("Could not load UI: %s", e.message);
        }
        window = (Gtk.Window) builder.get_object ("gnome_chess_app");
        save_button = (Gtk.Widget) builder.get_object ("save_game_button");
        undo_button = (Gtk.Widget) builder.get_object ("undo_move_button");
        pause_button = (Gtk.Widget) builder.get_object ("pause_game_button");
        claim_draw_button = (Gtk.Widget) builder.get_object ("claim_draw_button");
        resign_button = (Gtk.Widget) builder.get_object ("resign_button");
        fullscreen_button = (Gtk.Widget) builder.get_object ("fullscreen_button");
>>>>>>> gnome-chess-application-rename
        first_move_button = (Gtk.Widget) builder.get_object ("first_move_button");
        prev_move_button = (Gtk.Widget) builder.get_object ("prev_move_button");
        next_move_button = (Gtk.Widget) builder.get_object ("next_move_button");
        last_move_button = (Gtk.Widget) builder.get_object ("last_move_button");
<<<<<<< HEAD

        history_combo = (Gtk.ComboBox) builder.get_object ("history_combo");
        /* Assign a model here instead of loading from ui */
        var history_model = new Gtk.ListStore (2, typeof (string), typeof (int));
        history_combo.set_model (history_model);

        white_time_label = (Gtk.Widget) builder.get_object ("white_time_label");
        black_time_label = (Gtk.Widget) builder.get_object ("black_time_label");
        settings_common.bind ("show-toolbar", builder.get_object ("toolbar"), "visible", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-history", builder.get_object ("navigation_box"), "visible", SettingsBindFlags.DEFAULT);
        var view_box = (Gtk.VBox) builder.get_object ("view_box");
        view_container = (Gtk.Container) builder.get_object ("view_container");

        builder.connect_signals (this);

=======
        history_combo = (Gtk.ComboBox) builder.get_object ("history_combo");
        white_time_label = (Gtk.Widget) builder.get_object ("white_time_label");
        black_time_label = (Gtk.Widget) builder.get_object ("black_time_label");
        var view_box = (Gtk.VBox) builder.get_object ("view_box");
        view_container = (Gtk.Container) builder.get_object ("view_container");
        builder.connect_signals (this);

        add_window (window);
        window.focus_out_event.connect (on_window_focus_out);
        window.focus_in_event.connect (on_window_focus_in);

>>>>>>> gnome-chess-application-rename
        info_bar = new Gtk.InfoBar ();
        var content_area = (Gtk.Container) info_bar.get_content_area ();
        view_box.pack_start (info_bar, false, true, 0);
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 6);
        vbox.show ();
        content_area.add (vbox);
        info_title_label = new Gtk.Label ("");
        info_title_label.show ();
        vbox.pack_start (info_title_label, false, true, 0);
        vbox.hexpand = true;
        vbox.vexpand = false;
        info_label = new Gtk.Label ("");
        info_label.show ();
        vbox.pack_start (info_label, true, true, 0);

        scene = new ChessScene ();
        scene.is_human.connect ((p) => { return p == human_player; } );
<<<<<<< HEAD
        scene.choose_promotion_type.connect (show_promotion_type_selector);
        settings_common.bind ("show-move-hints", scene, "show-move-hints", SettingsBindFlags.GET);
        settings_common.bind ("show-numbering", scene, "show-numbering", SettingsBindFlags.GET);
        settings_common.bind ("piece-theme", scene, "theme-name", SettingsBindFlags.GET);
        settings_common.bind ("show-3d-smooth", scene, "show-3d-smooth", SettingsBindFlags.GET);
        settings_common.bind ("move-format", scene, "move-format", SettingsBindFlags.GET);
        settings_common.bind ("board-side", scene, "board-side", SettingsBindFlags.GET);

        settings_changed_cb (settings_common, "show-3d");
=======
        scene.changed.connect (scene_changed_cb);
        scene.choose_promotion_type.connect (show_promotion_type_selector);
        settings.bind ("show-move-hints", scene, "show-move-hints", SettingsBindFlags.GET);
        settings.bind ("show-numbering", scene, "show-numbering", SettingsBindFlags.GET);
        settings.bind ("piece-theme", scene, "theme-name", SettingsBindFlags.GET);
        settings.bind ("show-3d-smooth", scene, "show-3d-smooth", SettingsBindFlags.GET);
        settings.bind ("move-format", scene, "move-format", SettingsBindFlags.GET);
        settings.bind ("board-side", scene, "board-side", SettingsBindFlags.GET);

        settings.changed.connect (settings_changed_cb);
        settings_changed_cb (settings, "show-3d");

        ai_profiles = AIProfile.load_ai_profiles (Path.build_filename (SYSCONFDIR, "chess-engines.conf", null));
        foreach (var profile in ai_profiles)
            message ("Detected AI profile %s in %s", profile.name, profile.path);

        autosave_filename = data_dir.get_path () + "/autosave.pgn";

        /* Load from history if no game requested */
        if (game_file == null)
        {
            if (FileUtils.test (autosave_filename, FileTest.EXISTS))
                game_file = File.new_for_path (autosave_filename);

            if (game_file != null)
                in_history = true;
            else
                start_new_game ();
        }
        else
            in_history = false;

        if (game_file != null)
        {
            try
            {
                load_game (game_file);
            }
            catch (Error e)
            {
                stderr.printf ("Failed to load %s: %s\n", game_file.get_path (), e.message);
                quit ();
            }
        }

        window.set_default_size (settings.get_int ("width"), settings.get_int ("height"));        

        if (settings.get_boolean ("fullscreen"))
        {
            window.fullscreen ();
            is_fullscreen = true;
        }
        else if (settings.get_boolean ("maximized"))
        {
            window.maximize ();
        }

        show ();
>>>>>>> gnome-chess-application-rename
    }

    protected override void shutdown ()
    {
        base.shutdown ();
        if (opponent_engine != null)
            opponent_engine.stop ();
    }

<<<<<<< HEAD
    protected PieceType show_promotion_type_selector ()
=======
    public PieceType show_promotion_type_selector ()
>>>>>>> gnome-chess-application-rename
    {
        Gtk.Builder promotion_type_selector_builder;

        promotion_type_selector_builder = new Gtk.Builder ();
        try
        {
<<<<<<< HEAD
            promotion_type_selector_builder.add_from_file (Path.build_filename (Config.PKGDATADIR, "promotion-type-selector.ui", null));
=======
            promotion_type_selector_builder.add_from_file (Path.build_filename (PKGDATADIR, "promotion-type-selector.ui", null));
>>>>>>> gnome-chess-application-rename
        }
        catch (Error e)
        {
            warning ("Could not load promotion type selector UI: %s", e.message);
        }

        Gtk.Dialog promotion_type_selector_dialog = promotion_type_selector_builder.get_object ("dialog_promotion_type_selector") as Gtk.Dialog;

        string color;
        if (game.current_player.color == Color.WHITE)
            color = "white";
        else
            color = "black";

<<<<<<< HEAD
        var filename = Path.build_filename (Config.PKGDATADIR, "pieces", scene.theme_name, "%sQueen.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_queen") as Gtk.Image, filename);

        filename = Path.build_filename (Config.PKGDATADIR, "pieces", scene.theme_name, "%sKnight.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_knight") as Gtk.Image, filename);

        filename = Path.build_filename (Config.PKGDATADIR, "pieces", scene.theme_name, "%sRook.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_rook") as Gtk.Image, filename);

        filename = Path.build_filename (Config.PKGDATADIR, "pieces", scene.theme_name, "%sBishop.svg".printf (color));
=======
        var filename = Path.build_filename (PKGDATADIR, "pieces", scene.theme_name, "%sQueen.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_queen") as Gtk.Image, filename);

        filename = Path.build_filename (PKGDATADIR, "pieces", scene.theme_name, "%sKnight.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_knight") as Gtk.Image, filename);

        filename = Path.build_filename (PKGDATADIR, "pieces", scene.theme_name, "%sRook.svg".printf (color));
        set_piece_image (promotion_type_selector_builder.get_object ("image_rook") as Gtk.Image, filename);

        filename = Path.build_filename (PKGDATADIR, "pieces", scene.theme_name, "%sBishop.svg".printf (color));
>>>>>>> gnome-chess-application-rename
        set_piece_image (promotion_type_selector_builder.get_object ("image_bishop") as Gtk.Image, filename);

        promotion_type_selector_builder.connect_signals (this);

        PieceType selection;
        int choice = promotion_type_selector_dialog.run ();
        switch (choice)
        {
            case PromotionTypeSelected.QUEEN:
                selection = PieceType.QUEEN;
                break;
            case PromotionTypeSelected.KNIGHT:
                selection = PieceType.KNIGHT;
                break;
            case PromotionTypeSelected.ROOK:
                selection = PieceType.ROOK;
                break;
            case PromotionTypeSelected.BISHOP:
                selection = PieceType.BISHOP;
                break;
            default:
                selection = PieceType.QUEEN;
                break;
        }
        promotion_type_selector_dialog.destroy ();

        return selection;
    }

    private void set_piece_image (Gtk.Image image, string filename)
    {
        int width, height;
        if (!Gtk.icon_size_lookup (Gtk.IconSize.DIALOG, out width, out height))
            return;

<<<<<<< HEAD
        Gdk.Pixbuf pixbuf;
        try
        {
            pixbuf = Rsvg.pixbuf_from_file_at_size (filename, width, height);
=======
        try
        {
            var h = new Rsvg.Handle.from_file (filename);

            var s = new Cairo.ImageSurface (Cairo.Format.ARGB32, width, height);
            var c = new Cairo.Context (s);
            var m = Cairo.Matrix.identity ();
            m.scale ((double) width / h.width, (double) height / h.height);
            c.set_matrix (m);
            h.render_cairo (c);

            var p = Gdk.pixbuf_get_from_surface (s, 0, 0, width, height);
            image.set_from_pixbuf (p);
>>>>>>> gnome-chess-application-rename
        }
        catch (Error e)
        {
            warning ("Failed to load image %s: %s", filename, e.message);
            return;
        }
<<<<<<< HEAD
        image.set_from_pixbuf (pixbuf);
    }

    protected enum PromotionTypeSelected
=======
    }

    enum PromotionTypeSelected
>>>>>>> gnome-chess-application-rename
    {
        QUEEN,
        KNIGHT,
        ROOK,
        BISHOP
    }

<<<<<<< HEAD
    /* Quits the application */
    private void quit_game ()
    {
        autosave ();
        Settings.sync ();
        if (launcher != null)
        {
          launcher.destroy ();
          launcher = null;
        }
        if (window != null)
        {
          window.destroy ();
          window = null;
        }
=======
    public void quit_game ()
    {
        if (save_duration_timeout != 0)
            save_duration_cb ();

        autosave ();
        window.destroy ();
>>>>>>> gnome-chess-application-rename
    }

    private void autosave ()
    {
<<<<<<< HEAD
        /* FIXME: Prompt user to save somewhere */
        if (!in_history)
            return;

        /* Don't autosave if no moves (e.g. they have been undone) or only the computer has moved */
        if (!game_needs_saving)
        {
            if (game_file != null)
                history.remove (game_file);
=======
        /* Don't autosave if no moves (e.g. they have been undone) or only the computer has moved */
        if (!game_needs_saving)
        {
            FileUtils.remove (autosave_filename);
>>>>>>> gnome-chess-application-rename
            return;
        }

        try
        {
<<<<<<< HEAD
            if (game_file != null)
                history.update (game_file, "", pgn_game.result);
            else
                game_file = history.add (pgn_game.date, pgn_game.result);
            debug ("Writing current game to %s", game_file.get_path ());
=======
            if (!in_history || game_file == null)
                game_file = File.new_for_path (autosave_filename);

            debug ("Writing current game to %s", game_file.get_path ());
            update_pgn_time_remaining ();
>>>>>>> gnome-chess-application-rename
            pgn_game.write (game_file);
        }
        catch (Error e)
        {
            warning ("Failed to autosave: %s", e.message);
        }
    }

<<<<<<< HEAD
    protected void settings_changed_cb (Settings settings_common, string key)
=======
    private void settings_changed_cb (Settings settings, string key)
>>>>>>> gnome-chess-application-rename
    {
        if (key == "show-3d")
        {
            if (view != null)
            {
                view_container.remove (view);
                view.destroy ();
            }
<<<<<<< HEAD
            if (settings_common.get_boolean ("show-3d"))
=======
            if (settings.get_boolean ("show-3d"))
>>>>>>> gnome-chess-application-rename
                view = new ChessView3D ();
            else
                view = new ChessView2D ();
            view.set_size_request (300, 300);
            view.scene = scene;
            view_container.add (view);
            view.show ();
        }
    }

<<<<<<< HEAD
    protected void update_history_model (ChessGame game, ChessScene scene, Gtk.TreeModel history_model)
    {
        /* Set move text for all moves (it may have changed format) */
        var n_moves = (int) game.n_moves;

        int i = n_moves;
        foreach (var state in game.move_stack)
        {
            if (state.last_move != null)
            {
                Gtk.TreeIter iter;
                if ((history_model as Gtk.ListStore).iter_nth_child (out iter, null, i))
                    set_move_text (iter, state.last_move, scene, history_model);
            }
            i--;
        }
    }

    protected void update_history_panel (ChessGame? game, ChessScene scene, Gtk.TreeModel history_model)
=======
    private void update_history_panel ()
>>>>>>> gnome-chess-application-rename
    {
        if (game == null)
            return;

        var move_number = scene.move_number;
        var n_moves = (int) game.n_moves;
        if (move_number < 0)
            move_number += 1 + n_moves;

        first_move_button.sensitive = n_moves > 0 && move_number != 0;
        prev_move_button.sensitive = move_number > 0;
        next_move_button.sensitive = move_number < n_moves;
        last_move_button.sensitive = n_moves > 0 && move_number != n_moves;

<<<<<<< HEAD
        update_history_model (game, scene, history_model);
=======
        /* Set move text for all moves (it may have changed format) */
        int i = n_moves;
        foreach (var state in game.move_stack)
        {
            if (state.last_move != null)
            {
                Gtk.TreeIter iter;
                if (history_combo.model.iter_nth_child (out iter, null, i))
                    set_move_text (iter, state.last_move);
            }
            i--;
        }
>>>>>>> gnome-chess-application-rename

        history_combo.set_active (move_number);
    }

<<<<<<< HEAD
    protected void scene_changed_cb (ChessScene scene)
    {
        ChessGame game = scene.game;
        Gtk.TreeModel history_model = game.get_data<Gtk.TreeModel> ("history-model");
        update_history_panel (game, scene, history_model);
=======
    private void scene_changed_cb (ChessScene scene)
    {
        update_history_panel ();
>>>>>>> gnome-chess-application-rename
    }

    private void start_game ()
    {
<<<<<<< HEAD
        if (in_history)
        {
            window.title = /* Title of the game window */
=======
        if (in_history || game_file == null)
        {
            window.title = /* Title of the main window */
>>>>>>> gnome-chess-application-rename
                           _("Chess");
        }
        else
        {
            var path = game_file.get_path ();
<<<<<<< HEAD
            window.title = /* Title of the window when explicitly loaded a file. The first argument is the
                            * base name of the file (e.g. test.pgn), the second argument is the directory
                            * (e.g. /home/fred) */
                           _("%1$s (%2$s) - Chess").printf (Path.get_basename (path), Path.get_dirname (path));
=======
            window.title = /* Title of the window when explicitly loaded a file. The argument is the
                            * base name of the file (e.g. test.pgn) */
                           _("Chess - %1$s").printf (Path.get_basename (path));
>>>>>>> gnome-chess-application-rename
        }

        var model = (Gtk.ListStore) history_combo.model;
        model.clear ();
        Gtk.TreeIter iter;
        model.append (out iter);
        model.set (iter, 0,
                   /* Move History Combo: Go to the start of the game */
                   _("Game Start"), 1, 0, -1);
        history_combo.set_active_iter (iter);

        string fen = ChessGame.STANDARD_SETUP;
        string[] moves = new string[pgn_game.moves.length ()];
        var i = 0;
        foreach (var move in pgn_game.moves)
            moves[i++] = move;

        if (pgn_game.set_up)
        {
            if (pgn_game.fen != null)
                fen = pgn_game.fen;
            else
                warning ("Chess game has SetUp tag but no FEN tag");
        }
        game = new ChessGame (fen, moves);
<<<<<<< HEAD
        game.set_data<PGNGame> ("pgn-game", pgn_game);
        game.set_data<Gtk.InfoBar> ("info-bar", info_bar);
        game.set_data<Gtk.Label> ("info-title-label", info_title_label);
        game.set_data<Gtk.Label> ("info-label", info_label);
        /* Associate history_model for access in scene_changed_cb */
        game.set_data<Gtk.TreeModel> ("history-model", history_combo.model);

        if (pgn_game.time_control != null)
        {
            var controls = pgn_game.time_control.split (":");
            foreach (var control in controls)
            {
                /* We only support simple timeouts */
                var duration = int.parse (control);
                if (duration > 0)
                    game.clock = new ChessClock (duration, duration);
=======

        /*
         * We only support simple timeouts
         * http://www.saremba.de/chessgml/standards/pgn/pgn-complete.htm#c9.6.1
         */
        if (pgn_game.time_control != null && int.parse (pgn_game.time_control) != 0)
        {
            if (pgn_game.white_time_left != null && pgn_game.black_time_left != null)
            {
                var white_seconds = int.parse (pgn_game.white_time_left);
                var black_seconds = int.parse (pgn_game.black_time_left);

                if (white_seconds > 0 && black_seconds > 0)
                    game.clock = new ChessClock (white_seconds, black_seconds);
>>>>>>> gnome-chess-application-rename
            }
        }

        game.started.connect (game_start_cb);
        game.turn_started.connect (game_turn_cb);
        game.moved.connect (game_move_cb);
        game.undo.connect (game_undo_cb);
        game.ended.connect (game_end_cb);
        if (game.clock != null)
            game.clock.tick.connect (game_clock_tick_cb);

        scene.game = game;
<<<<<<< HEAD
        /* scene_changed_cb makes use of game and history-model association on it so make sure that is set before connecting this to it's signal */
        scene.changed.connect (scene_changed_cb);
        info_bar.hide ();
        save_menu.sensitive = false;
        save_as_menu.sensitive = false;
        update_history_panel (game, scene, history_combo.model);
        update_control_buttons ();

        // TODO: Could both be engines
        var white_engine = pgn_game.tags.lookup ("WhiteAI");
        var white_level = pgn_game.tags.lookup ("WhiteLevel");
        if (white_level == null)
            white_level = "normal";

        var black_engine = pgn_game.tags.lookup ("BlackAI");
        var black_level = pgn_game.tags.lookup ("BlackLevel");
        if (black_level == null)
            black_level = "normal";

=======
        info_bar.hide ();
        save_button.sensitive = false;
        update_history_panel ();
        update_control_buttons ();

        // TODO: Could both be engines
        var white_engine = pgn_game.white_ai;
        var white_level = pgn_game.white_level;
        if (white_level == null)
            white_level = "normal";

        var black_engine = pgn_game.black_ai;
        var black_level = pgn_game.black_level;
        if (black_level == null)
            black_level = "normal";

        human_player = null;
>>>>>>> gnome-chess-application-rename
        opponent = null;
        if (opponent_engine != null)
        {
            opponent_engine.stop ();
            opponent_engine.ready_changed.disconnect (engine_ready_cb);
            opponent_engine.moved.disconnect (engine_move_cb);
<<<<<<< HEAD
            opponent_engine.stopped.disconnect (engine_stopped_cb);
            opponent_engine = null;
        }
=======
            opponent_engine.resigned.disconnect (engine_resigned_cb);
            opponent_engine.stopped.disconnect (engine_stopped_cb);
            opponent_engine.error.disconnect (engine_error_cb);
            opponent_engine.claim_draw.disconnect (engine_claim_draw_cb);
            opponent_engine.offer_draw.disconnect (engine_offer_draw_cb);
            opponent_engine = null;
        }

>>>>>>> gnome-chess-application-rename
        if (white_engine != null)
        {
            opponent = game.white;
            human_player = game.black;
            opponent_engine = get_engine (white_engine, white_level);
<<<<<<< HEAD
=======
            opponent.local_human = false;
            human_player.local_human = true;
>>>>>>> gnome-chess-application-rename
        }
        else if (black_engine != null)
        {
            opponent = game.black;
            human_player = game.white;
            opponent_engine = get_engine (black_engine, black_level);
<<<<<<< HEAD
        }

        if (opponent_engine != null)
        {
            opponent_engine.ready_changed.connect (engine_ready_cb);
            opponent_engine.moved.connect (engine_move_cb);
            opponent_engine.stopped.connect (engine_stopped_cb);
=======
            opponent.local_human = false;
            human_player.local_human = true;
        }

        /* Game saved vs. human, or game saved vs. engine but none installed */
        if (opponent_engine == null)
        {
            game.black.local_human = true;
            game.white.local_human = true;
        }
        else
        {
            opponent_engine.ready_changed.connect (engine_ready_cb);
            opponent_engine.moved.connect (engine_move_cb);
            opponent_engine.resigned.connect (engine_resigned_cb);
            opponent_engine.stopped.connect (engine_stopped_cb);
            opponent_engine.error.connect (engine_error_cb);
            opponent_engine.claim_draw.connect (engine_claim_draw_cb);
            opponent_engine.offer_draw.connect (engine_offer_draw_cb);
>>>>>>> gnome-chess-application-rename
            opponent_engine.start ();
        }

        /* Replay current moves */
        for (var j = (int) game.move_stack.length () - 2; j >= 0; j--)
        {
            var state = game.move_stack.nth_data (j);
            game_move_cb (game, state.last_move);
        }

<<<<<<< HEAD
        game_needs_saving = false;
        game.start ();

=======
        game_needs_saving = in_history;
        save_button.sensitive = in_history;
        game.start ();

        if (moves.length > 0 && game.clock != null)
        {
            game.clock.start ();
            pause_button.sensitive = true;
        }
        else
        {
            pause_button.sensitive = false;
        }

>>>>>>> gnome-chess-application-rename
        if (game.result != ChessResult.IN_PROGRESS)
            game_end_cb (game);

        white_time_label.queue_draw ();
        black_time_label.queue_draw ();
    }

    private ChessEngine? get_engine (string name, string difficulty)
    {
        ChessEngine engine;
        AIProfile? profile = null;

        if (name == "human")
            return null;

        foreach (var p in ai_profiles)
        {
            if (name == "" || p.name == name)
            {
                profile = p;
                break;
            }
        }
        if (profile == null)
        {
            warning ("Unknown AI profile %s", name);
            if (ai_profiles == null)
                return null;
            profile = ai_profiles.data;
        }

<<<<<<< HEAD
        string[] options;
=======
        string[] options, uci_go_options, args;
>>>>>>> gnome-chess-application-rename
        switch (difficulty)
        {
        case "easy":
            options = profile.easy_options;
<<<<<<< HEAD
=======
            uci_go_options = profile.easy_uci_go_options;
            args = profile.easy_args;
>>>>>>> gnome-chess-application-rename
            break;
        default:
        case "normal":
            options = profile.normal_options;
<<<<<<< HEAD
            break;
        case "hard":
            options = profile.hard_options;
=======
            uci_go_options = profile.normal_uci_go_options;
            args = profile.normal_args;
            break;
        case "hard":
            options = profile.hard_options;
            uci_go_options = profile.hard_uci_go_options;
            args = profile.hard_args;
>>>>>>> gnome-chess-application-rename
            break;
        }

        if (profile.protocol == "cecp")
<<<<<<< HEAD
            engine = new ChessEngineCECP (options);
        else if (profile.protocol == "uci")
            engine = new ChessEngineUCI (options);
=======
        {
            warn_if_fail (uci_go_options.length == 0);
            engine = new ChessEngineCECP (profile.binary, args, options);
        }
        else if (profile.protocol == "uci")
        {
            engine = new ChessEngineUCI (profile.binary, args, options, uci_go_options);
        }
>>>>>>> gnome-chess-application-rename
        else
        {
            warning ("Unknown AI protocol %s", profile.protocol);
            return null;
        }
<<<<<<< HEAD
        engine.binary = profile.binary;
=======
>>>>>>> gnome-chess-application-rename

        return engine;
    }

    public override void activate ()
    {
<<<<<<< HEAD
      /* Launcher or game-window would have been created by startup () already. Show it. */
      if (launcher != null)
          launcher.show ();
      if (window != null)
          window.show ();
    }

    [CCode (cname = "launcher_destroy_cb", instance_pos = -1)]
    public void launcher_destroy_cb (Gtk.Widget widget)
    {
        launcher = null;

        if (window == null || !(window as Gtk.Widget).get_visible ())
          quit_game ();
=======
        window.show ();
>>>>>>> gnome-chess-application-rename
    }

    private void engine_ready_cb (ChessEngine engine)
    {
        if (opponent_engine.ready)
        {
<<<<<<< HEAD
            game.start ();
            view.queue_draw ();
        }
    }

    private void engine_move_cb (ChessEngine engine, string move)
    {
        opponent.move (move);
    }

    private void engine_stopped_cb (ChessEngine engine)
=======
            view.queue_draw ();
        }
    }
    
    private void engine_move_cb (ChessEngine engine, string move)
    {
        if (!opponent.move (move))
            game.stop (ChessResult.BUG, ChessRule.BUG);
    }

    private void engine_resigned_cb (ChessEngine engine)
>>>>>>> gnome-chess-application-rename
    {
        opponent.resign ();
    }

<<<<<<< HEAD
=======
    private void engine_stopped_cb (ChessEngine engine)
    {
        /*
         * Many engines close themselves immediately after the end of the game.
         * So wait two seconds before displaying the unfortunate result. The
         * game is likely to end naturally first. (And in the off chance that
         * the game really is over but it takes more than two seconds for us to
         * figure that out, something really HAS gone wrong.)
         */
        Timeout.add_seconds (2, () => {
            game.stop (ChessResult.BUG, ChessRule.BUG);
            /* Disconnect from the mainloop */
            return false;
        });
    }

    private void engine_error_cb (ChessEngine engine)
    {
        game.stop (ChessResult.BUG, ChessRule.BUG);
    }

    private void engine_claim_draw_cb (ChessEngine engine)
    {
        if (!opponent.claim_draw ())
            game.stop (ChessResult.BUG, ChessRule.BUG);
    }

    private void engine_offer_draw_cb (ChessEngine engine)
    {
        opponent.claim_draw ();

        /*
         * If the draw cannot be claimed, do nothing.
         *
         * In the future we might want to actually give the player a choice
         * of accepting the draw, but this doesn't make much sense unless the
         * player can also offer a draw himself.
         */
    }

>>>>>>> gnome-chess-application-rename
    private void game_start_cb (ChessGame game)
    {
        if (opponent_engine != null)
            opponent_engine.start_game ();
    }

<<<<<<< HEAD
    protected void game_clock_tick_cb (ChessClock clock)
=======
    private void game_clock_tick_cb (ChessClock clock)
>>>>>>> gnome-chess-application-rename
    {
        white_time_label.queue_draw ();
        black_time_label.queue_draw ();
    }

    private void game_turn_cb (ChessGame game, ChessPlayer player)
    {
<<<<<<< HEAD
        if (opponent_engine != null && player == opponent)
            opponent_engine.request_move ();
    }

    protected void set_move_text (Gtk.TreeIter iter, ChessMove move, ChessScene scene, Gtk.TreeModel model)
=======
        if (game.clock != null)
            pause_button.sensitive = true;
        
        if (game.is_started && opponent_engine != null && player == opponent)
            opponent_engine.request_move ();
    }

    private void set_move_text (Gtk.TreeIter iter, ChessMove move)
>>>>>>> gnome-chess-application-rename
    {
        /* Note there are no move formats for pieces taking kings and this is not allowed in Chess rules */
        const string human_descriptions[] = {/* Human Move String: Description of a white pawn moving from %1$s to %2s, e.g. 'c2 to c4' */
                                             N_("White pawn moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white pawn at %1$s capturing a pawn at %2$s */
                                             N_("White pawn at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white pawn at %1$s capturing a rook at %2$s */
                                             N_("White pawn at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white pawn at %1$s capturing a knight at %2$s */
                                             N_("White pawn at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white pawn at %1$s capturing a bishop at %2$s */
                                             N_("White pawn at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white pawn at %1$s capturing a queen at %2$s */
                                             N_("White pawn at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a white rook moving from %1$s to %2$s, e.g. 'a1 to a5' */
                                             N_("White rook moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white rook at %1$s capturing a pawn at %2$s */
                                             N_("White rook at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white rook at %1$s capturing a rook at %2$s */
                                             N_("White rook at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white rook at %1$s capturing a knight at %2$s */
                                             N_("White rook at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white rook at %1$s capturing a bishop at %2$s */
                                             N_("White rook at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white rook at %1$s capturing a queen at %2$s" */
                                             N_("White rook at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a white knight moving from %1$s to %2$s, e.g. 'b1 to c3' */
                                             N_("White knight moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white knight at %1$s capturing a pawn at %2$s */
                                             N_("White knight at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white knight at %1$s capturing a rook at %2$s */
                                             N_("White knight at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white knight at %1$s capturing a knight at %2$s */
                                             N_("White knight at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white knight at %1$s capturing a bishop at %2$s */
                                             N_("White knight at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white knight at %1$s capturing a queen at %2$s */
                                             N_("White knight at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a white bishop moving from %1$s to %2$s, e.g. 'f1 to b5' */
                                             N_("White bishop moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white bishop at %1$s capturing a pawn at %2$s */
                                             N_("White bishop at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white bishop at %1$s capturing a rook at %2$s */
                                             N_("White bishop at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white bishop at %1$s capturing a knight at %2$s */
                                             N_("White bishop at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white bishop at %1$s capturing a bishop at %2$s */
                                             N_("White bishop at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white bishop at %1$s capturing a queen at %2$s */
                                             N_("White bishop at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a white queen moving from %1$s to %2$s, e.g. 'd1 to d4' */
                                             N_("White queen moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white queen at %1$s capturing a pawn at %2$s */
                                             N_("White queen at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white queen at %1$s capturing a rook at %2$s */
                                             N_("White queen at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white queen at %1$s capturing a knight at %2$s */
                                             N_("White queen at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white queen at %1$s capturing a bishop at %2$s */
                                             N_("White queen at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white queen at %1$s capturing a queen at %2$s */
                                             N_("White queen at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a white king moving from %1$s to %2$s, e.g. 'e1 to f1' */
                                             N_("White king moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a white king at %1$s capturing a pawn at %2$s */
                                             N_("White king at %1$s takes the black pawn at %2$s"),
                                             /* Human Move String: Description of a white king at %1$s capturing a rook at %2$s */
                                             N_("White king at %1$s takes the black rook at %2$s"),
                                             /* Human Move String: Description of a white king at %1$s capturing a knight at %2$s */
                                             N_("White king at %1$s takes the black knight at %2$s"),
                                             /* Human Move String: Description of a white king at %1$s capturing a bishop at %2$s */
                                             N_("White king at %1$s takes the black bishop at %2$s"),
                                             /* Human Move String: Description of a white king at %1$s capturing a queen at %2$s */
                                             N_("White king at %1$s takes the black queen at %2$s"),
                                             /* Human Move String: Description of a black pawn moving from %1$s to %2$s, e.g. 'c8 to c6' */
                                             N_("Black pawn moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black pawn at %1$s capturing a pawn at %2$s */
                                             N_("Black pawn at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black pawn at %1$s capturing a rook at %2$s */
                                             N_("Black pawn at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black pawn at %1$s capturing a knight at %2$s */
                                             N_("Black pawn at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black pawn at %1$s capturing a bishop at %2$s */
                                             N_("Black pawn at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black pawn at %1$s capturing a queen at %2$s */
                                             N_("Black pawn at %1$s takes the white queen at %2$s"),
                                             /* Human Move String: Description of a black rook moving from %1$s to %2$s, e.g. 'a8 to a4' */
                                             N_("Black rook moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black rook at %1$s capturing a pawn at %2$s */
                                             N_("Black rook at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black rook at %1$s capturing a rook at %2$s */
                                             N_("Black rook at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black rook at %1$s capturing a knight at %2$s */
                                             N_("Black rook at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black rook at %1$s capturing a bishop at %2$s */
                                             N_("Black rook at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black rook at %1$s capturing a queen at %2$s */
                                             N_("Black rook at %1$s takes the white queen at %2$s"),
                                             /* Human Move String: Description of a black knight moving from %1$s to %2$s, e.g. 'b8 to c6' */
                                             N_("Black knight moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black knight at %1$s capturing a pawn at %2$s */
                                             N_("Black knight at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black knight at %1$s capturing a rook at %2$s */
                                             N_("Black knight at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black knight at %1$s capturing a knight at %2$s */
                                             N_("Black knight at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black knight at %1$s capturing a bishop at %2$s */
                                             N_("Black knight at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black knight at %1$s capturing a queen at %2$s */
                                             N_("Black knight at %1$s takes the white queen at %2$s"),
                                             /* Human Move String: Description of a black bishop moving from %1$s to %2$s, e.g. 'f8 to b3' */
                                             N_("Black bishop moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black bishop at %1$s capturing a pawn at %2$s */
                                             N_("Black bishop at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black bishop at %1$s capturing a rook at %2$s */
                                             N_("Black bishop at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black bishop at %1$s capturing a knight at %2$s */
                                             N_("Black bishop at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black bishop at %1$s capturing a bishop at %2$s */
                                             N_("Black bishop at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black bishop at %1$s capturing a queen at %2$s */
                                             N_("Black bishop at %1$s takes the white queen at %2$s"),
                                             /* Human Move String: Description of a black queen moving from %1$s to %2$s, e.g. 'd8 to d5' */
                                             N_("Black queen moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black queen at %1$s capturing a pawn at %2$s */
                                             N_("Black queen at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black queen at %1$s capturing a rook at %2$s */
                                             N_("Black queen at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black queen at %1$s capturing a knight at %2$s */
                                             N_("Black queen at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black queen at %1$s capturing a bishop at %2$s */
                                             N_("Black queen at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black queen at %1$s capturing a queen at %2$s */
                                             N_("Black queen at %1$s takes the white queen at %2$s"),
                                             /* Human Move String: Description of a black king moving from %1$s to %2$s, e.g. 'e8 to f8' */
                                             N_("Black king moves from %1$s to %2$s"),
                                             /* Human Move String: Description of a black king at %1$s capturing a pawn at %2$s */
                                             N_("Black king at %1$s takes the white pawn at %2$s"),
                                             /* Human Move String: Description of a black king at %1$s capturing a rook at %2$s */
                                             N_("Black king at %1$s takes the white rook at %2$s"),
                                             /* Human Move String: Description of a black king at %1$s capturing a knight at %2$s */
                                             N_("Black king at %1$s takes the white knight at %2$s"),
                                             /* Human Move String: Description of a black king at %1$s capturing a bishop at %2$s */
                                             N_("Black king at %1$s takes the white bishop at %2$s"),
                                             /* Human Move String: Description of a black king at %1$s capturing a queen at %2$s" */
                                             N_("Black king at %1$s takes the white queen at %2$s")};

        var move_text = "";
        switch (scene.move_format)
        {
        case "human":
<<<<<<< HEAD
            int index;
            if (move.victim == null)
                index = 0;
            else
                index = move.victim.type + 1;
            index += move.piece.type * 6;
            if (move.piece.player.color == Color.BLACK)
                index += 36;

            // FIXME: Use castling text e.g. "White castles kingside" (do for next release, we are in a string freeze)

            var start = "%c%d".printf ('a' + move.f0, move.r0 + 1);
            var end = "%c%d".printf ('a' + move.f1, move.r1 + 1);
            move_text = _(human_descriptions[index]).printf (start, end);
=======
            if (move.moved_rook == null)
            {
                int index;
                if (move.victim == null)
                    index = 0;
                else
                    index = move.victim.type + 1;
                index += move.piece.type * 6;
                if (move.piece.player.color == Color.BLACK)
                    index += 36;

                var start = "%c%d".printf ('a' + move.f0, move.r0 + 1);
                var end = "%c%d".printf ('a' + move.f1, move.r1 + 1);
                move_text = _(human_descriptions[index]).printf (start, end);
            }
            else if (move.f0 < move.f1 && move.r0 == 0)
            {
                move_text = _("White castles kingside");
            }
            else if (move.f1 < move.f0 && move.r0 == 0)
            {
                move_text = _("White castles queenside");
            }
            else if (move.f0 < move.f1 && move.r0 == 7)
            {
                move_text = _("Black castles kingside");
            }
            else if (move.f1 < move.f0 && move.r0 == 7)
            {
                move_text = _("Black castles queenside");
            }
            else assert_not_reached ();
>>>>>>> gnome-chess-application-rename
            break;

        case "san":
            move_text = move.get_san ();
            break;

        case "fan":
            move_text = move.get_fan ();
            break;

        default:
        case "lan":
            move_text = move.get_lan ();
            break;
        }

<<<<<<< HEAD
        var label = "%u%c. %s".printf ((move.number + 1) / 2, move.number % 2 == 0 ? 'b' : 'a', move_text);
        (model as Gtk.ListStore).set (iter, 0, label, -1);
    }

    protected void game_move_cb (ChessGame game, ChessMove move)
=======
        var model = (Gtk.ListStore) history_combo.model;
        var label = "%u%c. %s".printf ((move.number + 1) / 2, move.number % 2 == 0 ? 'b' : 'a', move_text);
        model.set (iter, 0, label, -1);
    }

    private void game_move_cb (ChessGame game, ChessMove move)
>>>>>>> gnome-chess-application-rename
    {
        /* Need to save after each move */
        game_needs_saving = true;

        /* If the only mover is the AI, then don't bother saving */
        if (move.number == 1 && opponent != null && opponent.color == Color.WHITE)
            game_needs_saving = false;

        if (move.number > pgn_game.moves.length ())
            pgn_game.moves.append (move.get_san ());

        var model = (Gtk.ListStore) history_combo.model;
        Gtk.TreeIter iter;
        model.append (out iter);
        model.set (iter, 1, move.number, -1);        
<<<<<<< HEAD
        set_move_text (iter, move, scene, history_combo.model);
=======
        set_move_text (iter, move);
>>>>>>> gnome-chess-application-rename

        /* Follow the latest move */
        if (move.number == game.n_moves && scene.move_number == -1)
            history_combo.set_active_iter (iter);

<<<<<<< HEAD
        save_menu.sensitive = true;
        save_as_menu.sensitive = true;
        update_history_panel (game, scene, history_combo.model);
=======
        save_button.sensitive = true;
        update_history_panel ();
>>>>>>> gnome-chess-application-rename
        update_control_buttons ();

        if (opponent_engine != null)
            opponent_engine.report_move (move);
        view.queue_draw ();
    }

    private void game_undo_cb (ChessGame game)
    {
        /* Notify AI */
        if (opponent_engine != null)
            opponent_engine.undo ();

        /* Remove from the PGN game */
        pgn_game.moves.remove_link (pgn_game.moves.last ());

        /* Remove from the history */
        var model = (Gtk.ListStore) history_combo.model;
        Gtk.TreeIter iter;
        model.iter_nth_child (out iter, null, model.iter_n_children (null) - 1);
        model.remove (iter);

<<<<<<< HEAD
        /* If watching this move, go back one */
        if (scene.move_number > game.n_moves || scene.move_number == -1)
        {
            model.iter_nth_child (out iter, null, model.iter_n_children (null) - 1);
            history_combo.set_active_iter (iter);
            view.queue_draw ();
        }

        update_history_panel (game, scene, history_combo.model);
        update_control_buttons ();
    }

    protected void update_control_buttons ()
    {
        var can_resign = game.n_moves > 0;
        resign_menu.sensitive = resign_button.sensitive = can_resign;
=======
        /* Always undo from the most recent move */
        scene.move_number = -1;

        /* Go back one */
        model.iter_nth_child (out iter, null, model.iter_n_children (null) - 1);
        history_combo.set_active_iter (iter);
        view.queue_draw ();

        if (game.n_moves > 0)
        {
            game_needs_saving = true;
            save_button.sensitive = true;
        }
        else
        {
            game_needs_saving = false;
            save_button.sensitive = false;
        }

        update_history_panel ();
        update_control_buttons ();
    }
    
    private void update_control_buttons ()
    {
        var can_resign = game.n_moves > 0;
        resign_button.sensitive = can_resign;

        /* Claim draw only allowed on your own turn */        
        claim_draw_button.sensitive = can_resign && game.current_player != opponent;
>>>>>>> gnome-chess-application-rename

        /* Can undo once the human player has made a move */
        var can_undo = game.n_moves > 0;
        if (opponent != null && opponent.color == Color.WHITE)
            can_undo = game.n_moves > 1;

<<<<<<< HEAD
        undo_menu.sensitive = undo_button.sensitive = can_undo;
    }

    protected void game_end_cb (ChessGame game)
    {
        PGNGame pgn_game = game.get_data<PGNGame> ("pgn-game");
        Gtk.InfoBar info_bar = game.get_data<Gtk.InfoBar> ("info-bar");
        Gtk.Label info_title_label = game.get_data<Gtk.Label> ("info-title-bar");
        Gtk.Label info_label = game.get_data<Gtk.Label> ("info-label");
=======
        undo_button.sensitive = can_undo;
    }

    private void game_end_cb (ChessGame game)
    {
        resign_button.sensitive = false;
        undo_button.sensitive = false;
        claim_draw_button.sensitive = false;
        pause_button.sensitive = false;

        game_needs_saving = false;

        if (opponent_engine != null)
            opponent_engine.stop ();
>>>>>>> gnome-chess-application-rename

        string title = "";
        switch (game.result)
        {
        case ChessResult.WHITE_WON:
            /* Message display when the white player wins */
            title = _("White wins");
            pgn_game.result = PGNGame.RESULT_WHITE;
            break;
        case ChessResult.BLACK_WON:
            /* Message display when the black player wins */
            title = _("Black wins");
            pgn_game.result = PGNGame.RESULT_BLACK;
            break;
        case ChessResult.DRAW:
            /* Message display when the game is drawn */
            title = _("Game is drawn");
            pgn_game.result = PGNGame.RESULT_DRAW;            
            break;
<<<<<<< HEAD
=======
        case ChessResult.BUG:
            /* Message display when the game cannot continue */
            title = _("Oops! Something has gone wrong.");
            /* don't set the pgn_game result; these are standards */
            break;
>>>>>>> gnome-chess-application-rename
        default:
            break;
        }

        string reason = "";
        switch (game.rule)
        {
        case ChessRule.CHECKMATE:
            /* Message displayed when the game ends due to a player being checkmated */
            reason = _("Opponent is in check and cannot move (checkmate)");
            break;
        case ChessRule.STALEMATE:
            /* Message displayed when the game terminates due to a stalemate */
            reason = _("Opponent cannot move (stalemate)");
            break;
        case ChessRule.FIFTY_MOVES:
            /* Message displayed when the game is drawn due to the fifty move rule */
            reason = _("No piece has been taken or pawn moved in the last fifty moves");
            break;
        case ChessRule.TIMEOUT:
            /* Message displayed when the game ends due to one player's clock stopping */
            reason = _("Opponent has run out of time");
            break;
        case ChessRule.THREE_FOLD_REPETITION:
            /* Message displayed when the game is drawn due to the three-fold-repitition rule */
<<<<<<< HEAD
            reason = _("The same board state has occurred three times (three fold repetition)");
            break;
        case ChessRule.INSUFFICIENT_MATERIAL:
            /* Message displayed when the game is drawn due to the insufficient material rule */
            reason = _("Neither player can cause checkmate (insufficient material)");
=======
            reason = _("The same board state has occurred three times (threefold repetition)");
            break;
        case ChessRule.INSUFFICIENT_MATERIAL:
            /* Message displayed when the game is drawn due to the insufficient material rule */
            reason = _("Neither player can checkmate (insufficient material)");
>>>>>>> gnome-chess-application-rename
            break;
        case ChessRule.RESIGN:
            if (game.result == ChessResult.WHITE_WON)
            {
                /* Message displayed when the game ends due to the black player resigning */
                reason = _("The black player has resigned");
            }
            else
            {
                /* Message displayed when the game ends due to the white player resigning */
                reason = _("The white player has resigned");
            }
            break;
        case ChessRule.ABANDONMENT:
            /* Message displayed when a game is abandoned */
            reason = _("The game has been abandoned");
            pgn_game.termination = PGNGame.TERMINATE_ABANDONED;
            break;
        case ChessRule.DEATH:
            /* Message displayed when the game ends due to a player dying */
            reason = _("One of the players has died");
            pgn_game.termination = PGNGame.TERMINATE_DEATH;
            break;
<<<<<<< HEAD
=======
        case ChessRule.BUG:
            /* Message displayed when something goes wrong with the engine */
            reason = _("The game cannot continue.");
            /* Don't set pgn_game termination; these are standards*/
            break;
>>>>>>> gnome-chess-application-rename
        }

        info_title_label.set_markup ("<big><b>%s</b></big>".printf (title));
        info_label.set_text (reason);
        info_bar.show ();

        white_time_label.queue_draw ();
        black_time_label.queue_draw ();
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT game_window_delete_event_cb", instance_pos = -1)]
    public bool game_window_delete_event_cb (Gtk.Widget widget, Gdk.Event event)
=======
    public void show ()
    {
        window.show ();
    }

    [CCode (cname = "G_MODULE_EXPORT gnome_chess_app_delete_event_cb", instance_pos = -1)]
    public bool gnome_chess_app_delete_event_cb (Gtk.Widget widget, Gdk.Event event)
>>>>>>> gnome-chess-application-rename
    {
        quit_game ();
        return false;
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT game_window_configure_event_cb", instance_pos = -1)]
    public bool game_window_configure_event_cb (Gtk.Widget widget, Gdk.EventConfigure event)
    {
        if (!settings.get_boolean ("maximized") && !settings.get_boolean ("fullscreen"))
        {
            settings.set_int ("game-screen-width", event.width);
            settings.set_int ("game-screen-height", event.height);
=======
    [CCode (cname = "G_MODULE_EXPORT gnome_chess_app_configure_event_cb", instance_pos = -1)]
    public bool gnome_chess_app_configure_event_cb (Gtk.Widget widget, Gdk.EventConfigure event)
    {
        if (!settings.get_boolean ("maximized") && !settings.get_boolean ("fullscreen"))
        {
            settings.set_int ("width", event.width);
            settings.set_int ("height", event.height);
>>>>>>> gnome-chess-application-rename
        }

        return false;
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT game_window_window_state_event_cb", instance_pos = -1)]
    public bool game_window_window_state_event_cb (Gtk.Widget widget, Gdk.EventWindowState event)
=======
    [CCode (cname = "G_MODULE_EXPORT gnome_chess_app_window_state_event_cb", instance_pos = -1)]
    public bool gnome_chess_app_window_state_event_cb (Gtk.Widget widget, Gdk.EventWindowState event)
>>>>>>> gnome-chess-application-rename
    {
        if ((event.changed_mask & Gdk.WindowState.MAXIMIZED) != 0)
        {
            var is_maximized = (event.new_window_state & Gdk.WindowState.MAXIMIZED) != 0;
            settings.set_boolean ("maximized", is_maximized);
        }
        if ((event.changed_mask & Gdk.WindowState.FULLSCREEN) != 0)
        {
<<<<<<< HEAD
            bool is_fullscreen = (event.new_window_state & Gdk.WindowState.FULLSCREEN) != 0;
            settings.set_boolean ("fullscreen", is_fullscreen);
            fullscreen_menu.label = is_fullscreen ? Gtk.Stock.LEAVE_FULLSCREEN : Gtk.Stock.FULLSCREEN;
=======
            is_fullscreen = (event.new_window_state & Gdk.WindowState.FULLSCREEN) != 0;
            settings.set_boolean ("fullscreen", is_fullscreen);
>>>>>>> gnome-chess-application-rename
        }

        return false;
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT new_game_cb", instance_pos = -1)]
    public void new_game_cb (Gtk.Widget widget)
    {
        if (game_needs_saving || (in_history && game_file != null))
        {
            var dialog = new Gtk.MessageDialog.with_markup (window,
                                                            Gtk.DialogFlags.MODAL,
                                                            Gtk.MessageType.QUESTION,
                                                            Gtk.ButtonsType.NONE,
                                                            "<span weight=\"bold\" size=\"larger\">%s</span>",
                                                            _("Save this game before starting a new one?"));
            dialog.add_button (Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL);
            dialog.add_button (_("_Abandon game"), Gtk.ResponseType.NO);
            dialog.add_button (_("_Save game for later"), Gtk.ResponseType.YES);
            var result = dialog.run ();
            dialog.destroy ();
            if (result == Gtk.ResponseType.CANCEL)
                return;

            if (result == Gtk.ResponseType.NO)
            {
                in_history = false;
                game_needs_saving = false;
            }
        }

        autosave ();

        /* Hide game-window and show launcher */
        window.hide ();
        if (launcher == null)
        {
          launcher = create_launcher (engines_file, ai_profiles, history);
          add_window (launcher);
        }
        launcher.present ();
        launcher.show_opponent_selector ();
=======
    private bool prompt_save_game (string prompt_text)
    {
        if (!game_needs_saving && (!in_history || game_file == null))
            return true;

        var dialog = new Gtk.MessageDialog.with_markup (window,
                                                        Gtk.DialogFlags.MODAL,
                                                        Gtk.MessageType.QUESTION,
                                                        Gtk.ButtonsType.NONE,
                                                        "<span weight=\"bold\" size=\"larger\">%s</span>",
                                                        prompt_text);
        dialog.add_button (_("_Cancel"), Gtk.ResponseType.CANCEL);

        if (game.result == ChessResult.IN_PROGRESS)
        {
            dialog.add_button (_("_Abandon game"), Gtk.ResponseType.NO);
            dialog.add_button (_("_Save game for later"), Gtk.ResponseType.YES);
        }
        else
        {
            dialog.add_button (_("_Discard game"), Gtk.ResponseType.NO);
            dialog.add_button (_("_Save game log"), Gtk.ResponseType.YES);
        }

        var result = dialog.run ();
        dialog.destroy ();

        if (result == Gtk.ResponseType.CANCEL || result == Gtk.ResponseType.DELETE_EVENT)
        {
            return false;
        }
        else if (result == Gtk.ResponseType.YES)
        {
            /* Your very last chance to save */
            save_game (_("_Discard"), _("_Save"));
        }
        else
        {
            warn_if_fail (result == Gtk.ResponseType.NO);
            /* Remove completed game from history */
            game_needs_saving = false;
            autosave ();
        }

        return true;
    }

    [CCode (cname = "G_MODULE_EXPORT new_game_cb", instance_pos = -1)]
    public void new_game_cb (Gtk.Widget widget)
    {
        if (prompt_save_game (_("Save this game before starting a new one?")))
            start_new_game ();
>>>>>>> gnome-chess-application-rename
    }

    [CCode (cname = "G_MODULE_EXPORT resign_cb", instance_pos = -1)]
    public void resign_cb (Gtk.Widget widget)
    {
<<<<<<< HEAD
        game.current_player.resign ();
=======
        if (human_player != null)
            human_player.resign ();
        else
            game.current_player.resign ();
>>>>>>> gnome-chess-application-rename
    }

    [CCode (cname = "G_MODULE_EXPORT claim_draw_cb", instance_pos = -1)]
    public void claim_draw_cb (Gtk.Widget widget)
    {
<<<<<<< HEAD
        game.current_player.claim_draw ();
=======
        if (!game.current_player.claim_draw ())
        {
            var dialog = new Gtk.MessageDialog.with_markup (window,
                                                            Gtk.DialogFlags.MODAL,
                                                            Gtk.MessageType.INFO,
                                                            Gtk.ButtonsType.CLOSE,
                                                            "<span weight=\"bold\" size=\"larger\">%s</span>",
                                                            _("You cannot currently claim a draw."));

            var repetitions = game.state_repeated_times (game.current_state);
            var moves = game.current_state.halfmove_clock / 2;

            warn_if_fail (repetitions == 1 || repetitions == 2);

            /* Dialog that appears when Claim Draw is used but a draw cannot be claimed */
            dialog.format_secondary_text ("• " + (repetitions == 1 ?
                                                      _("It is the first time this board position has occurred") :
                                                      _("It is the second time this board position has occurred")) + "\n"
                                            + "• " + ngettext ("%d move has passed without a capture or pawn advancement",
                                                               "%d moves have passed without a capture or pawn advancement",
                                                               moves) + "\n\n"
                                            + _("You can claim a draw when either:") + "\n\n"
                                            + "• " + _("Any board position has occurred three times") + "\n"
                                            + "• " + _("50 moves have passed without a capture or pawn advancement") + "\n\n"
                                            + _("(Board position is affected by the ability to castle or capture en passant.)") + "\n\n"
                                            + _("The game is automatically a draw if:") + "\n\n"
                                            + "• " + _("The current player cannot move (stalemate)") + "\n"
                                            + "• " + _("Neither player can checkmate (insufficient material)"),
                                          moves);

            dialog.run ();
            dialog.destroy ();
        }
>>>>>>> gnome-chess-application-rename
    }

    [CCode (cname = "G_MODULE_EXPORT undo_move_cb", instance_pos = -1)]
    public void undo_move_cb (Gtk.Widget widget)
    {
        if (opponent != null)
            human_player.undo ();
        else
            game.opponent.undo ();
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT quit_cb", instance_pos = -1)]
    public virtual void quit_cb (Gtk.Widget widget)
=======
    private void stash_button_sensitivity ()
    {
        widget_sensitivity[SensitivityIndex.UNDO] = undo_button.sensitive;
        widget_sensitivity[SensitivityIndex.CLAIM_DRAW] =
            claim_draw_button.sensitive;
        widget_sensitivity[SensitivityIndex.RESIGN] = resign_button.sensitive;
        widget_sensitivity[SensitivityIndex.FIRST_MOVE] =
            first_move_button.sensitive;
        widget_sensitivity[SensitivityIndex.PREV_MOVE] =
            prev_move_button.sensitive;
        widget_sensitivity[SensitivityIndex.NEXT_MOVE] =
            next_move_button.sensitive;
        widget_sensitivity[SensitivityIndex.LAST_MOVE] =
            last_move_button.sensitive;
        widget_sensitivity[SensitivityIndex.HISTORY] = history_combo.sensitive;
    }

    private void revert_button_sensitivity ()
    {
        undo_button.sensitive = widget_sensitivity[SensitivityIndex.UNDO];
        claim_draw_button.sensitive =
            widget_sensitivity[SensitivityIndex.CLAIM_DRAW];
        resign_button.sensitive = widget_sensitivity[SensitivityIndex.RESIGN];
        first_move_button.sensitive =
            widget_sensitivity[SensitivityIndex.FIRST_MOVE];
        prev_move_button.sensitive =
            widget_sensitivity[SensitivityIndex.PREV_MOVE];
        next_move_button.sensitive =
            widget_sensitivity[SensitivityIndex.NEXT_MOVE];
        last_move_button.sensitive =
            widget_sensitivity[SensitivityIndex.LAST_MOVE];
        history_combo.sensitive = widget_sensitivity[SensitivityIndex.HISTORY];
    }

    [CCode (cname = "G_MODULE_EXPORT pause_game_button_pressed_cb", instance_pos = -1)]
    public void pause_game_button_pressed_cb (Gtk.Widget widget)
    {
        if (game.is_paused)
            game.unpause ();
        else
            game.superpause ();

        Gtk.ToolButton tool_button = (Gtk.ToolButton) pause_button;

        if (game.is_paused)
        {
            tool_button.stock_id = "gtk-media-play";
            tool_button.label = "Start";
            stash_button_sensitivity ();
            undo_button.sensitive = false;
            claim_draw_button.sensitive = false;
            resign_button.sensitive = false;
            first_move_button.sensitive = false;
            prev_move_button.sensitive = false;
            next_move_button.sensitive = false;
            last_move_button.sensitive = false;
            history_combo.sensitive = false;
        }
        else
        {
            tool_button.stock_id = "gtk-media-pause";
            tool_button.label = "Pause";
            revert_button_sensitivity ();
        }
    }

    public void quit_cb ()
>>>>>>> gnome-chess-application-rename
    {
        quit_game ();
    }

    [CCode (cname = "G_MODULE_EXPORT white_time_draw_cb", instance_pos = -1)]
    public bool white_time_draw_cb (Gtk.Widget widget, Cairo.Context c)
    {
        double fg[3] = { 0.0, 0.0, 0.0 };
        double bg[3] = { 1.0, 1.0, 1.0 };

        draw_time (widget, c, make_clock_text (game.clock, Color.WHITE), fg, bg);
        return false;
    }

    [CCode (cname = "G_MODULE_EXPORT black_time_draw_cb", instance_pos = -1)]
    public bool black_time_draw_cb (Gtk.Widget widget, Cairo.Context c)
    {
        double fg[3] = { 1.0, 1.0, 1.0 };
        double bg[3] = { 0.0, 0.0, 0.0 };

        draw_time (widget, c, make_clock_text (game.clock, Color.BLACK), fg, bg);
        return false;
    }

<<<<<<< HEAD
    protected string make_clock_text (ChessClock? clock, Color color)
=======
    private string make_clock_text (ChessClock? clock, Color color)
>>>>>>> gnome-chess-application-rename
    {
        if (clock == null)
            return "∞";

<<<<<<< HEAD
        int used;
        if (color == Color.WHITE)
            used = (int) (game.clock.white_duration / 1000 - game.clock.white_used_in_seconds);
        else
            used = (int) (game.clock.black_duration / 1000 - game.clock.black_used_in_seconds);

        if (used >= 60)
            return "%d:%02d".printf (used / 60, used % 60);
        else
            return ":%02d".printf (used);
=======
        int time;
        if (color == Color.WHITE)
            time = game.clock.white_initial_seconds - game.clock.white_seconds_used;
        else
            time = game.clock.black_initial_seconds - game.clock.black_seconds_used;

        if (time >= 60)
            return "%d:%02d".printf (time / 60, time % 60);
        else
            return ":%02d".printf (time);
>>>>>>> gnome-chess-application-rename
    }

    private void draw_time (Gtk.Widget widget, Cairo.Context c, string text, double[] fg, double[] bg)
    {
        double alpha = 1.0;

<<<<<<< HEAD
        if (widget.get_state () == Gtk.StateType.INSENSITIVE)
=======
        if ((widget.get_state_flags () & Gtk.StateFlags.INSENSITIVE) != 0)
>>>>>>> gnome-chess-application-rename
            alpha = 0.5;
        c.set_source_rgba (bg[0], bg[1], bg[2], alpha);
        c.paint ();

        c.set_source_rgba (fg[0], fg[1], fg[2], alpha);
        c.select_font_face ("fixed", Cairo.FontSlant.NORMAL, Cairo.FontWeight.BOLD);
        c.set_font_size (0.6 * widget.get_allocated_height ());
        Cairo.TextExtents extents;
        c.text_extents (text, out extents);
        c.move_to ((widget.get_allocated_width () - extents.width) / 2 - extents.x_bearing,
                   (widget.get_allocated_height () - extents.height) / 2 - extents.y_bearing);
        c.show_text (text);

        widget.set_size_request ((int) extents.width + 6, -1);
    }

    [CCode (cname = "G_MODULE_EXPORT history_combo_changed_cb", instance_pos = -1)]
    public void history_combo_changed_cb (Gtk.ComboBox combo)
    {
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return;
        int move_number;
        combo.model.get (iter, 1, out move_number, -1);
        if (game == null || move_number == game.n_moves)
            move_number = -1;
        scene.move_number = move_number;
    }

    [CCode (cname = "G_MODULE_EXPORT history_latest_clicked_cb", instance_pos = -1)]
    public void history_latest_clicked_cb (Gtk.Widget widget)
    {
        scene.move_number = -1;
    }

    [CCode (cname = "G_MODULE_EXPORT history_next_clicked_cb", instance_pos = -1)]
    public void history_next_clicked_cb (Gtk.Widget widget)
    {
        if (scene.move_number == -1)
            return;

        int move_number = scene.move_number + 1;
        if (move_number >= game.n_moves)
            scene.move_number = -1;
        else
            scene.move_number = move_number;
    }

    [CCode (cname = "G_MODULE_EXPORT history_previous_clicked_cb", instance_pos = -1)]
    public void history_previous_clicked_cb (Gtk.Widget widget)
    {
        if (scene.move_number == 0)
            return;

        if (scene.move_number == -1)
            scene.move_number = (int) game.n_moves - 1;
        else
            scene.move_number = scene.move_number - 1;
    }

    [CCode (cname = "G_MODULE_EXPORT history_start_clicked_cb", instance_pos = -1)]
    public void history_start_clicked_cb (Gtk.Widget widget)
    {
        scene.move_number = 0;
    }

    [CCode (cname = "G_MODULE_EXPORT toggle_fullscreen_cb", instance_pos = -1)]
    public void toggle_fullscreen_cb (Gtk.Widget widget)
    {
<<<<<<< HEAD
        if (fullscreen_menu.label == Gtk.Stock.FULLSCREEN)
            window.fullscreen ();
        else
            window.unfullscreen ();
    }

    [CCode (cname = "G_MODULE_EXPORT preferences_cb", instance_pos = -1)]
    public void preferences_cb (Gtk.Widget widget)
=======
        if (is_fullscreen)
        {
            ((Gtk.ToolButton) fullscreen_button).stock_id = "gtk-fullscreen";
            window.unfullscreen ();
        }
        else
        {
            ((Gtk.ToolButton) fullscreen_button).stock_id = "gtk-leave-fullscreen";
            window.fullscreen ();
        }
    }

    public void preferences_cb ()
>>>>>>> gnome-chess-application-rename
    {
        if (preferences_dialog != null)
        {
            preferences_dialog.present ();
            return;
        }

        preferences_builder = new Gtk.Builder ();
        try
        {
<<<<<<< HEAD
            preferences_builder.add_from_file (Path.build_filename (Config.PKGDATADIR, "preferences.ui", null));
=======
            preferences_builder.add_from_file (Path.build_filename (PKGDATADIR, "preferences.ui", null));
>>>>>>> gnome-chess-application-rename
        }
        catch (Error e)
        {
            warning ("Could not load preferences UI: %s", e.message);
        }
        preferences_dialog = (Gtk.Dialog) preferences_builder.get_object ("preferences");
<<<<<<< HEAD

        settings_common.bind ("show-numbering", preferences_builder.get_object ("show_numbering_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-move-hints", preferences_builder.get_object ("show_move_hints_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-toolbar", preferences_builder.get_object ("show_toolbar_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-history", preferences_builder.get_object ("show_history_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-3d", preferences_builder.get_object ("show_3d_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings_common.bind ("show-3d-smooth", preferences_builder.get_object ("show_3d_smooth_check"),
                       "active", SettingsBindFlags.DEFAULT);

        var orientation_combo = (Gtk.ComboBox) preferences_builder.get_object ("orientation_combo");
        set_combo (orientation_combo, 1, settings_common.get_string ("board-side"));

        var move_combo = (Gtk.ComboBox) preferences_builder.get_object ("move_format_combo");
        set_combo (move_combo, 1, settings_common.get_string ("move-format"));

        var theme_combo = (Gtk.ComboBox) preferences_builder.get_object ("piece_style_combo");
        set_combo (theme_combo, 1, settings_common.get_string ("piece-theme"));

        preferences_builder.connect_signals (this);

=======
        preferences_dialog.transient_for = window;
        
        settings.bind ("show-numbering", preferences_builder.get_object ("show_numbering_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings.bind ("show-move-hints", preferences_builder.get_object ("show_move_hints_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings.bind ("show-3d", preferences_builder.get_object ("show_3d_check"),
                       "active", SettingsBindFlags.DEFAULT);
        settings.bind ("show-3d-smooth", preferences_builder.get_object ("show_3d_smooth_check"),
                       "active", SettingsBindFlags.DEFAULT);

        side_combo = (Gtk.ComboBox) preferences_builder.get_object ("side_combo");
        side_combo.set_active (settings.get_boolean ("play-as-white") ? 0 : 1);

        var ai_combo = (Gtk.ComboBox) preferences_builder.get_object ("opponent_combo");
        var ai_model = (Gtk.ListStore) ai_combo.model;
        var opponent_name = settings.get_string ("opponent");
        if (opponent_name == "human")
            ai_combo.set_active (0);
        foreach (var p in ai_profiles)
        {
            Gtk.TreeIter iter;
            ai_model.append (out iter);
            ai_model.set (iter, 0, p.name, 1, p.name, -1);
            if (p.name == opponent_name || (opponent_name == "" && ai_combo.get_active () == -1))
                ai_combo.set_active_iter (iter);
        }
        if (ai_combo.get_active () == -1)
        {
            ai_combo.set_active (0);
            settings.set_string ("opponent", "human");
        }

        difficulty_combo = (Gtk.ComboBox) preferences_builder.get_object ("difficulty_combo");
        set_combo (difficulty_combo, 1, settings.get_string ("difficulty"));

        duration_combo = (Gtk.ComboBox) preferences_builder.get_object ("duration_combo");
        duration_adjustment = (Gtk.Adjustment) preferences_builder.get_object ("duration_adjustment");
        custom_duration_box = (Gtk.Container) preferences_builder.get_object ("custom_duration_box");
        custom_duration_units_combo = (Gtk.ComboBox) preferences_builder.get_object ("custom_duration_units_combo");
        set_duration (settings.get_int ("duration"));

        var orientation_combo = (Gtk.ComboBox) preferences_builder.get_object ("orientation_combo");
        set_combo (orientation_combo, 1, settings.get_string ("board-side"));

        var move_combo = (Gtk.ComboBox) preferences_builder.get_object ("move_format_combo");
        set_combo (move_combo, 1, settings.get_string ("move-format"));

        var show_3d_check = (Gtk.CheckButton) preferences_builder.get_object ("show_3d_check");

        var theme_combo = (Gtk.ComboBox) preferences_builder.get_object ("piece_style_combo");
        set_combo (theme_combo, 1, settings.get_string ("piece-theme"));
        theme_combo.sensitive = !show_3d_check.active;

        var show_3d_smooth_check = (Gtk.CheckButton) preferences_builder.get_object ("show_3d_smooth_check");
        show_3d_smooth_check.sensitive = show_3d_check.active;

        preferences_builder.connect_signals (this);

        /* Human vs. human */
        if (ai_combo.get_active () == 0)
        {
            side_combo.sensitive = false;
            difficulty_combo.sensitive = false;
        }

>>>>>>> gnome-chess-application-rename
        preferences_dialog.present ();
    }

    private void set_combo (Gtk.ComboBox combo, int value_index, string value)
    {
        Gtk.TreeIter iter;
        var model = combo.model;
        if (!model.get_iter_first (out iter))
            return;
        do
        {
            string v;
            model.get (iter, value_index, out v, -1);
            if (v == value)
            {
                combo.set_active_iter (iter);
                return;
            }
        } while (model.iter_next (ref iter));
    }

    private string? get_combo (Gtk.ComboBox combo, int value_index)
    {
        string value;
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return null;
        combo.model.get (iter, value_index, out value, -1);
        return value;
    }

<<<<<<< HEAD
=======
    [CCode (cname = "G_MODULE_EXPORT side_combo_changed_cb", instance_pos = -1)]
    public void side_combo_changed_cb (Gtk.ComboBox combo)
    {
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return;
        bool play_as_white;
        combo.model.get (iter, 1, out play_as_white, -1);
        settings.set_boolean ("play-as-white", play_as_white);
    }

    [CCode (cname = "G_MODULE_EXPORT opponent_combo_changed_cb", instance_pos = -1)]
    public void opponent_combo_changed_cb (Gtk.ComboBox combo)
    {
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return;
        string opponent;
        combo.model.get (iter, 1, out opponent, -1);
        settings.set_string ("opponent", opponent);
        bool vs_human = (combo.get_active () == 0);
        side_combo.sensitive = !vs_human;
        difficulty_combo.sensitive = !vs_human;
    }

    [CCode (cname = "G_MODULE_EXPORT difficulty_combo_changed_cb", instance_pos = -1)]
    public void difficulty_combo_changed_cb (Gtk.ComboBox combo)
    {
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return;
        string difficulty;
        combo.model.get (iter, 1, out difficulty, -1);
        settings.set_string ("difficulty", difficulty);
    }

    private void set_duration (int duration, bool simplify = true)
    {
        var model = custom_duration_units_combo.model;
        Gtk.TreeIter iter, max_iter = {};

        /* Find the largest units that can be used for this value */
        int max_multiplier = 0;
        if (model.get_iter_first (out iter))
        {
            do
            {
                int multiplier;
                model.get (iter, 1, out multiplier, -1);
                if (multiplier > max_multiplier && duration % multiplier == 0)
                {
                    max_multiplier = multiplier;
                    max_iter = iter;
                }
            } while (model.iter_next (ref iter));
        }

        /* Set the spin button to the value with the chosen units */
        var value = 0;
        if (max_multiplier > 0)
        {
            value = duration / max_multiplier;
            duration_adjustment.value = value;
            custom_duration_units_combo.set_active_iter (max_iter);
        }

        if (!simplify)
            return;

        model = duration_combo.model;
        if (!model.get_iter_first (out iter))
            return;
        do
        {
            int v;
            model.get (iter, 1, out v, -1);
            if (v == duration || v == -1)
            {
                duration_combo.set_active_iter (iter);
                custom_duration_box.visible = v == -1;
                return;
            }
        } while (model.iter_next (ref iter));
    }

    private int get_duration ()
    {
        Gtk.TreeIter iter;
        if (duration_combo.get_active_iter (out iter))
        {
            int duration;
            duration_combo.model.get (iter, 1, out duration, -1);
            if (duration >= 0)
                return duration;
        }
    
        var magnitude = (int) duration_adjustment.value;
        int multiplier = 1;
        if (custom_duration_units_combo.get_active_iter (out iter))
            custom_duration_units_combo.model.get (iter, 1, out multiplier, -1);
        return magnitude * multiplier;
    }

    private bool save_duration_cb ()
    {
        settings.set_int ("duration", get_duration ());
        Source.remove (save_duration_timeout);
        save_duration_timeout = 0;
        return false;
    }

    [CCode (cname = "G_MODULE_EXPORT duration_changed_cb", instance_pos = -1)]
    public void duration_changed_cb (Gtk.Adjustment adjustment)
    {
        var model = (Gtk.ListStore) custom_duration_units_combo.model;
        Gtk.TreeIter iter;
        /* Set the unit labels to the correct plural form */
        if (model.get_iter_first (out iter))
        {
            do
            {
                int multiplier;
                model.get (iter, 1, out multiplier, -1);
                switch (multiplier)
                {
                case 1:
                    model.set (iter, 0, ngettext (/* Preferences Dialog: Combo box entry for a custom game timer set in seconds */
                                                  "second", "seconds", (ulong) adjustment.value), -1);
                    break;
                case 60:
                    model.set (iter, 0, ngettext (/* Preferences Dialog: Combo box entry for a custom game timer set in minutes */
                                                  "minute", "minutes", (ulong) adjustment.value), -1);
                    break;
                case 3600:
                    model.set (iter, 0, ngettext (/* Preferences Dialog: Combo box entry for a custom game timer set in hours */
                                                  "hour", "hours", (ulong) adjustment.value), -1);
                    break;
                }
            } while (model.iter_next (ref iter));
        }

        save_duration ();
    }

    [CCode (cname = "G_MODULE_EXPORT duration_units_changed_cb", instance_pos = -1)]
    public void duration_units_changed_cb (Gtk.Widget widget)
    {
        save_duration ();
    }

    private void save_duration ()
    {
        /* Delay writing the value as it this event will be generated a lot spinning through the value */
        if (save_duration_timeout != 0)
            Source.remove (save_duration_timeout);
        save_duration_timeout = Timeout.add (100, save_duration_cb);
    }

    [CCode (cname = "G_MODULE_EXPORT duration_combo_changed_cb", instance_pos = -1)]
    public void duration_combo_changed_cb (Gtk.ComboBox combo)
    {
        Gtk.TreeIter iter;
        if (!combo.get_active_iter (out iter))
            return;
        int duration;
        combo.model.get (iter, 1, out duration, -1);
        custom_duration_box.visible = duration < 0;

        if (duration >= 0)
            set_duration (duration, false);
        /* Default to one hour (30 minutes/player) when setting custom duration */
        else if (get_duration () <= 0)
            set_duration (60 * 60, false);

        save_duration ();
    }

>>>>>>> gnome-chess-application-rename
    [CCode (cname = "G_MODULE_EXPORT preferences_response_cb", instance_pos = -1)]
    public void preferences_response_cb (Gtk.Widget widget, int response_id)
    {
        preferences_dialog.hide ();
    }

    [CCode (cname = "G_MODULE_EXPORT preferences_delete_event_cb", instance_pos = -1)]
    public bool preferences_delete_event_cb (Gtk.Widget widget, Gdk.Event event)
    {
        preferences_response_cb (widget, Gtk.ResponseType.CANCEL);
        return true;
    }

    [CCode (cname = "G_MODULE_EXPORT piece_style_combo_changed_cb", instance_pos = -1)]
    public void piece_style_combo_changed_cb (Gtk.ComboBox combo)
    {
<<<<<<< HEAD
        settings_common.set_string ("piece-theme", get_combo (combo, 1));
=======
        settings.set_string ("piece-theme", get_combo (combo, 1));
>>>>>>> gnome-chess-application-rename
    }

    [CCode (cname = "G_MODULE_EXPORT show_3d_toggle_cb", instance_pos = -1)]
    public void show_3d_toggle_cb (Gtk.ToggleButton widget)
    {
        var w = (Gtk.Widget) preferences_builder.get_object ("show_3d_smooth_check");
        w.sensitive = widget.active;

        w = (Gtk.Widget) preferences_builder.get_object ("piece_style_combo");
        w.sensitive = !widget.active;
    }

    [CCode (cname = "G_MODULE_EXPORT move_format_combo_changed_cb", instance_pos = -1)]
    public void move_format_combo_changed_cb (Gtk.ComboBox combo)
    {
<<<<<<< HEAD
        settings_common.set_string ("move-format", get_combo (combo, 1));
=======
        settings.set_string ("move-format", get_combo (combo, 1));
>>>>>>> gnome-chess-application-rename
    }

    [CCode (cname = "G_MODULE_EXPORT orientation_combo_changed_cb", instance_pos = -1)]
    public void orientation_combo_changed_cb (Gtk.ComboBox combo)
    {
<<<<<<< HEAD
        settings_common.set_string ("board-side", get_combo (combo, 1));    
    }

    [CCode (cname = "G_MODULE_EXPORT help_cb", instance_pos = -1)]
    public void help_cb (Gtk.Widget widget)
=======
        settings.set_string ("board-side", get_combo (combo, 1));    
    }

    public void help_cb ()
>>>>>>> gnome-chess-application-rename
    {
        try
        {
            Gtk.show_uri (window.get_screen (), "help:gnome-chess", Gtk.get_current_event_time ());
        }
        catch (Error e)
        {
            warning ("Unable to open help: %s", e.message);
        }
    }

    private const string[] authors = { "Robert Ancell <robert.ancell@gmail.com>", null };
    private const string[] artists = { "John-Paul Gignac (3D Models)", "Max Froumentin (2D Models)", "Hylke Bons <h.bons@student.rug.nl> (icon)", null };

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT about_cb", instance_pos = -1)]
    public void about_cb (Gtk.Widget widget)
=======
    public void about_cb ()
>>>>>>> gnome-chess-application-rename
    {
        if (about_dialog != null)
        {
            about_dialog.present ();
            return;
        }

        about_dialog = new Gtk.AboutDialog ();
        about_dialog.transient_for = window;
        about_dialog.modal = true;
<<<<<<< HEAD
        about_dialog.program_name = "Chess";
        about_dialog.version = Config.VERSION;
        about_dialog.copyright = "Copyright 2010 Robert Ancell <robert.ancell@gmail.com>";
        about_dialog.license_type = Gtk.License.GPL_2_0;
        about_dialog.comments = _("The 2D/3D chess game for GNOME. \n\nGNOME Chess is a part of GNOME Games.");
        about_dialog.authors = authors;
        about_dialog.artists = artists;
        about_dialog.translator_credits = "translator-credits";
=======
        about_dialog.program_name = _("Chess");
        about_dialog.version = VERSION;
        about_dialog.copyright = "Copyright © 2010–2013 Robert Ancell\nCopyright © 2013 Michael Catanzaro";
        about_dialog.license_type = Gtk.License.GPL_2_0;
        about_dialog.comments = _("The 2D/3D chess game for GNOME\n\nGNOME Chess is a part of GNOME Games.");
        about_dialog.authors = authors;
        about_dialog.artists = artists;
        about_dialog.translator_credits = _("translator-credits");
>>>>>>> gnome-chess-application-rename
        about_dialog.website = "http://www.gnome.org/projects/gnome-games/";
        about_dialog.website_label = _("GNOME Games web site");
        about_dialog.logo_icon_name = "gnome-chess";
        about_dialog.response.connect (about_response_cb);
        about_dialog.show ();
    }
    
    private void about_response_cb (int response_id)
    {
        about_dialog.destroy ();
        about_dialog = null;
    }

<<<<<<< HEAD
    [CCode (cname = "G_MODULE_EXPORT save_game_as_cb", instance_pos = -1)]
    public void save_game_as_cb (Gtk.Widget widget)
    {
        save_game ();
    }

=======
>>>>>>> gnome-chess-application-rename
    [CCode (cname = "G_MODULE_EXPORT save_game_cb", instance_pos = -1)]
    public void save_game_cb (Gtk.Widget widget)
    {
        save_game ();
    }

    private void add_info_bar_to_dialog (Gtk.Dialog dialog, out Gtk.InfoBar info_bar, out Gtk.Label label)
    {
        var vbox = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
        vbox.show ();

        info_bar = new Gtk.InfoBar ();
        var content_area = (Gtk.Container) info_bar.get_content_area ();
        vbox.pack_start (info_bar, false, true, 0);

        label = new Gtk.Label ("");
        content_area.add (label);
        label.show ();

        var child = (Gtk.Container) dialog.get_child ();
        child.reparent (vbox);
        child.border_width = dialog.border_width;
        dialog.border_width = 0;
<<<<<<< HEAD
        dialog.add (vbox);
    }

    private void save_game ()
=======

        vbox.set_child_packing (child, true, true, 0, Gtk.PackType.START);
        dialog.add (vbox);
    }
    
    private void save_game (string cancel_button_label = N_("_Cancel"), string save_button_label = N_("_Save"))
>>>>>>> gnome-chess-application-rename
    {
        /* Show active dialog */
        if (save_dialog != null)
        {
<<<<<<< HEAD
            save_dialog.present ();
=======
            save_dialog.run ();
>>>>>>> gnome-chess-application-rename
            return;
        }

        save_dialog = new Gtk.FileChooserDialog (/* Title of save game dialog */
                                                 _("Save Chess Game"),
                                                 window, Gtk.FileChooserAction.SAVE,
<<<<<<< HEAD
                                                 Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
                                                 Gtk.Stock.SAVE, Gtk.ResponseType.OK, null);
=======
                                                 cancel_button_label, Gtk.ResponseType.CANCEL,
                                                 save_button_label, Gtk.ResponseType.OK, null);
>>>>>>> gnome-chess-application-rename
        add_info_bar_to_dialog (save_dialog, out save_dialog_info_bar, out save_dialog_error_label);

        save_dialog.file_activated.connect (save_file_cb);        
        save_dialog.response.connect (save_cb);

<<<<<<< HEAD
=======
        if (saved_filename != null)
            save_dialog.set_filename (saved_filename);
        else
            save_dialog.set_current_name (/* Default filename for the save game dialog */
                                          _("Untitled Chess Game") + ".pgn");

>>>>>>> gnome-chess-application-rename
        /* Filter out non PGN files by default */
        var pgn_filter = new Gtk.FileFilter ();
        gtk_file_filter_set_name (pgn_filter,
                                  /* Save Game Dialog: Name of filter to show only PGN files */
                                  _("PGN files"));
        pgn_filter.add_pattern ("*.pgn");
        save_dialog.add_filter (pgn_filter);

        var all_filter = new Gtk.FileFilter ();
        gtk_file_filter_set_name (all_filter,
                                  /* Save Game Dialog: Name of filter to show all files */
                                  _("All files"));
        all_filter.add_pattern ("*");
        save_dialog.add_filter (all_filter);

<<<<<<< HEAD
        save_dialog.present ();
=======
        save_dialog.run ();
>>>>>>> gnome-chess-application-rename
    }    

    private void save_file_cb ()
    {
        save_cb (Gtk.ResponseType.OK);
    }

<<<<<<< HEAD
=======
    private void update_pgn_time_remaining ()
    {
        if (game.clock != null)
        {
            /* We currently only support simple timeouts */
            uint initial_time = int.parse (pgn_game.time_control);
            uint white_used = game.clock.white_seconds_used;
            uint black_used = game.clock.black_seconds_used;

            pgn_game.white_time_left = (initial_time - white_used).to_string ();
            pgn_game.black_time_left = (initial_time - black_used).to_string ();
        }
    }

>>>>>>> gnome-chess-application-rename
    private void save_cb (int response_id)
    {
        if (response_id == Gtk.ResponseType.OK)
        {
<<<<<<< HEAD
            save_menu.sensitive = false;
=======
            update_pgn_time_remaining ();
>>>>>>> gnome-chess-application-rename

            try
            {
                pgn_game.write (save_dialog.get_file ());
<<<<<<< HEAD
=======
                saved_filename = save_dialog.get_filename ();
                save_button.sensitive = false;
                game_needs_saving = false;
>>>>>>> gnome-chess-application-rename
            }
            catch (Error e)
            {
                save_dialog_error_label.set_text (_("Failed to save game: %s").printf (e.message));
                save_dialog_info_bar.set_message_type (Gtk.MessageType.ERROR);
                save_dialog_info_bar.show ();
                return;
            }
        }

        save_dialog.destroy ();
        save_dialog = null;
        save_dialog_info_bar = null;
        save_dialog_error_label = null;
    }

    [CCode (cname = "G_MODULE_EXPORT open_game_cb", instance_pos = -1)]
    public void open_game_cb (Gtk.Widget widget)
    {
<<<<<<< HEAD
=======
        if (!prompt_save_game (_("Save this game before loading another one?")))
            return;

>>>>>>> gnome-chess-application-rename
        /* Show active dialog */
        if (open_dialog != null)
        {
            open_dialog.present ();
            return;
        }

        open_dialog = new Gtk.FileChooserDialog (/* Title of load game dialog */
                                                 _("Load Chess Game"),
                                                 window, Gtk.FileChooserAction.OPEN,
<<<<<<< HEAD
                                                 Gtk.Stock.CANCEL, Gtk.ResponseType.CANCEL,
                                                 Gtk.Stock.OPEN, Gtk.ResponseType.OK, null);
=======
                                                 _("_Cancel"), Gtk.ResponseType.CANCEL,
                                                 _("_Open"), Gtk.ResponseType.OK, null);
>>>>>>> gnome-chess-application-rename
        add_info_bar_to_dialog (open_dialog, out open_dialog_info_bar, out open_dialog_error_label);

        open_dialog.file_activated.connect (open_file_cb);        
        open_dialog.response.connect (open_cb);

        /* Filter out non PGN files by default */
        var pgn_filter = new Gtk.FileFilter ();
        gtk_file_filter_set_name (pgn_filter,
                                  /* Load Game Dialog: Name of filter to show only PGN files */
                                  _("PGN files"));
        pgn_filter.add_pattern ("*.pgn");
        open_dialog.add_filter (pgn_filter);

        var all_filter = new Gtk.FileFilter ();
        gtk_file_filter_set_name (all_filter,
                                  /* Load Game Dialog: Name of filter to show all files */
                                  _("All files"));
        all_filter.add_pattern ("*");
        open_dialog.add_filter (all_filter);

        open_dialog.present ();
    }
    
    private void open_file_cb ()
    {
        open_cb (Gtk.ResponseType.OK);
    }

    private void open_cb (int response_id)
    {
        if (response_id == Gtk.ResponseType.OK)
        {
            try
            {
<<<<<<< HEAD
                load_game (open_dialog.get_file (), false);
=======
                in_history = false;
                load_game (open_dialog.get_file ());
                saved_filename = open_dialog.get_filename ();
>>>>>>> gnome-chess-application-rename
            }
            catch (Error e)
            {
                open_dialog_error_label.set_text (_("Failed to open game: %s").printf (e.message));
                open_dialog_info_bar.set_message_type (Gtk.MessageType.ERROR);
                open_dialog_info_bar.show ();
                return;
            }
        }

        open_dialog.destroy ();
        open_dialog = null;
        open_dialog_info_bar = null;
        open_dialog_error_label = null;
    }

<<<<<<< HEAD
    private void display_window ()
    {
        if (settings.get_boolean ("fullscreen"))
            window.fullscreen ();
        else if (settings.get_boolean ("maximized"))
            window.maximize ();

        game_vbox.show ();
        window.resize (settings.get_int ("game-screen-width"),
            settings.get_int ("game-screen-height"));

        window.show ();
    }

    private void start_new_game ()
    {
        string opponent_type = settings_common.get_string ("opponent-type");
        if (opponent_type == "remote-player")
        {
            string contact_id = settings_common.get_string ("remote-opponent");
            debug ("Opponent type selected: %s", opponent_type);
            debug ("Contact-id: %s", contact_id);
            debug ("Requested a chess channel to %s. gnome-chess-channel-handler takes charge. Now quitting", contact_id);
            quit_game ();
        }

        else
        {

            if (window == null)
            {
              create_game_window ();
              add_window (window);
            }

            in_history = true;
            game_file = null;

            pgn_game = new PGNGame ();
            var now = new DateTime.now_local ();
            pgn_game.date = now.format ("%Y.%m.%d");
            pgn_game.time = now.format ("%H:%M:%S");
            var duration = settings_common.get_int ("duration");
            if (duration > 0)
                pgn_game.time_control = "%d".printf (duration);

            if (settings_common.get_string ("opponent-type") == "robot")
            {
                var engine_name = settings_common.get_string ("opponent");
                var engine_level = settings_common.get_string ("difficulty");
                if (engine_name != null)
                {
                    if (settings_common.get_boolean ("play-as-white"))
                    {
                        pgn_game.tags.insert ("BlackAI", engine_name);
                        pgn_game.tags.insert ("BlackLevel", engine_level);
                    }
                    else
                    {
                        pgn_game.tags.insert ("WhiteAI", engine_name);
                        pgn_game.tags.insert ("WhiteLevel", engine_level);
                    }
                }
            }

            start_game ();

            display_window ();
            if (launcher != null)
              launcher.destroy ();

        }
    }

    [CCode (cname = "load_game_handler", instance_pos = -1)]
    private void load_game_handler (ChessLauncher launcher,
        File file,
        bool from_history)
    {
        try
        {
            load_game (file, from_history);
        }
        catch (Error e)
        {
           stderr.printf ("Error loading pgn from file: %s", e.message);
        }
    }

    private void load_game (File file, bool from_history) throws Error
    {
        if (window == null)
        {
          create_game_window ();
          add_window (window);
        }

=======
    private void start_new_game ()
    {
        in_history = false;
        game_file = null;

        pgn_game = new PGNGame ();
        var now = new DateTime.now_local ();
        pgn_game.date = now.format ("%Y.%m.%d");
        pgn_game.time = now.format ("%H:%M:%S");
        var duration = settings.get_int ("duration");
        if (duration > 0)
        {
            pgn_game.time_control = (duration / 2).to_string ();
            pgn_game.white_time_left = (duration / 2).to_string ();
            pgn_game.black_time_left = (duration / 2).to_string ();
        }
        var engine_name = settings.get_string ("opponent");
        if (engine_name == "")
        {
            if (ai_profiles != null)
                engine_name = ai_profiles.data.name;
            else
                engine_name = "human";
        }
        var engine_level = settings.get_string ("difficulty");
        if (engine_name != null && engine_name != "human")
        {
            if (settings.get_boolean ("play-as-white"))
            {
                pgn_game.black_ai = engine_name;
                pgn_game.black_level = engine_level;
            }
            else
            {
                pgn_game.white_ai = engine_name;
                pgn_game.white_level = engine_level;
            }
        }

        start_game ();
    }

    private void load_game (File file) throws Error
    {
>>>>>>> gnome-chess-application-rename
        var pgn = new PGN.from_file (file);
        pgn_game = pgn.games.nth_data (0);

        game_file = file;
<<<<<<< HEAD
        in_history = from_history;
        start_game ();

        display_window ();
        if (launcher != null)
          launcher.destroy ();
    }
}


=======
        start_game ();
    }
}
>>>>>>> gnome-chess-application-rename