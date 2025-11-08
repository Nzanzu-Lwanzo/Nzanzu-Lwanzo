# USING MAKEFILE

## Global notes

- By default, all the commands are printed to the terminal as they are executed. If you want them to be executed without being printed, add a `@` at the beginning. So, `@rm -rf folder/file.txt` would execute without being printed and `rm -rf folder/file.txt` would still execute but be printed to the terminal.

- When running `make`, errors stop further commands from running. To ignore them, add a `-k` or `-` or `-i` before the command.

## Defining variables

The syntax for defining a variable is :

```
variable := value which is always a string
```

The value is always string, no matter if you pass a number. Also, do not surround the value with quotes or double quotes because these are considered like any other character in Makefile.

```
# bad. Will output ''hello world'' or "'hello world'"
one := 'hello world'

# good. Will output "hello world" or 'hello world'
two := world world
```

To use the variables, enclose the name of the variable in `${}` or `$()`.

Here are some special variables :

- `$@` : the name of the currently running directive.
- `SHELL` : by default, the commands execute in the default shell wich is `/bin/bash`. You can change this by assigning a new value of SHELL.

## Directive

In these notes, we'll use the concept of **directive** to designate a set of commands to run. The official Makefile calls it **target** but as these notes are not intended for a use with C++ (which is originally the language Makefile is for), we won't use the same terminology.

Given the following Makefile content :

```
filename := file.txt

pwdloop:
    @echo "Write deep structure in ${filename}"
    ls -Ra > ${filename}

```

`pwdloop` is the **directive** and the lines under it are the commands. The first command will print something to the stdout and the second one will recursively dig through the folder structure and write it in the `file.txt` that you have stored in a variable.

To run a directive, you execute `make directive`, which will execute all the commands under it. In our case, if you open a terminal, navigate to that directory and type `make pwdloop`, you'll see a **file.txt** file created and inside of it, the deep structure of the folder.

Here are some special directives (or targets) :

- `all` : suppose you have 5 directives in your Makefile and want all of them to run. What you'd do is adding a `all` directive at the top of the file and list all the directives you want to run in the order you want to run them. So, it would look something like.

```
all : directive1 directive3 directive2

directive1:
    @echo "Hello from directive 1"

directive2:
    @echo "Hello from directive 2"

directive3:
    @echo "Hello from directive 3"
```

With this Makefile, running `make` would run the directive 1, then 3, then 2 (see the order in which we listed them).

Now, what it there's no **all** directive you simply run `make` ? In this case, only the first directive will be run.

### Special variables with directives

Now, we've decided to call targets directives. Also, we mentionned that Makefile was made for C++ language. One thing to bear in mind is that targets actually files and can be manipulated as such.

- `$(@D)` : this variable gives the path of the directory in which the target (file) is located. This path is relative to the Makefile.

  So, given the following fold structure :

  ```
  Makefile
  /scripts
      |
      |--/under
  ```

  And the following Makefile:

  ```
  scripts/under/main:
      echo "print('Hello world')" > $@.py
      @echo $(@D)
  ```

  This will take the name of the target (directive), will append a .py extension to it, which will give us `/scripts/under/main.py`, then will write `print('Hello world')` inside of that file.
  Then, on a second line, it will print the location of the directory under which `main.py` is located. Which should give `scripts/under`.

- `$(@F)` : this variable gives the name of the target file itself.
