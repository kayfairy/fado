<?php

namespace Fado\Model;

class Vehicle extends FadoModel {

    protected $relation = 'fado_vehicles';

    protected $relation2shop = 'fado_shops2vehicles';

    protected $masterQuery = 'SELECT *, tbl.id AS sid, tbl.changed AS vehicle_changed, tbl.created AS vehicle_created, CONCAT(REPLACE(lng, ".", ""), REPLACE(lat, ".", "")) AS location, stbl.id as shop_id FROM fado_vehicles AS tbl LEFT OUTER JOIN fado_shops2vehicles AS rel ON tbl.id = rel.vehicle_id LEFT OUTER JOIN fado_shops AS stbl ON stbl.id = rel.shop_id LEFT OUTER JOIN fado_shops2location AS loctbl ON stbl.id=loctbl.shop_id';

    public function getAll() {
        $query = $this->query($this->masterQuery . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function getByShopId($shopid) {
        $query = $this->prepare($this->masterQuery . ' WHERE rel.shop_id=:id' . $this->order());
        $query->execute(array('id' => $shopid));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function getByVehicleId($vehicleId) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.id=:id' . $this->order());
        $query->execute(array('id' => $vehicleId));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function add($data) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE name LIKE :name');
        $query->execute(array(':name' => $data['name']));
        $result = $query->fetch();
        if ($query->rowCount() > 0) {
            return false;
        }
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (name, manufacturer, type, construction_year, in_use, keynr, created) VALUES (:name, :manufacturer, :type, :construction_year, IFNULL(:in_use, "0"), :keynr, NOW())');
        foreach ($this->getColumns(array('id')) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        return $query->execute();
    }

    public function update($data) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET name=:name, manufacturer=:manufacturer, type=:type, construction_year=:construction_year, in_use=IFNULL(:in_use, "0"), keynr=:keynr, changed=NOW() WHERE id=:id');
        foreach ($this->getColumns(array()) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        return $query->execute();
    }

    public function saveVehicleToShopRelation(array $shopIds, array $vehicleIds) {
        foreach ($vehicleIds as $vehicleId) {
            foreach ($shopIds as $shopId) {
                // only 1:n (v:s)
                $query = $this->prepare('DELETE FROM ' . $this->relation2shop . ' WHERE vehicle_id=:vehicle_id');
                $query->execute(array(':vehicle_id' => $vehicleId));
                $query = $this->prepare('INSERT INTO ' . $this->relation2shop . ' (shop_id, vehicle_id) VALUES (:shop_id, :vehicle_id)');
                $query->execute(array(':shop_id' => $shopId, 'vehicle_id' => $vehicleId));
            }
        }
    }

    public function deleteAllVehicleToShopRelation($shopId) {
        $query = $this->prepare('DELETE FROM ' . $this->relation2shop . ' WHERE shop_id=:shop_id');
        $query->execute(array(':shop_id' => $shopId));
    }
}
