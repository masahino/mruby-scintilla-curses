##
## Scintilla::ScintillaCurses Test
##

assert("new") do
  sci = Scintilla::ScintillaCurses::new()
  assert_kind_of(Scintilla::ScintillaCurses, sci)
end

