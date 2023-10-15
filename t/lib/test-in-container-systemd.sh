#!/bin/bash
#
# Copyright (C) 2023 SUSE LLC
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, see <http://www.gnu.org/licenses/>.

last=${@:$#} # last parameter
other=${*%${!#}} # all parameters except the last

testcase=$last

set -euo pipefail
PODMAN=podman
image=${T_IMAGE-opensuse.leap}
(
PODMAN_info="$($PODMAN info >/dev/null 2>&1)" || $PODMAN info
[ -n "$testcase" ] || (echo No testcase provided; exit 1)
[ -f "$testcase" ] || (echo Cannot find file "$testcase"; exit 1 )
) >&2

thisdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
basename=$(basename "$testcase")
basename=${basename,,}
basename=${basename//:/_}

othermd5=
test -z "$other" || othermd5=($(echo "$other" | md5sum -))

ident=mysql.formula.t$othermd5
containername="$ident.${basename,,}"

# we use variable T_CACHE_PACKAGES to speedup testing and make sure that
(
if test -z "$other" || \
    test "${T_IMAGE-}" != "" || \
    test "${T_CACHE_PACKAGES:-}" != 1
then
    cat $thisdir/Dockerfile.${image}
else
    ar=""
    in="zypper -vvvn in "
    for pkg in $other vim; do
        if [[ $pkg == *:* ]]; then
            n=${pkg//*:}
            ar="$ar zypper -n ar http://download.opensuse.org/repositories/$pkg/\\\\\$releasever/ $n;"
            in="$in $n"
        else
            in="$in $pkg"
        fi
    done
    test -z "$ar" || ar="$ar zypper --gpg-auto-import-keys ref; "

    sed "s,\#\#DUMMY,RUN $ar $in,g" $thisdir/Dockerfile.${T_IMAGE}
fi

) | cat | $PODMAN build -t $ident.image -f - $thisdir/../..

map_port=""
[ -z "${EXPOSE_PORT:-}" ] || map_port="-p $EXPOSE_PORT:80"
$PODMAN run --privileged --rm $map_port --name "$containername" -d -v"$thisdir/../..":/opt/project --add-host localhost:127.0.0.1 -- $ident.image

in_cleanup=0

ret=111

function cleanup {
    [ "$in_cleanup" != 1 ] || return
    in_cleanup=1
    if [ "$ret" != 0 ] && [ -n "${T_PAUSE_ON_FAILURE-}" ]; then
        read -rsn1 -p"Test failed, press any key to finish";echo
    fi
    [ "$ret" == 0 ] || echo FAIL $basename
    $PODMAN stop -t 0 "$containername" >&/dev/null || :
}

trap cleanup INT TERM EXIT
counter=1

# wait container start
until [ $counter -gt 10 ]; do
  sleep 0.5
  $PODMAN exec "$containername" pwd >& /dev/null && break
  ((counter++))
done

$PODMAN exec "$containername" pwd >& /dev/null || (echo Cannot start container; exit 1 ) >&2

echo "$*"
# [ -z $initscript ] || echo "bash -xe /opt/project/t/$initscript" | $PODMAN exec -i "$containername" bash -x

set +e
$PODMAN exec -e TESTCASE="$testcase"  -i "$containername" bash -xe < "$testcase"
ret=$?
( exit $ret )

