<?php

namespace Fado\Controller;

use \Fado\Model\Cache as Cache;

class Ajax extends Source\FadoController {

    public function get(?\Fado\Core\ListIterator $list = null) {

        if ($this->request->getParameter('controller') == 'tabs' && $this->request->getParameter('id') != false) {
            Cache::set('activeTab', substr($this->request->getParameter('id'), 0, 20));
            header('HTTP/1.0 200 Content-Type: application/json', true, 200);
            echo json_encode(array('success' => true));
            die();
        }

        return $list;
    }
}
