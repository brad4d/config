#!/bin/bash -eu

usage_exit() {
  cat <<_eof_
USAGE: $(basename $0)

TODO: describe this script
_eof_
  if (($# == 0)); then
    # user asked for usage information
    exit 0
  else
    # error message was supplied
    printf '====\n'
    err_exit "$@"
  fi
}

main() {
  # TODO: do something
}


setup() {
  # TODO: add custom argument parsing
  local flag
  while getopts '' flag "$@"; do
    case $flag in
      (*) usage_exit 'unrecognized flag: %q\n' "$flag" ;;
    esac
  done
  shift $((OPTIND - 1))

  (( $# == 0 )) || usage_exit 'unexpected argument: %q\n' "$@"
}

err_exit() {
  printf "$@"
  exit 1
}

setup "$@"
main
