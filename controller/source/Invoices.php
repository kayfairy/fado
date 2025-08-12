<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;

class Invoices extends FadoController {

    protected $shopModel = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Invoice();
        $this->itemModel = new \Fado\Model\WarehouseItem();
        $this->shopModel = new \Fado\Model\Shop();
    }

    public function get(?Iterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewItemForm', '0');
        Cache::set('newFormData', '');

        $invoiceId = $this->request->getParameter('invoice');

        if ($invoiceId == false) {
            Cache::set('activeInvoice', '');
        }

        if ($this->request->getParameter('delete') == 'delete_invoice') {
            $invoiceId = $this->request->getParameter('id');
            if ($this->model->delete($invoiceId)) {
                $list = null;
                Cache::set('message', 'INVOICE_DELETED');
            } else {
                Cache::set('message', 'INVOICE_DELETE_ERROR');
            }
        }

        if ($this->request->getParameter('submit') == 'save_invoice') {
            Cache::set('activeTab', 'INVOICE_TAB_FORM');
            if (is_numeric($this->request->getParameter('id'))) {
                $formStatus = $this->update($this->request, 'validateInvoiceData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'INVOICE_SAVE_ERROR');
                } else {
                    Cache::set('message', 'INVOICE_SAVED');
                }
                $invoiceId = $formStatus['id'];
            } else {
                $formStatus = $this->add($this->request, 'validateInvoiceData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'INVOICE_ADD_ERROR');
                    Cache::set('openNewItemForm', '1');
                } else {
                    Cache::set('message', 'INVOICE_ADDED');
                }
                $invoiceId = $formStatus['id'];
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
                Cache::set('newFormData', json_encode($this->request->getData($this->model)));
            }
            $list = null;
        }

        if ($list == null) {
            $list = $this->getAll();
        }
        if ($invoiceId != false && $list->offsetExists($invoiceId)) {
            $list->setActivePos($invoiceId);
            $items = $this->model->getItemsByInvoiceId($invoiceId);
            Cache::set('activeInvoice', json_encode($items));
            Cache::set('InvoiceViewShopCustomer', json_encode($this->shopModel->get($list->current()['shop_id_customer'])));
            Cache::set('InvoiceViewShopSeller', json_encode($this->shopModel->get($list->current()['shop_id_seller'])));
        }

        return $list;
    }

    public function update(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        $data = $request->getData($this->model);

        $itemsForInvoice = $this->model->getItemsByInvoiceId($data['id']);
        foreach ($itemsForInvoice as $item) {
            $currentItem = $this->itemModel->get($item['item_id']);
            if ($data['is_payed'] == '1') {
                $currentItem['amount'] -= $item['item_amount'];
                $currentItem['sold'] += $item['item_amount'];
            } else {
                $currentItem['amount'] += $item['item_amount'];
                $currentItem['sold'] -= $item['item_amount'];
            }
//            $currentItem['amount'] = $currentItem['amount'] < 0 ? 0 : $currentItem['amount'];
            $this->itemModel->update($currentItem);
        }

        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            return array('id' => $data['id'], 'success' => $this->model->update($data));
        } else {
            return array('id' => $data['id'], 'success' => false) + $message;
        }
    }
}
