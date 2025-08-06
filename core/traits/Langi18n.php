<?php

namespace Fado\Core;

use \Fado\Model\Setting as Settings;

trait Langi18n {

    private $translations;

    public function translate($identifier, string ...$replacements) {
        if (isset($this->translations[$identifier])) {
            if (!empty($replacements)) {
                return call_user_func_array('sprintf', array_merge((array)$this->translations[$identifier], $replacements));
            }
            return preg_replace('/%(%[a-z]{0,1})/', '$1', $this->translations[$identifier]);
        }
        return $identifier;
    }

    public function loadTranslations() {
        $this->translations = include __DIR__ . '/../../lang/lang_' . $this->getActiveLanguageAndCountry() . '.php';
        return true;
    }

    public function getActiveLanguage() {
        return (Settings::get('lang') != '') ? strstr(Settings::get('lang'), '_', true) : 'en';
    }

    public function getActiveLanguageAndCountry() {
        return (Settings::get('lang') != '') ? Settings::get('lang') : 'en_GB';
    }

    public function getActiveCharset() {
        return (Settings::get('encoding') != '') ? mb_strtolower(Settings::get('encoding')) : 'utf-8';
    }

    public static function formatTime($time) {
        if ($time == null) {
            return '';
        }
        return strftime(Settings::get('time_format'), strtotime($time));
    }

    public static function formatDate($date) {
        if ($date == null) {
            return '';
        }
        return strftime(Settings::get('date_format'), strtotime($date));
    }

    public static function formatDateTime($date, $format = '') {
        if ($date == null) {
            return '';
        }
        if ($format == '') {
            $format = Settings::get('date_time_format');
        }
        return strftime($format, strtotime($date));
    }

    public static function formatNumber($number, array $format = array()) {
        if (empty($format)) {
            $format = json_decode(Settings::get('number_format'), true);
        }
        return call_user_func_array('number_format', array_merge(array((float)$number), $format));
    }

    /*
     * @param     string     $number        formatted number string (x xxx xx.yy)
     * @return    float                     float value
     *
     *
     */
    public static function numberFormat2Float(string $number) {
        return (float)preg_replace(array('/([\s]+)/u', '/(?![\.,][0-9]{2}+$)([0-9]+)/', '/[\.,]([0-9]{2})$/'), array('', '$1', '.$1'), $number);
    }

    public function escapeString($string) {
        return $this->encodeHtmlEntities($string);
    }

    public function encodeHtmlEntities($string) {
        return htmlentities($string, ENT_COMPAT, Settings::get('encoding'));
    }

    public function decodeHtmlEntities($string) {
        return html_entity_decode($string, ENT_COMPAT, Settings::get('encoding'));
    }

    public function urlEncode($string) {
        return urlencode($string);
    }

    public function urlDecode($string) {
        return urldecode($string);
    }

    public static function quotePRegExp($string) {
        return preg_replace('/([\.\\\+\*\$\?\[\^\]\(\)\{\}\=\!\<\>\|\:\-\#]+)/', '\Q$1\E', $string);
        return preg_quote($string);
    }

    public static function getAvailableTimeZones() {
        return \DateTimeZone::listIdentifiers();
    }

    public static function getOffsetGMT($timeZone = 'Europe/London') {
        $HereNow = new \DateTimeZone($timeZone);
        $GMTnow = new \DateTime('now', new \DateTimeZone('GMT'));
        return gmdate('+H:s', $HereNow->getOffset($GMTnow));
    }
}
