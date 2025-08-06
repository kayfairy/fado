<?php

namespace Fado\Model;

use \Fado\Core\CSVReader as CSVReader;

require_once 'ModelAccess.php';

abstract class FadoModel extends \PDO implements ModelAccess {

    protected $relation = 'fado_table';

    protected $masterQuery = 'SELECT tbl.id AS sid, * FROM fado_shops AS tbl';

    protected $order = '';

    protected $sortableFields = array();

    public function __construct() {
        $dbConfig = (array)CSVReader::read(DB_CONFIG_FILE);
        $dsn = 'mysql:dbname=' . $dbConfig['db'] . ';host=' . $dbConfig['host'] . ';charset=' . $dbConfig['charset'] . ';port=' . $dbConfig['port'] . ';socket=' . $dbConfig['socket'];
        parent::__construct($dsn, $dbConfig['user'], $dbConfig['pwd'], array(\PDO::MYSQL_ATTR_INIT_COMMAND => 'SET sql_mode="ALLOW_INVALID_DATES"'));
        $this->setAttribute(\PDO::ATTR_ERRMODE, \PDO::ERRMODE_EXCEPTION);
    }

    public function getColumns($exclude = array(), $timestamps = false, $prefix = '') {
        if (!$timestamps) {$exclude = array_merge($exclude, array('created', 'changed'));}
        $exclude = array_map(function ($a) {return $this->quote($a);}, $exclude);
        $query = $this->query('SELECT ' . (($prefix != '') ? 'CONCAT(' . $this->quote($prefix) . ', COLUMN_NAME)' : 'COLUMN_NAME') . ' FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME=' . $this->quote($this->relation) . ((!empty($exclude)) ? ' AND COLUMN_NAME NOT IN (' . implode(',', $exclude) . ')' : ''));
        return $query->fetchAll(\PDO::FETCH_COLUMN);
    }

    public function setOrder($column, $direction = 'ASC') {
        if (in_array($column, $this->getColumns(array(), true))) {
            $column = 'tbl.' . $column;
        } elseif (!in_array($column, $this->sortableFields)) {
            return false;
        }
        if (!in_array($direction, array('DESC', 'ASC'))) {
            return false;
        }
        $this->order = ' ORDER BY ' . $column . ' ' . $direction;
        return true;
    }

    public function getByIds(array $ids) {
        $query = $this->query($this->masterQuery . ' WHERE tbl.id IN (' . implode(',', $ids) . ')');
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function search($needle) {
        $query = $this->query($this->masterQuery . ' WHERE ' . implode(' LIKE "%' . $needle . '%" OR ', $this->getColumns(array(), true, 'tbl.')) . ' LIKE "%' . $needle . '%"' . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function delete($id) {
        $query = $this->prepare('DELETE FROM ' . $this->relation . ' WHERE id=:id');
        return $query->execute(array('id' => $id));
    }

    public function order() {
        return $this->order;
    }

    public function get($id) {}

    public function add($data) {}
}
