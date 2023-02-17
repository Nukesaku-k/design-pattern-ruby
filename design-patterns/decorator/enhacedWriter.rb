# 既存のオブジェクトに対して簡単に機能を追加するためのパターン。
# Decoratorパターンを使うとレイヤ状に機能を積み重ねていくことができ、
# それぞれの状況で必要なだけの機能を持つオブジェクトを作ることができる。
# 登場人物はデコレータと具象コンポーネント。
class EnhancedWriter
  attr_reader :check_sum

  def initialize(path)
    @file = File.open(path, "w")
    @check_sum = 0
    @line_number = 1
  end

  def write_line(line)
    p line
    @file.write(line)
    @file.write("\n")
  end

  def numbering_write_line(data)
    write_line("#{@line_number}: #{data}")
    @line_number += 1
  end

  def timestamping_write_line(data)
    write_line("#{Time.new}: #{data}")
  end

  def close
    @file.close
  end
end

# writer = EnhancedWriter.new('out.txt')
# writer.write_line('飾り気のない一行') # 普通のテキストを書き出す
# writer.numbering_write_line('行番号付きの一行') # 行番号付き
# writer.numbering_write_line('行番号付きの二行目') # 行番号付き
# writer.timestamping_write_line('タイムスタンプ付きの一行') # タイムスタンプ付き
# writer.close

# これでは、EnhancedWriterを使う全てのクライアントは出力するテキストが行番号付きなのか、
# タイムスタンプ付きなのかそれとも普通のテキストなのか、出力する全ての行で知らなければならない。
# また、「行番号とタイムスタンプ付き」といった出力の仕方が出来ない。
# 解決策として、本当に必要な機能の組み合わせを動的に実行時に組み立てるやり方、
# つまりDecoratorパターンを使ってみる。
# まずは普通のテキストの出力の方法と、その他のファイルに関するいくつかの操作だけを知っている
# 単純なオブジェクト(ConcreteComponent: 具象コンポーネント)を作る。
class SimpleWriter
  def initialize(path)
    @file = File.open(path, "w")
  end

  def write_line(line)
    p line
    @file.print(line)
    @file.print("\n")
  end

  def pos
    @file.pos
  end

  def rewind
    @file.rewind
  end

  def close
    @file.close
  end
end

# 行番号を付けたいときは、デコレータをSimpleWriterとクライアントの間に挿入する。
# デコレータは、各行に番号を付け足し、全体を元のSimpleWriterに渡す。
# 実際に書き出す処理はSimpleWriterが行う。
# デコレータを何種類も作ることが決まっているので、共通のコードを基底クラスに書き出す
class WriterDecorator
  def initialize(real_writer)
    @real_writer = real_writer
  end

  def write_line(line)
    @real_writer.write_line(line)
  end

  def pos
    @real_writer.pos
  end

  def rewind
    @real_writer.rewind
  end

  def close
    @real_writer.close
  end
end

class NumberingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
    @line_number = 1
  end

  # 普通のテキストの出力と同じインターフェイス
  def write_line(line)
    @real_writer.write_line("#{@line_number}: #{line}")
    @line_number += 1
  end
end

# 規程クラス: SimpleWriter
# デコレータ: WriterDecorator
# インターフェイスが同じなので、
# クライアントはやり取りをしている相手がSimpleWriterなのか
# NumberingWriterなのか気にする必要はない。
# 行番号をつけたければ、以下のようにNumberingWriterにSimpleWriterを注入してやればよい。
writer = SimpleWriter.new('out.txt')
writer.write_line('飾り気のない一行')
writer = NumberingWriter.new(SimpleWriter.new('out.txt'))
writer.write_line('飾り気のない一行')

# 同じパターンでタイムスタンプを付与するクラスを作ることができる。

class TimeStampingWriter < WriterDecorator
  def initialize(real_writer)
    super(real_writer)
  end

  def write_line(line)
    @real_writer.write_line("#{Time.new}: #{line}") # self じゃないのがポイントかも。
  end
end

writer = TimeStampingWriter.new(SimpleWriter.new('out.txt'))
writer.write_line('飾り気のない一行')

writer = NumberingWriter.new(TimeStampingWriter.new(SimpleWriter.new('out.txt')))
writer.write_line('飾り気のない一行')

# NumberingWriter
#   - WriterDecorator
#   - real_writer: TimeStampingWriter.write_line("#{Time.new}: #{line}").SimpleWriter.write_line(line)
#     TimeStampingWriter
#       - WriterDecorator
#         - real_writer: SimpleWriter.write_line(line)
#       - orverWrite: SimpleWriter.write_line("#{Time.new}: #{line}")
