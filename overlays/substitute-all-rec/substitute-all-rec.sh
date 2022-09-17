source $stdenv/setup

eval "$preInstall"

args=

prefix="${src%/}"

function subAllDir {
  target="$out${1#"$prefix"}"
  if test -d "$1"; then
    mkdir -p "$target"
    for file in "$1"/*; do
      subAllDir "$file"
    done
  else
    substituteAll "$1" "$target"
    if test -x "$1"; then
      chmod +x "$target"
    fi
  fi
}

subAllDir "$src"

eval "$postInstall"
