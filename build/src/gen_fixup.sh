set -e
cd "$1/lin"
find . -type f -not -name 'patchelf' -not -name 'ld-linux*' -executable -exec sh -c 'file -i "$0"|grep -q "x-executable; charset=binary" && file "$0" | grep -q "dynamically linked"' {} \; -printf '"$1/lib/ld-linux.so" "$1/bin/patchelf" --set-interpreter "$1/lib/ld-linux.so" "$1/%p"\n'
