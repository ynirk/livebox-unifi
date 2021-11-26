#!/usr/bin/env bash
# put in /config/scripts/post-config.d

if ! cmp -s /sbin/dhclient3 /config/scripts/dhclient3; then
    logger -t ${0##*/} "dhclient3 updated"
    cp  /sbin/dhclient3 /sbin/dhclient3.bak
    cp --force /config/scripts/dhclient3 /sbin/dhclient3
    chown root: /sbin/dhclient3
    chmod 755 /sbin/dhclient3
fi

if  ! grep -q "option rfc3118-auth code 90" /opt/vyatta/sbin/vyatta-interfaces.pl; then
    sed --in-place=.bak '/\$output \.= "option rfc3442/a \    $output .= "option rfc3118-auth code 90 = string;\\n\\n";' /opt/vyatta/sbin/vyatta-interfaces.pl
    logger -t  ${0##*/} "vyatta-interfaces.pl updated"
fi
