$use_voice = true

def declaim(str, lang = 0) # 0=Chinese; 1=English
  system('say -v ' + ['Ting-Ting ', 'Samantha '][lang] + str) if $use_voice
rescue Interrupt

end
