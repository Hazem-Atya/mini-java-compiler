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

  ## Setup 
  * [Download flex](http://gnuwin32.sourceforge.net/downlinks/flex.php) and install it
  * [Download bison](http://downloads.sourceforge.net/gnuwin32/bison-2.4.1-setup.exe) and install it
  * Install tkcode:
``` 
  pip3 install tkcode
``` 
 ## Run the app:
Open a terminal in the main folder and run these commands:
```
flex 1-analyse_lexicale/java2.lex
bison -d 2-analyse_syntaxique/java.y 
gcc java.tab.c lex.yy.c 
python GUI/main1.py
```
