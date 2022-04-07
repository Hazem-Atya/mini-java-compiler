import tkinter as tk
from tkinter.filedialog import askopenfilename, asksaveasfilename

def open_file():
    pass

def save_file():
    pass

window = tk.Tk()

# fix window size
window.geometry("1000x700+250+50")
window.resizable(False,False)
# ******

window.title("Text Editor Application")
window.rowconfigure(0, minsize=200, weight=1)
window.columnconfigure(1, minsize=200, weight=1)

txt_edit = tk.Text(window)

# we create a new window
new_txt = tk.Text(window)
# ********

fr_buttons = tk.Frame(window, relief=tk.RAISED, bd=2)
btn_open = tk.Button(fr_buttons, text="Open", command=open_file)
btn_save = tk.Button(fr_buttons, text="Save As...", command=save_file)

btn_open.grid(row=0, column=0, sticky="ew", padx=5, pady=5)
btn_save.grid(row=1, column=0, sticky="ew", padx=5)

fr_buttons.grid(row=0, column=0, rowspan=2, sticky="ns")
txt_edit.grid(row=0, column=1, sticky="nsew")

# we add it to the grid
new_txt.grid(row=1, column=1, sticky="nsew")
# ********

window.mainloop()