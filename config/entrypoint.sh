#!/bin/sh
echo "Open Web Analytics start"

# Setup timezone
TIME_ZONE=${TIME_ZONE:=UTC}
echo "timezone=${TIME_ZONE}"
rm -rf /etc/localtime
ln -s /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime
echo "${TIME_ZONE}" > /etc/timezone
sed -i "s|;*date.timezone\s*=.*|date.timezone = \"${TIME_ZONE}\"|i" /etc/php5/conf.d/owa.ini

exec $@
