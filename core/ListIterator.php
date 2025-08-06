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
    	  if (count($list) === 0) {
              return null;
    	  }
        $this->list = $list;
        $this->keyposition = 0;
        $this->keys = array_keys($this->list);
        $this->activePos = -1;
    }

    public function getPageCount() {
        if ($this->count() < 1) {
            return 1;
        }
        return ceil($this->count() / $this->itemsPerPage);
    }

    public function count(): int {
        return count($this->list);
    }

    public function get() {
        return array_slice($this->list, $this->itemsPerPage * ($this->currentPage - 1), $this->itemsPerPage, true);
    }

    public function getItem($id) {
        return isset($this->list[$id]) ? $this->list[$id] : false;
    }

    public function rewind(): void {
        $this->keyposition = 0;
        $this->activePos = $this->keys[0];
    }

    public function current(): Array {
        if (in_array($this->activePos, $this->keys)) {
            return $this->list[$this->activePos];
        }
        return array('sid' => null);
    }

    public function key(): mixed {
        return $this->keys[$this->keyposition];
    }

    public function next(): void {
        $this->keyposition++;
    }

    public function getPos(): int {
        return $this->keyposition;
    }

    public function setPos(mixed $key): int {
        $this->keyposition = array_values(array_search($key, $this->keys));
        return $this;
    }

    public function valid(): bool {
        return isset($this->keys[$this->keyposition]) && isset($this->list[$this->keys[$this->keyposition]]);
    }

    public function getCurrentPage() {
        return $this->currentPage;
    }

    public function setCurrentPage($page = 1) {
        $this->currentPage = $page;
        return $this;
    }

    public function offsetSet(mixed $offset, mixed $value): void {
        if (is_null($offset)) {
            $this->list[] = $value;
        } else {
            $this->list[$offset] = $value;
        }
    }

    public function offsetExists(mixed $offset): bool {
        return isset($this->list[array_search($offset, $this->keys)]);
    }

    public function offsetUnset(mixed $offset): void {
        unset($this->list[$offset]);
        $this->next();
    }

    public function offsetGet(mixed $offset): int {
        return isset($this->list[$offset]) ? $this->list[$offset] : null;
    }

    public function getItemsPerPage(): int {
        return $this->itemsPerPage;
    }

    public function setItemsPerPage($itemsPerPage) {
        $this->itemsPerPage = $itemsPerPage;
        return $this;
    }

    public function resetKeys(): void {
        $tmpList = array();
        $xkey = 0;
        foreach ($this->list as $listItem) {
            $tmpList[$xkey] = $listItem;
            $xkey++;
        }
        $this->list = $tmpList;
    }

    public function setActivePos(mixed $key): void {
        $this->activePos = $key;
    }

    public function getActivePos() {
        return $this->activePos;
    }

    public function getKeys(): mixed {
        return $this->keys;
    }
}
