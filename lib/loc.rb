require 'cgi'
module Loc
  def decode(loc, debug = false)
    debug = false
    p 'loc is ' + loc if debug
    n = loc[0, 1].to_i
    left = loc[1, loc.size]
    slen = left.size / n
    scnt = left.size % n
    arr = []
    
    (0..scnt-1).each do |i|
      p "first #{i}" if debug
      arr.push(left[(slen+1)*i, slen+1]);
      p arr[i] if debug
    end
    
    (scnt .. n-1).each do |i| 
      p "second #{i}" if debug				
      arr.push(left[slen*(i-scnt)+(slen+1)*scnt, slen]);
      p arr[i] if debug
    end
    r1 = ""
    (0 .. (arr[0].size - 1)).each do |i|
      (0 .. (arr.size - 1)).each do |j|
        r1 += arr[j][i, 1]
        #  p "r1 is #{r1}" if debug
      end
    end
    r1 = CGI.unescape(r1)
    r1.gsub!(/\^/, '0')
    p "result r1 is" + r1 if debug
    return r1
  end
  module_function :decode
end
