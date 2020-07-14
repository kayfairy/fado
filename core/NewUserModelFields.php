<?php

namespace Fado\Core;

define('SQL_NEW_USER_SETTINGS',
    "INSERT INTO `fado_user_settings` (`user_id`, `name`, `value`, `changed`, `created`) VALUES
    (:id,'lang','en_GB',NULL,NOW()),
    (:id,'timezone','Europe/London',NULL,NOW()),
    (:id,'number_format','[\"2\",\",\",\".\"]',NULL,NOW()),
    (:id,'date_time_format','%d.%m.%Y %H:%M:%S',NULL,NOW()),
    (:id,'item_amount_units','[\"100g\",\"50g\",\"100ml\",\"1m\u00b3\",\"1m\u00b2\",\"1cl\",\"1oz\",\"1kg\",\"100kg\",\"500ml\",\"1l\",\"10l\",\"1mg\",\"500mg\",\"50mg\",\"1box\",\"1pcs\",\"Transaction\",\"1oz ℮\"]',NULL,NOW()),
    (:id,'display_errors','1',NULL,NOW()),
    (:id,'currency','1',NULL,NOW()),
    (:id,'tax_rates','[\"8\",\"0\"]',NULL,NOW()),
    (:id,'invoice_mode','brutto',NULL,NOW()),
    (:id,'vat_on','1',NULL,NOW()),
    (:id,'list_count_single','3',NULL,NOW()),
    (:id,'time_format','%H:%M',NULL,NOW()),
    (:id,'date_format','%d.%m.%Y',NULL,NOW())"
);

define('SQL_NEW_USER_RIGHTS',
    "INSERT INTO `fado_user_rights` (`user_id`, `rights`, `created`) VALUES
    (:id,'{\"sh\":\"2\",\"ve\":\"2\",\"wa\":\"2\",\"inv\":\"2\",\"ne\":\"2\",\"na\":\"1\",\"us\":\"2\",\"ut\":\"2\",\"ur\":\"2\",\"at\":\"2\",\"st\":\"1\",\"ri\":\"2\",\"sq\":\"2\",\"me\":\"2\",\"aj\":\"2\",\"in\":\"1\",\"if\":\"1\"}',NOW())"
);

define('SQL_NEW_USER_2_SHOP',
    "INSERT INTO `fado_shops2user` (`user_id`, `shop_id`) VALUES (:id, 1)"
);
