# 2026-01-21 Move Production Services to OIDC Implementation level 2

For each service:

* OBF
* OPFF
* OPF
* OFF-PRO
* OFF

Check that teh minion and redis_listener services were still running:

```
export SERVICE=$HOSTNAME
sudo systemctl -l status -no-pager minion@$SERVICE.service 
sudo systemctl -l status -no-pager redis_listener@$SERVICE.service 
```

Edit Config2.pm using `sudo -u off vi /srv/$SERVICE/lib/ProductOpener/Config2.pm` and set `$oidc_implementation_level = 2;`

Restart services with:

```
sudo systemctl stop apache2 && sudo systemctl start apache2
[[ "$SERVICE" = off ]] && sudo systemctl stop apache2@priority && sudo systemctl start apache2@priority
sudo systemctl restart cloud_vision_ocr@$SERVICE.service minion@$SERVICE.service redis_listener@$SERVICE.service
```

To test:
* Log in to each flavour
* Go to the account screen in Keycloak (https://auth.openfoodfacts.org/realms/openfoodfacts/account) and edit Name
* Refresh PO page to see if Name updates in the top right
* Sign out of flavour
* Change password on Keycloak account screen
* Sign in to flavour with old password (should fail)
* Sign in to flavour with new password

# Progress

* OBF: Done
* OPFF: 
* OPF: 
* OFF-PRO: 
* OFF: 

# Status 2026-01-21 12:26 UTC

OBF worked OK but OPFF wouldn't allow login at Level 2. Investigating...
