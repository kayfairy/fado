<?php

namespace Fado\Controller\Filter;

use \Fado\Model\Cache as Cache;

class Sorting implements FadoInterface {

    private $controller = null;

    private $request = null;

    public function __construct(\Fado\Core\Request $request, $controller) {
        $this->controller = $controller;
        $this->request = $request;
    }

    public function filter(?\Fado\Core\ListIterator $list = null) {
        $sort = $this->request->getParameter('sort');
        $order = $this->request->getParameter('order');

        if ($sort != '' && $order != '') {
            $this->controller->getModel()->setOrder($sort, $order);
            Cache::set('sort', $sort);
            Cache::set('sort_d', $order);
        }

        $sort = Cache::get('sort');
        $order = Cache::get('sort_d');
        if ($sort != '' && $order != '') {
            $this->controller->getModel()->setOrder($sort, $order);
        }
    }

    public function setController($controller) {
        $this->controller = $controller;
        Cache::set('sort', '');
        Cache::set('sort_d', '');
    }
}
