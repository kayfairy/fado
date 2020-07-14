<?php

namespace Fado\Controller\Filter;

use \Fado\Model\Cache as Cache;

class Paginator implements FadoInterface {

    private $request = null;

    public function __construct(\Fado\Core\Request $request) {
        $this->request = $request;
    }

    public function filter(\Fado\Core\ListIterator $list = null) {
        $itemsPerPage = (int)$this->request->getParameter('pc');
        if ($itemsPerPage == 0) {
            $itemsPerPage = Cache::get('pc');
        }
        if ($itemsPerPage > 0) {
            Cache::set('pc', $itemsPerPage);
            $list->setItemsPerPage($itemsPerPage);
        }

        $page = $this->request->getParameter('p');
        if ($page == false) {
            $page = Cache::get('p');
            if ($page == '') {
                $page = 1;
            }
        }
        if ($page > $list->getPageCount()) {
            $page = $list->getPageCount();
        }
        if ($page < 0) {
            $page = 1;
        }
        Cache::set('p', $page);
        $list->setCurrentPage($page);

        return $list;
    }
}
