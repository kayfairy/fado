<?php

namespace Fado\Core;

use \Fado\Model\Setting as Setting;
$availInvoiceMode = json_decode(Setting::get('invoice_mode_available'));
$itemAmountUnits = json_decode(Setting::get('item_amount_units'));
$availLang = json_decode(Setting::get('lang_available'));
$timeZones = View::getAvailableTimeZones();
$currencies = Setting::getCurrencies();

$availInvoiceMode = array_map('\Fado\Core\View::quotePRegExp', $availInvoiceMode);
$itemAmountUnits = array_map('\Fado\Core\View::quotePRegExp', $itemAmountUnits);
$currencies = array_map('\Fado\Core\View::quotePRegExp', $currencies);
$availLang = array_map('\Fado\Core\View::quotePRegExp', $availLang);
$timeZones = array_map('\Fado\Core\View::quotePRegExp', $timeZones);

define('VALIDATION_REGEX_ARRAY_SETTINGUSER_DATA_FIELDS', array(
    'number_format' => array('/[0-9]{1}#[\s\.,;:]{1}#[\s\.,;:]{1}/u', true, 'ERROR_FIELD_INVALID'),
    'item_amount_units' => array('validateJSON', true, 'ERROR_FIELD_INVALID'),
    'tax_rates' => array('validateJSON', true, 'ERROR_FIELD_INVALID'),
    'display_errors' => array('/^[0,1]{0,1}$/', true, 'ERROR_FIELD_INVALID'),
    'vat_on' => array('/^[0,1]{0,1}$/', true, 'ERROR_FIELD_INVALID'),
    'list_count_single' => array('/^[0-9]{1,3}$/', true, 'ERROR_FIELD_ONLY_NUMBERS'),
    'lang' => array('@' . join('|', $availLang) . '@', true, 'ERROR_FIELD_INVALID'),
    'currency' => array('/[0-9]{1,2}/', true, 'ERROR_FIELD_INVALID'),
    'timezone' => array('@' . join('|', $timeZones) . '@', true, 'ERROR_FIELD_INVALID'),
    'date_time_format' => array('validateDate', true, 'ERROR_FIELD_INVALID'),
    'date_format' => array('validateDate', true, 'ERROR_FIELD_INVALID'),
    'invoice_mode' => array('@' . join('|', $availInvoiceMode) . '@', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_SETTING_DATA_FIELDS', array(
    'cookielife_hours' => array('/^[0-9]{1,2}$/', true, 'ERROR_FIELD_INVALID'),
    'cookiename' => array('/^[a-zA-Z0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'memcache_on' => array('/^[0,1]{0,1}$/', true, 'ERROR_FIELD_INVALID'),
    'memcache_life_seconds' => array('/^[0-9]{1,5}$/', true, 'ERROR_FIELD_ONLY_NUMBERS'),
    'memcache_port' => array('/^[0-9]{1,5}$/', true, 'ERROR_FIELD_ONLY_NUMBERS'),
    'memcache_host' => array('/(^((http|https):\/\/){1}(www.|[a-zA-Z0-9{}]+.)[a-z0-9-{}\.]+.[a-z]{2,3}(\/[a-zA-Z0-9{}.-\\?]+)*$|^((http|https):\/\/){0,1}[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}$|^((http|https):\/\/){0,1}localhost$)/', true, 'ERROR_FIELD_INVALID'),
    'map_tile_url' => array('/(^(www.|[a-zA-Z0-9{}]+.)[a-z0-9-{}\.]+.[a-z]{2,3}(\/[a-zA-Z0-9{}.-\\?]+)*$|^((http|https):\/\/){1}[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}(\/[a-zA-Z0-9{}.-\\?]+)*$|^((http|https):\/\/){1}localhost(\/[a-zA-Z0-9{}.-\\?]+)*$)/', true, 'ERROR_FIELD_INVALID'),
    'map_route_url' => array('/(^(www.|[a-zA-Z0-9{}]+.)[a-z0-9-{}\.]+.[a-z]{2,3}(\/[a-zA-Z0-9{}.-\\?]+)*$|^((http|https):\/\/){1}[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}(\/[a-zA-Z0-9{}.-\\?]+)*$|^((http|https):\/\/){1}localhost(\/[a-zA-Z0-9{}.-\\?]+)*$)/', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_SHOP_DATA_FIELDS', array(
    'description' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'street' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'streetnr' => array('/^[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'zip' => array('/^[0-9a-zA-Z\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'city' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'country' => array('/^[a-zA-Z0-9\W]+$/', false, 'ERROR_FIELD_INVALID'),
    'phone' => array('/^[+]{0,1}[ 0-9]+$/', false, 'ERROR_FIELD_INVALID'),
    'email' => array('/^[a-zA-Z0-9\W]+?@[a-zA-Z0-9\W]+?.[a-zA-Z]{2}$/', false, 'ERROR_FIELD_EMAIL_INVALID'),
    'information' => array('/^[a-zA-Z0-9\s\W\d\\\.]+$/u', false, 'ERROR_FIELD_INVALID'),
    'opening_hours' => array('validateJSON', true, 'ERROR_FIELD_INVALID'),
    'established' => array('/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_SHOP_LOCATION_DATA_FIELDS', array(
   'lng' =>  array('/^[0-9]+?\.[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
   'lat' =>  array('/^[0-9]+?\.[0-9]+$/', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_USER_DATA_FIELDS', array(
    'name' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'pwd' => array('/^[a-zA-Z0-9\W]+$/', false, 'ERROR_FIELD_INVALID'),
    'active' => array('/^[0,1]{0,1}$/', false, 'ERROR_FIELD_INVALID'),
    'phone' => array('/^[+ 0-9]+$/', false, 'ERROR_FIELD_INVALID'),
    'email' => array('/^[a-zA-Z0-9\W]+?@[a-zA-Z0-9\W]+?.[a-zA-Z]{2}$/', false, 'ERROR_FIELD_EMAIL_INVALID'),
    'data' => array('/^[a-zA-Z0-9\s\W\d\\"\'\.]+$/u', false, 'ERROR_FIELD_INVALID'),
    'birthday' => array('/^[0-9]{4}-[0-9]{2}-[0-9]{2}$/', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_VEHICLE_DATA_FIELDS', array(
    'name' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'manufacturer' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'type' => array('/^[a-zA-Z0-9\W]+$/', false, 'ERROR_FIELD_INVALID'),
    'construction_year' => array('/^[0-9]{4}$/', false, 'ERROR_FIELD_INVALID'),
    'in_use' => array('/^[0,1]{0,1}$/', false, 'ERROR_FIELD_INVALID'),
    'keynr' => array('/^[0-9]+$/', false, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_ITEM_DATA_FIELDS', array(
    'name' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'shop_id' => array('/^[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'information' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'amount' => array('/^[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'unit' => array('@' . join('|', $itemAmountUnits) . '@', true, 'ERROR_FIELD_INVALID'),
    'price_unit' => array('/^[0-9\., ]+$/', false, 'ERROR_FIELD_INVALID'),
    'tax_rate' => array('/^[0-9]{1,2}$/', true, 'ERROR_FIELD_INVALID'),
    'cut_rate' => array('/^[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'active' => array('/^[0,1]{0,1}$/', false, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_MEETING_DATA_FIELDS', array(
    'user_id' => array('/^[0-9]+$/', true, 'ERROR_FIELD_INVALID'),
    'title' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'description' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'meeting' => array('validateJSON', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_LOGIN_DATA_FIELDS', array(
    'username' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID'),
    'password' => array('/^[a-zA-Z0-9\W]+$/', true, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_INVOICE_DATA_FIELDS', array(
    'is_payed' => array('/^[0,1]{0,1}$/', false, 'ERROR_FIELD_INVALID')
));

define('VALIDATION_REGEX_ARRAY_INVOICEMAIL_DATA_FIELDS', array(
    'mailto' => array('/^[a-zA-Z0-9\W]+?@[a-zA-Z0-9\W]+?.[a-zA-Z]{2}$/', true, 'ERROR_FIELD_EMAIL_INVALID'),
));
