define f_flip(f) = function (x,y) f(y,x);

define fst = head;
define snd = head . tail;

define
    pad(x, xs, n) = xs when n <= 0
  | pad(x, xs, n) = x : pad(x, xs, n-1);

define path(x, n) =
  let _bits(x, bs) = bs when x = 0
    | _bits(x, bs) = _bits(x div 2, (x mod 2) : bs) in
  let bs = _bits(x, []) in
    pad(0, bs, n - length(bs));

define empty_heap = [[], 0, 1, 0];

define is_empty_h(h) = h = empty_heap;

define find_max([[x,_,_],_,_,_]) = x;

define insert(x, [t, lvl, spc, occ]) =
  let leaf(y) = [y, [], []] in

  let bubblel([p, [c, l2, r2], r1]) =
    if p > c then [p, [c, l2, r2], r1]
    else          [c, [p, l2, r2], r1] in

  let bubbler([p, l1, [c, l2, r2]]) =
    if p > c then [p, l1, [c, l2, r2]]
    else          [c, l1, [p, l2, r2]] in

  let _insert(y, _, ps)   = leaf(y) when ps = []
    | _insert(y, [x, l, r], 0:ps) =
      bubblel([x, _insert(y, l, ps), r])
    | _insert(y, [x, l, r], 1:ps) =
      bubbler([x, l, _insert(y, r, ps)]) in

  let new_t =
    if lvl = 0 then leaf(x)
    else            _insert(x, t, path(occ, lvl)) in

  if spc = occ+1 then
    [new_t, lvl+1, spc*2, 0]
  else
    [new_t, lvl, spc, occ+1];

define pop([t, lvl, spc, occ]) =
  let dec_size(lvl, spc, occ) =
    if occ = 0 then
      (let new_spc = spc div 2 in
        [lvl - 1, new_spc, new_spc - 1])
    else
      [lvl, spc, occ - 1] in

  let get_last([x, _, _], []) = [x, []]
    | get_last([x, l, r], 0:ps) =
        (let last_l = get_last(l, ps) in
           [fst(last_l), [x, snd(last_l), r]])
    | get_last([x, l, r], 1:ps) =
        (let last_r = get_last(r, ps) in
           [fst(last_r), [x, l, snd(last_r)]]) in

  let heapify([p, [], []]) = [p, [], []]
    | heapify([p, [c1, l1, r1], []]) =
      if p >= c1 then [p, [c1, l1, r1], []]
      else [c1, heapify([p, l1, r1]), []]
    | heapify([p, [], [c1, l1, r1]]) =
      if p >= c1 then [p, [], [c1, l1, r1]]
      else [c1, [],  heapify([p, l1, r1])]
    | heapify([p, [c1, l1, r1], [c2, l2, r2]]) =
      if p >= c1 and p >= c2 then
        [p, [c1, l1, r1], [c2, l2, r2]]
      else if c1 >= c2 then
        [c1, heapify([p, l1, r1]), [c2, l2, r2]]
      else
        [c2, [c1, l1, r1], heapify([p, l2, r2])] in

  let swap_in_last([last, [_, l, r]]) = heapify([last, l, r]) in

  let path_for_size([lvl, _, occ]) = path(occ, lvl) in

  if lvl = 0 then
    _error("cannot pop an empty heap", [])
  else if lvl = 1 and occ = 0 then
    [[], 0, 1, 0]
  else
    (let new_size = dec_size(lvl, spc, occ) in
     let last     = get_last(t, path_for_size(new_size)) in
       swap_in_last(last):new_size);

define hsort(xs) =
  let _hsort(h, xs) = xs when is_empty_h(h)
    | _hsort(h, xs) = _hsort(pop(h), find_max(h):xs) in
  _hsort(foldl(f_flip(insert), empty_heap, xs), []);

{
hsort([5,4,3,2,1]);

define h0 = mk_heap();
define h1 = insert(8, mk_heap());
define h2 = insert(10, insert(8, mk_heap()));
define h3 = insert(7, insert(10, insert(8, mk_heap())));
define h4 = insert(4, insert(7, insert(10, insert(8, mk_heap()))));

find_max(h1); pop(h1);
find_max(h2); pop(h2);
find_max(h3); pop(h3);
find_max(h4); pop(h4); find_max(pop(h4)); pop(pop(h4));
}
