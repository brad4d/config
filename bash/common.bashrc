# vi: set filetype=sh sw=2 ts=2 et:
# Bradfordaj kutimaj bash-agordoj
# ~/.bashrc enhavu jene:
#   export B4D_CONFIG=$HOME/src/config
#   source $B4D_CONFIG/bash/common.bashrc

if [[ ! -v B4D_CONFIG ]]; then
  echo "B4D_CONFIG estas nedifinita" >&2
  return 1
fi
if [[ ! -d $B4D_CONFIG ]]; then
  echo "ne estas dosierujo: $B4D_CONFIG (\$B4D_CONFIG)"
  return 1
fi

export HISTTIMEFORMAT="%F %T	"

function plenumu_dosierujon() {
  local -r cmd=plenumu_dosierujon
  if (( $# != 1 )); then
    echo >&2 "$cmd: $# argumentoj ricevitaj; nur 1 atendita"
    return 1
  fi
  local d=$1
  if [[ ! -d $d ]]; then
    echo >&2 "$cmd: ne estas dosierujo: $d"
    return 1
  fi
  local f
  # Trovu la dosierojn el $d, kies nomoj ne ekas per '.'.
  for f in $(find "$d" -maxdepth 1 -type f \! -name '.*'); do
    # Plenumu ties enhavojn.
    source $f
  done
}

# inkluzivas la jenajn difinojn
# * pathmerge
# * myenv
plenumu_dosierujon $B4D_CONFIG/bash/functions
myenv -q

export PATH=$(pathmerge $HOME/bin $HOME/.local/bin $PATH)

# Ĉi tiu metodo por valorizi debian_root kopiiĝis el la defaŭlta .bashrc
# proviziita per debian Linuks' kaj ĝiaj idoj.
# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Mi volas uzi komplikan logikon por valorizi la invitilon,
# sed mi ne volas krei funkcion, kiu ruliĝos nur unufoje.
PS1=$(
  # Ĉi tiu metodo por kolorigi la invitilon adaptiĝis el la kutima .bashrc
  # proviziita per debian Linuks kaj ĝiaj idoj.

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

# elekti la plej bonan pervidan redaktilon, kiu disponeblas
export VISUAL=$(
komando_ekzistas() {
  type $1 >&/dev/null
}

declare redaktilo
for redaktilo in nvim vim vi ex ed; do
  if komando_ekzistas $redaktilo; then
    echo $redaktilo
    exit 0
  fi
done

printf >&2 'common.bashrc: neniu redaktilo troviĝis: defaŭlto estas %q\n' $redaktilo
echo $redaktilo
exit 1
)

export EDITOR=$VISUAL
alias redaktu="$EDITOR"

# Valorizu LANG, ĉar la defaŭlto, "C", malŝaltus uzado de LANGUAGE.
export LANG=en_US.UTF-8
# Montru al mi esperantajn mesaĝojn kiel eble plej ofte.
# Defaŭltu al Usona angla, kiam tio ne eblas.
export LANGUAGE=eo:en_US.UTF-8
