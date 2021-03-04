#!/usr/bin/env bash

CMD='/usr/bin/osascript -e'

if [[ -e "{{ home }}/{{ user }}/Desktop/{{ app }}" ]] && [[ "${1}" == "remove" ]]
then
    $CMD "tell application \"Finder\" to delete POSIX file \"{{home}}/{{user}}/Desktop/{{ app }}\""
elif [[ -e "{{ dir }}/{{ app ~ '.app' if suffix else app }}" ]] && [[ "${1}" == "add" ]]
then
    $CMD "tell application \"Finder\" to delete POSIX file \"{{home}}/{{user}}/Desktop/{{ app }}\"" >/dev/null 2>&1
    $CMD "tell application \"Finder\" to make new Alias at (path to desktop folder) to POSIX file \"{{ dir }}/{{ app }}{{ suffix or '' }}\""
fi
