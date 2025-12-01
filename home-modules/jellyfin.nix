{ pkgs, ... }:
let
  ffmpegPath = "${pkgs.jellyfin-ffmpeg}/bin/ffmpeg";
in
{
  xdg.configFile."jellyfin/encoding.xml".text = ''
    <EncoderAppPath>${ffmpegPath}</EncoderAppPath>
    <EncoderAppPathDisplay>${ffmpegPath}</EncoderAppPathDisplay>
  '';
}
