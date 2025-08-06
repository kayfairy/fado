<?php

namespace Fado\Core;

trait GeoCoordinates {

    public function DDtoDMS($decimal, $isLatLng = 'lat', $wHtmlTag = true) {
        $dec = explode('.', $decimal);
        if (count($dec) < 2) {
            return '';
        }
        $deg = $dec[0];
        $tmp = '0.' . $dec[1];
        $tmp = $tmp * 3600;
        $min = floor($tmp / 60);
        $sec = floor($tmp - ($min * 60));
        if ($isLatLng == 'lng') {
            if ($deg < 0) {
                $dir = 'S';
            } else {
                $dir = 'N';
            }
        } else {
            if ($deg < 0) {
                $dir = 'W';
            } else {
                $dir = 'E';
            }
        }
        $deg = abs($deg);
        if ($wHtmlTag) {
            return '<strong>' . $dir . '</strong>&nbsp;' . $deg . '°&nbsp;' . $min . '\'&nbsp;' . $sec . '\'\'';
        }
        return $dir . ' ' . $deg . '° ' . $min . '\' ' . $sec . '\'\'';
    }

    public function DMStoDD($deg, $min, $sec) {
        return $deg + ((($min * 60) + ($sec)) / 3600);
    }

}
