#!/bin/bash -eu

usage_exit() {
  cat <<_eof_
USAGE: $(basename $0)

Install Bradford's standard scripts and other config stuff.
_eof_
  printf '====\n'
  err_exit "$@"
}

main() {
  cd $(dirname $0)

  local f

  install_file inputrc "$HOME/.inputrc"

  f=lib/newscript/template.sh ; install_file $f $HOME/$f
  f=lib/newscript/template.gawk ; install_file $f $HOME/$f
  f=bin/newscript ; install_file $f $HOME/$f
  f=bin/ytts2srt ; install_file $f $HOME/$f
  f=bin/tsv2mdtable ; install_file $f $HOME/$f
}

install_file() {
  local -r src=$1
  local -r dst=$2
  if should_install "$src" "$dst"; then
    install -v -D "$src" "$dst"
  fi
}

should_install() {
  local -r src=$1
  local -r dst=$2

  if ! [[ -e $dst ]]; then
    return 0
  fi

  printf '%q: already exists\n' "$dst"
  if diff -u "$dst" "$src"; then
    printf '...and the contents are the same.\n'
    # no need to install
    return 1
  fi

  printf 'Overwrite file %q?\n' "$dst"
  local -l answer
  read -r -p '[y|N]? ' answer
  [[ $answer = y ]]
}

setup() {
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
