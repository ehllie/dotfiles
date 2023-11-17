import Graphics.X11.ExtraTypes.XF86
import System.Taffybar.Support.PagerHints (pagerHints)
import XMonad
import XMonad.Actions.CycleWS
import XMonad.Config.Desktop
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.FadeInactive
import XMonad.Layout.NoBorders (smartBorders)
import XMonad.Layout.Spacing (smartSpacing)
import XMonad.Util.EZConfig (additionalKeys, removeKeys)

main =
  let baseConfig = desktopConfig
      toAdd conf@XConfig{modMask = modm, terminal = term} =
        -- Clipboard simulation for windows that don't let you use paste
        let xdotoolCmd =
              unwords
                [ "sleep .25 &&" -- Short sleep to prevent losing initial characters
                , "xclip -selection clipboard -out |" -- Get contents from xclip
                , "tr \\n \\r |" -- Replace newlines with carriage returns
                , "xdotool type --clearmodifiers --delay 25 --file - &&" -- Type with a delay of 25 to not lose keystrokes again
                , "xdotool keyup Super_L Super_R Shift_L Shift_R" -- Raise super and shift keys manually to avoid them getting stuck
                ]
         in additionalKeys
              conf
              [ ((modm .|. shiftMask, xK_t), spawn term)
              , ((modm .|. controlMask, xK_Left), prevWS)
              , ((modm .|. controlMask, xK_Right), nextWS)
              , ((modm .|. controlMask, xK_Down), moveTo Next emptyWS)
              , ((modm .|. controlMask .|. shiftMask, xK_Left), shiftToPrev >> prevWS)
              , ((modm .|. controlMask .|. shiftMask, xK_Right), shiftToNext >> nextWS)
              , ((modm, xK_p), spawn "")
              , ((modm .|. shiftMask, xK_p), spawn xdotoolCmd)
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
      layoutHook' = smartSpacing 2 $ smartBorders $ layoutHook baseConfig
      logHook' = do
        logHook baseConfig
        fadeInactiveLogHook 0.8
   in xmonad
        . ewmh
        . ewmhFullscreen
        . pagerHints
        . toAdd
        . toRemove
        $ baseConfig
          { terminal = "alacritty"
          , borderWidth = 2
          , focusedBorderColor = "#ffffff"
          , layoutHook = layoutHook'
          , logHook = logHook'
          , modMask = mod4Mask
          , normalBorderColor = "#cccccc"
          }
