##
## Scintilla::ScintillaCurses Test
##

assert('new') do
  sci = Scintilla::ScintillaCurses.new
  assert_kind_of(Scintilla::ScintillaCurses, sci)
end

assert('delete') do
  #  sci = Scintilla::ScintillaCurses.new()
  #  sci.delete
end

assert('get_clipboard') do
  sci = Scintilla::ScintillaCurses.new
  text = sci.get_clipboard
  assert_kind_of(String, text)
end

assert('set_lexer_language') do
  sci = Scintilla::ScintillaCurses.new
  sci.sci_set_lexer_language('cpp')
  assert_equal('cpp', sci.sci_get_lexer_language)
  sci.sci_set_lexer_language('ruby')
  assert_equal('ruby', sci.sci_get_lexer_language)
end

assert('SCI_SETTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_SETTEXT('hogehoge')
  assert_equal 'hog', st.sci_get_text(3)
end

assert('SCI_AUTOCSELECT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_AUTOCSHOW(0, 'aaa bbb ccc')
  st.sci_autoc_select('bbb')
  assert_equal true, st.sci_autoc_active
end

assert('SCI_GETTARGETTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_INSERTTEXT(0, 'abcdefg')
  st.SCI_SETTARGETSTART(1)
  st.SCI_SETTARGETEND(5)
  assert_equal 'bcde', st.SCI_GETTARGETTEXT
  st.delete
end

assert('SCI_AUTOCGETCURRENTTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_AUTOCSHOW(0, 'abc xyz')
  assert_equal 'abc', st.SCI_AUTOCGETCURRENTTEXT
  st.delete
end

assert('SCI_ANNOTATIONGETTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_ANNOTATIONSETTEXT(0, 'abcd')
  assert_equal 'abcd', st.SCI_ANNOTATIONGETTEXT
end

assert('SCI_GETCURLINE') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_INSERTTEXT(0, 'abcdefg')
  st.SCI_CHARRIGHT
  assert_equal ['abcdefg', 1], st.sci_get_curline
  st.SCI_LINEEND
  st.SCI_NEWLINE
  st.SCI_DOCUMENTEND
  st.SCI_ADDTEXT(7, 'xyz')
  assert_equal ['xyz', 7], st.SCI_GETCURLINE
end

assert('SCI_GETTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_INSERTTEXT(0, 'abcdefg')
  assert_equal 'abc', st.sci_get_text(3)
  assert_equal 'abcde', st.SCI_GETTEXT(5)
end

assert('SCI_GETSELTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_INSERTTEXT(0, 'abcdefg')
  assert_equal '', st.sci_get_seltext
  st.SCI_SELECTALL
  assert_equal 'abcdefg', st.SCI_GETSELTEXT
end

assert('SCI_GETPROPERTY') do
  st = Scintilla::ScintillaCurses.new
  st.sci_set_lexer_language('ruby')
  st.SCI_SETPROPERTY('fold', '1')
  assert_equal '1', st.sci_get_property('fold')
  st.SCI_SETPROPERTY('test2', 'bbbb')
  assert_equal 'bbbb', st.SCI_GETPROPERTY('test2')
end

assert('SCI_GETLINE') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_INSERTTEXT(0, 'abcdefg')
  st.SCI_CHARRIGHT
  assert_equal 'abcdefg', st.sci_get_line(0)
  st.SCI_LINEEND
  st.SCI_NEWLINE
  st.SCI_DOCUMENTEND
  st.SCI_ADDTEXT(7, 'xyz')
  st.SCI_LINEEND
  st.SCI_NEWLINE
  assert_equal 'xyz', st.SCI_GETLINE(1)
end

assert('SCI_GETWORDCHARS') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_SETWORDCHARS(0, 'abcde')
  assert_equal 5, st.sci_get_wordchars.length
  st.SCI_SETWORDCHARS(0, 'abcdefghijklmn')
  assert_equal 14, st.SCI_GETWORDCHARS.length
end

assert('SCI_GETLEXERLANGUAGE') do
  st = Scintilla::ScintillaCurses.new
  st.sci_set_lexer_language('ruby')
  assert_equal 'ruby', st.sci_get_lexer_language
  st.sci_set_lexer_language('yaml')
  assert_equal 'yaml', st.SCI_GETLEXERLANGUAGE
end

assert('SCI_MARGINGETTEXT') do
  st = Scintilla::ScintillaCurses.new
  st.SCI_NEWLINE
  st.sci_margin_set_text(0, 'aaa')
  assert_equal 'aaa', st.sci_margin_get_text(0)
  st.sci_margin_set_text(1, 'bbbb')
  assert_equal 'bbbb', st.SCI_MARGINGETTEXT(1)
end

assert('SCI_GETDOCPOINTER') do
  st = Scintilla::ScintillaCurses.new
  doc = st.SCI_GETDOCPOINTER
  assert_kind_of Scintilla::Document, doc
end

assert('SCI_CREATEDOCUMENT') do
  st = Scintilla::ScintillaCurses.new
  assert_equal 0, st.SCI_GETDOCUMENTOPTIONS
  doc = st.SCI_CREATEDOCUMENT(0, 0x100)
  assert_kind_of Scintilla::Document, doc
  st.sci_set_docpointer(doc)
  assert_equal 0x100, st.SCI_GETDOCUMENTOPTIONS
end

assert('SCI_SETDOCPOINTER') do
  st = Scintilla::ScintillaCurses.new
  doc = st.sci_get_docpointer
  st.sci_set_docpointer(nil)
  assert_not_equal st.sci_get_docpointer, doc
end

assert('SCI_ADDREFDOCUMENT') do
  st = Scintilla::ScintillaCurses.new
  doc = st.sci_getdocpointer
  assert_equal 0, st.SCI_ADDREFDOCUMENT(doc)
end

assert('SCI_RELEASEDOCUMENT') do
  st = Scintilla::ScintillaCurses.new
  doc = st.sci_createdocument
  assert_equal 0, st.SCI_RELEASEDOCUMENT(doc)
end

assert('SCI_SETILEXER') do
  st = Scintilla::ScintillaCurses.new
  lexer = Scintilla.create_lexer('ruby')
  st.SCI_SETILEXER(lexer)
  assert_equal 'ruby', st.SCI_GETLEXERLANGUAGE
end
