# HTMLFormatterもPlainTextFormatterもoutput_reportを実装している。
# ここで本質的には何もしない基底クラスを作るのは、Ruby流のダックタイピングの哲学に反する。なので、
class ReportV2Beta
  attr_reader :title, :text
  attr_accessor :formatter # 集約

  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self) # 委譲
  end
end

class HTMLFormatter
  def output_report(context)
    puts "<title>#{context.title}</title>"
    puts '<body>'
    context.text.each do |line|
      puts "<p>#{line}</p>"
    end
    puts '</body>'
  end
end

class PlainTextFormatter
  def output_report(context)
    puts("***#{context.title}***")
    context.text.each do |line|
      puts("***#{line}***")
    end
  end
end

report = ReportV2Beta.new(HTMLFormatter.new)
report.output_report

report.formatter = PlainTextFormatter.new
report.output_report
