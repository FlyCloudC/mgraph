///|
type DfsAt[A] A

///|
pub fn[A] dfs_at(a : A) -> DfsAt[A] {
  DfsAt(a)
}

///|
pub fn[A : Node] DfsAt::each(self : DfsAt[A], f : (A) -> Unit) -> Unit {
  let DfsAt(start) = self
  let st = []
  if not(start.will_visit()) {
    st.push(start)
    start.set_will_visit(true)
  }
  while st.pop() is Some(cur) {
    f(cur)
    cur.each_nexts(next => if not(next.will_visit()) {
      st.push(next)
      next.set_will_visit(true)
    })
  }
}

///|
pub fn[A : Node] DfsAt::iter(self : DfsAt[A]) -> Iter[A] {
  let DfsAt(start) = self
  Iter::new(yield_ => {
    let st = []
    if not(start.will_visit()) {
      st.push(start)
      start.set_will_visit(true)
    }
    while st.pop() is Some(cur) {
      guard yield_(cur) is IterContinue else {
        st.each(_.set_will_visit(false))
        return IterEnd
      }
      cur.each_nexts(next => if not(next.will_visit()) {
        st.push(next)
        next.set_will_visit(true)
      })
    }
    IterContinue
  })
}
