# mini-java-compiler
 <ol>
    <li>
      <a href="#about-the-repo">About The repo</a>
    </li>
      <li>
      <a href="#setup">Setup</a>
    </li>
      <li>
      <a href="#run-the-app">Run the app</a>
    </li>
  </ol>
  
  ## About the repo
  This repository contains a mini java compiler with w simple graphical user interface for code editing.
  The document TP_2022.doc contains the grammar and the rules.
  Used technologies:
  * Flex: Fast lexical analyzer generator, used for Lexical analysis
  * Yacc Yet Another Compiler-Compiler, used for Syntactic analysis
  * Python3
  * Tkinter: A python package for GUI programming
  * Tkcode: Code block and code editor widget for tkinter with syntax highlighting 
# Important Note:
This mini compiler treats only the grammar explained [here](https://github.com/Hazem-Atya/mini-java-compiler/blob/main/TP_2022.doc)
  ## Setup 
  * [Download flex](http://gnuwin32.sourceforge.net/downlinks/flex.php) and install it
  * [Download bison](http://downloads.sourceforge.net/gnuwin32/bison-2.4.1-setup.exe) and install it
  * Install tkcode:
``` 
  pip3 install tkcode
``` 
 ## Run the app:
Open a terminal in the main folder and run the script:
```
./script.bash
```
![Untitled](https://user-images.githubusercontent.com/53778545/166907908-1a71d964-1a54-430c-8d4b-158cf09664a4.png)

