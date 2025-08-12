<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIteratorFactory as Factory;

class NewInvoice extends FadoController {

    protected $invoicesModel = null;

    protected $userController = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController, \Fado\Controller\Source\Users $user) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\WarehouseItem();
        $this->invoicesModel = new \Fado\Model\Invoice();
        $this->shopModel = new \Fado\Model\Shop();
        $this->userController = $user;
    }

    public function get(?\Fado\Core\ListIterator $list = null) {
        $itemCount = (int)$this->request->getParameter('item-count');
        $shopId = (int)$this->request->getParameter('shop-id');
        $forward = $this->request->getParameter('forward') == 'save_forward';
        $save = $this->request->getParameter('save_invoice') == 'save_invoice';
        $cancel = $this->request->getParameter('cancel_invoice') == 'cancel_invoice';

        $shop = $this->shopModel->get($shopId);
        if (is_array($shop)) {
            Cache::set('InvoiceShopCustomer', json_encode($shop));
        }

        $items = Cache::get('newInvoiceList');

        if ($items != '') {
            $items = Factory::create(json_decode($items, true));
            if ($items->count() > 0) {
                $list = $items;
            }
        }
        $currentState = Cache::get('newItemState');
        $currentState = ($currentState != false) ? $currentState : 1;

        if ($forward) {
            $currentState = 2;
        }

        if ($save) {
            $customerShop = (array)json_decode(Cache::get('InvoiceShopCustomer'));

            $this->invoicesModel->add(array('shop_id_seller' => $this->userController->getLoggedInUser()['shop_id'], 'shop_id_customer' => $customerShop['sid']));

            $values = array('ids' => array(), 'count' => array());
            foreach ($items->get() as $item) {
                $values['ids'][] = $item['sid'];
                $values['count'][] = $item['item_amount'];
            }

            $this->invoicesModel->addItemsToInvoice($this->invoicesModel->lastInsertId(), $values['ids'], $values['count']);

            $currentState = 1;
            Cache::set('InvoiceShopCustomer', '');
            Cache::set('newInvoiceList', '');
            Cache::set('message', 'INVOICE_ADDED');
        }

        if ($cancel) {
            $currentState = 1;
            Cache::set('InvoiceShopCustomer', '');
            Cache::set('newInvoiceList', '');
            Cache::set('message', '');
        }

        if ($itemCount > 0) {
            $items = array('count' => array(), 'ids' => array());

            for ($i = 0; $i < $itemCount; $i++) {
                $count = (int)$this->request->getParameter('item-count-' . $i);
                if ($count > 0) {
                    $items['ids'][$i] = (int)$this->request->getParameter('item-' . $i);
                    $items['count'][$items['ids'][$i]] = $count;
                }
            }

            $invoiceItems = $this->model->getByIds($items['ids']);
            foreach ($invoiceItems as $key => $item) {
                $invoiceItems[$key]['item_amount'] = $items['count'][$key];
                unset($invoiceItems[$key]['information']);
                unset($invoiceItems[$key]['shop_information']);
                unset($invoiceItems[$key]['opening_hours']);
                foreach ($item as $column => $value) {
                    if (is_int($column)) {
                        unset($invoiceItems[$key][$column]);
                    }
                }
            }

            Cache::set('newInvoiceList', json_encode($invoiceItems));
            $currentState = 2;
            $list = Factory::create($invoiceItems);
        }

        Cache::set('newItemState', $currentState);

        if ($list == null) {
            $list = Factory::create(array());
        }

        return $list;
    }

}
