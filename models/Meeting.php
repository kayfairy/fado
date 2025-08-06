<?php

namespace Fado\Model;

class Meeting extends FadoModel {

    protected $relation = 'fado_meetings';

    protected $masterQuery = 'SELECT tbl.id AS id, tbl.id AS sid, user_id, title, description, meeting, tbl.created as created, tbl.changed as changed, usrtbl.changed as user_changed, usrtbl.created as user_created FROM fado_meetings AS tbl LEFT OUTER JOIN fado_user AS usrtbl ON tbl.user_id=usrtbl.id';

    public function getAll() {
        $query = $this->query($this->masterQuery . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function getByUserId($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.user_id=:user_id ' . $this->order());
        $query->bindValue(':user_id', $id);
        $query->execute();
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function add($data) {
        $query = $this->prepare('SELECT id FROM ' . $this->relation . ' WHERE title=:title');
        $query->bindValue(':title', $data['title']);
        $query->execute();
        $result = $query->fetch();
        if ($query->rowCount() > 0) {
//            return $this->update($data);
            return false;
        }
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (user_id, title, description, meeting, created) VALUES (:user_id, :title, :description, :meeting, NOW())');
        foreach ($this->getColumns(array('id', 'changed')) as $columnIdentifier) {
            $query->bindValue(':' . $columnIdentifier, $data[$columnIdentifier]);
        }
        return $query->execute();
    }
}
