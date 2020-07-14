<?php

namespace Fado\Controller\Source;

interface FadoInterface {
    public function get(\Fado\Core\ListIterator $list);
}