<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\CSVReader as CSVReader;

class DatabaseSQL extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Shop();
    }

    public function get(?\Fado\Core\ListIterator $list = null) {
        if ($this->request->getParameter('importsql')) {
            if (!empty($_FILES['sqlfile']) && !empty($_FILES['sqlfile']['tmp_name'][0])) {
                $file = file_get_contents($_FILES['sqlfile']['tmp_name'][0]);
                try {
                    $this->model->exec($file);
                    Cache::set('message', 'SQL_RUN_SUCCESS');
                    Cache::set('error', '');
                } catch (\Exception $e){
                    Cache::set('message', 'SQL_RUN_ERROR');
                    Cache::set('error', $e);
                }
            } else {
                Cache::set('message', 'SQL_FILE_ERROR');
                Cache::set('error', '');
            }
        }

        if ($this->request->getParameter('exportsql')) {
            $filePath = sys_get_temp_dir() . '/fado' . $this->rightsController->userController->getLoggedInUser()['name'] . '.sql';
                $tables = '*';
                $this->backupDatabaseTables($this->model, $tables, $filePath);
            header('Content-Disposition: attachment; filename=fado.sql');
            echo file_get_contents($filePath);
            Cache::empty();
            die();
        }

        if ($this->request->getParameter('emptycache')) {
            Cache::empty();
            Cache::set('message', 'EMPTY_CACHE_SUCCESS');
        }
    }

    /**
     * Perform MySQL Database Backup
     *
     * @param $pdo
     * @param string $tables
     * @param string $filePath
     * @return bool
     */
    function backupDatabaseTables($pdo, $tables = '*', $filePath = '/')
    {
        try {

            // Get all of the tables
            if ($tables == '*') {
                $tables = [];
                $query = $pdo->query('SELECT TABLE_NAME AS nom FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_SCHEMA='fado' ORDER BY nom DESC');
                while ($row = $query->fetch()) {
                    $tables[] = $row[0];
                }
            } else {
                $tables = is_array($tables) ? $tables : explode(',', $tables);
            }

            if (empty($tables)) {
                return false;
            }

            $out = '';

            // Loop through the tables
            foreach ($tables as $table) {
                // Add DROP TABLE statement
                $out .= 'DROP TABLE ' . $table . ';' . "\n\n";
            }
            foreach ($tables as $table) {
                $query = $pdo->query('SELECT * FROM ' . $table);
                $numColumns = $query->columnCount();

                // Add CREATE TABLE statement
                $query2 = $pdo->query('SHOW CREATE TABLE ' . $table);
                $row2 = $query2->fetch();
                $out .= $row2[1] . ';' . "\n\n";

                // Add INSERT INTO statements
                for ($i = 0; $i < $numColumns; $i++) {
                    while ($row = $query->fetch()) {
                        $out .= "INSERT INTO $table VALUES(";
                        for ($j = 0; $j < $numColumns; $j++) {
                            $row[$j] = addslashes($row[$j]);
                            $row[$j] = preg_replace("/\n/us", "\\n", $row[$j]);
                            if (isset($row[$j])) {
                                $out .= '"' . $row[$j] . '"';
                            } else {
                                $out .= '""';
                            }
                            if ($j < ($numColumns - 1)) {
                                $out .= ',';
                            }
                        }
                        $out .= ');' . "\n";
                    }
                }
                $out .= "\n\n\n";
            }

            // Save file
            file_put_contents($filePath, $out);
        } catch (\Exception $e) {
            echo "<br><pre>Exception => " . $e->getMessage() . "</pre>\n";
            return false;
        }

        return true;
    }
}
