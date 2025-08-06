<?php

namespace Fado\Model;

class WarehouseItem extends FadoModel {

    protected $relation = 'fado_warehouse_items';

    protected $masterQuery = 'SELECT *, tbl.information AS information, tbl.id AS sid, tbl.id AS id, stbl.information AS shop_information, stbl.created AS shop_created, stbl.changed AS shop_changed, stbl.id AS shop_id, stbl.description AS spname FROM fado_warehouse_items AS tbl LEFT OUTER JOIN fado_shops AS stbl ON stbl.id = tbl.shop_id LEFT OUTER JOIN fado_shops2location AS loctbl ON stbl.id=loctbl.shop_id';

    public function get($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.id=:id');
        $query->execute(array('id' => $id));
        return $query->fetch();
    }

    public function getAll($onlyActive = false) {
        $query = $this->query($this->masterQuery . $this->order() . (($onlyActive) ? ' WHERE tbl.amount>0 AND tbl.active=1' : ''));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function getByShopId($shopid) {
        $query = $this->prepare($this->masterQuery . ' WHERE stbl.id=:id' . $this->order());
        $query->execute(array('id' => $shopid));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function add($data) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE name LIKE :name');
        $query->execute(array(':name' => $data['name']));
        $result = $query->fetch();
        if ($query->rowCount() > 0) {
            return false;
        }
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (name, shop_id, information, amount, sold, unit, price_unit, tax_rate, cut_rate, active, created) VALUES (:name, :shop_id, :information, :amount, 0, :unit, :price_unit, :tax_rate, :cut_rate, IFNULL(:active, "0"), NOW())');
        foreach ($this->getColumns(array('id', 'sold')) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        return $query->execute();
    }

    public function update($data) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET name=:name, shop_id=:shop_id, information=:information, amount=:amount, unit=:unit, price_unit=:price_unit, tax_rate=:tax_rate, cut_rate=:cut_rate, active=IFNULL(:active, "0"), changed=NOW() WHERE id=:id');
        foreach ($this->getColumns(array('sold')) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        return $query->execute();
    }
}
