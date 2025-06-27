///|
priv struct Person {
  name : String
  children : Array[Person]
  mut father : Person?
  mut mother : Person?
  mut visit : Bool
}

///|
fn Person::new(name : String) -> Person {
  { name, father: None, mother: None, children: [], visit: false }
}

///|
fn Person::set_father(self : Person, father : Person) -> Unit {
  guard self.father is None
  self.father = Some(father)
  father.children.push(self)
}

///|
fn Person::set_mother(self : Person, mother : Person) -> Unit {
  guard self.mother is None
  self.mother = Some(mother)
  mother.children.push(self)
}

///|
impl Show for Person with output(self, logger) {
  logger.write_object(self.name)
}

///|
impl Node for Person with each_nexts(self, f) {
  self.children.each(f)
  if self.mother is Some(p) {
    f(p)
  }
  if self.father is Some(p) {
    f(p)
  }
}

///|
impl Node for Person with set_will_visit(self, bool) {
  self.visit = bool
}

///|
impl Node for Person with will_visit(self) {
  self.visit
}

///|
test "dfs on family" {
  let grandpa = Person::new("Grandpa".to_string())
  let grandma = Person::new("Grandma".to_string())
  let father = Person::new("Father".to_string())
  let mother = Person::new("Mother".to_string())
  for x in [1, 2, 3] {
    let child = Person::new("Child \{x}")
    child.set_father(father)
    child.set_mother(mother)
  }
  father.set_father(grandpa)
  father.set_mother(grandma)

  // Example: BFS traversal
  let visited = []
  bfs_at(father).each(visited.push(_))
  inspect(
    visited,
    content=
      #|["Father", "Child 1", "Child 2", "Child 3", "Grandma", "Grandpa", "Mother"]
    ,
  )
  visited.each(p => p.visit = false)
  let visited_by_iter = []
  bfs_at(father).iter().each(visited_by_iter.push(_))
  inspect(
    visited_by_iter,
    content=
      #|["Father", "Child 1", "Child 2", "Child 3", "Grandma", "Grandpa", "Mother"]
    ,
  )
}
