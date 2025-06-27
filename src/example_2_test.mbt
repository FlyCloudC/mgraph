///|
/// Invariant: x < vis.length()
priv struct MyInt {
  vis : FixedArray[Bool]
  x : Int
}

///|
impl Show for MyInt with output(self, logger) {
  logger.write_object(self.x)
}

///|
impl Node for MyInt with each_nexts(self, yield_) {
  let { vis, x } = self
  if x * 2 < vis.length() {
    yield_({ vis, x: x * 2 })
  }
  if x % 6 == 4 {
    yield_({ vis, x: (x - 1) / 3 })
  }
}

///|
impl Node for MyInt with set_will_visit(self, bool) {
  let { vis, x } = self
  vis[x] = bool
}

///|
impl Node for MyInt with will_visit(self) {
  let { vis, x } = self
  vis[x]
}

///|
test "bfs on revert 3n+1" {
  let x = MyInt::{ vis: FixedArray::make(100, false), x: 1 }
  let res = []
  bfs_at(x).each(res.push(_))
  inspect(
    res,
    content="[1, 2, 4, 8, 16, 32, 5, 64, 10, 21, 20, 3, 42, 40, 6, 84, 80, 13, 12, 26, 24, 52, 48, 17, 96, 34, 68, 11, 22, 44, 7, 88, 14, 29, 28, 58, 56, 9, 19, 18, 38, 36, 76, 72, 25, 50]",
  )
  let x = MyInt::{ vis: FixedArray::make(100, false), x: 1 }
  inspect(
    bfs_at(x).iter().take(30),
    content="[1, 2, 4, 8, 16, 32, 5, 64, 10, 21, 20, 3, 42, 40, 6, 84, 80, 13, 12, 26, 24, 52, 48, 17, 96, 34, 68, 11, 22, 44]",
  )
}
