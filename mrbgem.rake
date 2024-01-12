MRuby::Gem::Specification.new('mruby-scintilla-curses') do |spec|
  spec.license = 'MIT'
  spec.authors = 'masahino'
  spec.add_dependency 'mruby-scintilla-base', :github => 'masahino/mruby-scintilla-base'
  spec.version = '5.4.1'

  def spec.download_scintilla
    require 'open-uri'
    scintilla_ver = '541'
    scinterm_ver = '5.0'
    lexilla_ver = '530'
    scintilla_url = "https://scintilla.org/scintilla#{scintilla_ver}.tgz"
    scinterm_url = "https://github.com/orbitalquark/scinterm/archive/refs/tags/scinterm_#{scinterm_ver}.tar.gz"
    lexilla_url = "https://scintilla.org/lexilla#{lexilla_ver}.tgz"
    scintilla_build_root = "#{build_dir}/scintilla/"
    scintilla_dir = "#{scintilla_build_root}/scintilla"
    scintilla_a = "#{scintilla_dir}/bin/scintilla.a"
    scintilla_curses_dir = "#{scintilla_dir}/curses"
    lexilla_dir = "#{scintilla_build_root}/lexilla"
    lexilla_a = "#{lexilla_dir}/bin/liblexilla.a"
    curses_flag = ''
    scintilla_h = "#{scintilla_dir}/include/Scintilla.h"
    scintilla_curses_h = "#{scintilla_curses_dir}/ScintillaCurses.h"
    lexilla_h = "#{lexilla_dir}/include/Lexilla.h"

    file scintilla_h do
      URI.parse(scintilla_url).open(ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        scintilla_tar = http.read
        FileUtils.mkdir_p scintilla_build_root
        IO.popen("tar xfz - -C #{filename scintilla_build_root}", 'wb') do |f|
          f.write scintilla_tar
        end
      end
    end

    file scintilla_curses_h do
      URI.parse(scinterm_url).open(ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE) do |http|
        scinterm_tar = http.read
        FileUtils.mkdir_p scintilla_curses_dir
        IO.popen("tar xfz - -C #{filename scintilla_curses_dir} --strip-components 1", 'wb') do |f|
          f.write scinterm_tar
        end
      end
    end

    file scintilla_a => [scintilla_h, scintilla_curses_h] do
      curses_flag = '-D_XOPEN_SOURCE'
      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-w64-mingw32 i686-w64-mingw32).include?(build.host_target)
        curses_flag += " -I/usr/#{build.host_target}/include/pdcurses"
      end
      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-apple-darwin14).include?(build.host_target)
        curses_flag += ' -stdlib=libc++'
      end
      if build.kind_of?(MRuby::CrossBuild)
        curses_flag += " #{build.cxx.all_flags.gsub('\\', '\\\\').gsub('"', '\\"')}"
      end
      if ENV['MSYSTEM'] != nil
        curses_flag += " -I#{ENV['MINGW_PREFIX']}/include/pdcurses"
      end
      sh %Q{(cd #{scintilla_curses_dir} && make CXX=#{build.cxx.command} AR=#{build.archiver.command} CURSES_FLAGS="#{curses_flag}")}
    end

    file lexilla_h do
      URI.open(lexilla_url, :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        lexilla_tar = http.read
        FileUtils.mkdir_p scintilla_build_root
        IO.popen("tar xfz - -C #{filename scintilla_build_root}", 'wb') do |f|
          f.write lexilla_tar
        end
      end
    end

    file lexilla_a => lexilla_h do
      sh %Q{(cd #{lexilla_dir}/src && make CXX=#{build.cxx.command} AR=#{build.archiver.command})}
    end

    task :mruby_mrbmacs_curses_with_compile_option do
      linker.flags_before_libraries << scintilla_a
#      linker.flags_before_libraries << lexilla_a

      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-apple-darwin14).include?(build.host_target)
        linker.libraries << 'c++'
      else
        linker.libraries << 'stdc++'
        linker.libraries << 'pthread'
      end
      if build.kind_of?(MRuby::CrossBuild) && %w(x86_64-w64-mingw32 i686-w64-mingw32).include?(build.host_target)
        cc.include_paths << "/usr/#{build.host_target}/include/pdcurses"
        linker.libraries << 'pdcurses'
      elsif ENV['MSYSTEM'] != nil
        cc.include_paths << "#{ENV['MINGW_PREFIX']}/include/pdcurses"
        linker.libraries << 'pdcurses'
      else
        linker.libraries << 'ncurses'
        linker.libraries << 'panel'
      end
      [cc, cxx, objc, mruby.cc, mruby.cxx, mruby.objc].each do |cc|
        cc.include_paths << "#{scintilla_dir}/include"
        cc.include_paths << "#{scintilla_dir}/src"
        cc.include_paths << scintilla_curses_dir
        cc.include_paths << "#{lexilla_dir}/include"
      end
    end
    file "#{dir}/src/scintilla-curses.c" => [:mruby_mrbmacs_curses_with_compile_option, scintilla_a, lexilla_h]
  end

  spec.download_scintilla
end
