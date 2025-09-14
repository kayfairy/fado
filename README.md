![Bootstrap](https://img.shields.io/badge/bootstrap-%238511FA.svg?style=for-the-badge&logo=bootstrap&logoColor=white)![jQuery](https://img.shields.io/badge/jquery-%230769AD.svg?style=for-the-badge&logo=jquery&logoColor=white)![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)![Debian](https://img.shields.io/badge/Debian-D70A53?style=for-the-badge&logo=debian&logoColor=white)![Apache](https://img.shields.io/badge/apache-%23D42029.svg?style=for-the-badge&logo=apache&logoColor=white)
![MariaDB](https://img.shields.io/badge/MariaDB-003545?style=for-the-badge&logo=mariadb&logoColor=white)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
[<img src="https://vmssoftware.com/images/intro/product/memcached.png" width="30"/>](https://vmssoftware.com/images/intro/product/memcached.png)
[<img src="https://wiki.openstreetmap.org/w/images/3/3e/Icon_logos.png" width="30" />](https://wiki.openstreetmap.org/w/images/3/3e/Icon_logos.png)
![Firefox](https://img.shields.io/badge/Firefox-FF7139?style=for-the-badge&logo=Firefox-Browser&logoColor=white)![Opera](https://img.shields.io/badge/Opera-FF1B2D?style=for-the-badge&logo=Opera&logoColor=white)

# fado
Manage shops, vehicles and commodities in administration panel. Calculate invoices and routes with fado server.

![FadoScreenshot](https://user-images.githubusercontent.com/45335404/71079337-5fd22600-218b-11ea-9500-a17b98e7d9c5.png)

## Install
`Debian 11` required (PHP 8.2).

Download to `/var/www/html/` and run install script.

    sudo sh /var/www/html/install.sh

## Start Docker container
    cd /home/fado
    git clone https://github.com/kayfairy/fado.git
    cd fado/
    docker-compose up

The Apache config file and SSL keys are linked in the volume section of the `docker-compose.yml`. Activate HTTPS with `/usr/sbin/a2enmod ssl`.
Compatible with Android and Termux App utilizing udocker on ARM CPU.

## User
Open <http://172.0.0.1> or <https://172.0.0.1> and login as superuser `fado` with password `rood`.
Change the password of the database user:

    mariadb -u root -e "SET PASSWORD FOR 'fado'@'localhost' = PASSWORD('secret1');"

## Features
-   Mobile device support
-   Full Template Engine (HTML5, MVC, Forms, Direct Memory)
-   User and access control
-   Adjust and save opening hours
-   Save location, amount and price of goods for invoice print
-   Save location of customer shops and vehicles to print path in OpenStreet map (B2B)
-   Appointments calendar

## includes new useful input elements
[round date and time selector](https://github.com/kayfairy/round-date-selector.git)

[weekdayrange selector](https://github.com/kayfairy/weekday-range-selector.git)

![FadoOpeningHours](https://user-images.githubusercontent.com/45335404/61489900-0ed7bf00-a9ac-11e9-8c40-73d68b275523.png)

## Database
MySQL database created is `fado` for user `fado` with password `rood`. Insert new credentials into `database.csv`.
Move file to `/etc/fado/database.csv`. Edit `core/Loader.php`:

    define('DB_CONFIG_FILE', '/etc/fado/database.csv');

## Demo data
Go to <http://127.0.0.1/?page=sq> and upload `fado-DML.sql`.

## Languages
English, German, Spanish, Dutch, Turkish (per user 5 available)

## License
[GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.en.html) © 2017-2025 Fatih Kaymak
