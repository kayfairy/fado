<?php

namespace Fado\Controller;

use \Fado\Model\Cache as Cache;

/*        
 *  PAGENAME        =>    SHORT
 *  ajax             => aj
 *  information     => if
 *  settings        => st
 *  shop           => sh
 *  vehicles        => ve
 *  warehouse        => wa
 *  invoices        => in
 *  newinvoice     => ne
 *  navigator        => na
 *  meetings        => me
 *  user           => us
 *  usersettings     => ut
 *  sqladmin        => sq
 *  adminsettings => at
 *  userrights    => ur
 *
 */

class RouterRights extends Source\FadoController {

    public static $NONE = 0;

    public static $READ = 1;

    public static $WRITE = 2;

    protected $model = null;

    protected $request = null;

    public $userController = null;

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\Source\Users $user) {
        $this->model = new \Fado\Model\Rights();
        $this->request = $request;
        $this->userController = $user;
    }

    public function get(?\Fado\Core\ListIterator $list = null) {
        $page = $this->request->getParameter('page');
        Cache::set('message', '');

        if ($this->request->getParameter('save_userrights') == 'save_userrights') {
            $userId = $this->request->getParameter('user_id');
            $rights = array();

            foreach (USER_RIGHTS_AREAS as $page) {
                if (in_array($this->request->getParameter($page), array(0, 1, 2))) {
                    $rights[$page] = $this->request->getParameter($page);
                    if ($rights[$page] == false) {
                        $rights[$page] = '0';
                    }
                }
            }

            $rights['aj'] = '2';
            $rights['st'] = '1';
            $rights['if'] = '1';

            if (in_array($this->userController->getModel()->get($userId)['name'], ADMIN_USERS)) {
                $rights['ur'] = '2';
                 $rights['ut'] = '2';
                 $rights['us'] = '2';
                 $rights['at'] = '2';
                 $rights['sq'] = '2';
            }

            if ($this->model->set($userId, json_encode($rights))) {
                Cache::set('message', 'USER_RIGHTS_SAVED');
            } else {
                Cache::set('message', 'USER_RIGHTS_SAVE_ERROR');
            }
        }

        return $this->isAllowed($page, static::$READ) || $this->isAllowed($page, static::$WRITE);
    }

    public function isAllowed($page, $action, $redirect = false) {
        if ($page == '') {
            $page = 'sh';
        }
        $rights = $this->getRoutingRights($this->userController->getLoggedInUser()['sid']);

        if ($rights != null && array_key_exists($page, $rights) && $rights[$page] == $action) {
            return true;
        }
        if ($redirect) {
            $this->redirect();
        }
        return false;
    }

    public function getAllowedLevel($page) {
        $rights = $this->getRoutingRights($this->userController->getLoggedInUser()['sid']);
        if ($rights != null && array_key_exists($page, $rights)) {
            return $rights[$page];
        }
        return static::$NONE;
    }

    public function getRoutingRights($userId) {
        return json_decode($this->model->get($userId)['rights'], true);
    }

    public function redirect() {
        header('HTTP/1.0 403 Forbidden', true, 403);
        \Fado\Core\View::staticIncludeTemplate('403', array(), true);
        return;
    }

}
