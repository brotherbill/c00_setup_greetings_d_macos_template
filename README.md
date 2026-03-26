# greetings_d

Minimal D project with working macOS Apple Silicon build and F5 debug setup in VS Code.

## Express Route

These are the shortest known-good steps to go from a mostly reset Mac mini to a working D setup for this repo.

## 1. Software Update

Update to latest version of Mac OS.

## 2. Install VS Code

Download and install VS Code for macOS.

Open VS Code once so macOS finishes its first-run setup.

## 3. Install XCode

Use Apple Store to install XCode.
Open XCode, then close it.

## 4. Download LDC Instead of DMD

DMD has no native arm64 macOS build. The x86_64 DMD binary (v2.112.0) was tried under Rosetta, but it
hangs at startup in `rt.sections_darwin.getTLSRange` — the D runtime's Thread Local Storage detection
code is incompatible with Rosetta's TLS emulation on Apple Silicon. This is a known, unfixed limitation;
the official dlang.org install script explicitly states that DMD does not support macOS aarch64/arm64.
LDC is the correct compiler for Apple Silicon Macs.

Open:

```text
https://github.com/ldc-developers/ldc/releases
```

Download the current macOS ARM64 archive.

Example:

```text
ldc2-1.42.0-osx-arm64.tar.xz
```

Expand it in Finder.

If macOS blocks `ldc2` or `dub` the first time you run them:

1. Click `Done`.
2. Open `System Settings` -> `Privacy & Security`.
3. Click `Open Anyway` for the blocked binary.

## 5. Move the Toolchain to a Stable Folder

Do not keep the compiler in Downloads.

Run:

```bash
mkdir -p ~/tools

mv ~/Downloads/ldc2-1.42.0-osx-arm64 ~/tools/
```

Final tool location:

```bash
~/tools/ldc2-1.42.0-osx-arm64
```

## 6. Add LDC and DUB to PATH

Create or Edit `~/.zprofile` so it contains: (*May use VS Code to create/edit file*)

```bash
if [ -x /opt/homebrew/bin/brew ]; then
	eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ -d "$HOME/tools/ldc2-1.42.0-osx-arm64/bin" ]; then
	path=("$HOME/tools/ldc2-1.42.0-osx-arm64/bin" $path)
fi
```

Open a new terminal, or run:

```bash
source ~/.zprofile
```

## 7. Verify the Toolchain

Run:

```bash
ldc2 --version
dub --version
```

Expected result:

- `ldc2` prints compiler version information
- `dub` prints DUB version information

## 8. Open This Repo in VS Code

Open the folder for this repo in VS Code.

## 9. Set VS Code Theme to Dark

In VS Code:

1. Open `Code` -> `Settings` -> `Theme` -> `Color Theme`
2. Choose `Default Dark Modern`

If you prefer the Command Palette:

1. Press `Cmd+Shift+P`
2. Run `Preferences: Color Theme`
3. Choose `Default Dark Modern`

## 10. Install VS Code Extensions

Install these extensions:

1. `code-d` by `webfreak`
2. `CodeLLDB` by `Vadim Chugunov`

If VS Code asks, allow the publisher and continue installation.

## 11. Build the Project

This repo already includes the needed VS Code files:

- `.vscode/tasks.json`
- `.vscode/launch.json`

Manual build command:

```bash
dub build --build=debug --compiler=ldc2
```

## 12. Debug with F5

Open `source/app.d`, set a breakpoint, then press `F5`.

Choose:

```text
Debug greetings_d
```

Expected result:

- the build runs first
- the debugger stops at the breakpoint
- pressing `F10` advances execution
- program output appears in the VS Code Terminal pane

For this repo, the output is:

```text
Greetings from D!
```

## Current Workspace Configuration

Build task:

```json
{
	"label": "dub: build debug",
	"type": "shell",
	"command": "dub",
	"args": ["build", "--build=debug", "--compiler=ldc2"]
}
```

Launch config:

```json
{
	"name": "Debug greetings_d",
	"type": "lldb",
	"request": "launch",
	"cwd": "${workspaceFolder}",
	"program": "${workspaceFolder}/greetings_d",
	"preLaunchTask": "dub: build debug",
	"console": "integratedTerminal"
}
```

## Troubleshooting

- If `ldc2` or `dub` is blocked by macOS, use `System Settings` -> `Privacy & Security` -> `Open Anyway`.
- If `ldc2` or `dub` is `command not found`, open a new terminal or run `source ~/.zprofile`.
- If the build fails because the toolchain moved, restore it to `~/tools/ldc2-1.42.0-osx-arm64` or update `~/.zprofile`.
- If debug runs but no output appears in the terminal pane, confirm `.vscode/launch.json` uses `"console": "integratedTerminal"`.
- If you try the official DMD macOS package on Apple Silicon, it may crash with a segmentation fault. LDC is the working path documented here.
