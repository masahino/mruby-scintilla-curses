##
## Scintilla::ScintillaCurses Test
##

assert("new") do
  sci = Scintilla::ScintillaCurses::new()
  assert_kind_of(Scintilla::ScintillaCurses, sci)
end

assert("delete") do
#  sci = Scintilla::ScintillaCurses.new()
#  sci.delete
end

assert("get_clipboard") do
  sci = Scintilla::ScintillaCurses.new()
  text = sci.get_clipboard
  assert_kind_of(String, text)
end

assert("set_lexer_language") do
  sci = Scintilla::ScintillaCurses.new()
  sci.sci_set_lexer_language("cpp")
  assert_equal("cpp", sci.sci_get_lexer_language)
  sci.sci_set_lexer_language("ruby")
  assert_equal("ruby", sci.sci_get_lexer_language)
end