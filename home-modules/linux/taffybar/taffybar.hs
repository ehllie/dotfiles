import System.Taffybar (startTaffybar)
import System.Taffybar.Hooks
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget

main =
  let workspaces =
        workspacesNew
          defaultWorkspacesConfig
            { widgetGap = 1
            , showWorkspaceFn = hideEmpty
            }
      clock =
        textClockNewWith $
          ClockConfig
            { clockTimeZone = Nothing
            , clockTimeLocale = Nothing
            , clockFormatString = "%k:%M | %a %e %b"
            , clockUpdateStrategy = ConstantInterval 10
            }
      window = windowsNew defaultWindowsConfig
      tray = sniTrayNew
      battery = map (>>= buildContentsBox) [batteryIconNew, batteryText]
       where
        batteryText = textBatteryNew "$percentage$%"
   in startTaffybar
        . withBatteryRefresh
        . withLogServer
        . withToggleServer
        . toTaffyConfig
        $ defaultSimpleTaffyConfig
          { startWidgets = [workspaces]
          , centerWidgets = [window]
          , endWidgets = battery ++ map (>>= buildContentsBox) [clock, tray, mpris2New]
          , barHeight = ExactSize 50
          , barPadding = 2
          , widgetSpacing = 5
          }
