CREATE TABLE fado_shops (
    id INT NOT NULL AUTO_INCREMENT,
    description VARCHAR(256),
    city VARCHAR(256),
    zip VARCHAR(256),
    street VARCHAR(256),
    streetnr VARCHAR(256),
    country VARCHAR(256),
    phone VARCHAR(256),
    email VARCHAR(256),
    information VARCHAR(2048),
    opening_hours VARCHAR(256),
    established DATE NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    changed TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE fado_user (
    id INT NOT NULL AUTO_INCREMENT,
    active INT,
    online INT,
    name VARCHAR(256),
    pwd VARCHAR(256),
    salt VARCHAR(256),
    session VARCHAR(256),
    phone VARCHAR(256),
    email VARCHAR(256),
    data VARCHAR(2048),
    birthday DATE NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    changed TIMESTAMP NULL DEFAULT NULL,
    last_login TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

INSERT INTO fado_user (id, active, online, name, pwd, salt, session, phone, email, data, birthday, created, changed, last_login) VALUES (1,1,'0','fado','71f8bbcbeda85c1bdd739593c2671ba3ac882dac652e6b30c6c4c28b77e31e59','be5694902b43e839c6e9af7a36b9be8f2bb802ce810a5f25d05958dba0145d99',NULL,'0049111222333','fado@fado.com','\"<p><span style=\\\"color:#3498db\\\"><em>Superadmin<\\/em><\\/span><\\/p>\\r\\n\"', '2006-01-01', NOW(),NULL,NULL);

CREATE TABLE fado_vehicles (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256),
    manufacturer VARCHAR(256),
    type VARCHAR(256),
    construction_year INT,
    in_use INT,
    keynr INT,
    created TIMESTAMP NULL DEFAULT NULL,
    changed TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE fado_warehouse_items (
    id INT NOT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    name VARCHAR(256),
    information VARCHAR(2048),
    amount INT,
    sold INT,
    unit VARCHAR(256),
    price_unit DOUBLE,
    tax_rate DOUBLE,
    cut_rate DOUBLE,
    active INT,
    created TIMESTAMP NULL DEFAULT NULL,
    changed TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (shop_id)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_invoices (
    id INT NOT NULL AUTO_INCREMENT,
    shop_id_seller INT NOT NULL,
    shop_id_customer INT NOT NULL,
    is_payed INT,
    zone_time VARCHAR(6),
    created TIMESTAMP NULL DEFAULT NULL,
    changed TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (shop_id_seller)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    FOREIGN KEY (shop_id_customer)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_invoices2items (
    id INT NOT NULL AUTO_INCREMENT,
    invoice_id INT NOT NULL,
    item_id INT NOT NULL,
    amount INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (invoice_id)
    REFERENCES fado_invoices(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    FOREIGN KEY (item_id)
    REFERENCES fado_warehouse_items(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_shops2location (
    id INT NOT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    lat DOUBLE,
    lng DOUBLE,
    changed TIMESTAMP NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (shop_id)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_shops2user (
    id INT NOT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    user_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (shop_id)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    FOREIGN KEY (user_id)
    REFERENCES fado_user(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_shops2vehicles (
    id INT NOT NULL AUTO_INCREMENT,
    vehicle_id INT NOT NULL,
    shop_id INT NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (vehicle_id)
    REFERENCES fado_vehicles(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE,
    FOREIGN KEY (shop_id)
    REFERENCES fado_shops(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_currency (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(32),
    currency VARCHAR(4),
    ISO4217 varchar(3) DEFAULT NULL,
    PRIMARY KEY (id)
);

INSERT INTO fado_currency (id, name, currency, ISO4217) VALUES
(1,'Euro','€','EUR'),
(2,'Dollar','$','USD'),
(3,'Pound','£','GBP'),
(4,'Lira','₺','ITL'),
(5,'Ruble','₽','RUB'),
(6,'Yen','¥','JPY'),
(7,'Peso','₱','PHP'),
(8,'Dong','₫','VND'),
(9,'Hryvnia','₴','UAH'),
(10,'Franc','₣','CHF'),
(11,'Rial','﷼','YER'),
(12,'Sol','S/.','PEN'),
(13,'Shekel','₪','ILS'),
(14,'Cedi','¢','GHS'),
(15,'Won','₩','WON'),
(16,'Livbre','₶','LVB');

CREATE TABLE fado_settings (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(256),
    value VARCHAR(256),
    changed TIMESTAMP NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id)
);

INSERT INTO `fado_settings` (`id`, `name`, `value`, `changed`, `created`) VALUES
(1,'encoding','UTF-8',NULL,NOW()),
(2,'lang_available','[\"en_GB\",\"de_DE\",\"tr_TR\"]',NULL,NOW()),
(3,'date_time_format_available','{\"lang\":\"%c\",\"en_GB\":\"%Y/%m/%d %H:%M:%S\",\"en_US\":\"%d-%m-%Y %H:%M:%S\",\"UTC\":\"%x %H:%M:%S\",\"UTC2\":\"%a, %d. %b %Y %H:%M:%S\",\"UTC3\":\"%A %d. %B %Y %H:%M:%S\",\"de_DE\":\"%d.%m.%Y %H:%M:%S\"}',NULL,NOW()),
(4,'cookiename','FADO',NULL,NOW()),
(5,'cookielife_hours','8',NULL,NOW()),
(6,'error_reporting_available','[\"0\",\"E_ALL\",\"E_ALL & ~E_NOTICE\"]',NULL,NOW()),
(7,'error_log','1',NULL,NOW()),
(8,'error_reporting','E_ALL',NULL,NOW()),
(9,'memcache_on','0',NULL,NOW()),
(10,'memcache_host','127.0.0.1',NULL,NOW()),
(11,'memcache_port','11211',NULL,NOW()),
(12,'memcache_life_seconds','36000',NULL,NOW()),
(13,'memcache_compressed','0',NULL,NOW()),
(14,'invoice_mode_available','[\"brutto\",\"netto\"]',NULL,NOW()),
(15,'map_tile_url','{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',NULL,NOW()),
(16,'map_route_url','router.project-osrm.org/route/v1',NULL,NOW()),
(17,'rewrite_route','0',NULL,NOW()),
(18,'date_format_available','{"en_GB\":\"%Y/%m/%d\",\"en_US\":\"%d-%m-%Y\",\"UTC\":\"%x\",\"UTC2\":\"%a, %d. %b %Y\",\"UTC3\":\"%A %d. %B %Y\",\"de_DE\":\"%d.%m.%Y\"}',NULL,NOW()),
(19,'maximum_login_attempts','5',NULL,NOW());

CREATE TABLE fado_user_settings (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(256),
    value VARCHAR(256),
    changed TIMESTAMP NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id)
    REFERENCES fado_user(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

INSERT INTO `fado_user_settings` (`id`, `user_id`, `name`, `value`, `changed`, `created`) VALUES
(1,1,'lang','en_GB',NULL,NOW()),
(2,1,'timezone','Europe/London',NULL,NOW()),
(3,1,'number_format','[\"2\",\",\",\".\"]',NULL,NOW()),
(4,1,'date_time_format','%d.%m.%Y %H:%M:%S',NULL,NOW()),
(5,1,'item_amount_units','[\"100g\",\"50g\",\"100ml\",\"1m³\",\"1m²\",\"1cl\",\"1oz\",\"1kg\",\"100kg\",\"500ml\",\"1l\",\"10l\",\"1mg\",\"500mg\",\"50mg\",\"1box\",\"1pcs\",\"Transaction\",\"1l ℮\"]',NULL,NOW()),
(6,1,'display_errors','1',NULL,NOW()),
(7,1,'currency','3',NULL,NOW()),
(8,1,'tax_rates','[\"8\",\"18\",\"0\"]',NULL,NOW()),
(9,1,'invoice_mode','brutto',NULL,NOW()),
(10,1,'vat_on','1',NULL,NOW()),
(11,1,'list_count_single','3',NULL,NOW()),
(12,1,'date_format','%a, %d. %b %Y',NULL,NOW()),
(13,1,'time_format','%H:%M',NULL,NOW());

CREATE TABLE fado_user_rights (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    rights VARCHAR(2048),
    changed TIMESTAMP NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id)
    REFERENCES fado_user(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

INSERT INTO `fado_user_rights` (`id`, `user_id`, `rights`, `changed`, `created`) VALUES
(1,1,'{\"sh\":\"2\",\"ve\":\"2\",\"wa\":\"2\",\"in\":\"2\",\"ne\":\"2\",\"na\":\"1\",\"us\":\"2\",\"ut\":\"2\",\"at\":\"2\",\"st\":\"1\",\"ri\":\"2\",\"sq\":\"2\",\"me\":\"2\",\"aj\":\"2\",\"if\":\"1\"}',NULL,NOW());

CREATE TABLE fado_meetings (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    title VARCHAR(256),
    description VARCHAR(256),
    meeting VARCHAR(256),
    changed TIMESTAMP NULL DEFAULT NULL,
    created TIMESTAMP NULL DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (user_id)
    REFERENCES fado_user(id)
    ON UPDATE NO ACTION
    ON DELETE CASCADE
);

CREATE TABLE fado_cache (
    session VARCHAR(64),
    name VARCHAR(64),
    value VARCHAR(10000)
)ENGINE = MEMORY;

SET sql_mode="ALLOW_INVALID_DATES";
