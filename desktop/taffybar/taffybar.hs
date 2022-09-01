import Data.Default (def)
import System.Taffybar (dyreTaffybar)
import System.Taffybar.Hooks
import System.Taffybar.SimpleConfig
import System.Taffybar.Widget

main =
  let myWorkspacesConfig =
        def
          { minIcons = 1,
            widgetGap = 1,
            showWorkspaceFn = hideEmpty
          }
      workspaces = workspacesNew myWorkspacesConfig
      clockFormat = "%a %x %k:%M"
      clock = textClockNewWith $ ClockConfig Nothing Nothing clockFormat $ ConstantInterval 10
      layout = layoutNew def
      windowsW = windowsNew def
      tray = sniTrayNew
      myConfig =
        def
          { startWidgets =
              workspaces : map (>>= buildContentsBox) [layout, windowsW],
            endWidgets =
              map
                (>>= buildContentsBox)
                [ batteryIconNew,
                  clock,
                  tray,
                  mpris2New
                ],
            barPosition = Top,
            barPadding = 10,
            barHeight = ExactSize 50,
            widgetSpacing = 0
          }
   in dyreTaffybar $
        withBatteryRefresh . withLogServer . withToggleServer $
          toTaffyConfig myConfig
