import XMonad
import XMonad.Config.Desktop

main :: IO ()
main =
  xmonad $
    desktopConfig
      { terminal = "alacritty",
        modMask = mod4Mask,
        borderWidth = 2
      }
