# Last-minute_GRE (for Mac) 简介
Last-minute_GRE 是一个使用 Ruby 语言编写的、用于 GRE Verbal 及 Analytical Writing 考试准备的跨平台开源控制台程序。

## 总述
DicReader、DicSearcher、WordCount 是三个使用 Ruby 2.2 语言编写的开源控制台程序。本仓库内的程序运行平台为 Mac OS X。

*适用于 Win 10 x64 平台运行的相应程序请移步[此仓库](https://github.com/Z-H-Sun/Last-minute_GRE/)。*

## 声明
本程序词表来源为《新东方 2017 佛脚词汇表单词》，仅供学习交流之用，切勿用于商业用途。*此外，由于在字符串分割、处理的过程中，无法避免一些意料之外的因素，本程序所显示的内容可能会存在极少量的错误（已知的有：某些单词英文释义不完整、识别单词遗漏）*。虽然**不影响正常使用**，但并**不能**完全用于替代《佛脚词汇表》，建议对照查看。

## 下载和运行
[点此](https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/archive/master.zip)下载最新的 Source Code (zip)。解压至任意文件夹后，双击运行对应的.tool文件即可。

## 功能介绍
以下分别简要介绍，具体可参见程序内说明及运行效果图。

* **DicReader**：可随机显示新东方 2017 佛脚词汇表单词，利用 Mac 自带的“say”功能朗读单词及释义，显示网络例句（由百度翻译提供），并生成背词记录方便复习。具体操作说明详参程序内的说明。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/raw/master/images/DicReader.png" width="80%" height="80%"/>
</p>

* **DicSearcher**：可查找佛脚词汇表中收录的单词，功能基本同上，方便记忆同义词、拼写相近的单词。输入内容不区分大小写，可通过单词的某一部分进行查找（如词根词缀；如只记得 ana 也可查到 anachronism），可查找中文释义，且支持正则表达式（常用的有 “.” 代表任意字符，“.\*”代表零个或一个或多个任意字符，“^”表示匹配开头，“$”表示匹配结尾等）。**在输入查找内容时，请勿使用←/→键移动光标；这是 Ruby 自身的问题，无法转义控制符。**

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/raw/master/images/DicSearcher.png" width="80%" height="80%"/>
</p>

* **WordCount**：可以利用 `vim` 进行写作练习（不推荐使用 word 输入，因其有拼写检查功能）。一些 vim 的基本命令：**按 i 键以开始插入文本；按 ESC 后输入 :wq 回车以保存文本，或 :q! 以直接退出（不保存）**。同时，会在标题栏显示逝去时间，如下图。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/raw/master/images/WordCount-1.png" width="80%" height="80%"/>
</p>

30 分钟后有警告声提示和文本提示，如下图。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/raw/master/images/WordCount-2.png" width="80%" height="80%"/>
</p>

保存退出 vim 后，会统计显示每个段落及总的单词数，以及总计所耗时间。

<p align="center">
  <img src="https://github.com/Z-H-Sun/Last-minute_GRE_for_MAC/raw/master/images/WordCount-3.png" width="80%" height="80%"/>
</p>

所写的内容被保存在程序目录下的 `AW-YYYY-mm-DD-HH-MM-SS.txt` （年-月-日-时-分-秒）文件中，可供后续回顾和检查。

## 高级玩法
* 按 Ctrl+C (中止符) 可退出当前循环；
* 在朗读过程中按 Ctrl + C 也可以终止朗读。

## 更新记录：
* V 1.0 -> 1.1 (03/05/2019) 第一个稳定发行版。
