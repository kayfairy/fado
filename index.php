<?php

namespace Fado;

require_once './core/Loader.php';

use \Fado\Model\Setting as Settings;

mb_internal_encoding(Settings::get('encoding'));

setlocale(LC_ALL, Settings::get('lang') . '.UTF-8', Settings::get('lang') . '.utf8', Settings::get('lang'));
date_default_timezone_set(Settings::get('timezone'));

error_reporting((int)Settings::get('error_reporting'));
ini_set('error_log', (int)Settings::get('error_log'));
ini_set('display_errors', (int)Settings::get('display_errors'));

new Core\Router();
