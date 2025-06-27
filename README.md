# FlyCloudC/mgraph

A lightweight graph traversal library for MoonBit, providing BFS (Breadth-First Search) and DFS (Depth-First Search) utilities.

## Features

- Define custom graph nodes via the `Node` trait.
- Perform traversal using `bfs_at` or `dfs_at`.
- Iterate over nodes with `iter` or `each`.

## Example

Step 1 - Define your type.

```mbt
struct Person {
  name : String
  children : Array[Person]
  mut father : Person?
  mut mother : Person?
}

fn Person::new(name : String) -> Person {
  { name, father: None, mother: None, children: [], visit: false }
}

fn Person::set_father(self : Person, father : Person) -> Unit {
  guard self.father is None
  self.father = Some(father)
  father.children.push(self)
}

fn Person::set_mother(self : Person, mother : Person) -> Unit {
  guard self.mother is None
  self.mother = Some(mother)
  mother.children.push(self)
}
```

Step 2 - Impl `Node` for your type. You may need to add a `mut visit` field.

```mbt
struct Person {
  ...
  mut visit : Bool
}

impl Node for Person with set_will_visit(self, bool) {
  self.visit = bool
}

impl Node for Person with will_visit(self) {
  self.visit
}

impl Node for Person with each_nexts(self, f) {
  self.children.each(f)
  if self.mother is Some(p) {
    f(p)
  }
  if self.father is Some(p) {
    f(p)
  }
}
```

Step 3 - Now, you can traverse any structure implementing the `Node` trait. The traversal will visit each node once, using the `visit` field to track state.

- Use `bfs_at(start_node)` for breadth-first traversal.
- Use `dfs_at(start_node)` for depth-first traversal.
- Use `.each(f)` to apply a function to each visited node.
- Use `.iter()` to get an iterator over the nodes, or you can directly write `for node in dfs_at(start_node) { ... }` and use `break` to exit early during traversal if needed.

Let's construct a family.

```mbt
let grandpa = Person::new("Grandpa")
let grandma = Person::new("Grandma")
let father = Person::new("Father")
let mother = Person::new("Mother")
for x in [1, 2, 3] {
  let child = Person::new("Child \{x}")
  child.set_father(father)
  child.set_mother(mother)
}
father.set_father(grandpa)
father.set_mother(grandma)
```

and traverse.

```mbt
let visited = []
bfs_at(father).each(visited.push(_))
inspect(
  visited,
  content=
    #|["Father", "Child 1", "Child 2", "Child 3", "Grandma", "Grandpa", "Mother"]
  ,
)
```

> **Note:** If you need to traverse the graph again, remember to reset the `visit` field.

```mbt
visited.each(p => p.visit = false)
let visited_by_iter = []
bfs_at(father).iter().each(visited_by_iter.push(_))
inspect(
  visited_by_iter,
  content=
    #|["Father", "Child 1", "Child 2", "Child 3", "Grandma", "Grandpa", "Mother"]
  ,
)
```

A complete example can be found in [`src/example_1_test.mbt`](src/example_1_test.mbt).

## More Examples

See another example in [`src/example_2_test.mbt`](src/example_2_test.mbt).

## License

MIT
