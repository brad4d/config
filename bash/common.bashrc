# vi: set filetype=sh sw=2 ts=2 et:
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
myenv -q

export PATH=$(pathmerge $HOME/bin $HOME/.local/bin $PATH)

# This method for setting debian_root is copied from the default .bashrc
# supplied by debian Linux and its derivatives.
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# I want to use some fancy logic for creating the value for the prompt,
# but I don't want to create a function to be called just once.
PS1=$(
  # This method for coloring the prompt is adapted from the standard .bashrc
  # supplied by debian Linux and its derivatives

  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)

    # Escape sequence to set color for user / system text
    # bold/bright (01) green (32)
    cuseron='\[\e[01;32m\]'
    # Escape sequence to set color for current directory text
    # bold/bright (01) blue (32)
    cdiron='\[\e[01;34m\]'
    # Escape sequence to set normal text color
    # normal (22) black (30)
    #coff='\[\e[22;30m\]'
    coff='\[\e[01;00m\]'
  else
    cuseron=
    cdiron=
    coff=
  fi

  cat <<_EOF_
# ======================================================================
# $cuseron\u@\h$coff  \D{%A %Y-%m-%d %H:%M:%S}
# \${debian_chroot:+(\$debian_chroot)}$cdiron\w$coff
\\$ 
_EOF_
)

# pick the best visual editor that is available
export VISUAL=$(
cmd_exists() {
  type $1 >&/dev/null
}

declare editor
for editor in nvim vim vi ed; do
  if cmd_exists $editor; then
    echo $editor
    exit 0
  fi
done

printf >&2 'common.bashrc: no editor found: using %q\n' $editor
echo $editor
exit 1
)

export EDITOR=$VISUAL
alias bed="$EDITOR"
