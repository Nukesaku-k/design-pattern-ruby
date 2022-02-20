# あなたが必要としていることができるオブジェクトがありますが、
# そのインターフェイスがふさわしくない場合どうすればよいでしょう？
# このインターフェイスの不整合はとても深くて複雑かもしれませんし、
# writeをsaveで呼びなおすだけのオブジェクトがあれば十分かもしれません。
# GoFのオススメはAdapterパターンです
class Encrypter
  def initialize(key)
    @key = key
  end

  def encrypt(reader, writer)
    key_index = 0
    while not reader.eof?
      clear_char = reader.getc
      encrypted_char = clear_char ^ @key[key_index]
      writer.putc encrypted_char
      key_index = (key_index + 1) % @key.size
    end
  end
end

# Encrypterクラスで、ファイルではなく文字列の暗号化をするために、
# インターフェイス間にある不整合を解消する。
class StringIOAdapter
  def initialize(string)
    @string = string
    @position = 0
  end

  def getc
    raise EOFError if eof?
    ch = @string[@position]
    @position += 1
    return ch
  end

  def eof?
    return @position >= @string.length
  end
end

# 秘密鍵を渡して初期化し、2つの開いたファイルを渡せば暗号化をしてくれる。
# encrypter = Encrypter.new('my secret key')
# reader = File.open('message.txt')
# writer = File.open('message.encrypted', 'w')
# encrypter.encrypt(reader, writer)

# StringIOAdapterでEncrypterを使うには、入力ファイルをアダプタに置き換えればよい。
encrypter = Encrypter.new('XYZZY')
reader = StringIOAdapter.new('We attack at dawn')
writer = File.open('out.txt', 'w')
encrypter.encrypt(reader, writer)
