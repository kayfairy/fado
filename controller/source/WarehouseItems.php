<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;
use \Fado\Core\ListIteratorFactory as Factory;

class WarehouseItems extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\WarehouseItem();
    }

    public function get(?Iterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewItemForm', '0');
        Cache::set('newFormData', '');
        Cache::set('newFormData2', '');

        $validTabs = WAREHOUSE_ITEMS_TABS;
        if (!in_array(Cache::get('activeTab'), $validTabs)) {
            Cache::set('activeTab', 'WAREHOUSE_TAB_DATA');
        }

        $itemId = $this->request->getParameter('item');

        if ($this->request->getParameter('delete') == 'delete_item') {
            $itemId = $this->request->getParameter('id');
            if ($this->model->delete($itemId)) {
                $list = null;
                Cache::set('message', 'ITEM_DELETED');
            } else {
                Cache::set('message', 'ITEM_DELETE_ERROR');
            }
        }

        if ($this->request->getParameter('submit') == 'save_item') {
            Cache::set('activeTab', 'WAREHOUSE_TAB_DATA');
            if (is_numeric($this->request->getParameter('id'))) {
                $formStatus = $this->update($this->request, 'validateItemData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'ITEM_SAVE_ERROR');
                } else {
                    Cache::set('message', 'ITEM_SAVED');
                }
                Cache::set('newFormData', json_encode($this->request->getData($this->model)));
                $itemId = $formStatus['id'];
            } else {
                $formStatus = $this->add($this->request, 'validateItemData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'ITEM_ADD_ERROR');
                    Cache::set('openNewItemForm', '1');
                    $itemId = $formStatus['id'];
                } else {
                    Cache::set('message', 'ITEM_ADDED');
                }
                Cache::set('newFormData2', json_encode($this->request->getData($this->model)));
                $itemId = $formStatus['id'];
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
            }
            $list = null;
        }

        if ($list == null) {
            $list = $this->getAll();
        }

        if ($itemId != false && $list->offsetExists($itemId)) {
            $list->setActivePos($itemId);
        }

        return $list;
    }

    public function update(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            return;
        }
        $data = $request->getData($this->model);
        $data['price_unit'] = \Fado\Core\View::numberFormat2Float($data['price_unit']);
        $data['information'] = json_encode($request->getParameter('editor-1'));
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            return array('id' => $data['id'], 'success' => $this->model->update($data));
        } else {
            return array('id' => $data['id'], 'success' => false) + $message;
        }
    }

    public function add(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            $this->rightsController->redirect();
        }
        $data = $request->getData($this->model);
        $data['price_unit'] = \Fado\Core\View::numberFormat2Float($data['price_unit']);
        $data['information'] = json_encode($request->getParameter('editor-new'));
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            $success = $this->model->add($data);
            return array('id' => $this->model->lastInsertId(), 'success' => $success);
        } else {
            return array('id' => null, 'success' => false) + $message;
        }
    }

    public function getByShopId($shopId) {
         return Factory::create($this->model->getByShopId($shopId));
    }

}
