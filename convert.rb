def convert(srcfile)
  # url short cut
  urls = {
    "插件脚本" => "http://rm.66rpg.com/thread-347133-1-1.html",
    "书籍系统" => "http://rm.66rpg.com/thread-337128-1-1.html",
    "虚拟日历" => "http://rm.66rpg.com/thread-330684-1-1.html",
    "自动存档" => "http://rm.66rpg.com/thread-332854-1-1.html",
    "A星寻路"  => "http://rm.66rpg.com/thread-369852-1-1.html",
  }
  # read
  contents = open(srcfile, "r", &:read)
  # head
  contents.gsub!(/^head\s(.*?)\n/){ "[size=6][align=center]#{$1}[/align][/size]\n" }
  contents.gsub!(/^subh\s(.*?)\n/){ "[size=5][align=center]#{$1}[/align][/size]\n" }
  # strike
  contents.gsub!(/~~(.*?)~~/m){ "[s]#{$1}[/s]" }
  # code
  contents.gsub!(/^```(.*?)\n(.*?)\n```/m){
    "[pre lang=\"#{$1}\" line=\"1\"]#{$2}[/pre]"
  }
  # url
  contents.gsub!(/\(([^()]*?)\)\[url\s(.*?)\]/m){ "[url=#{urls[$2]}]#{$1}[/url]" }
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
    "[box=Black][color=White][size=4][align=center]" +
    "#{$1}[/align][/size][/color][/box]" + "\n" +
    "[align=center][fold][align=left]" +
    "#{$2}[/align][/fold][/align]"
  }
  # write
  open(srcfile, "w+"){|f| f << "[font=微软雅黑]#{contents}[/font]" }
end
