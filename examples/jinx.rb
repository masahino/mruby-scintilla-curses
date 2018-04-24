#  setlocale(LC_CTYPE, ""); // for displaying UTF-8 characters properly
win = Curses.initscr
Curses.raw
Curses.cbreak
Curses.noecho
Curses.start_color
sci = Scintilla::ScintillaCurses.new

#  curs_set(0); // Scintilla draws its own cursor
Curses.curs_set(0)
Curses.keypad(win, "1")

  sci.sci_style_set_fore(Scintilla::STYLE_DEFAULT, 0xFFFFFF)
  sci.sci_style_set_back(Scintilla::STYLE_DEFAULT, 0)
  sci.sci_style_clear_all

  sci.sci_set_lexer_language("cpp")
  sci.sci_set_keywords(0, "int char")
  sci.sci_style_set_fore(Scintilla::SCE_C_COMMENT, 0x00ff00)
  sci.sci_style_set_fore(Scintilla::SCE_C_COMMENTLINE, 0x00FF00)
  sci.sci_style_set_fore(Scintilla::SCE_C_NUMBER, 0xFFFF00)
  sci.sci_style_set_fore(Scintilla::SCE_C_WORD, 0xFF0000)
  sci.sci_style_set_fore(Scintilla::SCE_C_STRING, 0xFF00FF)
  sci.sci_style_set_fore(Scintilla::SCE_C_OPERATOR, 1)
  sci.sci_inserttext(0,
      "int main(int argc, char **argv) {\n    // Start up the gnome\n    gnome_init(\"stest\", \"1.0\", argc, argv);\n}")
  sci.sci_set_property("fold", "1")
  sci.sci_set_margin_widthn(2, 1)
  sci.sci_set_margin_maskn(2, Scintilla::SC_MASK_FOLDERS)
  sci.sci_set_margin_sensitiven(2, 1)
  sci.sci_set_automatic_fold(Scintilla::SC_AUTOMATICFOLD_CLICK, 0)
  sci.sci_set_focus(1)
  sci.refresh()

print ("\033[?1000h") # enable mouse press and release events
#  //printf("\033[?1002h"); // enable mouse press, drag, and release events
#  //printf("\033[?1003h"); // enable mouse move, press, drag, and release events
#  Curses.mousemask(Curses::ALL_MOUSE_EVENTS, nil);
  Curses.mouseinterval(0)
#
#  // Non-UTF8 input.
c = 0
#  MEVENT mouse;
#  WINDOW *win = scintilla_get_window(sci);
while true do
  c = Curses.wgetch(win)
  if c < 256 and c.chr == 'q'
    break
  end
  if c != Curses::KEY_MOUSE
    c = Scintilla::SCK_UP   if c == Curses::KEY_UP
    c = Scintilla::SCK_DOWN if c == Curses::KEY_DOWN
    c = Scintilla::SCK_LEFT if c == Curses::KEY_LEFT
    c = Scintilla::SCK_RIGHT if c == Curses::KEY_RIGHT
      sci.send_key(c, false, false, false)
#    } else if (getmouse(&mouse) == OK) {
#      int event = SCM_DRAG, button = 0;
#      if (mouse.bstate & BUTTON1_PRESSED)
#        event = SCM_PRESS, button = 1;
#      else if (mouse.bstate & BUTTON1_RELEASED)
#        event = SCM_RELEASE, button = 1;
#      struct timeval time = {0, 0};
#      gettimeofday(&time, NULL);
#      int millis = time.tv_sec * 1000 + time.tv_usec / 1000;
#      scintilla_send_mouse(sci, event, millis, button, mouse.y, mouse.x,
#                           mouse.bstate & BUTTON_SHIFT,
#                           mouse.bstate & BUTTON_CTRL,
#                           mouse.bstate & BUTTON_ALT);
#    }
    end
    sci.refresh()
end
print("\033[?1000l") # disable mouse press and release events
# printf("\033[?1002l") // disable mouse press, drag, and release events
#printf("\033[?1003l") // disable mouse move, press, drag, and release

sci.delete()
Curses.endwin()