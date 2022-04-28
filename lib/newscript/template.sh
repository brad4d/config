#!/bin/bash -eu

usage_exit() {
  cat <<_eof_
USAGE: $PROGNAME

TODO: describe this script
_eof_
  printf '====\n'
  err_exit "$@"
}

readonly PROGNAME=$(basename $0)

err_exit() {
  printf "$@"
  exit 1
}

declare flag
while getopts '' flag "$@"; do
  case $flag in
    (*) usage_exit 'unrecognized flag: %q\n' "$flag" ;;
  esac
done
shift $((OPTIND - 1))

(( $# == 0 )) || usage_exit 'unexpected argument: %q\n' "$@"

main() {
  # TODO: do something
}

main
