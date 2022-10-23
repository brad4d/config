package main

import (
  "bufio"
  "fmt"
  "os"
  "sort"
  "unicode"
)

func main() {
  linesCh := startReadLinesFromFileArgs(os.Args[1:])
  totalLines := 1
  rune2NumLines := make(map[rune]int)
  for line := range linesCh {
    totalLines += 1
    countMap := runeCounts(line)
    for r := range countMap {
      if !unicode.IsSpace(r) {
        rune2NumLines[r] += 1
      }
    }
  }

  fmt.Printf("len(rune2NumLines) = %d\n", len(rune2NumLines))

  runeSlice := makeSliceOfKeys(rune2NumLines)

  sort.Slice(runeSlice, func(i, j int) bool {
    return rune2NumLines[runeSlice[i]] > rune2NumLines[runeSlice[j]]
  })
  for _, r := range runeSlice {
    numLines := rune2NumLines[r]
    pct := 100.0 * float32(numLines) / float32(totalLines)
    fmt.Printf("%8d %6.2f%% %c\n", numLines, pct, r)
  }
}

func makeSliceOfKeys[K comparable, V any](m map[K]V) []K {
  slice := make([]K, len(m))
  i := 0
  for k := range m {
    slice[i] = k
    i += 1
  }
  return slice
}

func runeCounts(str string) map[rune]int {
  countMap := make(map[rune]int)
  for _, r := range str {
    countMap[r] += 1
  }
  return countMap
}

func startReadLinesFromFileArgs(fileArgs []string) <-chan string {
  linesCh := make(chan string)
  go readLinesFromFileArgs(os.Args[1:], linesCh)
  return linesCh
}

func readLinesFromFileArgs(fileArgs []string, linesCh chan<- string) {
  for _, fileArg := range fileArgs {
    readLinesFromFileArg(fileArg, linesCh)
  }
  close(linesCh)
}

func readLinesFromFileArg(fileArg string, ch chan<- string) {
  defer func() {
    if err := recover(); err != nil {
      fmt.Fprintf(os.Stderr, "ERROR: %s: %s\n", fileArg, err)
    }
  }()
  var scanner *bufio.Scanner
  if fileArg == "-" {
    scanner = bufio.NewScanner(os.Stdin)
  } else {
    file, err := os.Open(fileArg)
    if err != nil {
      panic(err);
    }
    defer file.Close()
    scanner = bufio.NewScanner(file)
  }
  for scanner.Scan() {
    ch <- scanner.Text()
  }
  if err := scanner.Err(); err != nil {
    panic(err)
  }
}
