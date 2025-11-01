{ pkgs, ... }:
{
  home.packages = [
    pkgs.polonium
  ];
  programs.plasma = {
    enable = true;
    shortcuts = {
      "ActivityManager"."switch-to-activity-beed01d4-62f4-488b-9c1c-295b977c8625" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Last-Used Keyboard Layout" = [ ];
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = [ ];
      "kaccess"."Toggle Screen Reader On and Off" = [ ];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."decrease_volume_small" = "Shift+Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."increase_volume_small" = "Shift+Volume Up";
      "kmix"."mic_mute" = "Microphone Mute";
      "kmix"."mute" = "Volume Mute";

      "ksmserver"."Halt Without Confirmation" = [ ];
      "ksmserver"."Lock Session" = "Ctrl+Meta+Shift+L";
      "ksmserver"."Log Out" = "Meta+Ctrl+F4";
      "ksmserver"."Log Out Without Confirmation" = [ ];
      "ksmserver"."LogOut" = [ ];
      "ksmserver"."Reboot" = [ ];
      "ksmserver"."Reboot Without Confirmation" = [ ];
      "ksmserver"."Shut Down" = "Meta+Ctrl+F7";

      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Cycle Overview" = [ ];
      "kwin"."Cycle Overview Opposite" = [ ];
      "kwin"."Decrease Opacity" = [ ];
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Meta+Ctrl+F9";
      "kwin"."ExposeAll" = "Meta+Ctrl+F10";
      "kwin"."ExposeClass" = "Meta+Ctrl+F7";
      "kwin"."ExposeClassCurrentDesktop" = [ ];
      "kwin"."Grid View" = "Meta+Ctrl+F8";
      "kwin"."Increase Opacity" = [ ];
      "kwin"."Kill Window" = "Meta+Alt+F4";
      "kwin"."Move Tablet to Next Output" = [ ];
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."MoveZoomDown" = [ ];
      "kwin"."MoveZoomLeft" = [ ];
      "kwin"."MoveZoomRight" = [ ];
      "kwin"."MoveZoomUp" = [ ];
      "kwin"."Overview" = "Meta+F9";

      "kwin"."PoloniumCycleEngine" = [ ];
      "kwin"."PoloniumFocusAbove" = "Meta+K";
      "kwin"."PoloniumFocusBelow" = "Meta+J";
      "kwin"."PoloniumFocusLeft" = "Meta+H";
      "kwin"."PoloniumFocusRight" = "Meta+L";
      "kwin"."PoloniumInsertAbove" = "Meta+Shift+K,none,Polonium: Insert Above";
      "kwin"."PoloniumInsertBelow" = "Meta+Shift+J,none,Polonium: Insert Below";
      "kwin"."PoloniumInsertLeft" = "Meta+Shift+H,none,Polonium: Insert Left";
      "kwin"."PoloniumInsertRight" = "Meta+Shift+L,none,Polonium: Insert Right";
      "kwin"."PoloniumOpenSettings" = "Meta+\\\\,none,Polonium: Open Settings Dialog";
      # "kwin"."PoloniumResizeAbove" = "Meta+Ctrl+K,none,Polonium: Resize Above";
      # "kwin"."PoloniumResizeBelow" = "Meta+Ctrl+J,none,Polonium: Resize Below";
      # "kwin"."PoloniumResizeLeft" = "Meta+Ctrl+H,none,Polonium: Resize Left";
      # "kwin"."PoloniumResizeRight" = "Meta+Ctrl+L,none,Polonium: Resize Right";
      "kwin"."PoloniumRetileWindow" = "Meta+Shift+Space,none,Polonium: Retile Window";
      "kwin"."PoloniumSwitchBTree" = ",none,Polonium: Use Binary Tree Engine";
      "kwin"."PoloniumSwitchHalf" = ",none,Polonium: Use Half Engine";
      "kwin"."PoloniumSwitchKwin" = ",none,Polonium: Use KWin Engine";
      "kwin"."PoloniumSwitchMonocle" = ",none,Polonium: Use Monocle Engine";
      "kwin"."PoloniumSwitchThreeColumn" = ",none,Polonium: Use Three Column Engine";

      "kwin"."Setup Window Shortcut" = "none,,Setup Window Shortcut";
      "kwin"."Show Desktop" = "Meta+D";

      # Desktop switching (Sway: Meta+1..0)
      "kwin"."Switch One Desktop Down" = "Meta+Ctrl+Down";
      "kwin"."Switch One Desktop Up" = "Meta+Ctrl+Up";
      "kwin"."Switch One Desktop to the Left" = "Meta+Ctrl+Left";
      "kwin"."Switch One Desktop to the Right" = "Meta+Ctrl+Right";

      "kwin"."Switch Window Left" = [
        "Meta+Alt+Shift+Left"
        "Meta+Alt+Shift+H"
      ];
      "kwin"."Switch Window Down" = [
        "Meta+Alt+Shift+Down"
        "Meta+Alt+Shift+J"
      ];
      "kwin"."Switch Window Up" = [
        "Meta+Alt+Shift+Up"
        "Meta+Alt+Shift+K"
      ];
      "kwin"."Switch Window Right" = [
        "Meta+Alt+Shift+Right"
        "Meta+Alt+Shift+L"
      ];

      # Numbered desktops (Sway parity)
      "kwin"."Switch to Desktop 1" = "Meta+1";
      "kwin"."Switch to Desktop 2" = "Meta+2";
      "kwin"."Switch to Desktop 3" = "Meta+3";
      "kwin"."Switch to Desktop 4" = "Meta+4";
      "kwin"."Switch to Desktop 5" = "Meta+5";
      "kwin"."Switch to Desktop 6" = "Meta+6";
      "kwin"."Switch to Desktop 7" = "Meta+7";
      "kwin"."Switch to Desktop 8" = "Meta+8";
      "kwin"."Switch to Desktop 9" = "Meta+9";
      "kwin"."Switch to Desktop 10" = "Meta+0";
      "kwin"."Switch to Desktop 11" = "none,,Switch to Desktop 11";
      "kwin"."Switch to Desktop 12" = "none,,Switch to Desktop 12";
      "kwin"."Switch to Desktop 13" = "none,,Switch to Desktop 13";
      "kwin"."Switch to Desktop 14" = "none,,Switch to Desktop 14";
      "kwin"."Switch to Desktop 15" = "none,,Switch to Desktop 15";
      "kwin"."Switch to Desktop 16" = "none,,Switch to Desktop 16";
      "kwin"."Switch to Desktop 17" = "none,,Switch to Desktop 17";
      "kwin"."Switch to Desktop 18" = "none,,Switch to Desktop 18";
      "kwin"."Switch to Desktop 19" = "none,,Switch to Desktop 19";
      "kwin"."Switch to Desktop 20" = "none,,Switch to Desktop 20";

      "kwin"."Switch to Next Desktop" = "Meta+P"; # Sway: Meta+p
      "kwin"."Switch to Previous Desktop" = "Meta+O"; # Sway: Meta+o

      "kwin"."Switch to Previous Screen" = "Meta+BracketLeft";
      "kwin"."Switch to Next Screen" = "Meta+BracketRight";
      "kwin"."Window to Previous Screen" = [
        "Meta+Shift+Left"
        "Meta+Shift+BracketLeft"
      ];
      "kwin"."Window to Next Screen" = [
        "Meta+Shift+Right"
        "Meta+Shift+BracketRight"
      ];

      "kwin"."Switch to Screen 0" = "none,,Switch to Screen 0";
      "kwin"."Switch to Screen 1" = "none,,Switch to Screen 1";
      "kwin"."Switch to Screen 2" = "none,,Switch to Screen 2";
      "kwin"."Switch to Screen 3" = "none,,Switch to Screen 3";
      "kwin"."Switch to Screen 4" = "none,,Switch to Screen 4";
      "kwin"."Switch to Screen 5" = "none,,Switch to Screen 5";
      "kwin"."Switch to Screen 6" = "none,,Switch to Screen 6";
      "kwin"."Switch to Screen 7" = "none,,Switch to Screen 7";
      "kwin"."Switch to Screen Above" = "none,,Switch to Screen Above";
      "kwin"."Switch to Screen Below" = "none,,Switch to Screen Below";
      "kwin"."Switch to Screen to the Left" = "none,,Switch to Screen to the Left";
      "kwin"."Switch to Screen to the Right" = "none,,Switch to Screen to the Right";

      "kwin"."Toggle Night Color" = [ ];
      "kwin"."Toggle Window Raise/Lower" = "none,,Toggle Window Raise/Lower";

      "kwin"."Walk Through Windows" = [
        "Meta+Tab"
        ""
        "Alt+Tab\\, ,Meta+Tab"
        "Alt+Tab,Walk Through Windows"
      ];
      "kwin"."Walk Through Windows (Reverse)" = [
        "Meta+Shift+Tab"
        ""
        "Alt+Shift+Tab\\, ,Meta+Shift+Tab"
        "Alt+Shift+Tab,Walk Through Windows (Reverse)"
      ];
      "kwin"."Walk Through Windows Alternative" = [ ];
      "kwin"."Walk Through Windows Alternative (Reverse)" = [ ];
      "kwin"."Walk Through Windows of Current Application" = [
        "Meta+`"
        ""
        "Alt+`\\, ,Meta+`"
        "Alt+`,Walk Through Windows of Current Application"
      ];
      "kwin"."Walk Through Windows of Current Application (Reverse)" = [
        "Meta+~"
        ""
        "Alt+~\\, ,Meta+~"
        "Alt+~,Walk Through Windows of Current Application (Reverse)"
      ];
      "kwin"."Walk Through Windows of Current Application Alternative" = [ ];
      "kwin"."Walk Through Windows of Current Application Alternative (Reverse)" = [ ];

      "kwin"."Window Above Other Windows" = "none,,Keep Window Above Others";
      "kwin"."Window Below Other Windows" = "none,,Keep Window Below Others";

      # Close / Kill (Sway: Alt+F4, Meta+F4, Meta+Alt+F4)
      "kwin"."Window Close" = [
        "Alt+F4"
        "Meta+F4"
        "Meta+Alt+F4"
      ];

      "kwin"."Window Custom Quick Tile Bottom" = "none,,Custom Quick Tile Window to the Bottom";
      "kwin"."Window Custom Quick Tile Left" = "none,,Custom Quick Tile Window to the Left";
      "kwin"."Window Custom Quick Tile Right" = "none,,Custom Quick Tile Window to the Right";
      "kwin"."Window Custom Quick Tile Top" = "none,,Custom Quick Tile Window to the Top";

      # Fullscreen (Sway: Meta+Shift+F11)
      "kwin"."Window Fullscreen" = "Meta+Shift+F11";

      "kwin"."Window Grow Horizontal" = "none,,Expand Window Horizontally";
      "kwin"."Window Grow Vertical" = "none,,Expand Window Vertically";
      "kwin"."Window Lower" = "none,,Lower Window";
      "kwin"."Window Maximize" = "Meta+PgUp";
      "kwin"."Window Maximize Horizontal" = "none,,Maximise Window Horizontally";
      "kwin"."Window Maximize Vertical" = "none,,Maximise Window Vertically";
      "kwin"."Window Minimize" = "Meta+PgDown";
      "kwin"."Window Move" = "none,,Move Window";
      "kwin"."Window Move Center" = "none,,Move Window to the Centre";
      "kwin"."Window No Border" = "none,,Toggle Window Titlebar and Frame";
      "kwin"."Window On All Desktops" = "none,,Keep Window on All Desktops";

      # Move window to numbered desktops (Sway: Meta+Shift+1..0)
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window One Screen Down" = "none,,Move Window One Screen Down";
      "kwin"."Window One Screen Up" = "none,,Move Window One Screen Up";
      "kwin"."Window One Screen to the Left" = "none,,Move Window One Screen to the Left";
      "kwin"."Window One Screen to the Right" = "none,,Move Window One Screen to the Right";
      "kwin"."Window Operations Menu" = "Alt+F3";
      "kwin"."Window Pack Down" = "none,,Move Window Down";
      "kwin"."Window Pack Left" = "none,,Move Window Left";
      "kwin"."Window Pack Right" = "none,,Move Window Right";
      "kwin"."Window Pack Up" = "none,,Move Window Up";

      "kwin"."Window Quick Tile Bottom" = "Meta+Down";
      "kwin"."Window Quick Tile Bottom Left" = "none,,Quick Tile Window to the Bottom Left";
      "kwin"."Window Quick Tile Bottom Right" = "none,,Quick Tile Window to the Bottom Right";
      "kwin"."Window Quick Tile Left" = "Meta+Left";
      "kwin"."Window Quick Tile Right" = "Meta+Right";
      "kwin"."Window Quick Tile Top" = "Meta+Up";
      "kwin"."Window Quick Tile Top Left" = "none,,Quick Tile Window to the Top Left";
      "kwin"."Window Quick Tile Top Right" = "none,,Quick Tile Window to the Top Right";
      "kwin"."Window Raise" = "none,,Raise Window";
      "kwin"."Window Resize" = "none,,Resize Window";
      "kwin"."Window Shade" = "none,,Shade Window";
      "kwin"."Window Shrink Horizontal" = "none,,Shrink Window Horizontally";
      "kwin"."Window Shrink Vertical" = "none,,Shrink Window Vertically";

      "kwin"."Window to Desktop 1" = "Meta+Shift+1";
      "kwin"."Window to Desktop 2" = "Meta+Shift+2";
      "kwin"."Window to Desktop 3" = "Meta+Shift+3";
      "kwin"."Window to Desktop 4" = "Meta+Shift+4";
      "kwin"."Window to Desktop 5" = "Meta+Shift+5";
      "kwin"."Window to Desktop 6" = "Meta+Shift+6";
      "kwin"."Window to Desktop 7" = "Meta+Shift+7";
      "kwin"."Window to Desktop 8" = "Meta+Shift+8";
      "kwin"."Window to Desktop 9" = "Meta+Shift+9";
      "kwin"."Window to Desktop 10" = "Meta+Shift+0";
      "kwin"."Window to Desktop 11" = "none,,Window to Desktop 11";
      "kwin"."Window to Desktop 12" = "none,,Window to Desktop 12";
      "kwin"."Window to Desktop 13" = "none,,Window to Desktop 13";
      "kwin"."Window to Desktop 14" = "none,,Window to Desktop 14";
      "kwin"."Window to Desktop 15" = "none,,Window to Desktop 15";
      "kwin"."Window to Desktop 16" = "none,,Window to Desktop 16";
      "kwin"."Window to Desktop 17" = "none,,Window to Desktop 17";
      "kwin"."Window to Desktop 18" = "none,,Window to Desktop 18";
      "kwin"."Window to Desktop 19" = "none,,Window to Desktop 19";
      "kwin"."Window to Desktop 20" = "none,,Window to Desktop 20";

      "kwin"."Window to Next Desktop" = "none,,Window to Next Desktop";

      # Already set above with brackets for parity; keep arrow bindings too
      # "kwin"."Window to Next Screen" / "Previous Screen" overridden as arrays above

      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = [
        "Meta++"
        ""
        "Meta+=\\, Zoom In,Meta++"
        "Meta+=,Zoom In"
      ];
      "kwin"."view_zoom_out" = "Meta+-";

      # Media controls & brightness (parity with Sway XF86 keys)
      "mediacontrol"."mediavolumedown" = "none,,Media volume down";
      "mediacontrol"."mediavolumeup" = "none,,Media volume up";
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = "none,,Play media playback";
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";

      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness Small" = "Shift+Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness Small" = "Shift+Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Meta+Ctrl+F6"; # Sway: Meta+Ctrl+F6 suspend
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [ ];
      "org_kde_powerdevil"."powerProfile" = [
        "Battery"
        ""
        "Meta+B\\, ,Battery"
        "Meta+B,Switch Power Profile"
      ];

      # Launcher (Sway: Meta+R)
      "plasmashell"."activate application launcher" = "Meta+R";

      # Free number keys for desktops (unset Task Manager entries 1..9)
      "plasmashell"."activate task manager entry 1" = "none,,Activate Task Manager Entry 1";
      "plasmashell"."activate task manager entry 2" = "none,,Activate Task Manager Entry 2";
      "plasmashell"."activate task manager entry 3" = "none,,Activate Task Manager Entry 3";
      "plasmashell"."activate task manager entry 4" = "none,,Activate Task Manager Entry 4";
      "plasmashell"."activate task manager entry 5" = "none,,Activate Task Manager Entry 5";
      "plasmashell"."activate task manager entry 6" = "none,,Activate Task Manager Entry 6";
      "plasmashell"."activate task manager entry 7" = "none,,Activate Task Manager Entry 7";
      "plasmashell"."activate task manager entry 8" = "none,,Activate Task Manager Entry 8";
      "plasmashell"."activate task manager entry 9" = "none,,Activate Task Manager Entry 9";
      "plasmashell"."activate task manager entry 10" = "none,,Activate Task Manager Entry 10";

      "plasmashell"."clear-history" = "none,,Clear Clipboard History";
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = "none,,Next History Item";
      "plasmashell"."cyclePrevAction" = "none,,Previous History Item";
      "plasmashell"."edit_clipboard" = "none,,Edit Contents…";
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+A\\, \\, ,none,Walk through activities";
      "plasmashell"."previous activity" = "Meta+Shift+A\\, \\, ,none,Walk through activities (Reverse)";
      "plasmashell"."repeat_action" = "none,,Manually Invoke Action on Current Clipboard";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = "none,,Show Barcode…";
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = "none,,Switch to Next Activity";
      "plasmashell"."switch to previous activity" = "none,,Switch to Previous Activity";
      "plasmashell"."toggle do not disturb" = "none,,Toggle do not disturb";
    };

    configFile = {
      "baloofilerc"."General"."dbVersion" = 2;
      "baloofilerc"."General"."exclude filters" =
        "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.tfstate*,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,.terraform,.venv,venv,core-dumps,lost+found";
      "baloofilerc"."General"."exclude filters version" = 9;
      "dolphinrc"."General"."ViewPropsTimestamp" = "2024,12,30,13,25,16.366";
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "kactivitymanagerdrc"."activities"."beed01d4-62f4-488b-9c1c-295b977c8625" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "beed01d4-62f4-488b-9c1c-295b977c8625";
      "kded5rc"."Module-device_automounter"."autoload" = false;
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = false;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = false;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Preview" = false;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = false;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Date";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = true;
      "kdeglobals"."KFileDialog Settings"."Speedbar Width" = 165;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."WM"."activeBackground" = "227,229,231";
      "kdeglobals"."WM"."activeBlend" = "227,229,231";
      "kdeglobals"."WM"."activeForeground" = "35,38,41";
      "kdeglobals"."WM"."inactiveBackground" = "239,240,241";
      "kdeglobals"."WM"."inactiveBlend" = "239,240,241";
      "kdeglobals"."WM"."inactiveForeground" = "112,125,138";
      "kwalletrc"."Wallet"."Default Wallet" = "Default";
      "kwalletrc"."Wallet"."First Use" = false;

      # Increase desktops to 10 for Meta+1..0
      "kwinrc"."Desktops"."Id_1" = "7af96390-22a0-41a8-983d-acc8a0296297";
      "kwinrc"."Desktops"."Number" = 10;
      "kwinrc"."Desktops"."Rows" = 1;

      "kwinrc"."Plugins"."poloniumEnabled" = true;
      "kwinrc"."Script-polonium"."Debug" = true;
      "kwinrc"."Script-polonium"."TilePopups" = true;
      "kwinrc"."Tiling"."padding" = 4;
      "kwinrc"."Tiling/7af96390-22a0-41a8-983d-acc8a0296297/af48f9e3-77a2-4aa3-8127-1d9f4c505768"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[]}";
      "kwinrc"."Tiling/7af96390-22a0-41a8-983d-acc8a0296297/b8d2f7d4-662d-4634-ad91-3033d0f6a716"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[]}";
      "kwinrc"."Tiling/7af96390-22a0-41a8-983d-acc8a0296297/c9d2da78-0c5d-4433-b15a-dcb021a96e2b"."tiles" =
        "{\"layoutDirection\":\"horizontal\",\"tiles\":[{\"width\":0.25},{\"width\":0.5},{\"width\":0.25}]}";
      "kwinrc"."Windows"."ElectricBorders" = 2;
      "kwinrc"."Xwayland"."Scale" = 1;
      "plasma-localerc"."Formats"."LANG" = "en_GB.UTF-8";
      "spectaclerc"."ImageSave"."translatedScreenshotsFolder" = "Screenshots";
      "spectaclerc"."VideoSave"."translatedScreencastsFolder" = "Screencasts";
    };

    dataFile = {

    };
  };
}
