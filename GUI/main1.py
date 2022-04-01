import tkinter as tk
from tkinter.filedialog import askopenfilename, asksaveasfilename
from tkcode import CodeEditor
from tkinter import ttk


def open_file():
    """Open a file for editing."""
    filepath = askopenfilename(
        filetypes=[("Text Files", "*.txt"), ("All Files", "*.*")]
    )
    if not filepath:
        return
    #txt_edit.delete(1.0, tk.END)
    #txt_edit.forget(tab_1)
    with open(filepath, "r") as input_file:
        text = input_file.read()
        code_editor.content =text
        txt_edit.add(tab_1, text=filepath)





    window.title(f"Mini java compiler - {filepath}")


def save_file():
    """Save the current file as a new file."""
    filepath = asksaveasfilename(
        defaultextension="java",
        filetypes=[(".java", "*.java"), ("All Files", "*.*")],
    )
    if not filepath:
        return
    with open(filepath, "w") as output_file:
        text = code_editor.content
        output_file.write(text)
    txt_edit.add(tab_1, text=filepath)
    window.title(f"Mini java compiler - {filepath}")


def compileFile():
    print("The file is being compiled")


window = tk.Tk()
window.title("Mini java compiler")
window.rowconfigure(0, minsize=600, weight=1)
window.columnconfigure(1, minsize=600, weight=1)

txt_edit = tk.Text(window)
fr_buttons = tk.Frame(window, relief=tk.RAISED, bd=2)
btn_open = tk.Button(fr_buttons, text="Open", command=open_file)
btn_save = tk.Button(fr_buttons, text="Save As...", command=save_file)
btn_compile = tk.Button(fr_buttons, text="Compile", command=compileFile)

btn_open.grid(row=0, column=0, sticky="ew", padx=5, pady=5)
btn_save.grid(row=1, column=0, sticky="ew", padx=5)
btn_compile.grid(row=2, column=0, sticky="ew", padx=5)

fr_buttons.grid(row=0, column=0, sticky="ns")
#txt_edit.grid(row=0, column=1, sticky="nsew")



txt_edit = ttk.Notebook(window)
tab_1 = ttk.Frame(txt_edit)
txt_edit.add(tab_1, text='')
txt_edit.grid(row="0", column=1, sticky="nsew")
code_editor = CodeEditor(
    tab_1,
    width=99,
    height=30,
    language="java",
    background="black",
    highlighter="mariana",
    font="Consolas",
    autofocus=True,
    blockcursor=True,
    insertofftime=0,
    padx=10,
    pady=10,  
)
code_editor.pack(fill="both", expand=True)
code_editor.content = """print("Hello World")"""

window.update()
window.mainloop()
