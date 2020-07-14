<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;
use \Fado\Core\ListIteratorFactory as Factory;

class Vehicles2Shop extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Vehicle();
    }

    public function get(Iterator $list = null) {
        $vehicleId = $this->request->getParameter('vehicle');
        $shopId = $this->request->getParameter('shop');

        $saveVehicle2shop = $this->request->getParameter('save_vehicle2shop');
        $vehicle2ShopId = $this->request->getParameter('vehicle2shop_id');
        $vehicle2ShopVehicles = $this->request->getParameter('vehicle2shop_vehicles');

        if ($vehicle2ShopId != false && $saveVehicle2shop == 'save_vehicle2shop') {
            if ($vehicle2ShopVehicles == false) {
                $this->model->deleteAllVehicleToShopRelation($vehicle2ShopId);
            } else if (!$this->model->saveVehicleToShopRelation(array($vehicle2ShopId), $vehicle2ShopVehicles)) {
                Cache::set('message', 'VEHICLE_TO_SHOP_ADDED');
            } else {
                Cache::set('message', 'VEHICLE_TO_SHOP_ADD_ERROR');
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

        if ($vehicleId != false && $list->offsetExists($vehicleId)) {
            $list->setActivePos($vehicleId);
        }

        return $list;
    }
}
