# -*- coding: utf-8 -*-
require 'tk'
require 'tkextlib/tile'
$:.unshift File.join(File.dirname(__FILE__),'..','gems/parseconfig-0.5.2/lib')
require 'parseconfig'
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'loc'
require 'zhua'

conf = File.join(File.dirname(__FILE__),'..','conf')
conf_f = "#{conf}/setup.conf"
config = ParseConfig.new(conf_f)
save_path =  config.get_value('save_path')
debug_st =  config.get_value('debug')

root = TkRoot.new {title "Hi!!get music(^O^) beta 0.1 "}
content = Tk::Tile::Frame.new(root) {padding "3 3 12 12"}.grid( :sticky => 'nsew')
TkGrid.columnconfigure root, 0, :weight => 1
TkGrid.rowconfigure root, 0, :weight => 1

$aid = TkVariable.new
$result = TkVariable.new
$save_path_text = TkVariable.new
$save_path_text.value = save_path
1
Tk::Tile::Label.new(content) {text 'aid_url'}.grid( :column => 1, :row => 1, :sticky => 'e')
f = Tk::Tile::Entry.new(content) {width 50; textvariable $aid}.grid( :column => 2, :row => 1, :sticky => 'we' )
Tk::Tile::Button.new(content) {text 'crawl'; command {get}}.grid( :column => 3, :row => 1, :sticky => 'w')

# 2
Tk::Tile::Label.new(content) {text 'result:'}.grid( :column => 1, :row => 2, :sticky => 'e')
Tk::Tile::Label.new(content) {textvariable $result}.grid( :column => 2, :row => 2, :sticky => 'we')

# 3
Tk::Tile::Label.new(content) {text 'save path:'}.grid( :column => 1, :row => 3, :sticky => 'e')
g = Tk::Tile::Entry.new(content) {width 50; textvariable $save_path_text}.grid( :column => 2, :row => 3, :sticky => 'we' )
Tk::Tile::Button.new(content) {text 'save'; command {save_conf}}.grid( :column => 3, :row => 3, :sticky => 'w')

Tk::Tile::Label.new(content) {text 'debug:'}.grid( :column => 1, :row => 4, :sticky => 'e')
Tk::Tile::Label.new(content) {text debug_st}.grid( :column => 2, :row => 4, :sticky => 'e')
# g = Tk::Tile::Entry.new(content) {width 50; textvariable $save_path}.grid( :column => 2, :row => 4, :sticky => 'we' )
# Tk::Tile::Button.new(content) {text '更换debug'; command {save_debug}}.grid( :column => 3, :row => 4, :sticky => 'w')


# Tk::Tile::Label.new(content) {text 'meters'}.grid( :column => 3, :row => 2, :sticky => 'w')

TkWinfo.children(content).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}
# f.focus
# root.bind("Return") {get}
# g.focus
# root.bind("Return") {save}

def save_conf
  begin
    p "--------------------start save path #{$save_path_text.value}"
    conf = File.join(File.dirname(__FILE__),'..','conf')
    conf_f = "#{conf}/setup.conf"
    config = ParseConfig.new(conf_f)    
    $result.value = "saving setup..."
    Zhua::save_conf({:save_path => $save_path_text.value, :conf_path => conf_f})    
    # config.set_value($save_path)    
    $result.value = "saved succesed"
    p "--------------------end save path"    
  rescue 
    puts "error\n#{$!}:\n#{$!.backtrace.join("\n")}"        
  end
end


def get
  begin
    # $results.value = (0.3048*$feet*10000.0).round()/10000.0
    p "---------start get -----------"
    $result.value = "crawling..."
    aid = $aid.value
    tmp = aid[/id\/(.*?)\/obj/, 1]
    aid = tmp unless tmp.nil?
    
    conf = File.join(File.dirname(__FILE__),'..','conf')
    conf_f = "#{conf}/setup.conf"
    config = ParseConfig.new(conf_f)
    save_path =  config.get_value('save_path')
    debug_st =  config.get_value('debug')
    debug = false
    debug = true if debug_st == 'on'
    Zhua.xia(aid, save_path, debug)
    $result.value = "crawled successed"    
    p "---------end get -----------"    
    puts "url is #$aid" if debug
  rescue 
    $result.value = 'crawl failed'
    puts "error\n#{$!}:\n#{$!.backtrace.join("\n")}"    
  end
end


Tk.mainloop
