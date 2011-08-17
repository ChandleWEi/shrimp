$:.unshift File.join(File.dirname(__FILE__),'..','gems/parseconfig-0.5.2/lib')
require 'parseconfig'
$:.unshift File.join(File.dirname(__FILE__),'..','lib')
require 'loc'
require 'zhua'

describe Zhua do
  context "when first crawl" do
    it "is empty" do
      # Zhua.xia
      p Zhua::os_family
    end
  end
  context "gui" do
    it "save conf" do
      conf = File.join(File.dirname(__FILE__),'..','conf')
      conf_f = "#{conf}/setup.conf"
      config = ParseConfig.new(conf_f)
      save_path = "c:\\xiami"      
      Zhua::save_conf({:save_path => save_path, :conf_path => conf_f})
      config = ParseConfig.new(conf_f)      
      config.get_value('save_path').should == save_path
      save_path = '/Users/chandle/Downloads/xiami/'
      Zhua::save_conf({:save_path => save_path, :conf_path => conf_f})
      config = ParseConfig.new(conf_f)      
      config.get_value('save_path').should == save_path      
    end
  end  
end
