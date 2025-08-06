<?php

namespace Fado\Model;

/*
 * use \Fado\Model\Setting as Settings;
 * Settings::get($name)
 *
 */

final class Setting extends FadoStaticModel {

    protected static $relation = 'fado_settings';

    protected static $userRelation = 'fado_user_settings';

    protected static $userSettings = array();

    protected static $userId = 1;

    public static function singleton() {
        $instance = parent::singleton();
        $instance::$userSettings = $instance->query('SELECT name FROM fado_user_settings')->fetchAll(\PDO::FETCH_COLUMN);
        return $instance;
    }

    public static function getUserSettings() {
        return static::$userSettings;
    }

    public static function setUserId(int $userId) {
        static::$userId = $userId;
    }

    public static function getUserId() {
        return static::$userId;
    }

    public static function getCurrencies() {
        $query = static::singleton()->query('SELECT currency FROM fado_currency');
        return $query->fetchAll(\PDO::FETCH_COLUMN);
    }

    public static function getActiveCurrency() {
        $query = static::singleton()->prepare('SELECT currency FROM fado_currency WHERE id=(SELECT value FROM fado_user_settings WHERE name="currency" AND user_id=:user_id)');
        $query->execute(array('user_id' => static::$userId));
        return $query->fetchColumn();
    }

    public static function getAll($afixCurrencies = true, $userSettings = true) {
        $query = static::singleton()->prepare('SELECT name, value FROM ' . static::$relation . (($userSettings) ? ' UNION SELECT name, value FROM ' . static::$userRelation . ' WHERE user_id=:user_id' : ''));
        if ($userSettings) {
            $query->execute(array('user_id' => static::$userId));
        }
        $query->execute();
        if ($afixCurrencies) {
            return array_merge($query->fetchAll(\PDO::FETCH_KEY_PAIR), array('currencies_available' => json_encode(static::getCurrencies())));
        }
        return $query->fetchAll(\PDO::FETCH_KEY_PAIR);
    }

    public static function set($name, $value = 0) {
        $query = static::singleton()->prepare('UPDATE ' . ((in_array($name, static::$userSettings)) ? static::$userRelation : static::$relation) . ' SET value=:value, changed=NOW() WHERE name=:name' . ((in_array($name, static::$userSettings)) ? ' AND user_id=:user_id' : ''));
        $values = (in_array($name, static::$userSettings)) ? array('name' => $name, 'value' => $value, 'user_id' => static::$userId) : array('name' => $name, 'value' => $value);
        return $query->execute($values);
    }

    public static function get($name) {
        $query = static::singleton()->prepare('SELECT value FROM ' . ((in_array($name, static::$userSettings)) ? static::$userRelation : static::$relation) . ' WHERE name=:name' . ((in_array($name, static::$userSettings)) ? ' AND user_id=:user_id' : ''));
        $values = (in_array($name, static::$userSettings)) ? array('name' => $name, 'user_id' => static::$userId) : array('name' => $name);
        $query->execute($values);
        return $query->fetchColumn();
    }

    public static function delete($name) {
        $query = static::singleton()->prepare('DELETE FROM ' . ((in_array($name, static::$userSettings)) ? static::$userRelation : static::$relation) . ' WHERE name=:name' . (in_array($name, static::$userSettings)) ? ' AND user_id=:user_id' : '');
        $values = (in_array($name, static::$userSettings)) ? array('name' => $name, 'user_id' => static::$userId) : array('name' => $name);
        return $query->execute($values);
    }
}
