# icinga2-rocketchat-notification

### Your setup may vary, so some of the config files included here may need to be tweaked

* Set up a new incoming webhook /services/new/incoming-webhook for your team
* Add `rocketchat-host-notification.sh` and `rocketchat-service-notification.sh` to `/etc/icinga2/scripts` directory and **make sure icinga can run them**
* Add the contents of `rocketchat-host-notification.conf` and `rocketchat-service-notification.conf` to your `conf.d/templates.conf` (or keep it separate depending on your setup)
* Add the contents of `rocketchat-host-notification-command.conf` `rocketchat-service-notification-command.conf` to your `conf.d/commands.conf` (or keep it separate depending on your setup)
* Add an entry to your `conf.d/notifications.conf` (see example below)

```
apply Notification "rocketchat" to Host {
  import "rocketchat-host-notification"
  user_groups = [ "oncall" ]
  interval = 30m
  assign where host.vars.sla == "24x7"
}

apply Notification "rocketchat" to Service {
  import "rocketchat-service-notification"
  user_groups = [ "oncall" ]
  interval = 30m
  assign where host.vars.sla == "24x7"
}
```
* Set up a new user and usergroup if you didn't use a usergroup that already existed in you setup in the new `conf.d/notifications.conf` addition

```
object User "oncall_alerts" {
  import "generic-user"

  display_name = "oncall alerts"
  groups = [ "oncall" ]
  states = [ OK, Warning, Critical, Up, Down ]
  types = [ Problem, Recovery ]

  email = "my@email.com"
}

object UserGroup "oncall" {
  display_name = "oncall"
}
```

#### Sample message
The notification will look something like that (feel to imagine that you see an emoji instead of text when relevant):

`:emoji: NOTIFICATION_TYPE HOST_NAME: STATE | HOST_OUTPUT | [ *COMMENT AUTHOR* ] COMMENT`

`:emoji: NOTIFICATION_TYPE HOST_NAME (SERVICE_NAME): STATE | SERVICE_OUTPUT | [ *COMMENT AUTHOR* ] COMMENT`