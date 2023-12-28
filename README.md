# InvenTree

InvenTree is an open-source Inventory Management System which provides powerful low-level stock control and part tracking. The core of the InvenTree system is a Python/Django database backend which provides an admin interface (web-based) and a REST API for interaction with external interfaces and applications. A powerful plugin system provides support for custom applications and extensions.

inventree.org

<img src="https://github.com/inventree/InvenTree/raw/master/images/logo/inventree.png" alt="inventree logo" width="%60" height="auto">

## How to use this Makejail

### Standalone

```sh
appjail makejail \
    -j inventree \
    -f gh+AppJail-makejails/inventree \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose=8000
```

This Makejail is designed to run InvenTree without preconfiguring it. By default it uses SQLite and some defaults to run smoothly, such as enabling debug mode, so it does not need a static web server, but this approach is recommended only if you need a simple approach. A more robust configuration designed for a production environment can be found in [Deploy using appjail-director](#deploy-using-appjail-director).

**WARNING**: Don't use SQLite in a production environment due to limitations to 1 concurrent write connection, making the API and workers nearly unusable.

### Deploy using appjail-director

**appjail-director.yml**:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  inventree:
    name: inventree
    makejail: gh+AppJail-makejails/inventree
    volumes:
      - inventree-data: /inventree/data
    environment:
      - INVENTREE_ADMIN_USER: !ENV '${INVENTREE_ADMIN_USER}'
      - INVENTREE_ADMIN_PASSWORD: !ENV '${INVENTREE_ADMIN_PASSWORD}'
      - INVENTREE_ADMIN_EMAIL: !ENV '${INVENTREE_ADMIN_EMAIL}'
      - INVENTREE_CACHE_HOST: inventree-redis
      - INVENTREE_DEBUG: False
      - INVENTREE_DB_ENGINE: mysql
      - INVENTREE_DB_HOST: inventree-mariadb
      - INVENTREE_DB_PORT: 3306
      - INVENTREE_DB_NAME: inventree
      - INVENTREE_DB_USER: inventree
      - INVENTREE_DB_PASSWORD: !ENV '${INVENTREE_DB_PASSWORD}'
      - INVENTREE_BACKGROUND_WORKERS: 4
      - INVENTREE_TIMEZONE: America/Caracas
      - INVENTREE_LANGUAGE: es-ES
    arguments:
      - inventree_gunicorn_conf: !ENV '${INVENTREE_GUNICORN_CONF}'
    options:
      - healthcheck: 'health_cmd:jail:/inventree/init/check.sh "recover_cmd:jail:su -l inventree -c /inventree/init/restart.sh"'
    scripts:
      - type: local
        text: 'service appjail-health onerestart'
  db:
    name: inventree-mariadb
    makejail: gh+AppJail-makejails/mariadb
    priority: 97
    arguments:
      - mariadb_user: inventree
      - mariadb_password: !ENV '${INVENTREE_DB_PASSWORD}'
      - mariadb_database: inventree
      - mariadb_root_password: !ENV '${INVENTREE_DB_ROOT_PASSWORD}'
    volumes:
      - db: /var/db/mysql
      - db-done: /.mariadb-done
  cache:
    name: inventree-redis
    makejail: gh+AppJail-makejails/redis
    priority: 98
  reverse-proxy:
    name: inventree-nginx
    makejail: gh+AppJail-makejails/nginx
    options:
      - copydir: !ENV '${PWD}/copydir-files'
      - file: /usr/local/etc/nginx/nginx.conf
      - expose: 80
    priority: 100
    volumes:
      - inventree-static: /usr/local/www/inventree/static
      - inventree-media: /usr/local/www/inventree/media

volumes:
  inventree-data:
    device: ./volumes/inventree/data
    owner: 1001
    group: 1001
  inventree-static:
    device: ./volumes/inventree/data/static
  inventree-media:
    device: ./volumes/inventree/data/media
  db:
    device: ./volumes/mariadb/db
    owner: 88
    group: 88
  db-done:
    device: ./volumes/mariadb/done
```

**.env**:

```
DIRECTOR_PROJECT=inventree
INVENTREE_ADMIN_USER=admin
INVENTREE_ADMIN_PASSWORD=inventree
INVENTREE_ADMIN_EMAIL=info@example.com
INVENTREE_DB_PASSWORD=123
INVENTREE_DB_ROOT_PASSWORD=321
INVENTREE_GUNICORN_CONF=${PWD}/gunicorn.conf.py
```

**copydir-files/usr/local/etc/nginx/nginx.conf**:

```
# NGINX configuration file based on https://github.com/inventree/InvenTree/blob/master/docker/production/nginx.prod.conf

events {
    worker_connections 1024;
}

http {
    include mime.types;
    default_type application/octet-stream;

    # Necessary when using DNS to resolve hostnames in the proxy_pass directive.
    resolver 172.0.0.1 valid=30s;

    server {
        # Listen for connection on (internal) port 80
        # If you are exposing this server to the internet, you should use HTTPS!
        # In which case, you should also set up a redirect from HTTP to HTTPS, and listen on port 443
        # See the Nginx documentation for more details
        listen 80;

        real_ip_header proxy_protocol;

        location / {
            proxy_set_header      Host              $http_host;
            proxy_set_header      X-Forwarded-By    $server_addr:$server_port;
            proxy_set_header      X-Forwarded-For   $remote_addr;
            proxy_set_header      X-Forwarded-Proto $scheme;
            proxy_set_header      X-Real-IP         $remote_addr;
            proxy_set_header      CLIENT_IP         $remote_addr;

            proxy_pass_request_headers on;

            proxy_redirect off;

            client_max_body_size 100M;

            proxy_buffering off;
            proxy_request_buffering off;
            # Do not touch this unless you have a specific reason - this and the appjail-director need to match
            set $endpoint inventree:8000;
            proxy_pass http://$endpoint;
        }

        # Redirect any requests for static files
        location /static/ {
            alias /usr/local/www/inventree/static/;
            autoindex on;

            # Caching settings
            expires 30d;
            add_header Pragma public;
            add_header Cache-Control "public";
        }

        # Redirect any requests for media files
        location /media/ {
            alias /usr/local/www/inventree/media/;

            # Media files require user authentication
            auth_request /auth;

            # Content header to force download
            add_header Content-disposition "attachment";
        }

        # Use the 'user' API endpoint for auth
        location /auth {
            internal;

            set $endpoint inventree:8000;
            proxy_pass http://$endpoint/auth/;

            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-URI $request_uri;
        }
    }
}
```

**gunicorn.conf.py**:

```python
"""Gunicorn configuration script for InvenTree web server"""

bind = "0.0.0.0:8000"

workers = 4
```

The structure of the tree is as follows:

```
# tree -apug
[drwxr-xr-x root     wheel   ]  .
├── [-rw-r--r-- root     wheel   ]  .env
├── [-rw-r--r-- root     wheel   ]  appjail-director.yml
├── [drwxr-xr-x root     wheel   ]  copydir-files
│   └── [drwxr-xr-x root     wheel   ]  usr
│       └── [drwxr-xr-x root     wheel   ]  local
│           └── [drwxr-xr-x root     wheel   ]  etc
│               └── [drwxr-xr-x root     wheel   ]  nginx
│                   └── [-rw-r--r-- root     wheel   ]  nginx.conf
└── [-rw-r--r-- root     wheel   ]  gunicorn.conf.py

6 directories, 4 files
```

Run `appjail-director up` and the entire InvenTree stack will be deployed.

**Note#1**: All of the above files are examples only, so change anything that does not fit your environment.

**Note#2**: The above configuration files assume that you have DNS enabled and configured to use shorter domain names. See the [AppJail documentation](https://appjail.readthedocs.io) for details.

### Custom Stages

This Makejail defines some custom stages to easily manage the InvenTree web server. They are: `start`, `stop`, `restart` and `check`.

```
# appjail run -s check inventree
inventree is running as pid 48482.
# appjail run -s stop inventree
Stopping inventree.
Waiting for PID: 48482.
# appjail run -s restart inventree
inventree not running? (check /inventree/run/pid).
Starting inventree.
```

### Inside the jail

InvenTree uses `invoke` for some administrative operations. To use it, just log into the jail and change the current path to `/inventree/src`.

```
# appjail login -u inventree inventree
...
jail $ cd src
jail $ invoke --list
...
```

### Arguments

* `inventree_tag` (default: `13.2`): See [#tags](#tags).
* `inventree_gunicorn_conf` (default: `files/gunicorn.conf.py`): Gunicorn configuration file to be used by the InvenTree web server. An empty file is used by default.
* `inventree_conf` (default: `files/config.yaml`): InvenTree configuration file. An empty file is used by default.

### Environment

* `INVENTREE_ADMIN_USER` (optional): Admin account username.
* `INVENTREE_ADMIN_PASSWORD` (optional): Admin account password.
* `INVENTREE_ADMIN_EMAIL` (optional): Admin account email address.
* `INVENTREE_BACKGROUND_WORKERS` (default: `1`): The number of workers to use in the cluster. See https://django-q.readthedocs.io/en/latest/configure.html#workers for details.
* `INVENTREE_BACKGROUND_TIMEOUT` (default: `90`): The number of seconds a worker is allowed to spend on a task before it’s terminated. See https://django-q.readthedocs.io/en/latest/configure.html#timeout for details.
* `INVENTREE_BACKGROUND_MAX_ATTEMPTS` (default: `5`): Limit the number of retry attempts for failed tasks. See https://django-q.readthedocs.io/en/latest/configure.html#max-attempts for details.
* `INVENTREE_DEBUG` (default: `True`): Enable debug mode.
* `INVENTREE_LOG_LEVEL` (default: `WARNING`): Set level of logging to terminal.
* `INVENTREE_TIMEZONE` (default: `UTC`): Server timezone.
* `INVENTREE_ADMIN_URL` (default: `admin`): URL for accessing admin interface.
* `INVENTREE_LANGUAGE` (default: `en-us`): Default language.
* `INVENTREE_BASE_URL` (optional): Server base URL.
* `INVENTREE_AUTO_UPDATE` (default: `False`): Enable auto-migrations.
* `INVENTREE_SITE_URL` (optional).
* `INVENTREE_CACHE_HOST` (optional): Redis address or hostname.
* `INVENTREE_CACHE_PORT` (optional): Redis port to connect to.
* `INVENTREE_ALLOWED_HOSTS` (optional): List of allowed hosts.
* `INVENTREE_CORS_ORIGIN_ALLOW_ALL` (optional): Allow all remote URLS for CORS checks.
* `INVENTREE_CORS_ORIGIN_WHITELIST` (optional): List of whitelisted CORS URLs.
* `INVENTREE_BASE_CURRENCY` (default: `USD`): Base currency code.
* `INVENTREE_CURRENCIES` (default: `AUD CAD CNY EUR GBP JPY NZD USD`): Space-separated list of currencies supported by default.
* `INVENTREE_CUSTOM_LOGO` (optional): Path to custom logo in the static files directory. The provided custom logo path must be specified relative to the location of the `/static/` directory.
* `INVENTREE_CUSTOM_SPLASH` (optional): Path to custom splash screen in the static files directory. The provided custom splash screen path must be specified relative to the location of the `/static/` directory.
* `INVENTREE_CUSTOM_LOGIN_MESSAGE` (optional): Custom message for login page.
* `INVENTREE_CUSTOM_NAVBAR_MESSAGE` (optional): Custom message for navbar.
* `INVENTREE_CUSTOM_HIDE_ADMIN_LINK` (optional).
* `INVENTREE_CUSTOM_HIDE_PASSWORD_RESET` (optional).
* `INVENTREE_DB_ENGINE` (default: `sqlite3`): Database backend.
* `INVENTREE_DB_NAME` (default: `/inventree/data/database.db`): Database name.
* `INVENTREE_DB_USER` (optional): Database username.
* `INVENTREE_DB_PASSWORD` (optional): Database password.
* `INVENTREE_DB_HOST` (optional): Database host address.
* `INVENTREE_DB_PORT` (optional): Database host port.
* `INVENTREE_DB_TIMEOUT` (optional): Database connection timeout. Used by PostgreSQL.
* `INVENTREE_DB_TCP_KEEPALIVES` (optional): TCP keepalive. Used by PostgreSQL.
* `INVENTREE_DB_TCP_KEEPALIVES_IDLE` (optional): Idle TCP keepalive. Used by PostgreSQL.
* `INVENTREE_DB_TCP_KEEPALIVES_INTERNAL` (optional): Internal TCP keepalive. Used by PostgreSQL.
* `INVENTREE_DB_TCP_KEEPALIVES_COUNT` (optional): TCP keepalive count. Used by PostgreSQL.
* `INVENTREE_DB_ISOLATION_SERIALIZABLE` (optional): Database isolation level configured to "serializable". Used by PostgreSQL and MySQL/MariaDB.
* `INVENTREE_EMAIL_BACKEND` (optional): Email backend module.
* `INVENTREE_EMAIL_HOST` (optional): Email server host.
* `INVENTREE_EMAIL_PORT` (optional): Email server port.
* `INVENTREE_EMAIL_USERNAME` (optional): Email account username.
* `INVENTREE_EMAIL_PASSWORD` (optional): Email account password.
* `INVENTREE_EMAIL_TLS` (optional): Enable TLS support.
* `INVENTREE_EMAIL_SSL` (optional): Enable SSL support.
* `INVENTREE_EMAIL_SENDER` (optional): Sending email address.
* `INVENTREE_EMAIL_PREFIX` (optional): Prefix for subject text.
* `INVENTREE_EXTRA_URL_SCHEMES` (optional): Optional URL schemes to allow in URL fields.
* `INVENTREE_STATIC_ROOT` (default: `/inventree/data/static`): List of allowed hosts.
* `INVENTREE_MEDIA_ROOT` (default: `/inventree/data/media`): Allow all remote URLS for CORS checks.
* `INVENTREE_BACKUP_DIR` (default: `/inventree/data/backup`): List of whitelisted CORS URLs.
* `INVENTREE_LOGIN_CONFIRM_DAYS` (default: `3`): Duration for which confirmation links are valid.
* `INVENTREE_LOGIN_ATTEMPTS` (default: `5`): Count of allowed login attempts before blocking user.
* `INVENTREE_LOGIN_DEFAULT_PROTOCOL` (default: `http`): Default HTTP protocol used by django-allauth. See https://docs.allauth.org/en/latest/account/configuration.html for details.
* `INVENTREE_REMOTE_LOGIN_ENABLED` (default: `False`), `INVENTREE_REMOTE_LOGIN_HEADER` (default: `HTTP_REMOTE_USER`): See https://docs.djangoproject.com/en/3.2/howto/auth-remote-user/ and https://docs.djangoproject.com/en/3.2/ref/request-response/#django.http.HttpRequest.META for details.
* `INVENTREE_USE_JWT` (optional): Enable JWT to authenticate users.
* `INVENTREE_LOGOUT_REDIRECT_URL` (optional): This setting may be required if using remote / proxy login to redirect requests during the logout process (default is 'index'). See https://docs.djangoproject.com/en/3.2/ref/settings/#logout-redirect-url for details.
* `INVENTREE_PLUGINS_ENABLED` (default: `False`): Enable plugin support.
* `INVENTREE_PLUGIN_FILE` (default: `/inventree/data/plugins.txt`): Location of plugin installation file.
* `INVENTREE_PLUGIN_DIR` (default: `/inventree/data/plugins/`): Location of external plugin directory.
* `INVENTREE_PLUGIN_RETRY` (default: `5`): Maximum number of attempts before breaking the load when a plugin fails to load.
* `INVENTREE_SECRET_KEY` (optional): Raw secret key value. It takes precedence over `INVENTREE_SECRET_KEY_FILE`.
* `INVENTREE_SECRET_KEY_FILE` (default: `/inventree/data/secret_key.txt`): File containing secret key value.
* `INVENTREE_SENTRY_ENABLED` (default: `False`): Enable sentry.io integration.
* `INVENTREE_SENTRY_SAMPLE_RATE` (optional): Sentry DSN (data source name) key.
* `INVENTREE_SENTRY_DSN` (optional): How often to send data samples.

See https://docs.inventree.org/en/stable/start/config for more details.

### Volumes

| Name             | Owner | Group | Perm | Type | Mountpoint                                           |
| ---------------- | ----- | ----- | ---- | ---- | ---------------------------------------------------- |
| inventree-data   | 1001  | 1001  |  -   |  -   | /inventree/data                                      |
| inventree-locale | 1001  | 1001  |  -   |  -   | /inventree/src/InvenTree/locale                      |
| inventree-i18n   | 1001  | 1001  |  -   |  -   | /inventree/src/InvenTree/InvenTree/static\_i18n/i18n |
| inventree-done   |  -    |  -    |  -   |  -   | /.inventree-done                                     |

## Tags

| Tag    | Arch    | Version        | Type   | `inventree_version` | `inventree_enable_pgsql` | `inventree_enable_mysql` |
| ------ | ------- | -------------- | ------ | ------------------- | ------------------------ | ------------------------ |
| `13.2` | `amd64` | `13.2-RELEASE` | `thin` |      `0.13.0`       |           `1`            |            `1`           |
| `14.0` | `amd64` | `14.0-RELEASE` | `thin` |      `0.13.0`       |           `1`            |            `1`           |

## Notes

1. If you want to skip `invoke update` when running the Makejail, simply create a volume and mount it in `/.inventree-done`. With this approach `invoke update` is executed only once. But you need to create more volumes to keep the files that this command creates:

```yaml
options:
  - virtualnet: ':<random> default'
  - nat:

services:
  inventree:
    name: inventree
    makejail: gh+AppJail-makejails/inventree
    volumes:
      - inventree-data: /inventree/data
      - inventree-locale: /inventree/src/InvenTree/locale
      - inventree-i18n: /inventree/src/InvenTree/InvenTree/static_i18n/i18n
      - inventree-done: /.inventree-done
    environment:
      - INVENTREE_ADMIN_USER: !ENV '${INVENTREE_ADMIN_USER}'
      - INVENTREE_ADMIN_PASSWORD: !ENV '${INVENTREE_ADMIN_PASSWORD}'
      - INVENTREE_ADMIN_EMAIL: !ENV '${INVENTREE_ADMIN_EMAIL}'
      - INVENTREE_CACHE_HOST: inventree-redis
      - INVENTREE_DEBUG: False
      - INVENTREE_DB_ENGINE: mysql
      - INVENTREE_DB_HOST: inventree-mariadb
      - INVENTREE_DB_PORT: 3306
      - INVENTREE_DB_NAME: inventree
      - INVENTREE_DB_USER: inventree
      - INVENTREE_DB_PASSWORD: !ENV '${INVENTREE_DB_PASSWORD}'
      - INVENTREE_BACKGROUND_WORKERS: 4
      - INVENTREE_TIMEZONE: America/Caracas
      - INVENTREE_LANGUAGE: es-ES
      - INVENTREE_CURRENCIES: USD
    arguments:
      - inventree_gunicorn_conf: !ENV '${INVENTREE_GUNICORN_CONF}'
    options:
      - healthcheck: 'health_cmd:jail:/inventree/init/check.sh "recover_cmd:jail:su -l inventree -c /inventree/init/restart.sh"'
    scripts:
      - type: local
        text: 'service appjail-health onerestart'
  db:
    name: inventree-mariadb
    makejail: gh+AppJail-makejails/mariadb
    priority: 97
    arguments:
      - mariadb_user: inventree
      - mariadb_password: !ENV '${INVENTREE_DB_PASSWORD}'
      - mariadb_database: inventree
      - mariadb_root_password: !ENV '${INVENTREE_DB_ROOT_PASSWORD}'
    volumes:
      - db: /var/db/mysql
      - db-done: /.mariadb-done
  cache:
    name: inventree-redis
    makejail: gh+AppJail-makejails/redis
    priority: 98
  reverse-proxy:
    name: inventree-nginx
    makejail: gh+AppJail-makejails/nginx
    options:
      - copydir: !ENV '${PWD}/copydir-files'
      - file: /usr/local/etc/nginx/nginx.conf
      - expose: 80
    priority: 100
    volumes:
      - inventree-static: /usr/local/www/inventree/static
      - inventree-media: /usr/local/www/inventree/media

volumes:
  inventree-data:
    device: ./volumes/inventree/data
    owner: 1001
    group: 1001
  inventree-static:
    device: ./volumes/inventree/data/static
  inventree-media:
    device: ./volumes/inventree/data/media
  inventree-locale:
    device: ./volumes/inventree/data/locale
    owner: 1001
    group: 1001
  inventree-i18n:
    device: ./volumes/inventree/data/i18n
    owner: 1001
    group: 1001
  inventree-done:
    device: ./volumes/inventree/done
  db:
    device: ./volumes/mariadb/db
    owner: 88
    group: 88
  db-done:
    device: ./volumes/mariadb/done
```
