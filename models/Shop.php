<?php

namespace Fado\Model;

use \Fado\Model\Cache as Cache;
use \Fado\Model\Setting as Settings;

class Shop extends FadoModel {

    protected $relation = 'fado_shops';

    protected $sortableFields = array('location');

    protected $masterQuery = 'SELECT tbl.id AS id, tbl.id AS sid, loctbl.id AS locid, description, city, zip, street, streetnr, country, opening_hours, established, phone, email, information, email AS shop_email, phone AS shop_phone,CASE WHEN lng is NULL THEN "0.0" ELSE lng END AS lng, CASE WHEN lat is NULL THEN "0.0" ELSE lat END AS lat, CONCAT(REPLACE(lng, ".", ""), REPLACE(lat, ".", "")) AS location, tbl.created as shpcreated, tbl.changed AS shpchanged, loctbl.created AS loccreated, loctbl.changed AS locchanged FROM fado_shops AS tbl LEFT OUTER JOIN fado_shops2location AS loctbl ON tbl.id=loctbl.shop_id';

    public function getAll() {
        ##### SQL LIMIT #######
    	$pageCount = Cache::get('pc');
    	if ($pageCount === false) {
	    $pageCount = (int)Settings::get('list_count_single');
        }
	$page = Cache::get('p');
        if ($page === false) {
            $page = 1
        }
        $query = $this->query('SELECT COUNT(*) FROM fado_shops'); 
        $countmax = 0;
        $query->fetch()['COUNT(*)'];
        $query = $this->query($this->masterQuery . $this->order() . ' LIMIT ' . ($page - 1) * $pageCount . ', ' . $pageCount);
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function search($needle) {
        $query = $this->query($this->masterQuery . ' WHERE ' . implode(' LIKE "%' . $needle . '%" OR ', $this->getColumns(array('id'))) . ' LIKE "%' . $needle . '%"' . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function get($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.id=:id');
        $query->execute(array('id' => $id));
        return $query->fetch();
    }

    public function add($data) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE description=:description AND city=:city');
        $query->execute(array('description' => $data['description'], 'city' => $data['city']));
        $result = $query->fetch();
        if ($query->rowCount() > 0) {
//            return $this->update($data);
            return false;
        }
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (description, city, zip, street, streetnr, country, email, phone, information, established, opening_hours, created) VALUES (:description, :city, :zip, :street, :streetnr, :country, :email, :phone, :information, :established, :opening_hours, NOW())');
        foreach ($this->getColumns(array('id')) as $columnIdentifier) {
            $query->bindValue(':' . $columnIdentifier, $data[$columnIdentifier]);
        }
        return $query->execute();
    }

    public function update($data) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET description=:description, city=:city, zip=:zip, street=:street, streetnr=:streetnr, opening_hours=:opening_hours, country=:country, email=:email, phone=:phone, information=:information, established=:established, changed=NOW() WHERE id=:id');
        foreach ($this->getColumns() as $columnIdentifier) {
            $query->bindValue(':' . $columnIdentifier, $data[$columnIdentifier]);
        }
        return $query->execute();
    }
}
