# AGENTS.md

## Purpose

This file provides rules and guidelines for agentic coding agents operating within the JPEG Archive repository. It includes build, lint, and test commands (with a focus on running single tests), code style recommendations, naming conventions, and error handling procedures. It aims to promote consistency, maintainability, and reliability.

---

## Build, Test, and Lint Commands

### Build

JPEG Archive utilities are written in C and built using `make` (with GCC or Clang):

- **Build all targets:**
  ```bash
  make
  ```
- **Build on Windows (MinGW):**
  ```bash
  mingw32-make
  ```
- **Build with custom prefix:**
  ```bash
  make PREFIX=/custom/path
  ```
- **Build the IQA library only:**
  ```bash
  cd src/iqa
  make RELEASE=1
  ```

### Test

Testing is performed via Makefile recipes and bash scripts. To ensure all tests pass:

- **Run core C tests:**
  ```bash
  make test
  ```
- **Run shell script tests (integration):**
  ```bash
  cd test
  ./test.sh
  ```
- **Run image comparison test:**
  ```bash
  cd test
  ./comparison.sh
  ```
- **Run a single C test:**
  - Edit the Makefile to add a target for the specific test source, e.g.:
    ```make
    test_X: test/X.c src/util.o src/edit.o src/hash.o
    	$(CC) $(CFLAGS) -o test/$@ $^ $(LIBJPEG) $(LDFLAGS)
    	./test/$@
    ```
  - Then run:
    ```bash
    make test_X
    ```
  - Alternatively, compile and run individually:
    ```bash
    gcc -std=c99 -Wall -O3 -o test/mytest test/mytest.c src/util.o src/edit.o src/hash.o -lm
    ./test/mytest
    ```

- **Continuous Integration builds:**
  - Linux (Travis): Runs `make`, then `make test`, then executes in `test/`.
  - Windows (Appveyor): Runs `mingw32-make`, then `mingw32-make test`.

### Lint

No dedicated linter is used. For C, ensure strict warnings:
- Use `-Wall` with GCC or Clang.

For shell scripts:
- Use `shellcheck <script>` if available.

---

## Code Style Guidelines

### C Code

#### Imports/Includes
- Use relative file includes in double quotes (e.g. `#include "smallfry.h"`).
- System headers should use angle brackets (e.g. `#include <stdio.h>`).
- Group system includes above project includes.

#### Formatting
- **Indentation:** Use tabs for indentation; align continued lines naturally.
- **Line length:** Prefer ≤80 characters per line, but up to 100 is acceptable for clarity.
- **Braces:** Place opening braces on the same line. Example:
  ```c
  if (condition) {
      // ...
  }
  ```
- **Spacing:** Use space after keywords (e.g. `if (x)` not `if(x)`).
- **Comments:**
  - Use `//` for short comments, `/* ... */` for longer blocks.
  - Doc blocks should precede functions or complex logic.

#### Types and Variables
- Explicitly declare all variables, avoid implicit int.
- Use descriptive names: `input_file`, `output_buffer`, etc.
- For structures, prefix names with their purpose (`jpeg_`, `test_`, `iqa_`).
- Constants should be all uppercase with underscores.

#### Functions
- Group related functions together.
- Declare static functions at file scope unless needed externally.
- Use short, descriptive function names: `calculate_ssim`, `read_image`, `write_output`.

#### Error Handling
- Always check return values of system calls, file writes, malloc, etc.
- On error, print an explanatory message to stderr and exit/return when appropriate.
  - Example:
    ```c
    if ((fp = fopen(path, "rb")) == NULL) {
        fprintf(stderr, "Error opening file: %s\n", path);
        return 1;
    }
    ```
- Do not silently ignore errors.

#### Modularity
- Organize code by functionality: utility code in `src/util.c`, image quality assessment in `src/iqa/`, etc.
- Test code is found in `src/test/` and `test/` folders.

#### Data Structures
- Use typedef for structs when clarity is improved.
- Prefer immutable data where possible; minimize global variables.

#### Naming Conventions
- Functions: `snake_case` (e.g., `compress_image`)
- Types: `CamelCaseStruct` (e.g., `ImageInfo`)
- Constants/macros: `ALL_UPPERCASE`
- File names: Use hyphens or underscores to reflect content (e.g., `jpeg-recompress.c`)

---

### Shell Scripts

- Start with `#!/bin/bash` or preferred shell.
- Use `set -e` for early error exit.
- Quote all variable expansions, especially file paths.
- Prefer explicit, descriptive variable names.
- Comment operations, especially those involving downloads, system changes, or image transformations.

---

### Project Conventions

- All core utilities accept `--help` and strive for clear CLI option naming.
- Output files should not overwrite unless explicitly intended.
- Test outputs are written to `test-output/` folder.
- External resources (test images, binaries) should be obtained from documented URLs, e.g. test.sh pulls files from Dropbox.

---

## Miscellaneous/Best Practices

- Contributions should be accompanied by descriptive commit messages.
- New code should be supported by tests where practical.
- Avoid redundant code; factor shared logic into utility modules.
- Follow the UNIX philosophy: small tools, composable logic.
- Respect upstream licenses and patent warnings (see SmallFry metric).

---

## Automation Summary

1. **Always update and build dependencies as shown in README for your OS.**
2. **Run tests via Makefile and shell scripts.**
3. **If adding tests, follow established naming and folder structure.**
4. **Code style as above; prefer clarity, robustness, and fail-fast error handling.**
5. **No Cursor or Copilot rules apply. If any appear, integrate them here.**

---

## References

- See README.md for further build, test, and install details.
- For any unusual build setup, see `Makefile`, `.travis.yml`, or `appveyor.yml`.
- For shell scripts, refer to `test/test.sh` and `test/comparison.sh` as templates.

---

_Last updated: March 2026_