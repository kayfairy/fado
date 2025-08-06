<?php

namespace Fado\Core;
use Fado\Core\Request as FormValidatorTraitParent;

trait FormValidator {

    /*
     * Magic method calling validate() with regex array for form validation
     */
    public function __call($name, $arguments) {
        preg_match('/validate([a-zA-Z]+?)Data/', $name, $matches);
        if (count($matches) > 0) {
            return $this->validate($arguments[0], constant('VALIDATION_REGEX_ARRAY_' . mb_strtoupper($matches[1]) . '_DATA_FIELDS'));
        }
        return false;
    }

    public static function validateDate($value) {
        return (date($value, time()) === false) ? false : true;
    }

    public static function validateJSON($value) {
        return (json_decode($value) === null) ? false : true;
    }

    /*
     * Validation function
     */
    public function validate(array $data, array $validationRegex) {
        $message = array();
        foreach ($validationRegex as $field => $validationConf) {
            if ($validationConf[1] && $data[$field] == null) {
                $message[$field] = 'ERROR_FIELD_EMPTY';
                continue;
            }
            if (!$validationConf[1] && $data[$field] == null) {
                continue;
            }
            if (function_exists('\\' . $validationConf[0])) {
                if (call_user_func($validationConf[0], $data[$field]) == false) {
                    $message[$field] = $validationConf[2];
                }
                continue;
            }
            if (function_exists('FormValidatorTraitParent::' . $validationConf[0])) {
                if (static::{$validationConf[0]}($data[$field]) == false) {
                    $message[$field] = $validationConf[2];
                }
                continue;
            }
            if (preg_match($validationConf[0], $data[$field], $matches) == 0) {
                $message[$field] = $validationConf[2];
                continue;
            }
        }
        return $message;
    }
}

