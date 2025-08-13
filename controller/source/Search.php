<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIteratorFactory as Factory;

class Search extends FadoController {

    protected $urlParmIdentifier = 'search';

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController, $controller) {
        parent::__construct($request, $rightsController);
        $this->controller = $controller;
    }

    public function get(?\Fado\Core\ListIterator $list = null) {
        $needle = '';
        $getParam = $this->request->getParameter($this->urlParmIdentifier);
        $sessionParam = Cache::get($this->urlParmIdentifier);

        if ($getParam === '') {
            Cache::set($this->urlParmIdentifier, '');
            $sessionParam = '';
        }
        if ($getParam != false && $getParam != '') {
            $needle = $getParam;
            Cache::set($this->urlParmIdentifier, $needle);
        }
        if ($sessionParam != '' && $getParam == false) {
            $needle = $sessionParam;
        }
        if ($needle != '') {
            Cache::set('p', 1);
            return Factory::create($this->controller->getModel()->search($needle));
        }
        if ($list == null) {
            $list = Factory::create($this->controller->getModel()->getAll());
        }
        return $list;
    }
}
