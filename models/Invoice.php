<?php

namespace Fado\Model;

class Invoice extends FadoModel {

    protected $relation = 'fado_invoices';

    protected $relation2item = 'fado_invoices2items';

    protected $masterQuery = 'SELECT *, tbl.id AS id, tbl.id AS sid, (SELECT currency FROM fado_currency WHERE id=(SELECT value FROM fado_settings WHERE name="currency")) AS currency, tbl.created AS created, tbl.changed AS changed, s1.description AS spname1, s2.description AS spname2 FROM fado_invoices AS tbl LEFT OUTER JOIN fado_shops AS stbl ON stbl.id=tbl.shop_id_customer LEFT OUTER JOIN fado_shops2location AS loctbl ON stbl.id=loctbl.shop_id LEFT OUTER JOIN fado_shops AS s1 ON s1.id=tbl.shop_id_seller LEFT OUTER JOIN fado_shops AS s2 ON s2.id=tbl.shop_id_customer';

    protected $masterQueryItems = 'SELECT  *, tbl.created AS created, tbl.changed AS changed, rel.amount AS item_amount,  (SELECT currency FROM fado_currency WHERE id=(SELECT value FROM fado_settings WHERE name="currency")) AS currency, inv.created AS inv_created FROM fado_warehouse_items AS tbl LEFT OUTER JOIN fado_invoices2items AS rel ON tbl.id=rel.item_id LEFT OUTER JOIN fado_invoices AS inv ON rel.invoice_id=inv.id';

    public function getAll() {
        $query = $this->query($this->masterQuery . $this->order());
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function get($id) {
        $query = $this->prepare($this->masterQuery . ' WHERE tbl.id=:id');
        $query->execute(array('id' => $id));
        return $query->fetch();
    }

    public function getItemsByInvoiceId($id) {
        $query = $this->prepare($this->masterQueryItems . ' WHERE inv.id=:id');
        $query->execute(array('id' => $id));
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function getItemsByIds(array $ids) {
        $query = $this->query($this->masterQueryItems . ' WHERE tbl.id IN (' . implode(',', $ids) . ')');
        return $query->fetchAll(\PDO::FETCH_GROUP | \PDO::FETCH_UNIQUE);
    }

    public function add($data) {
        $query = $this->prepare('INSERT INTO ' . $this->relation . ' (shop_id_seller, shop_id_customer, is_payed, created) VALUES (:shop_id_seller, :shop_id_customer, "0", NOW())');
        foreach ($this->getColumns(array('id', 'is_payed', 'zone_time')) as $column) {
            $query->bindParam(':' . $column, $data[$column]);
        }
        $query->execute();
        return;
    }

    public function update($data) {
        $query = $this->prepare('UPDATE ' . $this->relation . ' SET is_payed=IFNULL(:is_payed, "0"), changed=NOW() WHERE id=:id');
        foreach ($this->getColumns(array('shop_id_seller', 'shop_id_customer', 'zone_time')) as $column) {
            $query->bindParam(':' . $column, $data[$column]);
        }
        return $query->execute();
    }

    public function addItemsToInvoice($invoiceId, array $itemIds, array $itemAmounts) {
        $query = $this->prepare('DELETE FROM ' . $this->relation2item . ' WHERE invoice_id=:id');
        $query->execute(array('id' => $invoiceId));
        foreach ($itemIds as $key => $itemId) {
            $query = $this->prepare('INSERT INTO ' . $this->relation2item . ' (invoice_id, item_id, amount) VALUES (:invoice_id, :item_id, :amount)');
            $query->execute(array('invoice_id' => $invoiceId, 'item_id' => $itemId, 'amount' => $itemAmounts[$key]));
        }
        return true;
    }
}
