<?php

namespace Fado\Core;

trait HttpRequest {

    public static function getProtocol() {
        return ($_SERVER['SERVER_PORT'] == 443 || $_SERVER['SERVER_PORT'] == 8443) ? 'https://' : 'http://';
    }

    public static function getHostLink() {
        return static::getProtocol() . $_SERVER['HTTP_HOST'] . ':' . $_SERVER['SERVER_PORT'];
    }

    public static function getSelfLink() {
        return static::getProtocol() . $_SERVER['HTTP_HOST']  . ':' . $_SERVER['SERVER_PORT'] . $_SERVER['PHP_SELF'];
    }

    public static function getFullLink() {
        return static::getProtocol() . $_SERVER['HTTP_HOST']  . ':' . $_SERVER['SERVER_PORT'] . $_SERVER['REQUEST_URI'];
    }

    public static function getReferer() {
        return $_SERVER ['HTTP_REFERER'];
    }

    public static function getParameter($name) {
        if (isset($_POST[$name]) && is_array($_POST[$name])) {
            $returnValue = array();
            foreach ($_POST[$name] as $value) {
                $returnValue[] = static::trim($value);
            }
            return $returnValue;
        }
        if (isset($_GET[$name]) && is_array($_GET[$name])) {
            $returnValue = array();
            foreach ($_GET[$name] as $value) {
                $returnValue[] = static::trim($value);
            }
            return $returnValue;
        }
        if (isset($_POST[$name])) {
            return static::trim($_POST[$name]);
        }
        if (isset($_GET[$name])) {
            return static::trim($_GET[$name]);
        }
        return false;
    }

    public static function trim($value) {
        return preg_replace(array('/^(\s+)[.]+$/u', '/^[.]+(\s+)$/u', '/^(\s+)$/u'), array('', '', '$1'), $value);
    }

    public static function isMobile() {
        return preg_match('/(android|avantgo|blackberry|bolt|boost|cricket|docomo|fone|hiptop|mini|mobi|palm|phone|pie|tablet|up\.browser|up\.link|webos|wos)/i', $_SERVER['HTTP_USER_AGENT']);
    }
}
