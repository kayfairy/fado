<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIteratorFactory as Factory;

class Meetings extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Meeting();
    }

    public function get(?\Fado\Core\ListIterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewShopForm', '0');
        if ($list == null) {
            $list = Factory::create($this->model->getByUserId($this->rightsController->userController->getLoggedInUser()['sid']));
        }
        if ($this->request->getParameter('submit') == 'save_meeting') {
            $data = json_encode(array(
                'day' => $this->request->getParameter('meeting-date'),
                'range' => $this->request->getParameter('meeting-range'),
                'start' => $this->request->getParameter('meeting-start'),
                'stop' => $this->request->getParameter('meeting-stop'),
                'period' => $this->request->getParameter('meeting-period')
            ));
            $request = array('meeting' => $data, 'user_id' => $this->request->getParameter('meeting-user-id'), 'title' => $this->request->getParameter('meeting-title'), 'description' => $this->request->getParameter('meeting-description'));
            $message = $this->request->{'validateMeetingData'}($request);
            if (empty($message)) {
                $success = $this->model->add($request);
                $formStatus = array('id' => $this->model->lastInsertId(), 'success' => $success);
                if ($success) {
                    Cache::set('message', 'MEETING_SAVE_SUCCESS');
                } else {
                    Cache::set('message', 'MEETING_SAVE_ERROR');
                }
            } else {
                $formStatus = array('id' => null, 'success' => false) + $message;
                Cache::set('message', 'MEETING_SAVE_ERROR');
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
            }
            $list = null;
        }
        if ($this->request->getParameter('delete') == 'delete_meeting') {
            $id = $this->request->getParameter('id');
            if ($this->model->delete($id)) {
                $list = null;
                Cache::set('message', 'MEETING_DELETED');
            } else {
                Cache::set('message', 'MEETING_DELETE_ERROR');
            }
        }
        if ($list == null) {
            $list = Factory::create($this->model->getByUserId($this->rightsController->userController->getLoggedInUser()['sid']));
        }
        return $list;
    }
}
