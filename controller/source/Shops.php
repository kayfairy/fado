<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;

class Shops extends FadoController {

    protected $locationModel;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Shop();
        $this->locationModel = new \Fado\Model\ShopLocation();
    }

    public function get(\Fado\Core\ListIterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewShopForm', '0');
        Cache::set('newFormData', '');
        Cache::set('newFormData2', '');

        $validTabs = SHOPS_TABS;
        if (!in_array(Cache::get('activeTab'), $validTabs)) {
            Cache::set('activeTab', 'SHOP_TAB_MAP');
        }

        if ($this->request->getParameter('delete') == 'delete_shop') {
            $id = $this->request->getParameter('id');
            if ($this->model->delete($id)) {
                $list = null;
                Cache::set('message', 'SHOP_DELETED');
            } else {
                Cache::set('message', 'SHOP_DELETE_ERROR');
            }
        }

        $shopId = $this->request->getParameter('shop');
        $shopLng = $this->request->getParameter('shop_coordinates_lng');
        $shopLat = $this->request->getParameter('shop_coordinates_lat');
        if ($shopId != false && $shopLng != false && $shopLat != false) {
            $message = $this->request->validateShopLocation(array('lng' => $shopLng, 'lat' => $shopLat));
            if (empty($message)) {
                $this->locationModel->add($shopId, array($shopLng, $shopLat));
                $list = null;
                Cache::set('message', 'SHOP_COORDS_SAVE');
            } else {
                Cache::set('message', 'SHOP_SAVE_ERROR');
            }
        }

        if ($this->request->getParameter('submit') == 'save_shop') {
            Cache::set('activeTab', 'SHOP_TAB_FORM');
            if (is_numeric($this->request->getParameter('id'))) {
                $formStatus = $this->update($this->request, 'validateShopData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'SHOP_SAVE_ERROR');
                } else {
                    Cache::set('message', 'SHOP_SAVED');
                }
                Cache::set('newFormData', json_encode($this->request->getData($this->model)));
                $shopId = $formStatus['id'];
            } else {
                $formStatus = $this->add($this->request, 'validateShopData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'SHOP_ADD_ERROR');
                    Cache::set('openNewShopForm', '1');
                    Cache::set('newFormData2', json_encode($this->request->getData($this->model)));
                } else {
                    Cache::set('message', 'SHOP_ADDED');
                }
                $shopId = $formStatus['id'];
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
            }
            $list = null;
        }
        if ($list == null) {
            $list = $this->getAll();
        }
        if ($shopId != false && $list->offsetExists($shopId)) {
            $list->setActivePos($shopId);
        }
        return $list;
    }

    public function update(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            $this->rightsController->redirect();
        }
        $data = $request->getData($this->model);
        $openingHours = array();
        for ($i = 1; $i <= intval($request->getParameter('openinghours-count-1')); $i++) {
            $openingHours[$i]['range'] = $request->getParameter('openinghours-range-' . $i);
            $openingHours[$i]['open'] = $request->getParameter('openinghours-open-' . $i);
            $openingHours[$i]['close'] = $request->getParameter('openinghours-close-' . $i);
        }
        $data['opening_hours'] = json_encode($openingHours);
        $data['information'] = json_encode($request->getParameter('editor-1'));
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            $success = $this->model->update($data);
            return array('id' => $data['id'], 'success' => $success);
        } else {
            return array('id' => $data['id'], 'success' => false) + $message;
        }
    }

    public function add(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            $this->rightsController->redirect();
        }
        $data = $request->getData($this->model);
        $openingHours = array();
        for ($i = 1; $i <= intval($request->getParameter('openinghours-count-new-1')); $i++) {
            $openingHours[$i]['range'] = $request->getParameter('openinghours-range-new-' . $i);
            $openingHours[$i]['open'] = $request->getParameter('openinghours-open-new-' . $i);
            $openingHours[$i]['close'] = $request->getParameter('openinghours-close-new-' . $i);
        }
        $data['opening_hours'] = json_encode($openingHours);
        $data['information'] = json_encode($request->getParameter('editor-new'));
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            $success = $this->model->add($data);
            return array('id' => $this->model->lastInsertId(), 'success' => $success);
        } else {
            return array('id' => null, 'success' => false) + $message;
        }
    }
}
