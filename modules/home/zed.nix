{
  inputs,
  config,
  pkgs,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  #home.file.".config/zed/settings.json".source =
  #  symlink "${config.home.homeDirectory}/sync/config/zed/settings.json";
  #home.file.".config/zed/keymap.json".source =
  #  symlink "${config.home.homeDirectory}/sync/config/zed/keymap.json";
  #home.file.".config/zed/themes/stylix.json".source =
  #  symlink "${config.home.homeDirectory}/sync/config/zed/themes/stylix.json";

  #home.packages = [ pkgs.zed-editor-fhs ];

  programs.zed-editor = {
    enable = true; # Use settings in ~/sync/config for live updating.
    package = pkgs.zed-editor-fhs;
    extensions = [
      "html"
      "toml"
      "astro"
      "git-firefly"
      "html"
      "lua"
      "nix"
      "sql"
      "latex"
      "make"
      "ini"
      "fish"
      "catppuccin-icons"
      "l" # python LSP
      "haskell"
      "typst"
      "markdown-oxide" # For obsidian.
      "unicode"
    ];
    extraPackages = [ ];
    installRemoteServer = false;
    userKeymaps = [
      {
        "context" = "not_editing || vim_mode == normal";
        "bindings" = {
          "space f f" = "file_finder::Toggle";
          "space f c" = "pane::DeploySearch";
          "space f d" = "workspace::Open";
          "space g s" = "git_panel::OpenMenu";
          "space g g" = "git_panel::OpenMenu";
          "space d g" = "editor::GoToDefinition";
          "space w /" = "pane::SplitVertical";
          "space w s" = "pane::SplitHorizontal";
          "space w l" = "workspace::ActivatePaneRight";
          "space w h" = "workspace::ActivatePaneLeft";
          "space w k" = "workspace::ActivatePaneUp";
          "space w j" = "workspace::ActivatePaneDown";
          "space t d" = "debugger::ToggleExpandItem";
          "space t a" = "agent::ToggleFocus";
          "space t o" = "outline::Toggle";
          "space t l" = "lsp_tool::ToggleMenu";
          "space t t" = "terminal_panel::ToggleFocus";
          "space t g" = "git_panel::ToggleFocus";
          "space p o" = "projects::OpenRecent";
          "space p r" = "projects::OpenRemote";
          "space p p" = "project_panel::ToggleFocus";
        };
      }
      {
        "context" = "";
        "bindings" = {
          "alt-x" = "command_palette::Toggle";
          "ctrl-l" = "workspace::ActivatePaneRight";
          "ctrl-h" = "workspace::ActivatePaneLeft";
          "ctrl-k" = "workspace::ActivatePaneUp";
          "ctrl-j" = "workspace::ActivatePaneDown";
        };
      }
      {
        "context" = "Editor";
        "bindings" = {
          "ctrl-s" = "workspace::Save";
          "space ;" = "editor::ToggleComments";
        };
      }
    ];

  userSettings = {
    auto_update = false;

    sticky_scroll = {
      enabled = true;
    };

    which_key = {
      delay_ms = 200;
      enabled = true;
    };

    autosave = "on_focus_change";
    base_keymap = "VSCode";
    redact_private_values = true;
    on_last_window_closed = "quit_app";
    #theme = "Ayu Dark";

    active_pane_modifiers = {
      border_size = 0;
      inactive_opacity = 1;
    };

    search = {
      button = true;
      case_sensitive = false;
      include_ignored = false;
      regex = true;
      whole_word = false;
    };

    search_wrap = true;
    seed_search_query_from_cursor = "always";
    selection_highlight = true;
    server_url = "https://zed.dev";
    show_call_status_icon = true;
    show_completion_documentation = true;
    show_completions_on_input = true;
    show_edit_predictions = true;
    show_signature_help_after_edits = false;
    show_whitespaces = "selection";
    show_wrap_guides = true;

    slash_commands = {
      docs = { enabled = false; };
      project = { enabled = false; };
    };

    snippet_sort_order = "inline";
    soft_wrap = "editor_width";
    ssh_connections = [ ];
    stable = { };

    tabs = {
      activate_on_close = "history";
      close_position = "right";
      file_icons = false;
      git_status = false;
      show_close_button = "hover";
    };

    tasks = {
      enabled = true;
      variables = { };
    };

    telemetry = {
      diagnostics = false;
      metrics = false;
    };

    terminal = {
      alternate_scroll = "on";
      blinking = "terminal_controlled";
      button = true;
      copy_on_select = false;
      cursor_shape = null;
      default_height = 320;
      default_width = 640;
      detect_venv = {
        on = {
          activate_script = "default";
          directories = [
            ".env"
            "env"
            ".venv"
            "venv"
          ];
        };
      };
      dock = "bottom";
      env = { };
      line_height = "comfortable";
      option_as_meta = false;
      scrollbar = {
        show = null;
      };
    };

    title_bar = {
      show_branch_icon = false;
      show_branch_name = true;
      show_onboarding_banner = true;
      show_project_items = true;
      show_user_picture = true;
    };

    toolbar = {
      agent_review = true;
      breadcrumbs = true;
      quick_actions = true;
      selections_menu = true;
    };

    unnecessary_code_fade = 0.3;
    use_auto_surround = true;
    use_autoclose = true;
    use_on_type_format = true;
    use_smartcase_search = false;
    use_system_path_prompts = false;
    use_system_prompts = false;
    vertical_scroll_margin = 3;

    vim = {
      cursor_shape = { };
      custom_digraphs = { };
      default_mode = "normal";
      highlight_on_yank_duration = 200;
      toggle_relative_line_numbers = false;
      use_smartcase_find = false;
      use_system_clipboard = "always";
    };

    vim_mode = true;
    when_closing_with_no_tabs = "keep_window_open";
    wrap_guides = [ ];

    git = {
      git_gutter = "tracked_files";
      gutter_debounce = 500;
      inline_blame.delay_ms = 1000;
    };

    load_direnv = "shell_hook";
    session.restore_unsaved_buffers = true;

    features = {
      edit_prediction_provider = "zed";
    };

    relative_line_numbers = "disabled";
    scroll_beyond_last_line = "one_page";

    inlay_hints = {
      show_type_hints = true;
      show_other_hints = true;
      edit_debounce_ms = 500;
    };

    edit_predictions = {
      mode = "eager";
      disabled_globs = [
        "**/*.journal"
      ];
    };

    lsp = {
      unicode = {
        settings = {
          include_all_symbols = "all";
        };
      };
      tinymist = {
        settings = {
          exportPdf = "onSave";
          outputPath = "$root/$name";
        };
      };
    };
  };
  };
  #programs.zed-editor-extensions = {
  #  enable = false;
  #  packages = with pkgs.nix-zed-extensions; [
  #    nix
  #    unicode
  #  ];
  #};
}
