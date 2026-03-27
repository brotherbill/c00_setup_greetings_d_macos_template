#!/bin/bash
# clean.sh - Remove dub build folder and template executables/debug files

# Remove .dub build folder
if [ -d ".dub" ]; then
    echo "Removing .dub/ directory..."
    rm -rf .dub
fi

# Remove dub build folder
if [ -d "dub" ]; then
    echo "Removing dub/ directory..."
    rm -rf dub
fi

# Remove executables and debug symbol files matching template name
for f in c00_greetings_d_wsl_ubuntu_template c00_greetings_d_wsl_ubuntu_template.exe c00_greetings_d_wsl_ubuntu_template.o c00_greetings_d_wsl_ubuntu_template.obj c00_greetings_d_wsl_ubuntu_template.pdb; do
    if [ -e "$f" ]; then
        echo "Removing $f..."
        rm -f "$f"
    fi
    # Also check in source/ if present
    if [ -e "source/$f" ]; then
        echo "Removing source/$f..."
        rm -f "source/$f"
    fi
    # Also check in bin/ if present
    if [ -e "bin/$f" ]; then
        echo "Removing bin/$f..."
        rm -f "bin/$f"
    fi
    # Also check in build/ if present
    if [ -e "build/$f" ]; then
        echo "Removing build/$f..."
        rm -f "build/$f"
    fi
    # Also check in debug/ if present
    if [ -e "debug/$f" ]; then
        echo "Removing debug/$f..."
        rm -f "debug/$f"
    fi
    # Also check in . for .pdb, .o, .obj
    for ext in o obj pdb; do
        if [ -e "c00_greetings_d_wsl_ubuntu_template.$ext" ]; then
            echo "Removing c00_greetings_d_wsl_ubuntu_template.$ext..."
            rm -f "c00_greetings_d_wsl_ubuntu_template.$ext"
        fi
    done
    # Remove from .dub if present
    if [ -e ".dub/$f" ]; then
        echo "Removing .dub/$f..."
        rm -f ".dub/$f"
    fi
    # Remove from .dub/obj if present
    if [ -e ".dub/obj/$f" ]; then
        echo "Removing .dub/obj/$f..."
        rm -f ".dub/obj/$f"
    fi
    # Remove from .dub/build if present
    if [ -e ".dub/build/$f" ]; then
        echo "Removing .dub/build/$f..."
        rm -f ".dub/build/$f"
    fi
done
