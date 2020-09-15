<?php

namespace Fado\Model;

/*
 * read: 1
 * edit: 2
 * block: 0
 *
 * {"aj": "2", "at": "2", "if": "1", "in": "2", "me": "2", "na": "1", "ne": "2", "ri": "2", "sh": "2", "sq": "2", "st": "1", "ur": 2, "us": "2", "ut": "2", "ve": "2", "wa": "2"}
 *   
 *  PAGENAME        =>    SHORT
 *  ajax             => aj
 *  information     => if
 *  settings        => st
 *  shop           => sh
 *  vehicles        => ve
 *  warehouse        => wa
 *  invoices        => in
 *  newinvoice     => ne
 *  navigator        => na
 *  meetings        => me
 *  user           => us
 *  usersettings     => ut
 *  sqladmin        => sq
 *  adminsettings => at
 *  userrights    => ur
 */

class Rights extends FadoModel {

    protected $relation = 'fado_user_rights';

    protected $masterQuery = 'SELECT tbl.id AS id, tbl.id AS sid, tbl.rights FROM fado_user_rights AS tbl';

    public function get($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.user_id=:id');
        $query->execute(array(':id' => $id));
        return $query->fetch();
    }

    public function set($id, $jsonList) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET rights=:rights, changed=NOW() WHERE user_id=:id');
        return $query->execute(array(':id' => $id, 'rights' => $jsonList));
    }

}
