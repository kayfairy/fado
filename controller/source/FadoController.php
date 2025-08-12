<?php

namespace Fado\Controller\Source;

use \Fado\Core\ListIteratorFactory as Factory;

class FadoController implements FadoInterface {

    protected $model = null;

    protected $request = null;

    protected $rightsController = null;

    protected $controller = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController = null) {
        $this->request = $request;
        $this->rightsController = $rightsController;
        $this->model = null;
        $this->controller = null;
    }

    public function get(?\Fado\Core\ListIterator $list) {
        return $list;
    }

    public function update(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            $this->rightsController->redirect();
        }
        $data = $request->getData($this->model);
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
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            $success = $this->model->add($data);
            return array('id' => $this->model->lastInsertId(), 'success' => $success);
        } else {
            return array('id' => null, 'success' => false) + $message;
        }
    }

    public function setController($controller) {
        $this->controller = $controller;
    }

    public function getModel() {
        return $this->model;
    }

    public function getAll($onlyActive = false) {
        return Factory::create($this->model->getAll($onlyActive));
    }

    public function delete($id) {
        return $this->model->delete($id);
    }
}
