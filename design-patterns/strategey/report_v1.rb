# アルゴリズムを交換する : Strategy
class ReportV1
  attr_reader :title, :text
  attr_accessor :formatter # 集約

  def initialize(formatter)
    @title = '月次報告'
    @text = ['順調', '最高の調子']
    @formatter = formatter
  end

  def output_report
    @formatter.output_report(self) # 委譲 self = Report
  end
end

class Formatter
  def output_report(context)
    raise 'Abstract method called'
  end
end

class HTMLFormatter < Formatter
  def output_report(context)
    puts "<title>#{context.title}</title>"
    puts '<body>'
    context.text.each do |line|
      puts "<p>#{line}</p>"
    end
    puts '</body>'
  end
end

class PlainTextFormatter < Formatter
  def output_report(context)
    puts("***#{context.title}***")
    context.text.each do |line|
      puts("***#{line}***")
    end
  end
end

report = ReportV1.new(HTMLFormatter.new)
report.output_report

report.formatter = PlainTextFormatter.new
report.output_report
