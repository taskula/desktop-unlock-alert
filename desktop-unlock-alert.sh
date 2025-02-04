#!/bin/bash

# Read configurations
. __DESKTOP_UNLOCK_ALERT_CONF_DIR__/config

DESKTOP_UNLOCK_ALERT_WAITED=0

wait_for_internet() {
  # Wait for internet connection
  until eval "$1"
    do
      if [ $DESKTOP_UNLOCK_ALERT_NETWORK_TIMEOUT -ge $DESKTOP_UNLOCK_ALERT_WAITED ]; then
        sleep 5
      else
        return 1
      fi
  done
}

gdbus monitor -y -d org.freedesktop.login1 |
  grep --line-buffered -o 'Session.Unlock ()' |
  while read -r; do
    echo "Lock screen was unlocked."
    if [ -n "$DESKTOP_UNLOCK_ALERT_TELEGRAM_BOT_TOKEN" ] && [ -n "$DESKTOP_UNLOCK_ALERT_TELEGRAM_CHAT_ID" ]; then
      if command -v curl 2>&1 >/dev/null; then
        wait_for_internet "curl -s -o /dev/null -X POST https://api.telegram.org/bot$DESKTOP_UNLOCK_ALERT_TELEGRAM_BOT_TOKEN/sendMessage"
        curl -s -X POST https://api.telegram.org/bot$DESKTOP_UNLOCK_ALERT_TELEGRAM_BOT_TOKEN/sendMessage -d chat_id=$DESKTOP_UNLOCK_ALERT_TELEGRAM_CHAT_ID -d text="$DESKTOP_UNLOCK_ALERT_TELEGRAM_MESSAGE"
      elif command -v wget 2>&1 >/dev/null; then
        wait_for_internet "wget -q -O /dev/null https://api.telegram.org"
        wget -o /dev/null https://api.telegram.org/bot$DESKTOP_UNLOCK_ALERT_TELEGRAM_BOT_TOKEN/sendMessage --post-data "chat_id=$DESKTOP_UNLOCK_ALERT_TELEGRAM_CHAT_ID&text=$DESKTOP_UNLOCK_ALERT_TELEGRAM_MESSAGE"
      fi
    fi
    if [ -n "$DESKTOP_UNLOCK_ALERT_SMTP_HOST" ] && [ -n "$DESKTOP_UNLOCK_ALERT_SMTP_PORT" ]; then
      if command -v openssl 2>&1 >/dev/null; then
        wait_for_internet "openssl s_client -quiet $DESKTOP_UNLOCK_ALERT_SMTP_STARTTLS -connect $DESKTOP_UNLOCK_ALERT_SMTP_HOST:$DESKTOP_UNLOCK_ALERT_SMTP_PORT <<< \"QUIT\""
        desktop_unlock_alert_smtp_send_mail
      fi
    fi
  done
