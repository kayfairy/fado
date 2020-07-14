<?php

namespace Fado\Core;

class CSVReader {

    public static function read($path) {
        $csv = array();
        $handle = fopen($path, 'r');
        if ($handle) {
            while (($row = fgetcsv($handle, 4096, ';')) !== false) {
                $csv[$row[0]] = $row[1];
            }
            if (!feof($handle)) {
                exit;
            }
            fclose($handle);
        }
        return $csv;
    }

}
