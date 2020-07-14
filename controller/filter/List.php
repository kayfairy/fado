<?php

namespace Fado\Controller\Filter;

class List implements FadoInterface {

    public function filter(\Fado\Core\ListIterator $list, $filterIds) {

        return $list;
    }

}
