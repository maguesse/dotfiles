# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files for examples
# the files are located in the bash-doc package.
case $- in
    *i*) ;;
    *) return ;;
esac

HISTTIMEFORMAT="%Y/%m%d %T "
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

case "$TERM" in
    xterm-color) color_prompt=yes;;
esac


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [[ -f /usr/share/bash-completion/bash_completion ]]; then
        . /usr/share/bash-completion/bash_completion
    elif [[ -f /etc/bash_completion ]]; then
        . /etc/bash_completion
    fi
fi

for DOTFILE in ~/.profile.d/*; do
    [[ -r "${DOTFILE}" ]] && [[ -f "${DOTFILE}" ]] && source ${DOTFILE}
done
unset file
