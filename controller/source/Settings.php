<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\ListIteratorFactory as Factory;

class Settings extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Setting();
    }

    public function get(?\Fado\Core\ListIterator $list = null, $userSettings = true) {
        Cache::set('formStatus', '');

        if ($this->request->getParameter('save') == 'save_fadosettings') {
            $list = Factory::create($this->model->getAll(false, $userSettings));
            $settingsData = array();
            foreach ($list->getKeys() as $key) {
                if ($this->request->getParameter($key) !== false) {
                    $settingsData[$key] = $this->request->getParameter($key);
                }
            }

            $settingsData = array_intersect_key($settingsData, $list->get());

            if ($userSettings && isset($settingsData['number_format'])) {
                $settingsData['number_format'] = join("#",  $settingsData['number_format']);
            }

            if ($userSettings) {
                $checkboxes = array('display_errors', 'vat_on');
            } else {
                $checkboxes = array('memcache_on', 'rewrite_route');
            }

            foreach ($checkboxes as $checkbox) {
                if (!isset($settingsData[$checkbox])) {
                    $settingsData = array_merge($settingsData, array($checkbox => '0'));
                }
            }

            if ($userSettings) {
                $message = $this->request->validateSettingUserData($settingsData);
            } else {
                $message = $this->request->validateSettingData($settingsData);
            }

            if ($userSettings && isset($settingsData['number_format'])) {
                $settingsData['number_format'] = json_encode(explode("#", preg_replace('/(\s+)/u', "\xc2\xa0", $settingsData['number_format'])));
            }

            if (!empty($message)) {
                Cache::set('message', 'SETTINGS_SAVE_ERROR');
                Cache::set('formStatus', json_encode($message));
            } else {
                $success = true;
                foreach ($settingsData as $key => $value) {
                    $success = $success && $this->model::set($key, $value);
                }
                if ($success) {
                    Cache::set('message', 'SETTINGS_SAVED');
                } else {
                    Cache::set('message', 'SETTINGS_SAVE_ERROR');
                }
            }
        }

        $list = Factory::create($this->model->getAll(true, $userSettings));
        return $list;
    }
}
