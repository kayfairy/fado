<?php

namespace Fado\Core;

use \Fado\Model\Setting as Settings;

/*
 *
 * use \Fado\Core\Cookie as Cookie;
 * Cookie::get($name);
 *
 */

final class Cookie {

    public static function isset($name) {
        return isset($_COOKIE[$name]);
    }

    public static function get($name = '') {
        if ($name == '') {
            $name = Settings::get('cookiename');
        }
        if (static::isset($name)) {
            return substr($_COOKIE[$name], 0, 64);
        }
        return false;
    }

    public static function set($name, $value) {
        setcookie($name, $value, strtotime('+' . Settings::get('cookielife_hours') . ' hours'), $_SERVER['SERVER_NAME'], true);
        return static::get($name);
    }

    public static function unset($name) {
        unset($_COOKIE[$name]);
    }

}
