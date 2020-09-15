<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;
use \Fado\Core\ListIteratorFactory as Factory;

class Shop2Vehicle extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Vehicle();
    }

    public function get(Iterator $list = null) {
        $vehicleId = $this->request->getParameter('vehicle');

        $saveVehicle2Shop = $this->request->getParameter('save_shop2vehicle');
        $vehicle2VehicleId = $this->request->getParameter('vehicle2shop_id');
        $vehicle2ShopId = $this->request->getParameter('shop2vehicle_shop');

        if ($vehicle2ShopId != false && $vehicle2VehicleId !== false && $saveVehicle2Shop == 'save_shop2vehicle') {
            if (!$this->rightsController->isAllowed($this->request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
                $this->rightsController->redirect();
            } else if ($this->model->saveVehicleToShopRelation(array($vehicle2ShopId), array($vehicle2VehicleId))) {
                Cache::set('message', 'VEHICLE_TO_SHOP_ADDED');
            } else {
                Cache::set('message', 'VEHICLE_TO_SHOP_ERROR');
            }
            $list = null;
        }

        if ($list == null) {
            if ($vehicleId != null) {
                $list = Factory::create($this->model->getByVehicleId($vehicleId));
            } else {
                $list = $this->getAll();
            }
        }

        if ($vehicleId != false && $list->offsetExists($vehicleId)) {
            $list->setActivePos($vehicleId);
        }

        return $list;
    }
}
