# TurnServer
Turn server to manage IceCandidates for the Burner Chat app

## Example configuration

```sh
# Basic TURN configuration
realm=burnerchat
listening-port=3478
listening-ip=192.168.1.61
relay-ip=192.168.1.61
external-ip=192.168.1.61

# Force use of TCP
no-udp
relay-transport=tcp

# Authentication
lt-cred-mech
user=example:example

# Enable detailed logs
log-file=/tmp/turn.log
simple-log

# Other useful settings
fingerprint
```
