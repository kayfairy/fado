<?php

namespace Fado\Core;

class ListIterator implements \Iterator, \ArrayAccess {

    private $list = array();

    private $keyposition = 0;

    private $activePos = -1;

    private $currentPage = 1;

    private $itemsPerPage = PHP_INT_MAX;

    private $keys = array(0 => 0);

    public function __construct(array $list) {
        $this->list = $list;
        $this->keyposition = 0;
        $this->keys = array_keys($this->list);
//        $this->activePos = $this->keys[0];
    }

    public function getPageCount() {
        if ($this->count() < 1) {
            return 1;
        }
        return ceil($this->count() / $this->itemsPerPage);
    }

    public function count() {
        return count($this->list);
    }

    public function get() {
        return array_slice($this->list, $this->itemsPerPage * ($this->currentPage - 1), $this->itemsPerPage, true);
    }

    public function getItem($id) {
        return isset($this->list[$id]) ? $this->list[$id] : false;
    }

    public function rewind() {
        $this->keyposition = 0;
        $this->activePos = $this->keys[0];
    }

    public function current() {
        if (in_array($this->activePos, $this->keys)) {
            return $this->list[$this->activePos];
        }
        return null;
    }

    public function key() {
        return $this->keys[$this->keyposition];
    }

    public function next() {
        $this->keyposition++;
    }

    public function getPos() {
        if ($this->count() < 1) {
            return 0;
        }
        return $this->keys[$this->keyposition];
    }

    public function setPos($key) {
        $this->keyposition = array_search($key, $this->keys);
        return $this;
    }

    public function valid() {
        return isset($this->keys[$this->keyposition]) && isset($this->list[$this->keys[$this->keyposition]]);
    }

    public function getCurrentPage() {
        return $this->currentPage;
    }

    public function setCurrentPage($page = 1) {
        $this->currentPage = $page;
        return $this;
    }

    public function offsetSet($offset, $value) {
        if (is_null($offset)) {
            $this->list[] = $value;
        } else {
            $this->list[$offset] = $value;
        }
        return $this;
    }

    public function offsetExists($offset) {
        return isset($this->list[$offset]);
    }

    public function offsetUnset($offset) {
        unset($this->list[$offset]);
        $this->next();
        return $this;
    }

    public function offsetGet($offset) {
        return isset($this->list[$offset]) ? $this->list[$offset] : null;
    }

    public function getItemsPerPage() {
        return $this->itemsPerPage;
    }

    public function setItemsPerPage($itemsPerPage) {
        $this->itemsPerPage = $itemsPerPage;
        return $this;
    }

    public function resetKeys() {
        $tmpList = array();
        $xkey = 0;
        foreach ($this->list as $listItem) {
            $tmpList[$xkey] = $listItem;
            $xkey++;
        }
        $this->list = $tmpList;
        return $this;
    }

    public function setActivePos($offset) {
        $this->activePos = $offset;
        return $this;
    }

    public function getActivePos() {
        return $this->activePos;
    }

    public function getKeys() {
        return $this->keys;
    }
}
