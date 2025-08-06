<?php

namespace Fado\Model;

use \Fado\Core\CSVReader as CSVReader;

abstract class FadoStaticModel extends \PDO {

    protected static $instances = array();

    protected static $relation = 'fado_table';

    public function __clone() {}

    public function __construct() {
        $dbConfig = CSVReader::read(DB_CONFIG_FILE);
        $dsn = 'mysql:dbname=' . $dbConfig['db'] . ';host=' . $dbConfig['host'] . ';charset=' . $dbConfig['charset'] . ';port=' . $dbConfig['port'] . ';socket=' . $dbConfig['socket'];
        parent::__construct($dsn, $dbConfig['user'], $dbConfig['pwd'], array(\PDO::MYSQL_ATTR_INIT_COMMAND => 'SET sql_mode="ALLOW_INVALID_DATES"'));
    }

    public static function singleton() {
        $instancedKey = array_keys(static::$instances, get_called_class());
        if (empty($instancedKey)) {
            $instance = new static;
            $instance->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
            static::$instances[get_class($instance)] = $instance;
        } else {
            $instance = static::$instances[$instancedKey];
        }
        return $instance;
    }

    public static function getColumnDataType($table, $columnNames) {
        $query = static::singleton()->query('SELECT COLUMN_NAME, DATA_TYPE FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=' . static::singleton()->quote(mb_strtolower('fado_' . $table)) . ' AND COLUMN_NAME IN (\'' . implode('\',\'', $columnNames) . '\')');
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public static function setTimezone($timeZone = 'Europe/London') {
        $query = static::singleton()->prepare('SET time_zone = :timezone');
        return $query->execute(array('timezone' => $timeZone));
    }

    public static function set($name, $value = 0) {}

    public static function get($name) {}

    public static function delete($name) {}

    public static function empty() {}

}
