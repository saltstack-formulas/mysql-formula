#!/usr/bin/env bash

CMD='/usr/bin/osascript -e'
if [[ -f "{{ home }}/{{ user }}/Desktop/{{ app }}" ]] && [[ "${1}" -eq "remove" ]]
then
    ${CMD} "tell application \"Finder\" to delete file \"{{home}}/{{user}}/Desktop/{{ app }}\""
elif [[ -d "{{ dir }}/{{ app }}" ]] && [[ "${1}" -eq "add" ]]
then
    ${CMD} "tell application \"Finder\" to make new Alias at (path to desktop folder) to POSIX file \"{{ dir }}/{{ app }}\""
fi
