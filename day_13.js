// Advent of Code 2021, Day 13: Transparent Origami
// (c) 2022 TillW
const events = require('events');
const fs = require('fs');
const readline = require('readline');

(async function main() {
  const reader = readline.createInterface({input: fs.createReadStream('input_13.txt'), crlfDelay: Infinity });
  var dots = new Set()
  var foldedAtLeastOnce = false

  function processDot(dot, axis, foldPosition, result) {
    [x, y] = dot
    if (axis == 'x' && foldPosition < x) {
      x = foldPosition-(x-foldPosition)
    } else if (axis == 'y' && foldPosition < y) {
      y = y - 2*(y - foldPosition)
    }
    result.add([x, y])
  }

  function doFold(axis, foldPosition) {
    result = new Set()
    dots.forEach((point) => { processDot(point, axis, foldPosition, result) })
    dots = result
  }

  function drawPaper() {
    maxx = 0
    maxy = 0
    dots.forEach((point) => {
      [x, y] = point
      if (x > maxx) maxx = x
      if (y > maxy) maxy = y
    })
    lines = []
    for (let i = 0; i <= maxy; i++) lines.push(new Array(maxx+1).fill('.'))
    dots.forEach((dot) => lines[dot[1]][dot[0]] = '#')
    lines.forEach((line) => { console.log(line.join('')) })
  }

  reader.on('line', (line) => {
    if (line.includes(',')) {
      [x, y] = line.split(',')
      dots.add([parseInt(x), parseInt(y)])
    } else if (line.startsWith('fold along')) {
      doFold(line[11], parseInt(line.substring(13)))
      if (!foldedAtLeastOnce) {
        console.log(`Number of visible dots after first fold: ${dots.size}`)
        foldedAtLeastOnce = true
      }
    }
  });

  await events.once(reader, 'close')
  drawPaper()
})();