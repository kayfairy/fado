<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIterator as Iterator;

class Vehicles extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Vehicle();
    }

    public function get(?Iterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewVehicleForm', '0');
        Cache::set('newFormData', '');
        Cache::set('newFormData2', '');
        Cache::set('message', '');

        $validTabs = VEHICLES_TABS;
        if (!in_array(Cache::get('activeTab'), $validTabs)) {
            Cache::set('activeTab', 'VEHICLE_TAB');
        }

        $vehicleId = $this->request->getParameter('vehicle');

        if ($this->request->getParameter('delete') == 'delete_vehicle') {
            $id = $this->request->getParameter('id');
            if ($this->model->delete($id)) {
                $list = null;
                Cache::set('message', 'VEHICLE_DELETED');
            } else {
                Cache::set('message', 'VEHICLE_DELETE_ERROR');
            }
        }

        if ($this->request->getParameter('submit') == 'save_vehicle') {
            if (is_numeric($this->request->getParameter('id'))) {
                $formStatus = $this->update($this->request, 'validateVehicleData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'VEHICLE_SAVE_ERROR');
                } else {
                    Cache::set('message', 'VEHICLE_SAVED');
                }
                Cache::set('newFormData', json_encode($this->request->getData($this->model)));
                $vehicleId = $formStatus['id'];
            } else {
                $formStatus = $this->add($this->request, 'validateVehicleData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'VEHICLE_ADD_ERROR');
                    Cache::set('openNewVehicleForm', '1');
                    Cache::set('newFormData2', json_encode($this->request->getData($this->model)));
                } else {
                    Cache::set('message', 'VEHICLE_ADDED');
                }
                $vehicleId = $formStatus['id'];
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
            }
            $list = null;
        }
        if ($list == null) {
            $list = $this->getAll();
        }
        if ($vehicleId != false && $list->offsetExists($vehicleId)) {
            $list->setActivePos($vehicleId);
        }
        return $list;
    }
}
