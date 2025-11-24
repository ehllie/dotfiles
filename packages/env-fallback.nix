{ writeShellScriptBin }:
binName: fallbackPkg:

writeShellScriptBin "${binName}" ''
  set -euo pipefail
  if ! command -v "${binName}" >/dev/null 2>&1; then
    exec "${fallbackPkg}/bin/${binName}" "$@"
  else
    exec "${binName}" "$@"
  fi
''
