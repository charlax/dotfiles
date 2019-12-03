# No POSIX way to get dir of sourced script.
[ "$BASH_VERSION" ] && thisDir="$(dirname "${BASH_SOURCE[0]}")"
[ "$ZSH_VERSION" ] && thisDir="$(dirname "$0")"
[ -z "$thisDir" ] && thisDir="./helpers"

# Get colour aliases.
. "$thisDir"/colours.sh

log_get() {
    printf "${CYAN}❯❯❯ Installing:${NC} %s\n" "$@"
}
