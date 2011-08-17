# # -*- coding: utf-8 -*-
$:.unshift File.join(File.dirname(__FILE__),'..','gems/parseconfig-0.5.2/lib')
require 'parseconfig'
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'loc'
require 'zhua'
begin
  conf = File.join(File.dirname(__FILE__),'..','conf')
  config = ParseConfig.new("#{conf}/setup.conf")
  save_path =  config.get_value('save_path')
  p "save_path is #{save_path}"
  debug = true if  config.get_value('debug') == 'on'

  if ARGV.size < 2
    puts "command format: ruby xm.rb aid type path"
  end
  aid = ARGV[0][/id\/(.*?)\/obj/, 1] unless ARGV[0].nil?
  aid = ARGV[0] || '6648309'  if aid.nil?
  p "aid is #{aid}" if debug
  type = ARGV[1] || '0'
  p "ARGV is #{ARGV}"
  p "type is #{type}" if debug
  Zhua.xia(aid,  save_path, type, debug)
rescue 
  p "xm error is #$!"
end



# p musics
# locdecode loc
