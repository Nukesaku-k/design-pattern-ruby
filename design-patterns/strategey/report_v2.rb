# コードのかたまりを保持するオブジェクトであるProcオブジェクトを利用したリファクタが出来る。
class ReportV2
  attr_reader :title, :text
  attr_accessor :formatter

  def initialize(&formatter) # &を付けてコードブロックを受け取る
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.call(self) #Procオブジェクトの呼び出し
  end
end

# クラスを作成する代わりに、Procオブジェクトに処理をラップする
HTML_FORMATTER = lambda do |context|
  puts "<title>#{context.title}</title>"
  puts '<body>'
  context.text.each do |line|
    puts "<p>#{line}</p>"
  end
  puts '</body>'
end

PLAIN_TEXT_FORMATTER = lambda do |context|
  puts("***#{context.title}***")
  context.text.each do |line|
    puts("***#{line}***")
  end
end

report = ReportV2.new(&HTML_FORMATTER)
report.formatter = PLAIN_TEXT_FORMATTER
report.output_report
