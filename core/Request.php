<?php

namespace Fado\Core;

require_once './core/traits/HttpRequest.php';
require_once './core/traits/FormValidator.php';

class Request {

    use FormValidator;
    use HttpRequest;

    /*
     * @param    \Fado\Model     $model
     *
     * @return    array          fetched data from request for all columns of model
     *
     */
    public function getData($model) {
        $data = array();

        foreach ($model->getColumns() as $column) {
            $parameter = $this->getParameter($column);
            $data[$column] = ($parameter === false) ? null : $parameter;
        }
        $data['sid'] = $data['id'];

        return $data;
    }
}
