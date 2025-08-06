<?php

namespace Fado\Model;

class User extends FadoModel {

    protected $relation = 'fado_user';

    protected $relation2user = 'fado_shops2user';

    protected $masterQuery = 'SELECT tbl.id AS id, tbl.id AS sid, stbl.id AS shop_id, session, active, online, name, pwd, salt, tbl.phone, tbl.email, data, birthday, tbl.created, tbl.changed, tbl.last_login, tbl.created AS user_created, tbl.changed AS user_changed, stbl.phone AS shop_phone, stbl.email AS shop_email,  description, city, zip, street, streetnr, country, opening_hours, established FROM fado_user AS tbl LEFT OUTER JOIN fado_shops2user AS rel ON tbl.id = rel.user_id LEFT OUTER JOIN fado_shops AS stbl ON stbl.id = rel.shop_id';

    /*
     * function used for generating hash out of value
     * returns random hash, if parameter provided is set to 0
     *
     * @param  string  $value
     * @return string  $hash
     *
     */
    public function hash($value = 0, $algorythm = 'haval256,5') {
        if ($value === 0) {
            $value = uniqid(rand(), true);
        }
        return (string)hash($algorythm, $value);
    }

    public function getAll() {
        $query = $this->query($this->masterQuery . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function get($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE name LIKE :id OR tbl.id LIKE :id OR session LIKE :id');
        $query->execute(array(':id' => $id));
        return $query->fetch();
    }

    public function getByShopId($shopId) {
        $query = $this->prepare($this->masterQuery . ' WHERE stbl.id=:shop_id');
        $query->execute(array(':shop_id' => $shopId));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function add($data) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE name LIKE :name');
        $query->execute(array(':name' => $data['name']));
        $result = $query->fetch();
        if ($query->rowCount() > 0) {
//            return $this->update($data);
            return false;
        }
        $data['salt'] = $this->hash();
        $data['pwd'] = $this->hash($data['pwd'] . $data['salt']);
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (active, online, name, pwd, salt, phone, email, data, birthday, created) VALUES (IFNULL(:active, "0"), IFNULL(:online, "0"), :name, :pwd, :salt, :phone, :email, :data, :birthday, NOW())');
        foreach ($this->getColumns(array('id', 'session', 'groups', 'last_login')) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        $returnValue = $query->execute();
        $newId = $this->lastInsertId();
        $query = $this->prepare(SQL_NEW_USER_SETTINGS);
        $query->execute(array(':id' => $newId));
        $query = $this->prepare(SQL_NEW_USER_RIGHTS);
        $query->execute(array(':id' => $newId));
        $query = $this->prepare(SQL_NEW_USER_2_SHOP);
        $query->execute(array(':id' => $newId));
        return $returnValue;
    }

    public function update($data) {
        if ($data['pwd'] == '') {
            $data['salt'] = null;
            $data['pwd']  = null;
        } else {
            $data['salt'] = $this->hash();
            $data['pwd']  = $this->hash($data['pwd'] . $data['salt']);
        }
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET active=IFNULL(:active, "0"), online=IFNULL(:online, "0"), pwd=IFNULL(:pwd, pwd), salt=IFNULL(:salt, salt), phone=:phone, email=:email, data=:data, birthday=:birthday, changed=NOW() WHERE id=:id');
        foreach ($this->getColumns(array('last_login', 'session', 'groups', 'name')) as $column) {
            $query->bindValue(':' . $column, $data[$column]);
        }
        return $query->execute();
    }

    public function getUserId($userName) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE name LIKE :name');
        $query->execute(array(':name' => $userName));
        return $query->fetch();
    }

    public function login($id) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET online="1", session=IF(session IS NULL, :hash, session) WHERE name LIKE :id OR id=:id');
        $query->execute(array(':id' => $id, ':hash' => $this->hash()));
        $this->updateLastLogin($id);
        return $this->get($id);
    }

    public function logout($id) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET online="0", session=NULL WHERE session LIKE :id OR id=:id');
        return $query->execute(array(':id' => $id));
    }

    public function updateLastLogin($id, $time = 'NOW()') {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET last_login=' . $time . ' WHERE name LIKE :id OR id=:id OR session LIKE :id');
        $query->execute(array(':id' => $id));
          $id= $this->getUserId($id)['id'];
        $query = $this->prepare('INSERT INTO fado_user_ip (user_id, ip, login_time) VALUES (:user_id, :ip, ' . $time . ')');
        return $query->execute(array(':user_id' => $id, ':ip' => $_SERVER['REMOTE_ADDR']));
    }

    public function validatePwd($pwd, $id) {
        $query = $this->prepare('SELECT salt, pwd, active FROM ' . $this->relation . ' WHERE name LIKE :id OR id=:id');
        $query->execute(array(':id' => $id));
        $result = $query->fetch();
        return ($result !== false) && ($result['active'] == '1') && ($this->hash($pwd . $result['salt']) == $result['pwd']);
    }

    public function saveUserToShopRelation($shopId, array $userIds) {
        foreach ($userIds as $userId) {
            $query = $this->prepare('DELETE FROM ' . $this->relation2user . ' WHERE user_id=:user_id');
            $query->execute(array(':user_id' => $userId));
            $query = $this->prepare('INSERT INTO ' . $this->relation2user . ' (shop_id, user_id) VALUES (:shop_id, :user_id)');
            $query->execute(array(':shop_id' => $shopId, 'user_id' => $userId));
        }
        $this->checkRelation();
        return true;
    }

    public function deleteAllUserToShopRelation($shopId) {
        $query = $this->prepare('DELETE FROM ' . $this->relation2user . ' WHERE shop_id=:shop_id');
        $query->execute(array(':shop_id' => $shopId));
        $this->checkRelation();
        return true;
    }

    public function checkRelation() {
        $query = $this->prepare('SELECT * FROM fado_user');
        $query->execute();
        $results = $query->fetchAll();
        foreach ($results as $result) {
            $query = $this->prepare('SELECT COUNT(*) FROM ' . $this->relation2user . ' WHERE user_id=:user_id');
            $query->execute(array(':user_id' => $result['id']));
            $relationIsNull = $query->fetch(\PDO::FETCH_COLUMN);
            if ($relationIsNull == 0) {
                $query = $this->prepare('INSERT INTO ' . $this->relation2user . ' (shop_id, user_id) VALUES ((SELECT id FROM fado_shops LIMIT 1), :user_id)');
                $query->execute(array(':user_id' => $result['id']));
            }
        }
    }
}
