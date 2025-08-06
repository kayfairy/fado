<?php

namespace Fado\Model;

interface ModelAccess {

    public function get($id);
    public function add($data);
    public function delete($id);

}