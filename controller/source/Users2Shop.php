<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;
use \Fado\Core\ListIteratorFactory as Factory;

class Users2Shop extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\User();
    }

    public function get(Iterator $list = null) {
        $userId = $this->request->getParameter('user');
        $shopId = $this->request->getParameter('shop');

        $saveuser2shop = $this->request->getParameter('save_user2shop');
        $user2ShopId = $this->request->getParameter('user2shop_id');
        $user2Shopusers = $this->request->getParameter('user2shop_users');

        if ($user2Shopusers != false && !is_array($user2Shopusers)) {
            $user2Shopusers = array($user2Shopusers);
        }
        if ($user2ShopId != false && $saveuser2shop == 'save_user2shop') {
            if ($user2Shopusers == false) {
                $this->model->deleteAllUserToShopRelation($user2ShopId);
            } else if (!$this->rightsController->isAllowed($this->request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
                $this->rightsController->redirect();
            } else if (is_array($user2Shopusers) && $this->model->saveuserToShopRelation($user2ShopId, $user2Shopusers)) {
                Cache::set('message', 'USER_TO_SHOP_ADDED');
            } else {
                Cache::set('message', 'USER_TO_SHOP_ERROR');
            }
            $list = null;
        }

        if ($list == null) {
            if ($shopId != null) {
                $list = Factory::create($this->model->getByShopId($shopId));
            } else {
                $list = $this->getAll();
            }
        }

        if ($userId != false && $list->offsetExists($userId)) {
            $list->setActivePos($userId);
        }

        return $list;
    }
}
