# オブジェクトを観測する必要があるたびに毎回上記のEmployeeクラスのようなコードを書くよりも、
# もっとよい方法として、モジュールを作ってインクルードする方法がある。
# オブザーバを管理しているコードを分離することによって、機能的で小さなモジュールに落ち着く。

module Subject
  def initialize
    @observers = []
  end

  def add_observer(observer)
    @observers << observer
  end

  def delete_observer(observer)
    @observers.delete(observer)
  end

  def notify_observers
    @observers.each do |observer|
      observer.update(self)
    end
  end
end

class Employee
  include Subject
  attr_reader :name, :salary

  def initialize(name, salary)
    super()
    @name = name
    @salary = salary
  end

  def salary=(new_salary)
    @salary = new_salary
    notify_observers
  end
end
