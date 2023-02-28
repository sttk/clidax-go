#!/usr/bin/env bash

clean() {
  go clean --cache
}

format() {
  go fmt ./...
}

compile() {
  go vet ./...
  go build ./...
}

test() {
  go test -v ./...
}

unit() {
  go test -v ./... -run $1
}

cover() {
  mkdir -p coverage
  go test -coverprofile=coverage/cover.out ./...
  go tool cover -html=coverage/cover.out -o coverage/cover.html
}

bench() {
  local dir=$2
  if [[ "$dir" == "" ]]; then
    dir="."
  fi
  pushd $dir
  go test -bench . --benchmem -run=^$
}

if [[ $# == 0 ]]; then
  clean
  format
  compile
  test
  cover
  exit 0
fi

if [[ "$1" == "unit" ]]; then
  unit $2
  exit 0
fi

for a in "$@"; do
  case "$a" in
  clean)
    clean
    ;;
  format)
    format
    ;;
  compile)
    compile
    ;;
  test)
    test
    ;;
  cover)
    cover
    ;;
  bench)
    bench
    ;;
  '')
    compile
    ;;
  *)
    echo "Bad task: %a"
    exit 1
    ;;
  esac
done
