#!/bin/bash
CURRENT="$(git describe --tags --abbrev=0)"
PREVIOUS=$(git describe --tags --abbrev=0 ${CURRENT}^)

echo "Installing needed tools..."
go get github.com/mitchellh/gox
gox -build-toolchain
go get github.com/aktau/github-release
go get golang.org/x/tools/cmd/cover

echo "Creating release $CURRENT..."
gox \
  -output="./bin/{{.Dir}}_{{.OS}}_{{.Arch}}" \
  -os="linux darwin freebsd openbsd netbsd" \
  -ldflags="-X main.version $CURRENT" \
  ./cmd/antibody/
LOG="$(git log --pretty=oneline --abbrev-commit "$PREVIOUS".."$CURRENT")"
DESCRIPTION="$LOG\n\nCompiled with: $(go version)"
github-release release \
  --user getantibody \
  --repo antibody \
  --tag "$CURRENT" \
  --description "$DESCRIPTION" \
  --pre-release
# shellcheck disable=SC2012
ls ./bin | while read file; do
  filename="$file.tar.gz"
  tar \
    --transform="s/${file}/antibody/" \
    -cvzf "$filename" \
    "bin/${file}" antibody.zsh README.md LICENSE
  github-release upload \
    --user getantibody \
    --repo antibody \
    --tag "$CURRENT" \
    --name "$filename" \
    --file "$filename"
done
