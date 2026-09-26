#!/usr/bin/env bash
# Submit tpg-scale-instance interactively: mandatory inputs first, then a menu of the
# optional ones, each with its type and an example. See submit-lib.sh.
#   HUB_CONTEXT=<hub kubectl context> scripts/submit/tpg-scale-instance.sh
WF_TEMPLATE=tpg-scale-instance
WF_TITLE="scale the read replicas of Postgres instances"
TARGETS="map-or-lists"
TARGET_LISTS="clusters instances"
MANDATORY="pushMode"
MANDATORY_WITHOUT_MAP="replicas"
# shellcheck source=scripts/submit/submit-lib.sh
source "$(dirname "$0")/submit-lib.sh"
sl_main "$@"
