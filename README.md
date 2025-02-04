# Desktop unlock alert

Sends you a message when your desktop's lock screen is unlocked.

Waits for internet connection to become alive before attempting to send alerts.

Current implementation is tested on Debian 12 (GNOME) by monitoring the
Session.Unlock() event.

Adds a systemd service for monitoring the lock screen events.

## Supported messaging methods

- SMTP
- Telegram
- Something else? Create a PR

## Requirements

### Telegram

`curl` or `wget`

Telegram Bot token from [@BotFather](https://telegram.me/BotFather)

## Installation

`sudo bash install.sh`

### SMTP

Please implement function `desktop_unlock_alert_smtp_send_mail` in
`/etc/desktop-unlock-alert/config` if you wish to send alerts by email.

We did not want to be dependent on any particular email/SMTP client so you are
free to implement this step using your favorite tools.

## Configuration

See `/etc/desktop-unlock-alert/config`

## Contributing

Accepting pull requests
