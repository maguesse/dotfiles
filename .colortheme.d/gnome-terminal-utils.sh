#!/bin/bash
newGnome=0
if which dconf > /dev/null 2>&1; then
    newGnome=1
    CONFTOOL=dconf
    CONFDIR=/org/gnome/terminal/legacy
    PROFILESDIR=${CONFDIR}/profiles:
else
    CONFTOOL=gconftool-2
    CONFDIR=/apps/gnome-terminal
    PROFILESDIR=${CONFDIR}/profiles
fi


to_gconf_fmt() {
    tr '\n' \: | sed 's#:$#\n#'
}

to_dconf_fmt() {
    :
    #tr '\n' '~' | sed -e "s#~\$#']\n#" -e "s#~#', '#g" -e "s#^#['#"
}

set_key() {
    declare type="$1"; shift
    declare key="$1"; shift
    declare value="$1"; shift

    if [ "$newGnome" == "0" ]; then
        ${CONFTOOL} --set --type "${type}" "${key}" -- "${value}"
    else
        ${CONFTOOL} write "${key}" "${value}"
    fi
}

append_to_list() {
    declare type="$1"; shift
    declare key="$1"; shift
    declare value="$1"; shift
    declare entries=

    if [ "$newGnome" == "0" ]; then
        entries="$(
            {
                "$CONFTOOL" --get "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$value"
                echo "$value"
            } | head -c-1 | tr "\n" ,
        )"

        "$CONFTOOL" --set --type list --list-type "$type" "$key" "[$entries]"
    else
        :
    fi
}

copy_profile_from_default() {
    declare pkey=$1;shift

    if [ "$newGnome" == "0" ]; then
        :
    else
        :
    fi
}

check_profile_exists() {
    declare pfound=0

    if [ "$newGnome" == "0" ]; then
        "${CONFTOOL}" --dir-exists "$1"
    else
        :
    fi
    return $?
}

create_new_profile() {
    declare schemeDir=${DIRCOLORS_DB_PATH}/${COLORTHEME}/gnome-terminal/${BACKGROUND}
    declare bg_color_file=${schemeDir}/bg_color
    declare fg_color_file=${schemeDir}/fg_color
    declare bd_color_file=${schemeDir}/bd_color
    declare palette_file=${schemeDir}/palette
    declare pkey=$1; shift

    copy_profile_from_default "$pkey"

    if [ "$newGnome" == "0" ]; then
        append_to_list string ${CONFDIR}/global/profile_list "${profile_uid}"

        set_key string ${PROFILE_KEY}/visible_name "${profile_name}"
        set_key bool   ${PROFILE_KEY}/use_theme_colors "false"
        set_key bool   ${PROFILE_KEY}/use_theme_background "false"
        set_key bool   ${PROFILE_KEY}/bold_color_same_as_fg "false"
        set_key string ${PROFILE_KEY}/palette "$(to_gconf_fmt < $palette_file)"
        set_key string ${PROFILE_KEY}/background_color "$(cat $bg_color_file)"
        set_key string ${PROFILE_KEY}/foreground_color "$(cat $fg_color_file)"
        set_key string ${PROFILE_KEY}/bold_color "$(cat $bd_color_file)"

        set_key string ${CONFDIR}/global/default_profile "${profile_uid}"
    else
        append_to_list string ${CONFDIR}/global/profile_list "${profile_uid}"

        set_key string ${PROFILE_KEY}/visible-name "${profile_name}"
        set_key bool   ${PROFILE_KEY}/use-theme-colors "false"
        set_key bool   ${PROFILE_KEY}/use-theme-background "false"
        set_key bool   ${PROFILE_KEY}/bold-color-same-as-fg "false"
        set_key string ${PROFILE_KEY}/palette "$(to_gconf_fmt < $palette_file)"
        set_key string ${PROFILE_KEY}/background-color "$(cat $bg_color_file)"
        set_key string ${PROFILE_KEY}/foreground-color "$(cat $fg_color_file)"
        set_key string ${PROFILE_KEY}/bold-color "$(cat $bd_color_file)"

        #set_key string ${CONFDIR}/global/default_profile "${profile_uid}"
    fi
}


set_terminal_profile() {
    declare scheme=$1; shift
    declare background=$1; shift
    declare profile_uid=$(echo $scheme $background | tr [:upper:] [:lower:] | tr ' ' '-')
    declare profile_name=$(echo ${profile_uid} | sed -e 's/-/ /g' -e 's/^\s*./\U&\E/g' -e 's/ \s*./\U&\E/g')

    if [ "$newGnome" == "0" ]; then
        PROFILE_KEY=${PROFILESDIR}/${profile_uid}
    else
        :
    fi

    create_new_profile ${PROFILE_KEY} ${profile_name} ${scheme} ${BACKGROUND}

    unset scheme background profile_uid profile_name profiles_name
}

