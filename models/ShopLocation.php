<?php

namespace Fado\Model;

class ShopLocation extends FadoModel {

    protected $relation = 'fado_shops2location';

    public function add($shopId, array $coordinates = array('NULL', 'NULL')) {
        if ($this->hasLocation($shopId)) {
            $query = $this->prepare('UPDATE ' . $this->relation . ' SET lng=:lng, lat=:lat, changed=NOW() WHERE shop_id=:id');
        } else {
            $query = $this->prepare('INSERT INTO ' . $this->relation . ' (shop_id, lng, lat, created) VALUES (:id, :lng, :lat, NOW())');
        }
        return $query->execute(array(':id' => $shopId, ':lng' => $coordinates[0], ':lat' => $coordinates[1]));
    }

    public function get($shopId) {
        $query = $this->prepare('SELECT * FROM ' . $this->relation . ' WHERE shop_id=:id');
        $query->execute(array(':id' => $shopId));
        return $query->fetch();
    }

    private function hasLocation($shopId) {
        if ($this->get($shopId) == false) {
            return false;
        }
        return true;
    }
}
