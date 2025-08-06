<?php

namespace Fado\Core;

use \Fado\Model\Setting as Settings;

require_once './core/traits/Langi18n.php';
require_once './core/traits/GeoCoordinates.php';
require_once './core/traits/InvoiceMath.php';
require_once './core/traits/ViewController.php';

class View {

    use LangI18n;
    use GeoCoordinates;
    use InvoiceMath;
    use ViewController;

    protected static $design = 'bs';

    protected static $templateFileExtension = 'phtml';

    protected $userRights = null;

    public function __construct($controller = null) {
        $this->loadTranslations();
        $this->userRights = $controller;
    }

    public function getProtocol() {
        return htmlspecialchars(Request::getProtocol());
    }

    public function getHostLink() {
        return htmlspecialchars(Request::getHostLink());
    }

    public function getSelfLink() {
        return htmlspecialchars(Request::getSelfLink());
    }

    public function getFullLink() {
        return htmlspecialchars(Request::getFullLink());
    }

    public static function getParameter($name) {
        return Request::getParameter($name);
    }

    public static function getHttpReferer() {
        return htmlspecialchars(Request::getReferer());
    }

    public static function getCacheParameter($name = '') {
        return \Fado\Model\Cache::get($name);
    }

    public function getURL($getParameter, $page = '') {
        $isRewrite = (bool)Settings::get('rewrite_route');
        $url = $this->getHostLink();
        if ($page != '' && !$isRewrite) {
            $getParameter = array_merge($getParameter, array('page' => $page));
        }
        if ($page != '' && $isRewrite) {
            $url = $url . '/' . $page . '/';
        }
        if ($isRewrite) {
            foreach ($getParameter as $name => $value) {
                if (in_array($name, URL_REWRITE_PARAMATER)) {
                    if ($value == '') {
                        $value = '0';
                    }
                    $url = $url . $name . '/' . $value . '/';
                    unset($getParameter[$name]);
                }
            }
        }
        if (count($getParameter) > 0) {
            $url .= '?';
        }
        $index = 0;
        foreach ($getParameter as $name => $value) {
            if ($index != 0 && $index < count($getParameter)) {
                $url .= '&';
            }
            $url .= $name . '=' . $value;
            $index++;
        }
        return $url;
    }

    public function getRewriteUrl($getParameter, $page = 'shp') {
        return $this->getURL($getParameter, $page);
    }

    public function includeTemplate($templateName, $templateParameter, $die = false, $view = null) {
        extract($templateParameter);
        if ($view === null) {
            $view = $this;
        }
        require __DIR__ . '/../templates/' . static::$design . '/' . $templateName . '.' . static::$templateFileExtension;
        if ($die) {
            \Fado\Model\Cache::set('message', '');
            die();
        }
    }

    public static function staticIncludeTemplate($templateName, $templateParameter, $die = false) {
        $instance = new static;
        $instance->includeTemplate($templateName, $templateParameter, $die, $instance);
    }
}
