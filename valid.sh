#!$runtimeShell
# shellcheck shell=bash
# shellcheck disable=2154

source "$stdenv/setup"

eval "$preInstall"

mkdir -p "$out"

function validate {
  if [ -d "$1" ]; then
    for file in "$1"/*; do
      if [ -d "$file" ] || [ "${file##*.}" = "nix" ]; then
        if ! validate "$file"; then return 1; fi
      fi
    done
  elif [ -f "$1" ] && ! hnix "$1"; then
    echo "File $1 is not of a valid nix expression"
    return 1
  fi
  return 0
}

echo "Evaluating $src"
if validate "$src"; then
  cp -r "$src"/* "$out"
else
  echo "$default" > "$out/default.nix"
fi

eval "$postInstall"
