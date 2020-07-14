<?php

namespace Fado\Controller;

use \Fado\Model\Cache as Cache;

class InvoiceMail extends Source\FadoController {

    protected $shopModel = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Invoice();
        $this->shopModel = new \Fado\Model\Shop();
    }

    public function get(\Fado\Core\ListIterator $list = null) {

        $invoiceId = $this->request->getParameter('invoice');
        $mailto = $this->request->getParameter('mailto');

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
            \Fado\Core\View::staticIncludeTemplate('mail/invoice', array('invoices' => $items));
            $mail = ob_get_contents();
            ob_clean();

            $message = $this->request->validateInvoiceMailData(array('mailto' => $mailto));

            if (!empty($message)) {
                Cache::set('formStatus', json_encode($message));
            } else {
                $subject = 'Invoice';
                $headers[] = 'MIME-Version: 1.0';
                $headers[] = 'Content-type: text/html; charset=utf8';
                $headers[] = 'From: client@fado.org';
                $headers[] = 'Reply-To: client@fado.org';
                $headers[] = 'X-Mailer: PHP/' . phpversion();

                mail($mailto, $subject, $mail, implode("\r\n", $headers));

                Cache::set('message', 'INVOICE_MAIL_SUCCESS');
            }
        }

        return $list;
    }
}
