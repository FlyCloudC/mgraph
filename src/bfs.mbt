///|
type BfsAt[A] A

///|
pub fn[A] bfs_at(a : A) -> BfsAt[A] {
  BfsAt(a)
}

///|
pub fn[A : Node] BfsAt::each(self : BfsAt[A], f : (A) -> Unit) -> Unit {
  let BfsAt(start) = self
  let dq = @deque.new()
  if not(start.will_visit()) {
    dq.push_front(start)
    start.set_will_visit(true)
  }
  while dq.pop_back() is Some(cur) {
    f(cur)
    cur.each_nexts(next => if not(next.will_visit()) {
      dq.push_front(next)
      next.set_will_visit(true)
    })
  }
}

///|
pub fn[A : Node] BfsAt::iter(self : BfsAt[A]) -> Iter[A] {
  let BfsAt(start) = self
  Iter::new(yield_ => {
    let dq = @deque.new()
    if not(start.will_visit()) {
      dq.push_front(start)
      start.set_will_visit(true)
    }
    while dq.pop_back() is Some(cur) {
      guard yield_(cur) is IterContinue else {
        dq.each(_.set_will_visit(false))
        return IterEnd
      }
      cur.each_nexts(next => if not(next.will_visit()) {
        dq.push_front(next)
        next.set_will_visit(true)
      })
    }
    IterContinue
  })
}
