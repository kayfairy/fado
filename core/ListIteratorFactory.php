<?php

namespace Fado\Core;

require_once './core/ListIterator.php';

class ListIteratorFactory {

    public static function create($list) {
        return new \Fado\Core\ListIterator($list);
    }
}