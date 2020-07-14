<?php

namespace Fado\Controller\Filter;

interface FadoInterface {
    public function filter(\Fado\Core\ListIterator $list);
}