<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIteratorFactory as Factory;

class InvoicePDF extends FadoController {

    protected $shopModel = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Invoice();
        $this->shopModel = new \Fado\Model\Shop();
    }

    public function get(\Fado\Core\ListIterator $list = null) {

        $invoiceId = $this->request->getParameter('invoice');

        if ($list == null) {
            $list = $this->getAll();
        }

        if ($invoiceId != false && $list->offsetExists($invoiceId)) {
            $list->setActivePos($invoiceId);
            $items = $this->model->getItemsByInvoiceId($invoiceId);
            Cache::set('activeInvoice', json_encode($items));
            Cache::set('InvoiceViewShopCustomer', json_encode($this->shopModel->get($list->current()['shop_id_customer'])));
            Cache::set('InvoiceViewShopSeller', json_encode($this->shopModel->get($list->current()['shop_id_seller'])));

            ob_start(null, 0, PHP_OUTPUT_HANDLER_STDFLAGS ^ PHP_OUTPUT_HANDLER_REMOVABLE);
            \Fado\Core\View::staticIncludeTemplate('print/invoice', array('invoices' => $items));
            $template = ob_get_contents();
            ob_clean();

            file_put_contents(sys_get_temp_dir() . '/invoice' . $invoiceId . '.html', $template, LOCK_EX);
            exec('wkhtmltopdf ' . sys_get_temp_dir() . '/invoice' . $invoiceId . '.html ' . sys_get_temp_dir() . '/invoice' . $invoiceId . '.pdf', $output);

            header('HTTP/1.0 200 OK', true, 200);
            header('Content-Disposition: attachment; filename=invoice' . $invoiceId . '.pdf');
            echo file_get_contents(sys_get_temp_dir() . '/invoice' . $invoiceId . '.pdf');
            die();
        }
    }
}
