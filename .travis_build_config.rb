MRuby::Build.new do |conf|
  toolchain :gcc
  conf.gembox 'default'
  conf.gem "#{MRUBY_ROOT}/mrbgems/mruby-eval"
#  conf.gem :github => 'jbreeden/mruby-curses'

  conf.gem :github => 'masahino/mruby-scintilla-base', :branch => "scintilla5" do |g|
    g.download_scintilla
  end

  conf.gem File.expand_path(File.dirname(__FILE__)) do |g|
    g.download_scintilla
  end
  conf.enable_test
  conf.linker do |linker|
#    linker.libraries << "stdc++"
#    linker.libraries << "ncurses"
#    linker.libraries << "panel"
  end
end
