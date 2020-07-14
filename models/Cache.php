<?php

namespace Fado\Model;

use Fado\Model\Setting as Settings;
use Fado\Model\MemCache as MemCache;
use Fado\Model\SQLCache as SQLCache;

/*
 *
 * use \Fado\Model\Cache as Cache;
 * Cache::get($name);
 *
 */

final class Cache {

    protected static $cacheObject = null;

    public static function singleton() {
        if (static::$cacheObject === null) {
            if (Settings::get('memcache_on') === '1') {
                static::$cacheObject = new MemCache();
            } else {
                static::$cacheObject = new SQLCache();
            }
        }
        return static::$cacheObject;
    }

    public static function set($name, $value = 0) {
        static::singleton()::set($name, $value);
    }

    public static function get($name) {
        return static::singleton()::get($name);
    }

    public static function delete($name) {
        static::singleton()::delete($name);
    }

    public static function empty() {
        static::singleton()::empty();
    }

}
