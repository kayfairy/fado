<?php

namespace Fado\Controller\Source;

use \Fado\Model\Cache as Cache;
use \Fado\Core\CSVReader as CSVReader;

class DatabaseSQL extends FadoController {

    public function __construct(\Fado\Core\Request $request, \Fado\Controller\RouterRights $rightsController) {
        parent::__construct($request, $rightsController);
        $this->model = new \Fado\Model\Shop();
    }

    public function get(\Fado\Core\ListIterator $list = null) {
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
            $dbConfig = (array)CSVReader::read(DB_CONFIG_FILE);
            exec('mysqldump -u ' . $dbConfig['user'] . ' -p' . $dbConfig['pwd'] . ' --add-drop-database fado > ' . sys_get_temp_dir() . '/fado' . $dbConfig['user'] . '.sql');
            header('Content-Disposition: attachment; filename=fado.sql');
            echo file_get_contents(sys_get_temp_dir() . '/fado' . $dbConfig['user'] . '.sql');
            Cache::empty();
            die();
        }

        if ($this->request->getParameter('emptycache')) {
            Cache::empty();
            Cache::set('message', 'EMPTY_CACHE_SUCCESS');
        }
    }
}
