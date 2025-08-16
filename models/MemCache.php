<?php

namespace Fado\Model;

use Fado\Core\Cookie as Cookie;
use Fado\Model\Setting as Settings;

final class MemCache {

    protected static $instance = null;

    public static function singleton() {
        if (static::$instance == null) {
            static::$instance = new \Memcache();
            static::$instance->addServer(Settings::get('memcache_host'), Settings::get('memcache_port'));
        }
        return static::$instance;
    }

    protected static function getKey($name) {
        return hash('md5', Cookie::get() . $name);
    }

    public static function set($name, $value = 0) {
        return static::singleton()->set(static::getKey($name), $value, ((bool)Settings::get('memcache_compressed')) ? MEMCACHE_COMPRESSED : NULL, (int)Settings::get('memcache_life_seconds'));
    }

    public static function get($name) {
        return static::singleton()->get(static::getKey($name));
    }

    public static function delete($name) {
        return static::singleton()->delete(static::getKey($name));
    }

    public static function empty() {
        return static::singleton()->flush();
    }

    public static function status() {
        return static::singleton()->getExtendedStats();
    }

}
