# PP6

## Goal

In this exercise you will:

* Learn how to produce text output to the terminal in four different environments:

  1. **Bash** shell scripting
  2. **GNU Assembler** (GAS) using system calls
  3. **C** via the standard library
  4. **Python 3** using built‑in printing functions

**Important:** Start a stopwatch when you begin and work uninterruptedly for **90 minutes**. When time is up, stop immediately and record exactly where you paused.

---

> **⚠️ WARNING:** The **workflow** steps have been **updated** for PP6. Please review the new workflow below carefully before proceeding.

## Workflow

1. **Fork** this repository on GitHub
2. **Clone** your fork to your local machine
3. Create a **solutions** directory at the repository root: `mkdir solutions`
4. For each task, add your solution file into `./solutions/` (e.g., `[solutions/print.sh](./solutions/print.sh)`)
5. **Commit** your changes locally, then **push** to GitHub
6. **Submit** your GitHub repository link for review

---

## Prerequisites

* Several starter repos are available here:
  [https://github.com/orgs/STEMgraph/repositories?q=SSH%3A](https://github.com/orgs/STEMgraph/repositories?q=SSH%3A)

---

> **Note:** Place all your solution files under the `solutions/` directory in your cloned repo.

## Tasks

### Task 1: Bash Printing & Shell Prompt

**Objective:** Use both `echo` and `printf` to format and display text and variables, and customize your shell prompt and login/logout messages.

1. In `./solutions/`, create a file named `print.sh` based on the template below.
2. At the top of `print.sh`, add the shebang:

   ```bash
   #!/usr/bin/env bash
   ```
3. Implement at least three functions:

   * `print_greeting`: prints `Hello from Bash!` using `echo`.
   * `print_vars`: declares two variables (e.g., `name="Bash"`, `version=5.1") and prints them with `printf\` using format specifiers.
   * `print_escape`: demonstrates escape sequences: newline (`\n`), tab (`\t`), and ANSI color codes (e.g., `\e[32m` for green).
4. Make the script executable and verify it runs:

   ```bash
   chmod +x solutions/print.sh
   ./solutions/print.sh
   ```
5. Modify your **`~/.bashrc`** on your local machine to:

   * Change the `PS1` prompt to include your username and current directory (e.g., `export PS1="[\u@\h \W]\$ "`).
   * Display a **welcome** message on login (e.g., `echo "Welcome, $(whoami)!"`).
   * Display a **goodbye** message on logout (add a `trap` for `EXIT` to echo `Goodbye!`).
6. Reload your shell (`source ~/.bashrc`) and demonstrate the prompt, greeting, and exit message.

**Template for `solutions/print.sh`**

```bash
#!/usr/bin/env bash

print_greeting() {
    # TODO: echo "Hello from Bash!"
}

print_vars() {
    local name="Bash"
    local version=5.1
    # TODO: printf "Using %s version %.1f\n" "$name" "$version"
}

print_escape() {
    # TODO: printf "This is a newline:\nThis is a tab:\tDone!\n"
    # TODO: printf "\e[32mGreen text\e[0m and normal text\n"
}

# Call your functions:
print_greeting
print_vars
print_escape
```

**Solution Reference**
Place your completed `print.sh` in `solutions/` and commit. Then link it here:

```
[print.sh](https://github.com/Besir76/PP6/blob/master/solutions/print.sh)
```

#### Reflection Questions

1. **What is the difference between `printf` and `echo` in Bash?** echo ist einfach und schnell, wird aber je nach System unterschiedlich interpretiert.
printf ist präziser und bietet bessere Kontrolle über Formatierung (z. B. Nachkommastellen, Farben, etc.).
2. **What is the role of `~/.bashrc` in your shell environment?** Die Datei ~/.bashrc wird bei jedem Start einer neuen Bash-Sitzung geladen.
Sie enthält Konfigurationen wie Umgebungsvariablen, Aliase und Anpassungen des Prompts.
3. **Explain the difference between sourcing (`source ~/.bashrc`) and executing (`./print.sh`).** source ~/.bashrc führt das Skript im aktuellen Terminal aus – Änderungen gelten sofort für das Terminal.
./print.sh startet ein neues Subshell-Terminal, das nach Ausführung wieder verschwindet – Änderungen wirken nur dort.

---

### Task 2: GAS Printing (32‑bit Linux)

**Objective:** Use the Linux `sys_write` and `sys_exit` system calls in GAS to write text, while ensuring your repo only contains source files.

1. At the repository root, create a file named `.gitignore` that ignores:

   * Object files (`*.o`)
   * Binaries/executables (e.g., `print`, `print_c`)
   * Any editor or OS-specific files
     Commit this `.gitignore` file.
     **Explain:** Why should compiled artifacts and binaries not be committed to a Git repository?
2. In `./solutions/`, create a file named `print.s` using the template below.
3. Define a message in the `.data` section (e.g., `msg: .ascii "Hello from GAS!\n"`, `len = . - msg`).
4. In the `.text` section’s `_start` symbol, invoke `sys_write` (syscall 4) and then `sys_exit` (syscall 1) via `int $0x80`.
5. Assemble and link in 32‑bit mode:

   ```bash
   as --32 -o print.o solutions/print.s
   ld -m elf_i386 -o print print.o
   ```
6. Run `./print` and verify it outputs your message.

**Template for `solutions/print.s`**

```asm
    .section .data
msg:    .ascii "Hello from GAS!\n"
len = . - msg

    .section .text
    .global _start
_start:
    movl $4, %eax        # sys_write
    movl $1, %ebx        # stdout
    movl $msg, %ecx
    movl $len, %edx
    int $0x80

    movl $1, %eax        # sys_exit
    movl $0, %ebx        # status 0
    int $0x80
```

**Solution Reference**

```
[print.s](https://github.com/Besir76/PP6/blob/master/solutions/simple.s)
```

#### Reflection Questions

1. **What is a file descriptor and how does the OS use it?** Ein File Descriptor ist eine kleine, nicht negative Ganzzahl, die vom Betriebssystem vergeben wird, um eine geöffnete Datei, einen Socket oder einen Stream zu identifizieren.
Typische File Descriptors:

0 = Standard Input (stdin)

1 = Standard Output (stdout)

2 = Standard Error (stderr)

Das Betriebssystem verwendet diese Deskriptoren, um die Verbindung zwischen einer Anwendung und einer Datei oder einem Gerät zu verwalten.

2. **How can you obtain or duplicate a file descriptor for another resource (e.g., a file or socket)?** dup() / dup2() / dup3() in C → duplizieren einen bestehenden File Descriptor auf einen neuen

fcntl() kann verwendet werden, um Eigenschaften eines Descriptors zu kopieren oder zu ändern

Shells wie Bash nutzen >& zur Umleitung

3. **What might happen if you use an invalid file descriptor in a syscall?** Wenn du einen ungültigen File Descriptor verwendest (z. B. einen geschlossenen oder nie existenten), führt das meist zu einem Fehler:

Das Systemcall schlägt fehl

errno wird auf EBADF gesetzt (Bad File Descriptor)

Die Funktion gibt -1 zurück

---

### Task 3: C Printing

**Objective:** Use `printf` and `puts` from `<stdio.h>` to display formatted data.

1. In `./solutions/`, create `print.c` based on the template below.
2. Implement `main()` to print a greeting, an integer, a float, and a string via `printf`, then use `puts`.
3. Compile and run:

   ```bash
   gcc -std=c11 -Wall -o print_c solutions/print.c
   ./print_c
   ```

**Template for `solutions/print.c`**

```c
#include <stdio.h>

int main(void) {
    printf("Hello from C!\n");
    printf("Integer: %d, Float: %.2f, String: %s\n", 42, 3.14, "test");
    puts("This is puts output");
    return 0;
}
```

**Solution Reference**

```
[print.c](https://github.com/Besir76/PP6/blob/master/solutions/print.c)
```

#### Reflection Questions

1. **Use `objdump -d` on `print_c` to find the assembly instructions corresponding to your `printf` calls.** Ich habe den Befehl objdump -d print_c ausgeführt. Dabei wurde mir der Assembler-Code des Programms angezeigt. In der Ausgabe konnte ich u. a. den Aufruf von printf erkennen sowie typische Assembler-Befehle wie push, mov oder call. Das zeigt, wie der C-Code intern in Maschinensprache umgesetzt wird
2. **Why is the syntax written differently from GAS assembly? Compare NASM vs. GAS notation.** Ich habe objdump -d print_s und print_c miteinander verglichen. Der Hauptunterschied liegt darin, dass print_s mit einem String arbeitet (char*), während print_c ein einzelnes Zeichen (char) nutzt. Dadurch unterscheiden sich die Aufrufe von printf leicht, und in print_s wird der Speicher anders vorbereitet, da ein String verarbeitet wird.
3. **How could you use `fprintf` to write output both to `stdout` and to a file instead? Provide example code.** Beim Ausführen von print_c wird nur ein einzelnes Zeichen ausgegeben, z. B. A.
Beim Ausführen von print_s hingegen erscheint ein ganzer String, z. B. ABC.
Der Unterschied liegt also in der Länge der Ausgabe: print_c gibt nur ein Zeichen aus, print_s dagegen mehrere.

---

### Task 4: Python 3 Printing

**Objective:** Use Python’s `print()` function with various parameters and f‑strings.

1. In `./solutions/`, create `print.py` using the template below.
2. Implement `main()` to print a greeting, multiple values with custom `sep`/`end`, and an f‑string expression.
3. Make it executable and run:

   ```bash
   chmod +x solutions/print.py
   ./solutions/print.py
   ```

**Template for `solutions/print.py`**

```python
#!/usr/bin/env python3

def main():
    print("Hello from Python3!")
    print("A", "B", "C", sep="-", end=".\n")
    value = 2 + 2
    print(f"Two plus two equals {value}")

if __name__ == "__main__":
    main()
```

**Solution Reference**

```
[print.py](https://github.com/Besir76/PP6/blob/master/solutions/print.py)
```
90 Minuten waren hier um
#### Reflection Questions

1. **Is Python’s print behavior closer to Bash, Assembly, or C? Explain.**
2. **Can you inspect a Python script’s binary with `objdump`? Why or why not?**

---

**Remember:** Stop working after **90 minutes** and document where you stopped.
