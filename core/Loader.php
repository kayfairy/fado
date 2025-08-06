<?php

// Database credentials
define('DB_CONFIG_FILE', 'database.csv');

// URL rewrite parameter
define('URL_REWRITE_PARAMATER', array('shop', 'item', 'invoice', 'vehicle', 'user','sort','order','p','pc', 'pdf', 'print'));

// Visible table columns
define('SHOPS_TABLE_COLUMNS', array('description', 'street', 'zip', 'city', 'country', 'opening_hours', 'established', 'location'));
define('USER_TABLE_COLUMNS', array('name', 'pwd', 'active', 'online', 'data', 'birthday', 'created', 'changed', 'last_login'));
define('VEHICLES_TABLE_COLUMNS', array('name', 'manufacturer', 'type', 'construction_year', 'in_use', 'keynr', 'changed'));
define('WAREHOUSE_ITEMS_TABLE_COLUMNS', array('name', 'shop_name', 'information', 'amount', 'sold', 'unit', 'tax_rate', 'cut_rate', 'price_unit', 'active'));
define('INVOICES_TABLE_COLUMNS', array('id', 'shop_seller', 'shop_customer', 'is_payed', 'created', 'changed'));
define('MEETINGS_TABLE_COLUMNS', array('title', 'description', 'meeting', 'created', 'delete'));

// Visible form fields
define('SHOPS_DATA_FIELDS', array('sid', 'description', 'street', 'streetnr', 'zip', 'city', 'country', 'email', 'information', 'phone', 'opening_hours', 'established'));
define('USER_DATA_FIELDS', array('sid', 'name', 'pwd', 'active', 'data', 'email', 'phone', 'birthday'));
define('VEHICLES_DATA_FIELDS', array('sid', 'name', 'manufacturer', 'type', 'construction_year', 'in_use', 'keynr'));
define('WAREHOUSE_ITEMS_DATA_FIELDS', array('sid', 'shop_id', 'information', 'name', 'amount', 'unit', 'price_unit', 'tax_rate', 'cut_rate', 'currency', 'active'));
define('INVOICES_DATA_FIELDS', array('is_payed'));

// Visible tabs
define('SHOPS_TABS', array('SHOP_TAB_MAP', 'SHOP_TAB_ADDRESS', 'SHOP_TAB_FORM', 'SHOP_TAB_VEHICLE', 'SHOP_TAB_USER'));
define('VEHICLES_TABS', array('VEHICLE_TAB', 'VEHICLE_TAB_SHOP'));
define('USER_TABS', array('USER_TAB_DATA', 'USER_TAB_RIGHTS', 'USER_TAB_SHOP'));
define('WAREHOUSE_ITEMS_TABS', array('WAREHOUSE_TAB_DATA'));

// Super administrators
define('ADMIN_USERS', array('fado'));

// Pages available
define('USER_RIGHTS_AREAS', array('sh', 've', 'wa', 'in', 'ne', 'na', 'us', 'ut', 'at', 'st', 'ri', 'sq', 'me', 'aj', 'if', 'ur'));

// Files loaded in order
require_once './core/Router.php';
require_once './core/CSVReader.php';
require_once './models/FadoModel.php';
require_once './models/FadoStaticModel.php';
require_once './models/Setting.php';
require_once './models/MemCache.php';
require_once './models/SQLCache.php';
require_once './core/ListIteratorFactory.php';
require_once './core/Cookie.php';
require_once './core/Request.php';
require_once './core/View.php';
require_once './models/ShopLocation.php';
require_once './models/Shop.php';
require_once './models/User.php';
require_once './models/Vehicle.php';
require_once './models/WarehouseItem.php';
require_once './models/Invoice.php';
require_once './models/Cache.php';
require_once './models/Rights.php';
require_once './models/Meeting.php';
require_once './controller/filter/FadoInterface.php';
require_once './controller/source/FadoInterface.php';
require_once './controller/source/FadoController.php';
require_once './controller/filter/Paginator.php';
require_once './controller/filter/Sorting.php';
require_once './controller/source/Search.php';
require_once './controller/source/Shops.php';
require_once './controller/source/Users.php';
require_once './controller/source/Users2Shop.php';
require_once './controller/source/Vehicles.php';
require_once './controller/source/Vehicles2Shop.php';
require_once './controller/source/Shop2Vehicle.php';
require_once './controller/source/WarehouseItems.php';
require_once './controller/source/NewInvoice.php';
require_once './controller/source/Invoices.php';
require_once './controller/source/Settings.php';
require_once './controller/source/DatabaseSQL.php';
require_once './controller/source/Meetings.php';
require_once './controller/Ajax.php';
require_once './controller/RouterRights.php';
require_once './core/FormValidationPRegExp.php';
require_once './core/NewUserModelFields.php';
