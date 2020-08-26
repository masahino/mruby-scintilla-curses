MRuby::Gem::Specification.new('mruby-scintilla-curses') do |spec|
  spec.license = 'MIT'
  spec.authors = 'masahino'
#  spec.add_dependency 'mruby-curses', :github => 'jbreeden/mruby-curses'
  spec.add_dependency 'mruby-scintilla-base', :github => 'masahino/mruby-scintilla-base'
  spec.version = '3.21.0'

  def spec.download_scintilla
    require 'open-uri'
    scintilla_ver = "3210"
    scintilla_url = "https://downloads.sourceforge.net/scintilla/scintilla#{scintilla_ver}.tgz"
    scintilla_build_root = "#{build_dir}/scintilla/"
    scintilla_dir = "#{scintilla_build_root}/scintilla#{scintilla_ver}"
    scintilla_a = "#{scintilla_dir}/bin/scintilla.a"
    scintilla_curses_dir = "#{scintilla_dir}/curses"
    curses_flag = ""

    unless File.exists?(scintilla_a)
      unless Dir.exist?(scintilla_dir) 
        URI.open(scintilla_url) do |http|
          scintilla_tar = http.read
          FileUtils.mkdir_p scintilla_build_root
          IO.popen("tar xfz - -C #{filename scintilla_build_root}", "wb") do |f|
            f.write scintilla_tar
          end
        end
      end
      curses_flag = "-D_XOPEN_SOURCE"
      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-w64-mingw32 i686-w64-mingw32).include?(build.host_target)
        curses_flag += " -I/usr/#{build.host_target}/include/pdcurses"
      end
      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-apple-darwin14).include?(build.host_target)
        curses_flag += " -stdlib=libc++"
      end
      if build.kind_of?(MRuby::CrossBuild)
        curses_flag += " #{build.cxx.all_flags.gsub('\\','\\\\').gsub('"', '\\"')}"
      end
      if ENV['MSYSTEM'] != nil
        curses_flag += " -I/#{ENV['MINGW_PREFIX']}/include/pdcurses"
      end
      sh %Q{(cd #{scintilla_curses_dir} && make CXX=#{build.cxx.command} AR=#{build.archiver.command} CURSES_FLAGS="#{curses_flag}")}
    end
    self.linker.flags_before_libraries << scintilla_a

    if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-apple-darwin14).include?(build.host_target)
      self.linker.libraries << "c++"
    else
      self.linker.libraries << "stdc++"
    end
    if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-w64-mingw32 i686-w64-mingw32).include?(build.host_target)
      self.cc.include_paths << "/usr/#{build.host_target}/include/pdcurses"
      self.linker.libraries << "pdcurses"
    elsif ENV['MSYSTEM'] != nil
      self.cc.include_paths << "#{ENV['MINGW_PREFIX']}/include/pdcurses"
      self.linker.libraries << "pdcurses"
    else
      self.linker.libraries << "ncurses"
      self.linker.libraries << "panel"
    end
    [self.cc, self.cxx, self.objc, self.mruby.cc, self.mruby.cxx, self.mruby.objc].each do |cc|
      cc.include_paths << scintilla_dir+"/include"
      cc.include_paths << scintilla_dir+"/src"
      cc.include_paths << scintilla_curses_dir
    end
  end

end
