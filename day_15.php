Advent of Code 2021, Day 15: Chiton
(c) 2022 TillW

<?php // PHP8
class Element {
  private $risk;
  private $x;
  private $y;

  public function __construct($x, $y, $risk) {
    $this->x = $x;
    $this->y = $y;
    $this->risk = $risk;
  }

  public function __get($key) {
    return $this->$key;
  }

  public function __toString() {
    return "{$this->x}/{$this->y}: {$this->risk}";
  }
}

class QueuedElement {
  private $element;
  private $totalRisk;

  public function __construct($element, $totalRisk) {
    $this->element = $element;
    $this->totalRisk = $totalRisk;
  }

  public function __get($key) {
    return $this->$key;
  }
}

class Node {
  private $content;
  private $next;

  public function __construct($content, $next = NULL) {
    $this->content = $content;
    $this->next = $next;
  }

  public function __get($key) {
    return $this->$key;
  }

  public function setNext($next)
  {
      $this->next = $next;
  }
}

class Queue {
  private $first;

  public function __construct() {
    $this->first = NULL;
  }

  public function push($element) {
    if ($this->isEmpty()) {
      $this->first = new Node($element);
    } else if ($element->totalRisk < $this->first->content->totalRisk) {
      $this->first = new Node($element, $this->first);
    } else {
      for($current = $this->first; $current != NULL; $current = $current->next) {
        if($current->next) {
          if($element->totalRisk < $current->next->content->totalRisk) {
            $current->setNext(new Node($element, $current->next));
            break;
          }
        } else {
          $current->setNext(new Node($element));
          break;
        }
      }
    }
  }

  public function pop() {
    $node = $this->first;
    $this->first = $node->next;
    return $node->content;
  }

  public function isEmpty() {
    return $this->first == NULL;
  }
}

class Risks {
  private $elements;

  public function __construct($cave) {
    foreach($cave as $element)
      $this->elements[(string)$element] = INF;
  }

  public function set($element, $risk) {
    $this->elements[(string)$element] = $risk;
  }

  public function get($element) {
    return $this->elements[(string)$element];
  }
}

class Pathfinder {
  private $cave;

  public function __construct($cave) {
    $this->cave = $cave;
  }

  public function getSafestPathLength() {
    $start = $this->cave[0];
    $destination = $this->cave[count($this->cave)-1];

    $queue = new Queue();
    $queue->push(new QueuedElement($start, 0));
    $minRisks = new Risks($this->cave);
    $minRisks->set($start, 0);
    $visited = array();
    
    while(!$queue->isEmpty()) {
      $tmp = $queue->pop();
      $node = $tmp->element;
      $riskToNode = $tmp->totalRisk;

      if($node == $destination)
        return $riskToNode;

      if(in_array($node, $visited))
        continue;

      array_push($visited, $node);
      foreach($this->getNeighbors($node) as $neighbor) {
        if(in_array($neighbor, $visited))
          continue;
        $riskToNeighbor = $riskToNode + $neighbor->risk;

        if($riskToNeighbor < $minRisks->get($neighbor)) {
          $minRisks->set($neighbor, $riskToNeighbor);
          $queue->push(new QueuedElement($neighbor, $riskToNeighbor));
        }
      }
    }
    return INF;
  }

  private function getNeighbors($node) {
    $caveHeight = getHeight($this->cave);
    $caveWidth = getWidth($this->cave);
    $key = array_search($node, $this->cave);

    $neighbors = array();
    if ($node->y > 0)
      $neighbors[] = $this->cave[$key-$caveWidth];
    if ($node->y < $caveHeight-1)
      $neighbors[] = $this->cave[$key+$caveWidth];
    if ($node->x > 0)
      $neighbors[] = $this->cave[$key-1];
    if ($node->x < $caveWidth-1)
      $neighbors[] = $this->cave[$key+1];
    return $neighbors;
  }
}

function readInput($filename) {
  $cave = array();
  if ($file = fopen($filename, "r")) {
    $y = 0;
    while(!feof($file)) {
      $line = str_split(fgets($file));
      for($x=0; $x<count($line); $x++) {
        if($line[$x] != "\n") {
          $element = new Element($x, $y, $line[$x]);
          $cave[] = $element;
        }
      }
      $y += 1;
    }
    fclose($file);
  }
  return $cave;  
}

function getHeight($cave) {
  return $cave[count($cave)-1]->y + 1;
}

function getWidth($cave) {
  return $cave[count($cave)-1]->x + 1;
}

function enlargeCave($template, $factor) {
  $enlarged = array();
  $templateHeight = getHeight($template);
  $templateWidth = getWidth($template);
  $targetHeight = $templateHeight * $factor;
  $targetWidth = $templateWidth * $factor;

  for($rowIndex = 0; $rowIndex < $templateHeight; $rowIndex++) {
    $row = array();
    for($colInTemplate = 0; $colInTemplate < $templateWidth; $colInTemplate++) {
      $row[] = $template[$rowIndex*$templateWidth+$colInTemplate];
    }
    for($colIndex = 0; $colIndex < $targetWidth-$templateWidth; $colIndex++) {
      $risk = $row[count($row)-$templateWidth]->risk + 1;
      $risk = $risk == 10 ? 1 : $risk;
      $row[] = new Element($templateWidth+$colIndex, $rowIndex, $risk);
    }
    $enlarged[] = $row;
  }
  for($rowIndex = count($enlarged); $rowIndex < $targetHeight; $rowIndex++) {
    $templateRow = $enlarged[$rowIndex-$templateHeight];
    $newRow = array();
    foreach($templateRow as $prototype) {
      $risk = $prototype->risk == 9 ? 1 : $prototype->risk + 1;
      $newRow[] = new Element($prototype->x, $rowIndex, $risk);
    }
    $enlarged[] = $newRow;
  }

  $merged = array();
  foreach($enlarged as $row)
    $merged = array_merge($merged, $row);

  return $merged;
}

$cave = readInput("input_15.txt");
$cave = enlargeCave($cave, 5);
$pathfinder = new Pathfinder($cave);
print("Looking for safest path...");
$length = $pathfinder->getSafestPathLength();
print($length);
?>