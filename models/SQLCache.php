<?php

namespace Fado\Model;

use \Fado\Core\Cookie as Cookie;

final class SQLCache extends FadoStaticModel {

    protected static $relation = 'fado_cache';

    protected static $session = null;

    public static function singleton() {
        $instance = parent::singleton();
        $instance::$session = Cookie::get();
        return $instance;
    }

    public static function set($name, $value = 0) {
        $instance = static::singleton();
        $instance->delete($name);
        $query = $instance->prepare('INSERT INTO ' . $instance::$relation . ' (session, name, value) VALUES (:session, :name, :value)');
        return $query->execute(array('name' => $name, 'value' => $value, 'session' => $instance::$session));
    }

    public static function get($name) {
        $instance = static::singleton();
        $query = $instance->prepare('SELECT value FROM ' . $instance::$relation . ' WHERE name=:name AND session=:session');
        $query->execute(array('name' => $name, 'session' => $instance::$session));
        return $query->fetchColumn();
    }

    public static function delete($name) {
        $instance = static::singleton();
        $query = $instance->prepare('DELETE FROM ' . $instance::$relation . ' WHERE name=:name AND session=:session');
        return $query->execute(array('name' => $name, 'session' => $instance::$session));
    }

    public static function empty() {
        $instance = static::singleton();
        $query = $instance->prepare('TRUNCATE TABLE ' . $instance::$relation);
        return $query->execute();
    }
}
