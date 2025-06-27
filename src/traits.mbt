///|
pub(open) trait Node {
  each_nexts(Self, (Self) -> Unit) -> Unit
  will_visit(Self) -> Bool
  set_will_visit(Self, Bool) -> Unit
}
