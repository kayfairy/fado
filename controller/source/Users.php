<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\Cookie as Cookie;
use \Fado\Model\Setting as Settings;
use \Fado\Core\ListIteratorFactory as Factory;

class Users extends FadoController {

    protected $cookieName = null;

    public function __construct(\Fado\Core\Request $request) {
        parent::__construct($request, null);
        $this->model = new \Fado\Model\User();
        $this->cookieName = Settings::get('cookiename');
    }

    public function checkLogin() {
        $user = $this->request->getParameter('email');
        $pwd = $this->request->getParameter('password');

        $session = Cookie::get($this->cookieName);
        if (Cache::get('logintrycnt') == false) {
            Cache::set('logintrycnt', 0);
        }
        if ((int)Cache::get('logintrycnt') >= (int)Settings::get('maximum_login_attempts')) {
            Cache::set('message', 'INVALID_AUTH_TOO_MANY_ATTEMPTS');
            return false;
        }

        if ($user !== false && $pwd !== false) {
            if ($this->model->validatePwd($pwd, $user)) {
                $user = $this->login($user, $pwd);
                header('HTTP/1.0 302 Found', true, 302);
                header('Location: ' . $this->request->getReferer(), false, 302);
            }

            Cache::set('logintrycnt', (int)Cache::get('logintrycnt') + 1);
            Cache::set('message', 'INVALID_AUTH');
            return false;
        } else {
                Cache::set('message', '');
        }
            

        if ($this->request->getParameter('logout') == '1') {
            $this->logout();
            header('HTTP/1.0 302 Found', true, 302);
            header('Location: /', false, 302);
        }

        return $this->getLoggedInUser();
    }

    public function get(\Fado\Core\ListIterator $list = null) {
        Cache::set('formStatus', '');
        Cache::set('openNewUserForm', '0');
        Cache::set('newFormData', '');
        Cache::set('newFormData2', '');

        $userId = $this->request->getParameter('user');

        $validTabs = USER_TABS;
        if (!in_array(Cache::get('activeTab'), $validTabs)) {
            Cache::set('activeTab', 'USER_TAB_DATA');
        }

        if ($this->request->getParameter('delete') == 'delete_user') {
            $userId = $this->request->getParameter('id');
            if ($this->model->delete($userId, 'validateUserData')) {
                $list = null;
                Cache::set('message', 'USER_DELETED');
            } else {
                Cache::set('message', 'USER_DELETE_ERROR');
            }
        }

        if ($this->request->getParameter('submit') == 'save_user') {

            Cache::set('activeTab', 'USER_TAB_DATA');
            if (is_numeric($this->request->getParameter('id'))) {
                $formStatus = $this->update($this->request, 'validateUserData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'USER_SAVE_ERROR');
                } else {
                    Cache::set('message', 'USER_SAVED');
                }
                Cache::set('newFormData', json_encode($this->request->getData($this->model)));
                $userId = $formStatus['id'];
            } else {
                $formStatus = $this->add($this->request, 'validateUserData');
                if (!$formStatus['success']) {
                    Cache::set('message', 'USER_ADD_ERROR');
                    Cache::set('openNewUserForm', '1');
                } else {
                    Cache::set('message', 'USER_ADDED');
                }
                Cache::set('newFormData2', json_encode($this->request->getData($this->model)));
                $userId = $formStatus['id'];
            }
            if (is_array($formStatus)) {
                Cache::set('formStatus', json_encode($formStatus));
            }
            $list = null;
        }
        if ($list == null) {
            $list = Factory::create($this->model->getAll());
        }
        if ($userId != false && $list->offsetExists($userId)) {
            $list->setActivePos($userId);
        }
        return $list;
    }

    public function update(\Fado\Core\Request $request, $validationFunction = 'validateUserData') {
        if (!$this->rightsController->isAllowed($request->getParameter('page'), \Fado\Controller\RouterRights::$WRITE, true)) {
            $this->rightsController->redirect();
        }
        $data = $request->getData($this->model);
        $data['data'] = json_encode($request->getParameter('editor-1'));
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
        $data['data'] = json_encode($request->getParameter('editor-new'));
        $message = $request->{$validationFunction}($data);
        if (empty($message)) {
            $success = $this->model->add($data);
            return array('id' => $this->model->lastInsertId(), 'success' => $success);
        } else {
            return array('id' => null, 'success' => false) + $message;
        }
    }

    public function getLoggedInUser() {
        $session = Cookie::get($this->cookieName);
        if ($session == false) {
            Cookie::set($this->cookieName, $this->model->hash());
            return false;
        }
        return $this->model->get($session);
    }

    public function login($user, $pwd) {
        $user = $this->model->login($user);
        Cookie::set($this->cookieName, $user['session']);
        return $user;
    }

    public function logout() {
        $session = Cookie::get($this->cookieName);
        if ($session == false) {
            return false;
        }
        Cookie::unset($this->cookieName);
//        Don't empty up cache.
//        Cache::empty();
        header('HTTP/1.0 302 Found', true, 302);
        header('Location: /', false, 302);
        return $this->model->logout($session);
    }

    public function setRightsController(\Fado\Controller\RouterRights $rightsController) {
        $this->rightsController = $rightsController;
    }
}
