#!/usr/bin/env bash
# Fetch the latest version of the library
fetch() {
if [ -d "parg" ]; then return; fi
URL="https://github.com/jibsen/parg/archive/refs/heads/master.zip"
ZIP="${URL##*/}"
DIR="parg-master"
mkdir -p .build
cd .build

# Download the release
if [ ! -f "$ZIP" ]; then
  echo "Downloading $ZIP from $URL ..."
  curl -L "$URL" -o "$ZIP"
  echo ""
fi

# Unzip the release
if [ ! -d "$DIR" ]; then
  echo "Unzipping $ZIP to .build/$DIR ..."
  cp "$ZIP" "$ZIP.bak"
  unzip -q "$ZIP"
  rm "$ZIP"
  mv "$ZIP.bak" "$ZIP"
  echo ""
fi
cd ..

# Copy the libs to the package directory
echo "Copying libs to parg/ ..."
rm -rf parg
mkdir -p parg
cp -f ".build/$DIR/parg.c" parg/
cp -f ".build/$DIR/parg.h" parg/
echo ""
}


# Test the project
test() {
echo "Running 01-example.c ..."
clang -I. -o 01.exe examples/01-example.c  && ./01.exe && echo -e "\n"
}


# Main script
if [[ "$1" == "test" ]]; then test
elif [[ "$1" == "fetch" ]]; then fetch
else echo "Usage: $0 {fetch|test}"; fi
