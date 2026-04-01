#!/bin/bash
# clean.sh - Remove dub build artifacts for macOS

# Must be run from the project root (where dub.json lives)

if [ ! -f "dub.json" ]; then
    echo "Error: dub.json not found. Must be run from the project root." >&2
    exit 1
fi

# Extract project name from dub.json
project_name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]\+"' dub.json | head -n1 | sed 's/.*: *"\([^"]*\)"/\1/')
if [ -z "$project_name" ]; then
    echo "Error: Could not determine project name from dub.json." >&2
    exit 1
fi

for d in .dub dub; do
    if [ -d "$d" ]; then
        echo "Removing $d/ directory..."
        rm -rf "$d"
    fi
done

target_name=$(grep -o '"targetName"[[:space:]]*:[[:space:]]*"[^"]\+"' dub.json | head -n1 | sed 's/.*: *"\([^"]*\)"/\1/')
if [ -z "$target_name" ]; then
    target_name="$project_name"
fi

search_dirs=("." "source" "bin" "build" "debug" ".dub" ".dub/obj" ".dub/build" ".dub/debug" ".dub/release" ".dub/test" ".dub/objects" "dub")
artifact_names=("$target_name" "$target_name.exe" "$target_name.o" "$target_name.obj" "$target_name.pdb")

for f in "${artifact_names[@]}"; do
    for d in "${search_dirs[@]}"; do
        path="$d/$f"
        if [ "$d" = "." ]; then
            path="$f"
        fi
        if [ -e "$path" ]; then
            echo "Removing $path..."
            rm -f "$path"
        fi
    done
done

# Remove macOS debug symbol bundle produced by ldc2
if [ -d "$target_name.dSYM" ]; then
    echo "Removing $target_name.dSYM/ directory..."
    rm -rf "$target_name.dSYM"
fi

echo "Clean complete."
