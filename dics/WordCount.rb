print "\033[3;0;0t" # 设置窗口位置和大小
print "\033[8;35;90t"

loop do
  print "\033]0;GRE 作文时间字数统计 by Z. S.\007"
  print "\n 请按回车键开始写作."
  STDIN.gets
  @timest = Time.now
  @quit = false # 是否结束写作
  @th = Thread.new do # 新线程计时
    while sleep(1)
      break if @quit # 写作结束则停止计时
      ts = (Time.now - @timest).round
      print "\033]0;%s %02d : %02d\007" % [ts<1800 ? "Elapsed Time =" : "Time Limit Exceeded !",ts/60, ts%60] # 重设终端标题
      if (1800-ts).abs < 2 # 允许 ±1 s 误差
        `afplay /System/Library/Sounds/Purr.aiff -v 10 >/dev/null 2>&1 &` # 提示铃
        print "\n\r\e[1;31mTime Limit Exceeded!\e[0m" # 输出红色警告文字
      end
    end
  end
  @fn = @timest.strftime('AW-%Y-%m-%d-%H-%M-%S.txt')
  Thread.new {system "vi #{@fn}"}.join # 新建文本文档待输入
  
  @quit = true # 结束写作
  if File.exist?(@fn)
    ts = (Time.now - @timest).round
    f = open(@fn)
    buf = f.read # 统计词数
    
    strs = buf.split
    strs.delete_if {|s| s.match(/[a-zA-Z]/).nil?} # 只匹配含英文字母的（不算数字）、由空格隔开的小片段
	
	print "\r\033[1A 时间: %02d : %02d, 词数: " % [ts/60, ts%60]
    print '%03d' % strs.size
    print ' ('; parawds = []
    paras = buf.split("\n")
    paras.each {|p| c = p.split; c.delete_if {|s| s.match(/[a-zA-Z]/).nil?}; parawds.push('%03d' % c.size) if c != []} # 每个段落内数词数
    print parawds.join('; ')
    print '), 请按回车键继续.'
  else
    print "\r\033[1A 文本文档未保存. 请按回车键继续."
  end
  STDIN.gets
  print "\033c" # 清屏
end