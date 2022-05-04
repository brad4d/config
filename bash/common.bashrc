# vim: filetype=sh
# Bradford's standard bash setup
# ~/.bashrc should have:
#   export B4D_CONFIG=$HOME/src/config
#   source $B4D_CONFIG/bash/common.bashrc

if [[ ! -v B4D_CONFIG ]]; then
  echo "B4D_CONFIG is not defined" >&2
  return 1
fi
if [[ ! -d $B4D_CONFIG ]]; then
  echo "not a directory: $B4D_CONFIG (\$B4D_CONFIG)"
  return 1
fi

export HISTTIMEFORMAT="%F %T	"

function source_dirfiles() {
  local -r cmd=source_dirfiles
  if (( $# != 1 )); then
    echo >&2 "$cmd: got $# args, expected 1"
    return 1
  fi
  local d=$1
  if [[ ! -d $d ]]; then
    echo >&2 "$cmd: not a directory: $d"
    return 1
  fi
  local f
  # Get the files in $d that do not start with a '.'
  for f in $(find "$d" -maxdepth 1 -type f \! -name '.*'); do
    source $f
  done
}

# includes definitions of
# * pathmerge
# * myenv
source_dirfiles $B4D_CONFIG/bash/functions

export PATH=$(pathmerge $HOME/bin $PATH)
myenv -q
