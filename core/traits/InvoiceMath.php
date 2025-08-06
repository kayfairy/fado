<?php

namespace Fado\Core;

trait InvoiceMath {

    public function calculateVAT(float $value, int $vatPercent) {
        $vat = (float)$value - $value * ((100 - $vatPercent) / 100);
        return $vat;
    }
}
