<?php

namespace Fado\Core;

trait ViewController {

    public function getController($type = 'Source\Users') {
        $class = '\\Fado\\Controller\\' . preg_replace('/\\\\/', '\\', $type);
        return new $class(new \Fado\Core\Request(), $this->userRights);
    }

}
