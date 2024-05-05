from customtkinter import CTk, CTkLabel


class MenuPopupWidget(CTk):
    COLOR_LIGHT = "#3a3c4e"
    DEFAULT_FONT = "Cousine Nerd Font"

    def __init__(self, title: str, width: int, height: int) -> None:
        super().__init__(className=title)

        self.title(title)
        self.set_geometry(width, height)
        self.resizable(0, 0)

        self.bind("<Escape>", self.on_keypressed)
        self.bind("<FocusOut>", self.on_focusout)

    def set_geometry(self, width: int, height: int) -> None:
        x = self.winfo_pointerx() - 20
        y = 28
        self.geometry(f"{width}x{height}+{x}+{y}")

    def on_focusout(self, event) -> None:
        if event.widget == self:
            self.destroy()

    def on_keypressed(self, event) -> None:
        self.destroy()

    def get_next_row(self) -> int:
        (_, row) = self.grid_size()
        return row

    def add_separator(self, columnspan: int) -> None:
        row = self.get_next_row()
        font = (self.DEFAULT_FONT, 1)
        separator = CTkLabel(
            master=self,
            text="",
            font=font,
            padx=0,
            pady=0,
            height=3,
            fg_color=self.COLOR_LIGHT,
        )
        separator.grid(row=row, column=0, columnspan=columnspan, sticky="we")
