import Graphics.X11.ExtraTypes.XF86
import System.Taffybar.Support.PagerHints (pagerHints)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh)
import XMonad.Hooks.FadeInactive
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Util.EZConfig (additionalKeys, removeKeys)

main =
  let toAdd conf@XConfig{modMask = modm, terminal = term} =
        additionalKeys
          conf
          [ ((modm .|. shiftMask, xK_t), spawn term)
          , -- Workspace navigation
            ((modm .|. controlMask, xK_Left), prevWS)
          , ((modm .|. controlMask, xK_Right), nextWS)
          , ((modm .|. controlMask, xK_Down), moveTo Next emptyWS)
          , ((modm .|. controlMask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
          , ((modm .|. controlMask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
          , ((modm, xK_space), spawn "rofi -show drun")
          , ((0, xF86XK_AudioRaiseVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%")
          , ((0, xF86XK_AudioLowerVolume), spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%")
          , ((0, xF86XK_AudioMute), spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")
          ]
      toRemove conf@XConfig{modMask = modm} =
        removeKeys
          conf
          [ (modm, xK_p)
          , (modm, xK_q)
          , (modm .|. shiftMask, xK_Return)
          , (modm .|. shiftMask, xK_p)
          ]
      logHook' = do
        logHook desktopConfig
        fadeInactiveLogHook 0.8
      layoutHook' = smartSpacing 2 $ smartBorders $ layoutHook desktopConfig
   in xmonad
        . ewmh
        . pagerHints
        . toAdd
        . toRemove
        $ desktopConfig
          { terminal = "alacritty"
          , modMask = mod4Mask
          , logHook = logHook'
          , layoutHook = layoutHook'
          , focusedBorderColor = "#ffffff"
          , normalBorderColor = "#cccccc"
          , borderWidth = 2
          }
