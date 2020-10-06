set -e
SHARED_LIB_DIR="$(readlink -f "$1/lin/lib")"
PROGRAM=fixup
. "$(dirname "$0")/../common.sh"

cd "$1"

declare -a deps
for a in $(find-binaries .); do
    deps=( $(compute-dependencies "$a") )
    for b in "${deps[@]:1}"; do
        cp -n "$b" "$SHARED_LIB_DIR"
    done
done


find "lin" -type f -not -name 'ld-linux*' -executable -exec sh -c 'file "$0" | grep -q "dynamically linked"' {} \; -exec sh -c 'chmod u+w "$0" && patchelf --set-rpath "\$ORIGIN/$(realpath --relative-to "$(dirname "$0")" "lin/lib")" "$0"' {} \; 
find "lin/hunspell" -type f -executable -exec sh -c 'file "$0" | grep -q "dynamically linked"' {} \; -exec sh -c 'patchelf --set-rpath "\$ORIGIN/$(realpath --relative-to "$(dirname "$0")" "lin/lib"):\$ORIGIN/$(realpath --relative-to "$(dirname "$0")" "lin/hunspell/lib")" "$0"' {} \; 
