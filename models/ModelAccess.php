<?php

namespace Fado\Model;

interface ModelAccess {

    public function get($id);
    public function set($data);
    public function delete($id);

}
