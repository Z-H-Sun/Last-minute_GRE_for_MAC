require './DicDeclaimer.rb'
def m_explains(mode = 0) # mode = 1 : 只显示例句的模式
  if @ln == 26
    @wd[1].each do |x|
      puts
      print " \033[1;4;30m#{x[1]}\033[0m	" if mode.zero?
      print " \033[1;41;37m例句\033[0m "
      puts x[0].gsub(/(?<foo>\b#{@wd[0].gsub(/(?<foo>.)(\W+)/, '(\k<foo>|.s|.es|.{0,2}ed|.{0,2}ing)\b|\b')}\b)/i, "\033[7m\\k<foo>\033[0m").gsub("\033[0m \033[7m", ' ').split(':', 2)[1]
      #将词组中出现的单词标出. 考虑了三单、过去、现在的变形. (将词组中非字母部分替换为通配符. 要考虑末尾y变为i, 末尾双写. 匹配单词边界 (空格)). 最后, 连续的标记间的空格也要一起标出.
      declaim x[1] if mode.zero? # 朗读解释
    end
    if mode.zero? then print "\n\n" else print "\n 请按回车键继续."; STDIN.gets end
  else
    if mode.zero?
      @wd[1].each do |x|
        eng = x[0].split(']', 2) # 朗读词性
        print "\n \033[1;41;37m#{eng[0]}]\033[0m#{eng[1]}	\033[1;4;30m#{x[1]}\033[0m\n" # 标出词性、中文释义
        if eng[0].include?('adv') then declaim '副词' elsif eng[0].include?('v') then declaim '动词' end
        if eng[0].include?('conj') then declaim '连词' elsif eng[0].include?('n') then declaim '名词' end
        declaim '形容词' if eng[0].include?('adj')
        declaim '介词' if eng[0].include?('prep')
        declaim x[1]
      end
      puts; print " 直接回车查看下一个单词；输入任意内容以查看网络例句: "
      if $stdin.gets == "\n" then print("\033[1A ----------------------------------------------------------------------------------------\n\n"); return true end
    end
    if @exmp[@wd[0]].empty? then print "\n 暂时没有可用或可靠的网络例句. 请按回车键继续."; STDIN.gets end
    @exmp[@wd[0]].each_with_index do |x, i|
      print "\n \033[1;41;37m例句\033[0m	\033[1;4;34m#{i + 1})\033[0m "
      puts x[0].gsub(/(?<foo>\b#{@wd[0][0..-2]}.*?\b)/i, "\033[7m\\k<foo>\033[0m") # 标出例句中的单词，考虑了三单、过去、现在的变形 (\b匹配单词边界, 加?表示非贪心, 找到最近的边界)
      puts; print '	'; print x[1]; print '	'; puts "\033[1;37m#{x[2]}\033[0m" # 例句来源
      puts; print ' 直接回车查看下一个例句或继续; 输入任意内容并回车以结束: '
      break unless $stdin.gets == "\n"
    end
  end
  print("\033[1A ----------------------------------------------------------------------------------------\n\n")
end

loop do
  begin # Ctrl+C 退出当前
    print "\033[3;0;0t" # 设置窗口位置和大小
    print "\033[8;45;90t"
    print "\033]0;GRE 佛脚单词复习 by Z. S.\007"
    @ln = 0; puts
    while @ln.zero? # 如果输入得不对就重来
      print "词表号 (1~26, 26 = 短语, 以 m 结尾表示静音不朗读单词及释义): "
      @ln = $stdin.gets.chomp
      $use_voice = (@ln[-1] != 'm')
      @ln = @ln.to_i
    end

    @rec = [0] # 读入背词记录
    fls = Dir.entries('Dic_%02d' % @ln)
    fls.each {|i| if i[0, 6] == ('Dic_%02d' % @ln) and i[-4, 4] == '.txt' then n = i.split('_')[2].to_i; @rec.push(n) unless n.zero? end}
    @rec.delete(999); @rec.sort!

    f = open('Dic_%02d/Dic_%02d_999.txt' % [@ln, @ln], 'r:gbk') # 读入单词表, 建立<单词-编号>映射
    eval("@list = #{f.read.encode('UTF-8')}"); f.close
    @hash = {}; @hash_del = {}
    @list.each_with_index {|x, i| @hash[x[0]] = i}

    unless @rec[-1].zero?
      @rec[1..-1].each do |i|
        f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, i], 'r:gbk')
        @hash_tmp = {}
        eval("#{f.read.encode('UTF-8')}.each {|x| @hash_tmp[x[0]] = @hash[x[0]]; @hash.delete(x[0])}") # 记录、删除已背单词
        @hash_del[i] = @hash_tmp
        f.close
      end
    end

    unless @ln == 26 # 读入例句
      f = open('Dic_%02d/Dic_%02d_Exmp.txt' % [@ln, @ln], 'r:gbk')
      eval("@exmp = #{f.read.encode('UTF-8')}"); f.close
    end

    if @hash.size.zero?
      puts; puts '该列表 %02d 的单词已全部认识.' % @ln
    else
      puts; print '直接回车可随机显示单词, 或输入任意文本并回车以顺序显示单词: '
      @wnl = @hash.values; random = false
      if $stdin.gets == "\n" then random = true; @wnl.shuffle! end # 打乱顺序
      print "\033c"; print "\033]0;词表 #{@ln}, 共 #{@list.size} 词, #{random ? '随机' : '顺序'}模式\007"

      puts; puts '提示: 直接回车表示认识该单词, 下次将从单词列表中去除. 本词表任务结束后, 将生成 "Dic_%02d_xxx.txt" 的已背词记录, 记录号 xxx 越大, 表示记录越新, 999 号记录即包括所有单词. 若误按回车, 可在下一个单词处输入任意数字 (0~9) 并回车以撤销.' % @ln
      puts; puts '输入任意字母 (A~Z, a~z) 并回车以查看网络例句 (由百度翻译提供); 输入任意其余字符表示不认识该单词, 将显示双语释义, 并保留在单词列表中.'
      print '请按回车键继续.'; STDIN.gets; print "\033c"; puts
    end

    $stdout.sync = true # 强制缓冲区立即输出至控制台, 虽然Ruby 2以上版本默认如此
    @wn = 0; @known = [] # 进度, 新背会单词列表
    while @wn < @hash.size
      @wn += 1; print "\033]0;词表 #{@ln}, 进度 #{@wn} / #{@hash.size}\007"
      @wd = @list[@wnl[@wn - 1]]
      print " \033[1;4;34m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim(@wd[0], 1); print '	'
      r = $stdin.gets
      if r == "\n"
        @known.push(@wnl[@wn - 1]) # 认识单词, 仍然显示、朗读中文释义
        print "\033[1A\033[45C \033[1;32m已认识 \033[0m\033[1;41;37m ("; @wd[1].each {|x| print x[1] + '; '; declaim x[1]}
        print "\033[2D)\033[0m\n\n"; print " ----------------------------------------------------------------------------------------\n\n"
      elsif (r.ord > 64 and r.ord < 91) or (r.ord > 96 and r.ord < 123) # [a-zA-Z]: 显示例句
        m_explains(1); @wn -= 1
      elsif r.ord > 47 and r.ord < 58
        if @wn > 1
          print "\r\033[1A"; sleep(0.05); print "\033[J"; sleep(0.05)
          @wn -= 2; @known.delete(@wnl[@wn]) # 回退至上一单词, 从已认识词表中删除本单词
        else # 第一个单词无法回退
          print "\033c"; sleep(0.05)
          @wn = 0; puts
        end
      else
        m_explains # 不认识该单词
      end
    end

    if @known.size > 0
      @rec.push(@rec[-1] + 1) # 更新已认识词表
      @hash_tmp = {}
      @known.each {|j| @hash_tmp[@list[j]] = j}
      @hash_del[@rec[-1]] = @hash_tmp

      f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rec[-1]], 'w')
      l = @known.map {|j| @list[j]}
      f.write(l.to_s); f.close
      puts " 此次新认识了 \033[1;4;34m#{@known.size}\033[0m 个单词! 已生成记录 \033[7m #{'Dic_%02d_%03d.txt' % [@ln, @rec[-1]]} \033[0m."
    end

    loop do
      begin # Ctrl+C 退出当前
        puts "\n-----------------------------------------------------------------------------------------"
        @rec[1..-1].each {|j| puts("\n\033[7m%03d\033[0m	" % j + File.mtime('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, j]).to_s)}
        print "\n接下来, 直接回车将回到最开始的选择列表页面, 或者可以输入相应的数字并回车以复习之前的背词记录 (如果有的话. 上面显示了可用的记录号): "
        @rn = $stdin.gets.chomp.to_i
        print "\033c"
        if @rec[1..-1].include?(@rn)
          puts; print '直接回车可随机显示单词, 或输入任意文本并回车以顺序显示单词: '
          @wnl = @hash_del[@rn].values.sort; random = false
          if $stdin.gets == "\n" then random = true; @wnl.shuffle! end
          puts "\n你选择了#{random ? '随机' : '顺序'}模式. 当每个单词出现后, 请按回车键继续, 或输入数字 (1~9) 回到上一条目, 或输入其余任意内容以将该词语重新纳入至生词本. 请按回车键继续."; STDIN.gets; print "\033c"; puts

          @wn = 0; @patch = [] # patch为重新不认识的单词, 需要从已认识词表中重新剔除
          while @wn < @hash_del[@rn].size
            @wn += 1; print "\033]0;词表 #{@ln}, 记录 #{'%03d' % @rn}, 进度 #{@wn} / #{@hash_del[@rn].size}\007"
            @wd = @list[@wnl[@wn - 1]]
            print " \033[1;4;34m[#{@wnl[@wn - 1] + 1}]\033[0m "; print @wd[0]; declaim(@wd[0], 1); print '	'; r = $stdin.gets.chomp
            if r.empty?
            elsif r.ord > 47 and r.ord < 58 # 返回上一个单词, 该单词不列入patch列表
              if @wn > 1
                print "\r\033[1A"; sleep(0.05); print "\033[J"; sleep(0.05)
                @wn -= 2; @patch.delete(@list[@wnl[@wn]][0])
              else
                print "\033c"; sleep(0.05)
                @wn = 0; puts
              end
              next
            else
              print "\033[1A\033[45C \033[1;32m已重新加入生词本\033[0m\n"; @patch.push(@wd[0])
            end
            m_explains
          end
          puts ' 记录 %03d 到此结束.' % @rn
          f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn], 'r:gbk')
          eval("@list_tmp = #{f.read.encode('UTF-8')}"); f.close
          @list_tmp.delete_if {|x| @patch.include?(x[0])}
          f = open('Dic_%02d/Dic_%02d_%03d.txt' % [@ln, @ln, @rn], 'w')
          f.write(@list_tmp.to_s); f.close # 重新写入已认识词表
        else
          break
        end
      rescue Interrupt
        next
      end
    end
  rescue Interrupt
    print "\033c"; next
  end
end