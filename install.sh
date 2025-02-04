#!/bin/bash

DESKTOP_UNLOCK_ALERT_DIR=/usr/share/desktop-unlock-alert
DESKTOP_UNLOCK_ALERT_CONF_DIR=/etc/desktop-unlock-alert

RUNNING_USER=$(logname)

echo "Create script directories"
if [ ! -f $DESKTOP_UNLOCK_ALERT_DIR ]; then
  mkdir -p $DESKTOP_UNLOCK_ALERT_DIR
fi
if [ ! -f $DESKTOP_UNLOCK_ALERT_CONF_DIR ]; then
  mkdir -p $DESKTOP_UNLOCK_ALERT_CONF_DIR
fi

if [ ! -f $DESKTOP_UNLOCK_ALERT_CONF_DIR/config ]; then
  cp config.template $DESKTOP_UNLOCK_ALERT_CONF_DIR/config
  chown $RUNNING_USER:$RUNNING_USER $DESKTOP_UNLOCK_ALERT_CONF_DIR/config
  chmod 640 $DESKTOP_UNLOCK_ALERT_CONF_DIR/config
fi

cp desktop-unlock-alert.sh $DESKTOP_UNLOCK_ALERT_DIR/desktop-unlock-alert.sh
chown $RUNNING_USER:$RUNNING_USER $DESKTOP_UNLOCK_ALERT_DIR/desktop-unlock-alert.sh
chmod 740 $DESKTOP_UNLOCK_ALERT_DIR/desktop-unlock-alert.sh
sed -i "s@\__DESKTOP_UNLOCK_ALERT_CONF_DIR__@$DESKTOP_UNLOCK_ALERT_CONF_DIR@g" $DESKTOP_UNLOCK_ALERT_DIR/desktop-unlock-alert.sh

echo "Install systemd service"
cp etc/systemd/system/* /etc/systemd/system
sed -i "s@\__DESKTOP_UNLOCK_ALERT_DIR__@$DESKTOP_UNLOCK_ALERT_DIR@g" /etc/systemd/system/desktop-unlock-alert.service
sed -i "s@\__USER__@$RUNNING_USER@g" /etc/systemd/system/desktop-unlock-alert.service
systemctl enable desktop-unlock-alert.service
systemctl start desktop-unlock-alert.service
systemctl daemon-reload

echo "Done!"
echo "Configuration is at $DESKTOP_UNLOCK_ALERT_CONF_DIR/config"
echo "Script is at $DESKTOP_UNLOCK_ALERT_CONF_DIR/desktop-unlock-alert.sh"
