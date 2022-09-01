import System.Taffybar.Support.PagerHints (pagerHints)
import XMonad
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.FadeInactive
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Util.EZConfig (additionalKeys)

main =
  xmonad . ewmh . pagerHints $
    myBaseConfig
      { terminal = myTerminal,
        modMask = myModKey,
        logHook = myLogHook,
        layoutHook = myLayoutHook,
        focusedBorderColor = "#ffffff",
        normalBorderColor = "#cccccc",
        borderWidth = 2
      }
      `additionalKeys` myKeys

myTerminal = "alacritty"

myBaseConfig = desktopConfig

myModKey = mod4Mask

myKeys = [((myModKey .|. shiftMask, xK_t), spawn myTerminal)]

myLogHook = do
  logHook myBaseConfig
  fadeInactiveLogHook 0.8

myLayoutHook = smartSpacing 2 $ smartBorders $ layoutHook myBaseConfig
