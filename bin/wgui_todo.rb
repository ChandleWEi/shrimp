#!/usr/bin/ruby -w
# wxtrout.rb
require 'rubygems'
require 'wxruby'
class TroutApp < Wx::App
  def on_init
    frame = Wx::Frame.new(nil, -1, 'Tiny wxRuby Application')
    panel = Wx::StaticText.new(frame, -1, 'You are a trout!',
                               Wx::Point.new(-1,1), Wx::DEFAULT_SIZE,
                               Wx::ALIGN_CENTER)
    frame.show
  end
end
