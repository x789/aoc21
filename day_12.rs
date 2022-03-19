// Advent of Code 2021, Day 12: Passage Pathing
// (c) 2022 TillW
use std::fs;

mod graph {
    use std::collections::HashMap;
    use std::collections::HashSet;
    pub struct Graph {
        adjacencies: HashMap<String, HashSet<String>>
    }
    
    impl Graph {
        pub fn new() -> Graph {
            Graph { adjacencies: HashMap::new() }
        }
    
        pub fn add_edge(&mut self, start: &str, end: &str) {
            self.add_adjacency(end, start);
            self.add_adjacency(start, end);
        }

        pub fn get_children(&self, vertex: &str) -> Vec<&String> {
            let neighbours = self.adjacencies.get(vertex);
            if neighbours.is_some() {
                return neighbours.unwrap().iter().collect();
            } else {
                return vec![];
            }
        }
    
        fn add_adjacency(&mut self, start: &str, end: &str) {
            if end != "start" {
                if !self.adjacencies.contains_key(start) {
                    self.adjacencies.insert(start.to_string(), HashSet::new());
                }
                let children = self.adjacencies.get_mut(start).unwrap();
                children.insert(end.to_string());
            }
        }
    }
}

fn is_small_cave(name:&str) -> bool {
    name.chars().all(|c| c.is_ascii_lowercase())
}

fn solve(graph:&graph::Graph, visit_small_caves_once:bool) -> u32 {
    let mut queue:Vec<(String, Vec<String>, bool)> = vec![("start".to_string(), vec!["start".to_string()], visit_small_caves_once)];
    let mut number_of_paths = 0;

    while !queue.is_empty() {
        let (node, visited, visited_twice) = queue.pop().unwrap();
        if node == "end" {
            number_of_paths += 1;
        } else {
            for n in graph.get_children(&node) {
                if !visited.contains(&n) || !is_small_cave(n) {                    
                    let mut nvisited = visited.clone();
                    nvisited.push(n.clone());
                    queue.push((n.clone(), nvisited, visited_twice));
                    continue;
                }
                if visited_twice {
                    continue;
                }
                
                queue.push((n.clone(), visited.clone(), true));
            }
        }
    }
    number_of_paths
}

fn solve_puzzle_1(graph:&graph::Graph) -> u32 { solve(graph, true) }
fn solve_puzzle_2(graph:&graph::Graph) -> u32 { solve(graph, false) }

fn main() {
    let contents = fs::read_to_string("input_12.txt").expect("Read failed");
    let mut graph = graph::Graph::new();
    for line in contents.split('\n') {
        let parts:Vec<&str> = line.split('-').collect();
        graph.add_edge(parts[0], parts[1]);
    }

    let number_of_paths1 = solve_puzzle_1(&graph);
    let number_of_paths2 = solve_puzzle_2(&graph);
    println!("number of paths: {}/{}", number_of_paths1, number_of_paths2);
}
