#!/bin/bash -eu

usage_exit() {
  cat <<_eof_
USAGE: $PROGNAME

Install Bradford's standard scripts and other config stuff.
_eof_
  printf '====\n'
  err_exit "$@"
}

readonly PROGNAME=$(basename $0)
readonly PROGDIR=$(dirname $0)

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

cd $(dirname $0)

main() {
  local f

  install_file inputrc "$HOME/.inputrc"

  f=lib/newscript/template.sh ; install_file $f $HOME/$f
  f=bin/newscript ; install_file $f $HOME/$f
}

install_file() {
  local -r src=$1
  local -r dst=$2
  if [[ -e $dst ]]; then
    printf '%q: already exists\n' "$dst"
  else
    printf 'installing %q as %q\n' "$src" "$dst"
    install -D "$src" "$dst"
  fi
}

main
