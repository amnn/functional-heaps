# Functional Heaps
An implementation of an immutable heap-like structure, using binary trees instead of the traditional array. 
Written for [GeomLab](http://www.cs.ox.ac.uk/geomlab/home.html). 

## Implementation
The heap is represented by a `[t, lvl, spc, occ]` 4-tuple.
 * `t` is the binary tree, represented in Geomlab using nested lists:
    * Each node is a 3-tuple containing, its element, left subtree, and right subtree: `[el, l, r]`
    * Each leaf represented, for uniformity, as a node with empty subtrees: `[el, [], []]`
 * `lvl` is the level of the tree that the next element will be inserted into.
 * `spc` is the total amount of space in the level currently being filled 
    * Always `2^lvl`, but is saved for convenience, to avoid recalculting it on every insertion, as I am unaware of
      a bitshifting operator in Geomlab.
 * `occ` is the occupancy of the level being filled
    * Always in the range `[0..spc)` because as soon as the current level is entirely filled, we immediately move
     on to filling the next layer.

### `find_max(h)`
Return the value of the root node of the tree.

### `insert(x,h)`
 * Find the "next" free space in `h` (the left-most free space in the level being filled).
 * Insert `x` at that position.
 * Bubble `x` up if its value is greater than its parent. (`bubblel`, `bubbler`)
 * Update `lvl`, `spc`, and `occ` to reflect the increase in the heap size.

### `pop`
 * Update `lvl`, `spc`, and `occ` to reflect the decrease in heap size. (`dec_size`)
 * Find the "last" element in `h` and remove it (the left-most free space in the heap with decreased size).
   (`get_last`)
 * Replace the root value with the "last" element. (`swap_in_last`)
 * Trickle it down if one of its children has a greater value than it. (`heapify`)

### Left-most Free Space
In `insert` and `pop` above, we must at some point find the "left-most free space". The path from the root to the
left-most free space is uniquely defined by `(lvl, occ)`. In particular, by the `lvl`-bit binary representation
of `occ`, with the MSB at the left. When viewed as a sequence of bits, the path can be extracted by treating a `0`
as a left turn, and a `1` as a right turn.

## LICENSE
Released under the MIT License, (C) 2015, Ashok Menon
