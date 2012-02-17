# -*- coding: utf-8 -*-
require 'fileutils'
$:.unshift File.join(File.dirname(__FILE__),'..','gems/escape-0.0.4/lib')
$:.unshift File.join(File.dirname(__FILE__),'..','gems/ruby-mp3info-0.6.15/lib')
require 'mp3info'
require 'escape'
require 'iconv'

module Zhua

  def self.crawl(path, tg, tmp_path, os, wget_cmd = 'wget', debug = false)
    puts "tag is #{tg}" rescue nil if debug
    puts "tag class is #{tg.class}" rescue nil if debug    
    if !(File.exist? path) && !tg.nil? && !tg.empty?
      p "#self crawl path is " + path if debug
      p "os is " + os if debug
      if os == "windows"
        puts "1 tmp_path is #{tmp_path}" if debug        
        # tmp_path = tmp_path + (rand(1000) + rand(500)).to_s + File.basename(tg)[/\.\w+/, 0]
        tmp_path = "#{tmp_path}#{rand(1000)+rand(500)}#{File.basename(tg)[/\.\w+/, 0]}"
        puts "2 tmp_path is #{tmp_path}" if debug
        # get_tg = Escape.shell_command([wget_cmd, "-c", tg, "-O", tmp_path])
        get_tg = "#{wget_cmd} -c #{tg} -O #{tmp_path}"
        puts "get_tg is #{get_tg}" if debug
        system(get_tg)        
        FileUtils.cp(tmp_path, path)
        FileUtils.rm tmp_path
      else        
        get_tg = Escape.shell_command([wget_cmd, "-c", tg, "-O", path])
        p get_tg if debug
        system(get_tg)
      end
    end
  end

  
  def self.win_encode(str, win_to_code = 'GB2312//IGNORE', win_from_code = 'UTF-8//IGNORE')
    Iconv.iconv(win_to_code, win_from_code, str).first
  end
  
  def self.save_conf(options)
    File.open(options[:conf_path]) do |fr|
      buffer = fr.read
      buf_ary = []
      buffer.split(/\n/).each do |fl|
        if fl =~ /save_path/
          fl = "save_path = #{options[:save_path]} "
        end
        buf_ary << fl        
      end
      buffer = buf_ary.join "\n"
      p "buffer is #{buffer}"
      File.open(options[:conf_path], "w") { |fw| fw.write(buffer) }
    end
  end

  
  def self.os_family  
    case RUBY_PLATFORM  
    when /ix/i, /ux/i, /gnu/i,  
      /sysv/i, /solaris/i,  
      /sunos/i, /bsd/i, /darwin/i
      "unix"  
    when /win/i, /ming/i  
      "windows"  
    else  
      "other"  
    end  
  end  

  
  def xia(aid = '6648309', save_path = '/Users/chandle/Downloads/shrimp/', type = '0', debug = false)
    begin 

      shrimp = 'x' + 'i' + 'a' + 'm' + 'i'
      os = self.os_family
      p "os is #{os}"
      # win_to_code = 'GBK//IGNORE'
      # win_from_code = 'UTF-8//IGNORE'    
      wget_cmd = "wget"
      
      music_path = save_path || "/Users/chandle/Downloads/shrimp/"
      FileUtils.mkdir_p music_path unless File.exists? music_path
      p music_path if debug
      url = "http://www.#{shrimp}.com/s" + "ong/play" + "list/i" + "d/#{aid}/type/#{type}";
      song_path = "#{music_path}song.xml"
      system("#{wget_cmd} #{url} -O #{song_path}");
      musics = []
      music = {}

      open(song_path) do |f|
        f.each do |x|
          music['title'] = $1 if x =~ /^<title>/ && x =~ /\[([^\[\]]+)\]/
          music['loc'] = Loc.decode($1, debug)    if x =~ /^<location>(.*)<\/location>$/
          music['album'] = $1 if x =~ /^<album_name>/ && x =~ /\[([^\[\]]+)\]/

          if x =~ /^<artist>(.*)<\/artist>$/
            tmp_data = $1
            if tmp_data =~ /CDATA/
              music['artist'] = $1 if tmp_data =~ /<!\[CDATA\[(.*)\]\]>/
            else
              music['artist'] = tmp_data                          
            end
            
          end
          music['picurl'] = $1 if x =~ /^<pic>(.*)<\/pic>$/
          music['lyric'] = $1 if x =~ /^<lyric>(.*)<\/lyric>$/
          # 一次循环

          next if music['album'].nil? || music['album'].empty? || music['artist'].nil? || music['artist'].empty?

          unless music['picurl'].nil?
            self.process_music(music, music_path, os)          
            # musics << music
            puts music if debug
            music = {}
          end
        end
      end
    rescue
      p "xia error is #$!"
    end      
  end


  def self.process_music(music, music_path, os, debug = false)
    p "____________________--------------------" if debug
    title = music['title']
    p "title is " + title if debug
    loc = music['loc']
    p "loc is " + loc if debug
    album = music['album']
    p "album is " + album if debug
    artist = music['artist']
    p "artist is " + artist  if debug
    picurl = music['picurl']
    p "picurl is " + picurl    if debug
    lyric = music['lyric']
    p "lyric is " + lyric    if debug  
    paths = []

    album_path = "#{music_path}#{artist}/#{album}".strip.to_s
    tmp_path = "#{music_path}tmp/".to_s      
    album_path_orig = album_path.dup
    if os == 'windows'
      album_path = self.win_encode(album_path)
    end
    # album_path = shellescape(album_path)
    # album_path = Escape.shell_command(album_path)  
    paths << album_path
    paths << tmp_path
    puts "tmp_path_is #{tmp_path}" if debug
    puts tmp_path if debug      
    puts "album_is" if debug
    puts album_path if debug
    paths.each do |path|
      FileUtils.mkdir_p path unless File.exists? path
    end
    # out = "2>/dev/null"
    out = ""
    # 获取mp3
    # mp3_path  = "#{album_path}/#{shellescape title}.mp3"
    mp3_path  = "#{album_path_orig}/#{title}.mp3"      
    if os == 'windows'
      mp3_path = self.win_encode(mp3_path)
    end      
    self.crawl(mp3_path, loc, tmp_path, os)
    
    # 获取图片
    # img_path  = "#{album_path}/#{shellescape title}.jpg"
    img_path  = "#{album_path_orig}/#{title}.jpg"
    if os == 'windows'
      img_path = self.win_encode(img_path)
    end

    self.crawl(img_path, picurl, tmp_path, os)
    
    # 获取歌词
    lrc_path  = "#{album_path_orig}/#{title}.lrc"
    if os == 'windows'
      lrc_path = self.win_encode(lrc_path)
    end
    self.crawl(lrc_path, lyric, tmp_path, os)      

    puts  "mp3info now start update #{mp3_path}"
    puts "mp3_path is #{mp3_path}" if debug
    Mp3Info.open(mp3_path, :encoding => 'utf-8') do |mp3|
      mp3.tag.title = title 
      mp3.tag.artist = artist
      mp3.tag.album = album
      img_file = open(img_path)    
      unless img_file.nil?
        mp3.tag2.APIC = "\000image/jpeg\000\000\000" + img_file.read
        img_file.close
      end
      # TODO
      # lrc_file = open(lrc_path)    
      # unless lrc_file.nil?
      # p "lrc_file is not nil"
      # # data = lrc_file.read
      # data = "我"
      # first = "\001eng\377\376\000\000\377\376"
      # # first = "\305\245\346\271\247\000"
      # last = "\000\000"
      # # data = first + data + last
      # data = Iconv.iconv('utf-16', 'utf-8', data).first
      # mp3.tag2.USLT = first + data[3, data.size] + last
      # # mp3.tag.LYRICS = data
      # # mp3.tag2.SYLT = data      
      # data = nil
      # lrc_file.close
      # end
    end
    itunes_path = "#{music_path}itunes"
    FileUtils.mkdir_p itunes_path unless File.exists? itunes_path
    FileUtils.cp(mp3_path, itunes_path)
    p "mp3info now  finished"
  end      






  
  module_function :xia  
end
