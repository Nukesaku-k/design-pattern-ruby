class Account
  attr_accessor :name, :balance

  def initialize(name, balance=0)
    @name = name
    @balane = balance
  end

  def <=>(other) # この実装が必要(宇宙船演算子)
    balance <=> other.balance
  end
end

class Portfolio
  include Enumerable

  def initialize
    @accounts = []
  end

  def each(&block)
    @accounts.each(&block)
  end

  def add_account(account)
    @accounts << account
  end
end

my_portfolio = Portfolio.new
my_portfolio.add_account(Account.new('ufj', 300000))
my_portfolio.add_account(Account.new('mizuho', 500000))
my_portfolio.any? { |account| account.balance > 400000 } # => true
my_portfolio.all? { |account| account.balance > 400000 } # => false
