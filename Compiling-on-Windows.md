## Notice of Depreciated Compiling Methods

**The Code::Blocks project file is depreciated** and no longer supported. Code::Blocks team have no intention of updating it to work properly on Windows 10 as of 2020-12-23.

**TDM-GCC is no longer needed** for compiling Red Eclipse on Microsoft Windows.

---

## Setup

MSYS2 by itself will be more than enough because Red Eclipse supports simple `make` commands from the MSYS2 terminal.

### Download and Install MSYS2

Download and install the correct MSYS2 release for your operating system architecture (**take note of the release date** of the package you choose):

- [MSYS2 64 bit](https://sourceforge.net/projects/msys2/files/Base/x86_64/) (install to `c:/msys64` or other non-spaced path)
- [MSYS2 32 bit](https://sourceforge.net/projects/msys2/files/Base/i686/) (install to `c:/msys32` or other non-spaced path)

### Start MSYS2 For The First Time

Launch MSYS2 via:

- `MSYS2 MSYS` in Start Menu or
- `msys2_shell.cmd` or `msys2.exe` in MSYS2 root located either at `c:/msys64`, `c:/msys32` or a custom user-defined non-space path.

### Update MSYS2 Keychains

**If you get the following type of error:** `error: <pkg>: key "4A6129F4E4B84AE46ED7F635628F528CF3053E04" is unknown` at any point, refer to this section.

> **Only for MSYS2 versions released before 2020-06-29.** Skip this section if your version was *released after this date*.

Run the following command:

`pacman -Syuu` or if that fails: `pacman -Syu`

If that fails, run the following commands:

```
curl -O http://repo.msys2.org/msys/x86_64/msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
curl -O http://repo.msys2.org/msys/x86_64/msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz.sig
pacman-key --verify msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz.sig
pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
```

If the last command (`pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz`) fails, run:

```
pacman -U --config <(echo) msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
```

If the last command (`pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz`) fails again, run:

```
rm -r /etc/pacman.d/gnupg/
pacman-key --init
pacman-key --populate msys2
pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz
```

If the last command (`pacman -U msys2-keyring-r21.b39fb11-1-any.pkg.tar.xz`) did not fail, then now run:

`pacman -Syuu` or if that fails: `pacman -Syu`

**You may be advised to `terminate MSYS2 without returning to shell and check for updates again`**. If so, simply close the MSYS2 MSYS Shell desktop app (ignore the `mintty` warning) and launch it again just as you did before to complete the update. Restart computer if MSYS2 fails to launch.

Complete the keychain update by running the following command:

`pacman -Su`

### Update MSYS2

**Check your pacman version** with the following command:

`pacman -Qi pacman`

An example of some of the information on a given package returned by the above command:

```
Name            : pacman
Version         : 5.2.2-4
```

Follow the steps listed for your Pacman version:

-   **Pacman 5.0.1.6403 and later**

    Run `pacman -Syuu`. Follow the instructions. Repeat this step until it says there are no packages to update.

-   **Pacman 4.2.1.6187 and later**

    Run `update-core`. If one of the packages is updated during script run you **_MUST_** restart MSYS2

    Run `pacman -Suu` to update the rest of the packages.

-   **In older MSYS2 installations**

    Run `pacman -Sy` to download the package databases.

    Run `pacman --needed -S bash pacman pacman-mirrors msys2-runtime`, if any packages got updated during this then you need to exit all MSYS2 shells (and if using MSYS2 32bit, run `autorebase.bat`) then re-launch `msys2_shell.bat`

    Run `pacman -Suu` to update the rest of the packages.

### Configuring MSYS2 for Red Eclipse

#### Adding Required Packages

Within MSYS2, install the correct MinGW toolchain for your operating system architecture by running one of the commands below (the 64 bit command also includes the toolchains for 32 bit):

- 64 Bit: `pacman -S --needed base-devel mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain git subversion mercurial mingw-w64-i686-cmake mingw-w64-x86_64-cmake`
- 32 bit: `pacman -S --needed base-devel mingw-w64-i686-toolchain git subversion mercurial mingw-w64-i686-cmake`

#### Configuring INI Files

In `C:\msys64` (or `C:\msys32`) there's 3 ini files: `mingw32.ini`, `mingw64.ini` and `msys2.ini` in those you want these 'settings':

```
MSYS=winsymlinks:nativestrict
MSYS2_PATH_TYPE=inherit
```

## Compiling Red Eclipse With MSYS2

Launch the correct MSYS2 compiling environmant terminal for your operating system via:

- `MSYS2 MinGW 64-bit` or `MSYS2 MinGW 32-bit` application from the Start Menu or
- `mingw64.exe` or `mingw32.exe` in MSYS2 root located either at `c:/msys64`, `c:/msys32` or a custom user-defined non-space path.

CD into the Red Eclipse src directory (the one with `bin`, `config`, `data`, and `src` directories). For example, run the command (your actual path may vary):

`cd C:/projects/redeclipse/base/src`

Run the `make <target>` command to compile the source code, the basic ones are:

- **Clean**: `make clean`
- **Compile**: `make install`

> You may also run `make` from any location, such as the project root, for example: `cd C:/projects/redeclipse/base` and `make -C src install`.

More targets are listed in the following section:

### Red Eclipse Make Targets

Run the following in the `make <target>` format, for example, `make install` (you can chain `make` commands such as `make clean install`):

> If `make` fails and your path has white spaces, try to build Red Eclipse in a path *without whitespaces*. Whitespaces have been known cause issues with `make` in some cases.

#### Cleaning Operations

These targets remove all cached object files, pre-compiled headers and binaries/executables. Next time a cleaned target is built all of the source code for that target will be recompiled, not just the source code files with changes since the previous build.

-   `clean-enet`
-   `clean-client`
-   `clean-server`
-   `clean-genkey`
-   `clean-tessfont`
-   `clean`: Runs all of the above cleaning operations.

#### Debugging Builds

These targets build the development/debugging version of the project's binaries/executables with debugging symbols and stores them in the `src` directory.

-   `client`
-   `server`
-   `genkey`
-   `tessfont`
-   `all`: Builds all the above development/debugging targets.

#### Production Builds

These targets build the production version of the project's binaries/executables without any debugging symbols and stores them in the `bin` directory.

-   `install-client`
-   `install-server`
-   `install-genkey`
-   `install-tessfont`
-   `install`: Builds all the above production targets.

#### Other Builds and Operations

-   `default`: Builds the `all` target, a development/debugging build.
-   `depend`: Builds the dependencies for the `client` and `server` targets and thier pre-compiled headers.

### Red Eclipse Make Variables

>   Example use case for setting variables for use in the Make process:
>
>   `WANT_STEAM=1 WANT_DISCORD=1 make -C src install`

-   **PLATFORM_BUILD**: 

    Sets the read-only integer-variable `versionbuild` value in the source code. 

    Default value (when not set): `0`

-   **PLATFORM_BRANCH**: 

    Sets the read-only string-variable `versionbranch` value in the source code. 

    Default value (when not set): `"selfbuilt"`

-   **PLATFORM_REVISION**: 

    Sets the read-only string-variable `versionrevision` value in the source code. 

    Default value (when not set): `""`

-   **PLATFORM_BIN**: 

    Sets the location for the generated binaries (*.exe in Windows) and additional libraries relative to the project's `bin` folder.

    Default value (when not set): *Automatically detected from the information about the current status of the target machine*

-   **INSTDIR**: 

    Sets the location for production builds of the binaries/executables relative to the project's `src` folder. Only applies when building using the `install` or `install-*` targets.

    Default value (when not set): `../bin/` *plus the relative path automatically generated from the `PLATFORM_BIN` variable*

-   **WANT_DISCORD**: 

    Builds the project for use with Discord.

    Default value (when not set): *disabled*

-   **WANT_STEAM**: 

    Builds the project for use with Steam.

    Default value (when not set): *disabled*

---

## Recommended Code Editor For Red Eclipse On Windows

- [Visual Studio Code](https://code.visualstudio.com/download) 

> **Visual Studio Code is a different application from Microsoft Visual Studio.** Visual Studio Code is platform neutral, supports build environments and git natively, and has a built-in terminal.

### Visual Studio Code Files

The following files are for the `.vscode` directory created in the root of the project.

#### c_cpp_properties.json

```
{
    "configurations": [
        {
            "name": "Win64",
            "includePath": [
                "${workspaceFolder}/**",
                "C:\\msys64\\mingw64\\include",
                "C:\\msys64\\mingw64\\lib\\gcc\\x86_64-w64-mingw32\\10.1.0\\include"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE"
            ],
            "compilerPath": "C:\\msys64\\mingw64\\bin\\gcc.exe",
            "cStandard": "c89",
            "cppStandard": "c++11",
            "intelliSenseMode": "gcc-x64"
        },
        {
            "name": "Win32",
            "includePath": [
                "${workspaceFolder}/**",
                "C:\\msys32\\mingw32\\include",
                "C:\\msys32\\mingw32\\lib\\gcc\\i686-w64-mingw32\\10.1.0\\include"
            ],
            "defines": [
                "_DEBUG",
                "UNICODE",
                "_UNICODE"
            ],
            "compilerPath": "C:\\msys32\\mingw32\\bin\\gcc.exe",
            "cStandard": "c89",
            "cppStandard": "c++11",
            "intelliSenseMode": "gcc-x86"
        }
    ],
    "version": 4
}
```

#### launch.json

```
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "name": "(gdb) Launch 64",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bin/amd64/redeclipse.exe",
            "args": ["-hhome"],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\msys64\\mingw64\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "make debug"
        },
        {
            "name": "(gdb) Launch 32",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/bin/x86/redeclipse.exe",
            "args": ["-hhome"],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "miDebuggerPath": "C:\\msys32\\mingw32\\bin\\gdb.exe",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "make debug"
        }
    ]
}
```

#### tasks.json

```
{
    // See https://go.microsoft.com/fwlink/?LinkId=733558
    // for the documentation about the tasks.json format
    "version": "2.0.0",
    "tasks": [
        {
            "label": "make client",
            "type": "shell",
            "command": "make -j$(nproc) install-client",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1"
                }
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "make debug",
            "type": "shell",
            "command": "make -j$(nproc) install-client",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1",
                    "CXXFLAGS": "-ggdb3"
                }
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "clean client",
            "type": "shell",
            "command": "make -j$(nproc) clean-client",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1"
                }
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "make server",
            "type": "shell",
            "command": "make -j$(nproc) install-server",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1"
                }
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "clean server",
            "type": "shell",
            "command": "make -j$(nproc) clean-server",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1"
                }
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "tessfont",
            "type": "shell",
            "command": "make -j$(nproc) install-tessfont",
            "options": {
                "cwd": "${workspaceFolder}/src"
            },
            "problemMatcher": ["$gcc"]
        },
        {
            "label": "make clean",
            "type": "shell",
            "command": "make -j$(nproc) clean",
            "options": {
                "cwd": "${workspaceFolder}/src"
            },
            "problemMatcher": []
        },
        {
            "label": "make all",
            "type": "shell",
            "command": "make -j$(nproc) install",
            "options": {
                "cwd": "${workspaceFolder}/src",
                "env": {
                    "WANT_STEAM": "1",
                    "WANT_DISCORD": "1"
                }
            },
            "problemMatcher": ["$gcc"],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

#### settings.json

This file is for setting up the Visual Studio Code terminals correctly. It should be located at: `%appdata%/Code/User` or `%appdata%/Code - Insiders/User`.

**For 64 Bit MSYS2:**

This will compile 32 bit binaries/executables as well, you do not need the 32 bit `settings.ini` below this one unless you are on a 32 bit-only machine.

```
{
    "workbench.colorTheme": "Default Dark+",
    "editor.fontSize": 12,
    "terminal.integrated.shell.windows": "C:\\msys64\\usr\\bin\\bash.exe",
    "terminal.integrated.env.windows": { "MSYSTEM": "MINGW64" },
    "terminal.integrated.cwd": "${workspaceFolder}",
    "extensions.ignoreRecommendations": false,
    "debug.console.fontSize": 12,
    "markdown.preview.fontSize": 12,
    "terminal.integrated.fontSize": 12,
    "workbench.sideBar.location": "left",
    "files.exclude": {
        "**/*.o": true
    },
    "git.detectSubmodulesLimit": 64,
    "C_Cpp.default.intelliSenseMode": "gcc-x64",
    "C_Cpp.dimInactiveRegions": false,
    "files.trimTrailingWhitespace": true,
    "workbench.editor.highlightModifiedTabs": true,
    "explorer.enableDragAndDrop": false,
    "workbench.startupEditor": "none",
    "workbench.tree.indent": 12,
    "window.autoDetectColorScheme": true,
    "C_Cpp.updateChannel": "Insiders",
    "git.path": "C:\\msys64\\usr\\bin\\git.exe",
    "shellLauncher.shells.windows": [
        {
            "shell": "C:\\Windows\\System32\\cmd.exe",
            "label": "cmd"
        },
        {
            "shell": "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
            "label": "PowerShell"
        },
        {
            "shell": "C:\\Windows\\System32\\bash.exe",
            "label": "WSL Bash"
        },
        {
            "shell": "C:\\msys64\\usr\\bin\\bash.exe",
            "label": "MSYS2",
            "env": { "MSYSTEM": "MINGW64" }
        }
    ],
    "window.zoomLevel": 0
}
```

**For 32 Bit MSYS2:**

You only need this if you are on a 32 bit-only machine. For 64 bit systems use the 64 bit version above.

```
{
    "workbench.colorTheme": "Default Dark+",
    "editor.fontSize": 12,
    "terminal.integrated.shell.windows": "C:\\msys32\\usr\\bin\\bash.exe",
    "terminal.integrated.env.windows": { "MSYSTEM": "MINGW32" },
    "terminal.integrated.cwd": "${workspaceFolder}",
    "extensions.ignoreRecommendations": false,
    "debug.console.fontSize": 12,
    "markdown.preview.fontSize": 12,
    "terminal.integrated.fontSize": 12,
    "workbench.sideBar.location": "left",
    "files.exclude": {
        "**/*.o": true
    },
    "git.detectSubmodulesLimit": 64,
    "C_Cpp.default.intelliSenseMode": "gcc-x86",
    "C_Cpp.dimInactiveRegions": false,
    "files.trimTrailingWhitespace": true,
    "workbench.editor.highlightModifiedTabs": true,
    "explorer.enableDragAndDrop": false,
    "workbench.startupEditor": "none",
    "workbench.tree.indent": 12,
    "window.autoDetectColorScheme": true,
    "C_Cpp.updateChannel": "Insiders",
    "git.path": "C:\\msys32\\usr\\bin\\git.exe",
    "shellLauncher.shells.windows": [
        {
            "shell": "C:\\Windows\\System32\\cmd.exe",
            "label": "cmd"
        },
        {
            "shell": "C:\\Windows\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
            "label": "PowerShell"
        },
        {
            "shell": "C:\\Windows\\System32\\bash.exe",
            "label": "WSL Bash"
        },
        {
            "shell": "C:\\msys32\\usr\\bin\\bash.exe",
            "label": "MSYS2",
            "env": { "MSYSTEM": "MINGW32" }
        }
    ],
    "window.zoomLevel": 0
}
```

### Using VSCode for Red Eclipse

Launch VSCode. From here you can go to the `top menu bar -> File -> Open Folder` and select the Red Eclipse root directory. From here you may run the terminal and build the source using `make -C src install`. VSCode also has Git integration to help with branching, pushing and pull requesting.

---

## Sources

- [MSYS2 Installation Guide](https://www.msys2.org/wiki/MSYS2-installation/#iii-updating-packages)
- [MSYS2 News: 2020-06-29 New Packagers](https://www.msys2.org/news/#2020-06-29-new-packagers)
- [Installing GCC & MSYS2](https://github.com/orlp/dev-on-windows/wiki/Installing-GCC--&-MSYS2)
- [Zepher: Development Environment Setup on Windows](https://docs.zephyrproject.org/1.9.0/getting_started/installation_win.html)
- [pacman Manual Page](https://archlinux.org/pacman/pacman.8.html#QO)
- [Stack Overflow: Visual Studio Code Intellisense Mode](https://stackoverflow.com/questions/46242360/visual-studio-code-intellisense-mode)
- [Wikipedia: Program Database](https://en.wikipedia.org/wiki/Program_database)

---

## Special Thanks

- Quinton Reeves and the Red Eclipse Team: For their help in aiding and assisting with the research and making of this page.

---

> Last updated: by Leviscus Tempris on 2020-12-25 09:36:09 Friday GMT.
> Written by Leviscus Tempris.
