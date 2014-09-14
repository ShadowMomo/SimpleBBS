# encoding: utf-8

module SimpleBBS
  module_function
  # parse
  def parse(srcfile)
    # read
    contents = open(srcfile, "r", &:read)
    sets = read_cus "settings"
    style = read_cus "style"
    scu = read_cus "shortcuturl"
    # head
    contents.gsub!(/^head\s(.*?)/){ style["head"].gsub("{%1%}"){ $1 } }
    contents.gsub!(/^subh\s(.*?)/){ style["subh"].gsub("{%1%}"){ $1 } }
    # strike
    contents.gsub!(/~~(.*?)~~/m){ "[s]#{$1}[/s]" }
    # code
    contents.gsub!(/^```(.*?)\n(.*?)\n```/m){
      "[pre lang=\"#{$1}\" line=\"1\"]#{$2}[/pre]"
    }
    # url
    contents.gsub!(/\(([^()]*?)\)\[url\s(.*?)\]/m){ "[url=#{scu[$2]}]#{$1}[/url]" }
    contents.gsub!(/\(([^()]*?)\)\[(.*?)\]/m){ "[url=#{$2}]#{$1}[/url]" }
    # bold
    contents.gsub!(/\*\*(.*?)\*\*/m){ "[b]#{$1}[/b]" }
    # list
    contents.gsub!(/^list\n(.*?)\nlist-end/m){
      "[list]#{ $1.gsub(/^\*\s/, "[*]") }[/list]"
    } 
    contents.gsub!(/^list=(.*?)\n(.*?)\nlist-end/m){
      "[list=#{$1}]#{ $2.gsub(/^\*\s/, "[*]") }[/list]"
    }
    # section
    contents.gsub!(/^section\s(.*?)\n(.*?)\nsection-end/m){
      style["section"].gsub("{%1%}"){ $1 }.gsub("{%2%}"){ $2 }
    }
    # write
    open(srcfile, "w+"){|f| f << sets["PREFIX"] + contents + sets["SUFFIX"] }
  end
  # read_cus
  def read_cus(cus)
    source = open("./cus/#{cus}.txt", 'r', &:read)
    result = Hash.new
    result[$1] = $2 while _ = source.slice!(/(.*?)\s(.*?)(?:\n|\z)/)
    result
  end
end