# fado

Manage shops, vehicles and commodities in administration panel. Calculate invoices and routes with fado server.

![FadoScreenshot](https://user-images.githubusercontent.com/45335404/71079337-5fd22600-218b-11ea-9500-a17b98e7d9c5.png)

## Install

`Ubuntu 20.04` required.

Download to `/var/www/fado/` and run install script.

    sudo sh /var/www/fado/install.sh

## User

Open <http://127.0.0.1> or <https://127.0.0.1> and login as superuser `fado` with password `rood`.

## Features

-   Mobile device support
-   User and access control
-   Adjust and save opening hours
-   Full Template Engine (HTML5, MVC, Forms, Direct Memory)

![FadoOpeningHours](https://user-images.githubusercontent.com/45335404/61489900-0ed7bf00-a9ac-11e9-8c40-73d68b275523.png)

## Database

MySQL database created is `fado` for user `fado` with password `rood`. Insert new credentials into `database.csv`.

Move file to `/etc/fado/database.csv`. Edit `core/Loader.php`:

    4   define('DB_CONFIG_FILE', '/etc/fado/database.csv');

## Demo

Go to <https://127.0.0.1/?page=sqladmin> and upload `fado-demo.sql`.

## License

[GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.en.html)
