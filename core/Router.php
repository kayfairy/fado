<?php

namespace Fado\Core;

use \Fado\Model\Setting as Settings;
use \Fado\Model\Cache as Cache;

class Router {

    public function __construct() {
        $this->route();
    }

    /*
     * URL Rewrite
     *
     * 127.0.0.1/page/parameter/value/ ->  127.0.0.1/?page=page&parameter=value
     *
     */
    public function urlRewrite() {
        $uri = (isset($_GET['page'])) ? Request::trim($_GET['page']) : '';
        if (preg_match_all('/[\w\d]+/', $uri, $uriPart) !== false) {
            $uriPart = $uriPart[0];
            if (count($uriPart) > 2) {
                $_GET['page'] = $uriPart[0];
                for ($i = 1; $i < count($uriPart); $i += 2) {
                    $_GET[$uriPart[$i]] = $uriPart[$i + 1];
                }
            }
        }
    }

    public function route() {
        $request = new Request();
        $user = new \Fado\Controller\Source\Users($request);
        $rights = new \Fado\Controller\RouterRights($request, $user);
        $pages = new \Fado\Controller\Filter\Paginator($request, $rights);

        if ($user->getLoggedInUser() !== false) {
            $userId = $user->getLoggedInUser()['sid'];
        } else {
            $userId = null;
        }
        if (is_int($userId)) {
            Settings::setUserId($userId);
        }
        $user->setRightsController($rights);

        $listDefaultCount = (int)Settings::get('list_count_single');

        $view = new View($rights);

        if ((int)Settings::get('rewrite_route')) {
            $this->urlRewrite();
        }
        $page = $request->getParameter('page');

        if ($user->checkLogin() == false) {
            $view->includeTemplate('login', array());
            return;
        }

        if (!$rights->get() && in_array($page, USER_RIGHTS_AREAS)) {
            $rights->redirect();
            return;
        }

        // ajax
        if ($page == 'aj') {
            $ajax = new \Fado\Controller\Ajax($request, $rights);
            $ajax->get();
            return;
        }

        // user
        if ($page == 'us') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $user);
            $search = new \Fado\Controller\Source\Search($request, $rights, $user);
            $users2Shop = new \Fado\Controller\Source\Users2Shop($request, $rights);

            $sort->filter();
            $allShopsList = $shops->getAll();
            $users2Shop->get();
            $userList = $pages->filter($user->get($search->get())->setItemsPerPage($listDefaultCount));
            if ($userList->current() && $userList->current()['sid'] != null) {
                $assignedShopList = ListIteratorFactory::create(array($userList->current()['shop_id'] => $userList->current()))->setActivePos($userList->current()['shop_id']);
            } else {
                $assignedShopList = array();
            }
            $view->includeTemplate('useradmin', array('user' => $userList, 'assignedShops' => $assignedShopList, 'allShops' => $allShopsList));
            return;
        }

        // navigator
        if ($page == 'na') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $warehouseItems = new \Fado\Controller\Source\WarehouseItems($request, $rights);
            $invoices = new \Fado\Controller\Source\Invoices($request, $rights);
            $vehicles2Shop = new \Fado\Controller\Source\Vehicles2Shop($request, $rights);

            $shops->getModel()->setOrder('location', 'ASC');
            $shopList = $shops->get()->resetKeys();
            $vehicles2Shop->getModel()->setOrder('location', 'ASC');
            $allVehiclesList = $vehicles2Shop->getAll()->resetKeys();
            $allInvoicesList = $invoices->getAll()->resetKeys();
            $allItemsList = $warehouseItems->getAll()->resetKeys();

            if ((bool)$request->getParameter('print')) {
                $view->includeTemplate('print/navigator', array('shops' => $shopList, 'vehicles' => $allVehiclesList, 'invoices' => $allInvoicesList, 'warehouseitems' => $allItemsList));
                return;
            }

            $view->includeTemplate('navigator', array('shops' => $shopList, 'vehicles' => $allVehiclesList, 'invoices' => $allInvoicesList, 'warehouseitems' => $allItemsList));
            return;
        }

        // vehicles
        if ($page == 've') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $vehicles = new \Fado\Controller\Source\Vehicles($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $vehicles);
            $search = new \Fado\Controller\Source\Search($request, $rights, $vehicles);
            $shop2Vehicle = new \Fado\Controller\Source\Shop2Vehicle($request, $rights);

            $sort->filter();
            $allShopsList = $shops->getAll();
            $assignedShopList = $shop2Vehicle->get();
            $vehicleList = $pages->filter($vehicles->get($search->get())->setItemsPerPage($listDefaultCount));

            $view->includeTemplate('vehicles', array('vehicles' => $vehicleList, 'assignedShops' => $assignedShopList, 'allShops' => $allShopsList));
            return;
        }

        // warehouse
        if ($page == 'wa') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $warehouseItems = new \Fado\Controller\Source\WarehouseItems($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $warehouseItems);
            $search = new \Fado\Controller\Source\Search($request, $rights, $warehouseItems);

            $sort->filter();
            $allShopsList = $shops->getAll();
            $warehouseItemList = $pages->filter($warehouseItems->get($search->get())->setItemsPerPage($listDefaultCount));

            $view->includeTemplate('warehouse', array('items' => $warehouseItemList, 'allShops' => $allShopsList));
            return;
        }

        // newinvoice
        if ($page == 'ne') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $newInvoice = new \Fado\Controller\Source\NewInvoice($request, $rights, $user);
            $warehouseItems = new \Fado\Controller\Source\WarehouseItems($request, $rights);

            $userShopId = $user->getLoggedInUser()['shop_id'];
            $warehouseItems->getModel()->setOrder('id', 'ASC');
            $allItemsList = $warehouseItems->getAll();
            $allShopsList = $shops->getAll();
            $invoiceItems = $newInvoice->get();
            $activeUser = $user->getLoggedInUser();

            $view->includeTemplate('newinvoice', array('allItems' => $allItemsList, 'allShops' => $allShopsList, 'activeUser' => $activeUser, 'invoices' => $invoiceItems));
            return;
        }

        // invoices
        if ($page == 'in') {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $invoices = new \Fado\Controller\Source\Invoices($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $invoices);
            $search = new \Fado\Controller\Source\Search($request, $rights, $invoices);

            $allShopsList = $shops->getAll();
            $invoices->getModel()->setOrder('id', 'DESC');
            $sort->filter();
            $invoiceItems = $pages->filter($invoices->get($search->get())->setItemsPerPage($listDefaultCount));

            if ((bool)$request->getParameter('print')) {
                $view->includeTemplate('print/invoice', array('invoices' => $invoiceItems));
            } else {
                $view->includeTemplate('invoices', array('invoices' => $invoiceItems, 'allShops' => $allShopsList));
            }
            return;
        }

        // shops
        if (in_array($page, array(false, 'sh'), true)) {
            $shops = new \Fado\Controller\Source\Shops($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $shops);
            $search = new \Fado\Controller\Source\Search($request, $rights, $shops);
            $vehicles2Shop = new \Fado\Controller\Source\Vehicles2Shop($request, $rights);
            $users2Shop = new \Fado\Controller\Source\Users2Shop($request, $rights);

            $sort->filter();
            $pages->filter();
            $allVehiclesList = $vehicles2Shop->getAll(true);
            $assignedVehiclesList = $vehicles2Shop->get();
            $allUsersList = $users2Shop->getAll(true);
            $assignedUsersList = $users2Shop->get();
            $shopList = $pages->filter($shops->get($search->get())->setItemsPerPage($listDefaultCount));

            $view->includeTemplate('shop', array('shops' => $shopList, 'assignedVehicles' => $assignedVehiclesList, 'allVehicles' => $allVehiclesList, 'assignedUsers' => $assignedUsersList, 'allUsers' => $allUsersList));
            return;
        }

        // meetings
        if ($page == 'me') {
            $meetings = new \Fado\Controller\Source\Meetings($request, $rights);
            $sort = new \Fado\Controller\Filter\Sorting($request, $meetings);
            $search = new \Fado\Controller\Source\Search($request, $rights, $meetings);

            $sort->filter();
            $meetingsList = $pages->filter($meetings->get($search->get())->setItemsPerPage($listDefaultCount));
            $view->includeTemplate('meetings', array('meetings' => $meetingsList));
            return;
        }

        // usersettings
        if ($page == 'ut') {
            $settings = new \Fado\Controller\Source\Settings($request, $rights);

            $settingsList = $settings->get();
            $view->includeTemplate('usersettings', array('settings' => $settingsList));
            return;
        }

        if ($page == 'at') {
            $settings = new \Fado\Controller\Source\Settings($request, $rights);

            $settingsList = $settings->get(null, false);
            $view->includeTemplate('adminsettings', array('settings' => $settingsList));
            return;
        }

        if ($page == 'sq') {
            $importer = new \Fado\Controller\Source\DatabaseSQL($request, $rights);

            $settingsList = $importer->get();
            $view->includeTemplate('settingsdatabase', array('settings' => $settingsList));
            return;
        }

        if ($page == 'st') {
            $view->includeTemplate('settings', array());
            return;
        }

        if ($page == 'if') {
            $view->includeTemplate('serverinfo', array());
            return;
        }

        if ($page == '403') {
            header('HTTP/1.0 403 Permission Denied', true, 403);
            $view->includeTemplate('403', array(''));
        } else {
            header('HTTP/1.0 404 Not Found', true, 404);
            $view->includeTemplate('404', array(''));
        }
        return;
    }

}
