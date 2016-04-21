# icinga2-rocketchat-notification

###Your setup may vary, so some of the config files included here may need to be tweaked

1. Set up a new incoming webhook /services/new/incoming-webhook for your team
2. Add rocketchat-service-notification.sh to /etc/icinga2/scripts directory
3. Add the contents of rocketchat-service-notification.conf to your templates.conf (or keep it separate depending on your setup)
4. Add the contents of rocketchat-service-notification-command.conf to your commands.conf (or keep it separate depending on your setup)
5. Add an entry to your notifications.conf (see example below)
```
apply Notification "rocketchat" to Service {
  import "rocketchat-service-notification"
  user_groups = [ "oncall" ]
  interval = 30m
  assign where host.vars.sla == "24x7"
}
```
6. Set up a new user and usergroup
```
object User "oncall_alerts" {
  import "generic-user"

  display_name = "oncall alerts"
  groups = [ "oncall" ]
  states = [ OK, Warning, Critical ]
  types = [ Problem, Recovery ]

  email = "my@email.com"
}

object UserGroup "oncall" {
  display_name = "oncall"
}
```

#### Sample message
The notification will look something like that (feel to imagine that you see an emoji instead of text when relevant):
`:emoji: NOTIFICATION_TYPE HOST_NAME (SERVICE_NAME): STATE | SERVICE_OUTPUT`
