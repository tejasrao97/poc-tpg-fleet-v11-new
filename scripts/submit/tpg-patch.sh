#!/usr/bin/env bash
# Submit tpg-patch interactively: mandatory inputs first, then a menu of the
# optional ones, each with its type and an example. See submit-lib.sh.
#   HUB_CONTEXT=<hub kubectl context> scripts/submit/tpg-patch.sh
WF_TEMPLATE=tpg-patch
WF_TITLE="patch operators and instances with files from the fleet repository"
TARGETS="map-or-lists"
TARGET_LISTS="clusters"
MANDATORY="pushMode"
MANDATORY_WITHOUT_MAP=""
# shellcheck source=scripts/submit/submit-lib.sh
source "$(dirname "$0")/submit-lib.sh"
# Without clusterMap at least one patch file input is needed; instance files also need instances
sl_hook_check() {
  [[ "${SL_MAP:-0}" -eq 1 ]] && return 0
  local f any=0
  for f in postgresPatchFilePath valuesPatchFilePath operatorValuesPatchFilePath operatorManifestPatchFilePath; do
    sl_isset "$f" && any=1
  done
  if [[ "$any" -eq 0 ]]; then sl_err "choose at least one patch file input (postgresPatchFilePath, valuesPatchFilePath, operatorValuesPatchFilePath or operatorManifestPatchFilePath)"; return 1; fi
  if { sl_isset postgresPatchFilePath || sl_isset valuesPatchFilePath; } && ! sl_isset instances; then
    sl_err "instance patch files need the instances input"; return 1
  fi
  return 0
}
sl_main "$@"
